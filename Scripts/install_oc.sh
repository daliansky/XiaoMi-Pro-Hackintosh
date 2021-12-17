#!/usr/bin/env bash

PLEDIT='/usr/libexec/PlistBuddy'

# Should be at PATH, but in case PATH is messed up
PLUTIL='/usr/bin/plutil'

# Overwrite with enviroment variable to test/debug localy
REPO_NAME="${REPO_NAME:=daliansky/XiaoMi-Pro-Hackintosh}"
REPO_BRANCH="${REPO_BRANCH:=main}"

# Display style setting
BOLD=$(tput bold)
UNDERLINE=$(tput smul)
REV=$(tput rev)
BLACK=$(tput setaf 0)
RED=$(tput setaf 1)
GREEN=$(tput setaf 2)
YELLOW=$(tput setaf 3)
BLUE=$(tput setaf 4)
CYAN=$(tput setaf 6)
WHITE=$(tput setaf 7)
OFF=$(tput sgr0)
HEAD=$(tput cub 10000)
HEADCLEAN="${HEAD}$(tput el)"
UP=$(tput cuu1)

# Tools
jq='jq'

# Exit in case of network failure
function networkWarn() {
	errMsg "Failed to download resources, please check your connection!"
	exit 1
}

function errMsg() {
	local linen="${BASH_LINENO[*]}"
	echo -e "${RED}${*}${OFF} ${WHITE}L:${linen}${OFF}" 1>&2
}
# Mount EFI by using mount_efi.sh, credits Rehabman
function mountEFI() {
	local repoURL="https://raw.githubusercontent.com/RehabMan/hack-tools/master/mount_efi.sh"
	curl --silent -O "${repoURL}" || networkWarn
	echo
	echo "Mounting EFI partition..."
	EFI_DIR="$(sh "mount_efi.sh")"

	# Check whether EFI partition exists
	if [[ -z "${EFI_DIR}" ]]; then
		errMsg "Failed to detect EFI partition"
		unmountEFI
		exit 1

		# Check whether EFI/OC exists
	elif [[ ! -f "${EFI_DIR}/EFI/OC/config.plist" ]]; then
		errMsg "Failed to detect OC install"
		unmountEFI
		exit 1
	fi

	echo -e "${GREEN}Mounted EFI at ${EFI_DIR} (credits RehabMan)${OFF}"
}

# Unmount EFI for safety
function unmountEFI() {
	[[ -z "$EFI_DIR" ]] && return
	echo
	echo "Unmounting EFI partition..."
	diskutil unmount "$EFI_DIR" &>/dev/null
	echo -e "${GREEN}OK Unmount complete${OFF}"

	# "Unset EFI_DIR"
	EFI_DIR=''
}

function setupEnviroment() {
	#create temp folder
	[[ -n "$tempFolder" ]] && return
	tempFolder=$(mktemp -d)
	#tempFolder=debug
	echo -e "${BLACK}Using tmporary fodler: $tempFolder${OFF}"
	echo -e "${BLACK}Using ${REPO_NAME}:${REPO_BRANCH}${OFF}"
	cd "$tempFolder" || exit 2
	if ! [[ -x "$(command -v jq)" ]]; then
		echo Downloading jq for json parsing
		curl -# -f -o 'jq' -L 'https://github.com/stedolan/jq/releases/download/jq-1.6/jq-osx-amd64' || networkWarn
		jq='./jq'
		chmod +x $jq
		echo -e "${CYAN}Done!${OFF}\n"
	fi

	local commandCheckList=(
		"$jq"
		"$PLEDIT"
		"$PLUTIL"
		"/bin/df"
		"awk"
		"curl"
		"cut"
		"date"
		"diff"
		"diskutil"
		"ditto"
		"find"
		"head"
		"ioreg"
		"mkdir"
		"mktemp"
		"open"
		"perl"
		"printf"
		"read"
		"rm"
		"rmdir"
		"seq"
		"sh"
		"sleep"
		"tput"
		"tr"
		"trap"
		"true"
		"unzip"
		"xargs"
	)
	echo -e "Checking installed commands"

	for utilities in "${commandCheckList[@]}"; do
		if ! command -v "${utilities}" >/dev/null; then
			errMsg "${utilities} is needed for this script to work! Aborting"
			exit 1
		fi
	done
	echo -e "${CYAN}Done!${OFF}"
}

function getGitHubLatestRelease() {
	#$1 Github repo name,  I.E 'daliansky/XiaoMi-Pro-Hackintosh'
	#$2 Download filter as regex
	local _jsonData
	_jsonData=$(curl -f --silent 'https://api.github.com/repos/'"${1}"'/releases/latest') || networkWarn
	# Parse JSON to filter
	echo -n -E "$_jsonData" | $jq -r '.assets | map(select(.name|test("'"${2}"'"))) | .[].browser_download_url'
}

function readInteger() {
	local _input
	while :; do
		read -er -p "${YELLOW}${1} ${GREEN}[$2-$3]:${OFF} " _input
		if [[ "$_input" =~ ^[0-9]+$ ]] && [[ "$_input" -ge "$2" ]] && [[ "$_input" -le "$3" ]]; then
			echo -n "$_input"
			return 0
			#else
			#echo -e "${RED} Enter a integer between [$2 - $3]${OFF}"
		fi
	done
}

function readYesNo() {
	local yn
	while true; do
		read -er -n 1 -p "${*:1} ${BLUE}[yn]${OFF}" yn
		case $yn in
		[Yy]*)
			echo
			return 0
			;;
		[Nn]*)
			echo
			return 1
			;;
		*) echo -e -n "${HEADCLEAN}" ;;
		esac
	done
}

function downloadEFI() {
	trap 'errMsg $_errMsg on command:\n$BASH_COMMAND L:${LINENO};break' ERR
	local _downloadList
	read -r -a _downloadList <<<"$(getGitHubLatestRelease ${REPO_NAME} '-OC-' | perl -pe 's/\n/ /')"

	# Auto detect model
	local _deviceId
	_deviceId=$(ioreg -n XHC -c 'IOPCIDevice' -r -x -k "device-id" | perl -ne 'print $1 if(/^  \|   "device-id" = <((?:[0-9]|[a-f])*)>$/)')
	local _version=-1
	case $_deviceId in
	"2f9d0000")
		# 8 Gen KBL
		echo -e "${GREEN}Detected KBL model...${OFF}"
		_version=$(printf '%s\n' "${_downloadList[@]}" | awk 'BEGIN {flag=0} /KBL/ {print NR-1;flag=1} END{if(flag==0){print -1}}')
		;;
	"ed020000")
		# CML
		echo -e "${GREEN}Detected CML model...${OFF}"
		_version=$(printf '%s\n' "${_downloadList[@]}" | awk 'BEGIN {flag=0} /CML/ {print NR-1;flag=1} END{if(flag==0){print -1}}')
		;;
	esac

	if [[ $_version -eq -1 ]]; then
		# Failed to dectect model... maybe just abort as there's something wrong with ioreg?
		# Select download
		echo "If you are using XiaoMi-Pro with 8th Gen CPU, then it's a KBL (Kaby Lake) machine. (Actually Kaby Lake Refresh)"
		echo "If you are using XiaoMi-Pro with 10th Gen CPU, then it's a CML (Comet Lake) machine."
		echo "Select your version from the list:"
		local _downloadListLen
		_downloadListLen=${#_downloadList[@]}
		for _i in $(seq 0 $((_downloadListLen - 1))); do
			echo -e "${GREEN}${_i}${OFF}:"
			echo "     ${_downloadList[$_i]}"
		done
		echo -e "${GREEN}${_downloadListLen}${OFF}:"
		echo -e "     ${YELLOW}Enter an URL manually for the EFI${OFF}"
		_version=$(readInteger "Select a version" 0 "$_downloadListLen")
		#echo $_version
	fi

	local _dirname

	# Download and extract
	if [[ ${_version} -eq ${_downloadListLen} ]] || [[ -n $CUSTOM_EFI_URL ]]; then
		local _inputURL
		read -er -p "EFI URL: " _inputURL
		echo -e "${GREEN}Downloading EFI from user URL...${OFF}:"
		curl -f -L -# -o "XiaoMi_EFI.zip" "${_inputURL}" || networkWarn

	else
		echo -e "${GREEN}Downloading EFI from Github...${OFF}:"
		curl -f -L -# -o "XiaoMi_EFI.zip" "${_downloadList[$_version]}" || networkWarn

	fi
	ditto -x -k "XiaoMi_EFI.zip" .

	_dirname=$(echo "${_downloadList[$_version]}" | xargs -I {} basename {} .zip)
	if ! [[ -d "./${_dirname}" ]] || ! [[ -f "./${_dirname}/EFI/OC/config.plist" ]]; then
		# Get folder name from zip list
		_dirname=$(unzip -l "XiaoMi_EFI.zip" | awk 'NR==5{print $4}')
		# Validate folder
		if ! [[ $(awk -F'/' '{print NF-1}' <<<"${_dirname}") -eq 1 ]] || ! [[ -d "$_dirname" ]] || ! [[ -f "./${_dirname}/EFI/OC/config.plist" ]]; then
			# Another fallback method
			if ! _dirname=$(find . -maxdepth 1 -mindepth 1 -type d -exec echo {} \; | cut -c3- | head -n1) || ! [[ -d "$_dirname" ]] || ! [[ -f "./${_dirname}/EFI/OC/config.plist" ]]; then
				errMsg "Downloaded folder not found! Open a issue for a script update."
			fi
		else
			# Found the folder name, but need to delete the tailing '/'
			_dirname=$(echo -n "${_dirname}" | perl -ne 'chop($_);print($_)')
		fi
	fi

	efi_work_dir="${PWD}/${_dirname}/EFI"
	trap - ERR
}

function backupEFI() {
	[[ -z "$EFI_DIR" ]] && mount_efi
	local _lastBackup
	_lastBackup=$(find "${EFI_DIR}/Backups" -type d -mindepth 1 -maxdepth 1 -print0 2>/dev/null | xargs -0 ls -tl | perl -ne 'if(/^(.+):$/){print $1;exit;}')
	# _lastBackup=$(find "${EFI_DIR}/Backups" -type d -maxdepth 1 -exec basename {} \; 2>/dev/null | sort -t _ -r -k1.1,1.4n -k1.5,1.6n -k1.7,1.8 -k2nr -k3nr -k4nr | perl -ne 'if(/[0-9]{8}_[0-9]{2}_[0-9]{2}_[0-9]{2}/){print;exit}')

	local _escaped_EFI_DIR
	_escaped_EFI_DIR=$(echo -n -E "${EFI_DIR}" | perl -pe 's/\//\\\//g')

	local _spaceUsed
	# Use the bundled BSD's df, GNU's df may freeze...
	_spaceUsed=$(/bin/df | awk '/'"${_escaped_EFI_DIR}"'/ {print $5}' | perl -ne '/([0-9]+)/ and print $1')
	if [[ "$_spaceUsed" -ge 80 ]]; then
		echo -e "${RED}More than ${UNDERLINE}${BOLD}${_spaceUsed}%${OFF}${RED} of EFi partition space is used${OFF}"
		echo -e "${RED}Please rerun this script after removing/moving the outdated backups${OFF}"
		echo -e "${YELLOW}Note: you need to delete the file in trash bin to actually free the space!${OFF}"
		open "${EFI_DIR}/Backups/"
		exit 1
	elif [[ "$_spaceUsed" -ge 50 ]]; then
		echo -e "${YELLOW}More than ${UNDERLINE}${BOLD}${_spaceUsed}%${OFF}${YELLOW} of EFi partition space is used"
	fi

	# echo "${_lastBackup}"

	if [[ -n "$_lastBackup" ]] && diff -r -x '\._*' -x '\.DS_Store' "${EFI_DIR}/EFI/OC/" "${_lastBackup}/OC/" &>/dev/null; then
		echo -e "${BOLD}${UNDERLINE}${GREEN}Found already ${YELLOW}existing${GREEN} backup: ${BLUE}${_lastBackup}${OFF}"
		return
	fi

	# Backuping to same partition as EFI so it's faster to recover using Linux/LiveISO
	local _backupDir
	_backupDir="${EFI_DIR}/Backups/$(date +%Y%m%d_%H_%M_%S)/"
	echo -e "${BOLD}${UNDERLINE}Backuping current efi to ${BLUE}${_backupDir}${OFF}"

	if ! mkdir -p "$_backupDir"; then
		errMsg "Error ocurred when creating backup folder, exiting..."
		exit 1
	fi

	if ! cp -r "${EFI_DIR}/EFI/OC/" "$_backupDir"; then
		errMsg "Error ocurred when backuping EFI, aborting."
		errMsg "Maybe not enough free disk space left? $(/bin/df | awk '/'"${_escaped_EFI_DIR}"'/ {print $5}') space used"
		rmdir "$_backupDir"
		exit 1
	fi

	echo -e "${CYAN}Backup done!${OFF}"
}

function cleanUp() {
	if [[ -n "$tempFolder" ]]; then
		echo
		if readYesNo "${YELLOW}Do you wish to clean up/delete the temporary folder: ${UNDERLINE}${tempFolder}${OFF}${YELLOW} immediately?${OFF}"; then
			rm -r -f "$tempFolder"
			efi_work_dir=""
		else
			echo -e "${GREEN}MacOs ${BOLD}should${OFF}${GREEN} delete the temporary folder automatically after a while, so it should be fine to ignore it."
		fi
	fi
	if [[ -n "$EFI_DIR" ]]; then
		unmountEFI
	fi
	trap - EXIT
	exit 0
}

function installEFI() {
	echo "Installing EFI..."
	[[ -z "$EFI_DIR" ]] && mount_efi
	[[ -z "$efi_work_dir" ]] && errMsg "No work directory found. Try to download firts?" && exit 1
	echo

	echo -e "\n${YELLOW}Do you want to install EFI automatically?${OFF}"
	echo -e "${BLUE}1:${OFF} Yes install automatically and clean up downloaded files"
	echo -e "${BLUE}2:${OFF} No, exit the program and open the downloaded folder in Finder.(Manual install)"
	echo -e "${BLUE}3:${OFF} No, exit the program and delete the downloaded files.(Abort Install)"
	local _selection
	_selection=$(readInteger "Select" 1 3)

	case $_selection in
	[1])
		rm -rf "${EFI_DIR}/EFI/OC/" || errMsg "Failed to delete old EFI..."
		rm -rf "${EFI_DIR}/EFI/BOOT/" || errMsg "Failed to delete old EFI..."
		cp -r "${efi_work_dir}/OC" "${EFI_DIR}/EFI/" || errMsg "Failed to copy during installation..."
		cp -r "${efi_work_dir}/BOOT" "${EFI_DIR}/EFI/" || errMsg "Failed to copy during installation..."
		unmountEFI
		;;
	[2])
		open "${efi_work_dir}"
		echo "${GREEN}The downloaded EFI folder is: ${CYAN}${efi_work_dir}${OFF}"
		echo "${GREEN}The EFI is mounted at: ${CYAN}${EFI_DIR}${OFF}"
		echo "${GREEN}Check your Finder!${OFF}"
		sleep 10

		;;
	[3])
		rm -rf "${tempFolder}"
		tempFolder=""
		unmountEFI
		;;
	*)
		echo -n "$_selection"
		;;
	esac
	echo -e "${CYAN}Done!${OFF}\n"
}

function searchPlistArray() {
	# Return index's of first array's entry that match the pattern passed as $1
	# Ouptut to stdout, you should capture it using $()
	# !!! The input is stdin and "should" be array output from PlistBuddy
	# !!! The script find the first match and calculate the index of array of most upper level that contain it
	# !!! You should add indent to regex patter if the input contain nested structure!
	# !!! The regex match to Print of PlistBuddy, not the original file. The formats are differents.

	# Fix / to \/, escape for perl.
	local _regex
	_regex=$(echo -n -E "${1}" | perl -pe 's/\//\\\//g')
  # Another way to escape / is to use parameter expansion like ${1//\//\\/}
	#perl -n -e 'BEGIN{$n=0}' -e 'if(/^( *)Array \{$/){if($n==0){$a=$1}else{exit 1}}' -e 'if(/^$a    \}$/){$n++}' -e 'if(/^$a\}$/){exit 0}' -e '{if(/'"${_regex}"'/){print $n;exit 0}}' -
	local _result
	_result="$(perl -n -e 'BEGIN{$n=0}' -e 'if(/^( *)([^ \n][^=\n]*= )?Array \{$/){if(!defined($a)){$a=$1}}' -e 'if(defined($a)&&/^$a    \}$/){$n++}' -e 'if(/^$a\}$/){exit 0}' -e 'if(/^$a\}$/){exit 0}' -e '{if(/^$a        '"${_regex}"'/){print "$n\n"}}' -)"
	local _r=$?
	echo "$_result"
	#if [[ ! $_r -eq 0 ]];then
	#echo "${RED}L:"${BASH_LINENO[$((2))]}"${OFF}"
	#fi

	return $_r
}

function getPlistHelper() {
	# Helper function for search plist array
	# $1 File path
	# $2 Plist path, use ":" for root
	# $3+ Can be Plist path or array regex search
	# Ouptut to stdout, you should capture it using $()
	# Plist path need to be starting with ':'
	# Anything else is used as regex for array search
	# see searchPlistArray() for regex pattern info
	if [[ $# -le 1 ]]; then
		# Invalid, no pattern...
		return 1
	fi
	if [[ $# -eq 2 ]]; then
		# Base case
		if $PLEDIT "$1" -c "Print $2" &>/dev/null; then
			echo -n "$2"
			return 0
		else
			return 1
		fi
	fi
	if [[ "$(echo "$3" | cut -c1)" == ":" ]]; then
		# Plist Path
		getPlistHelper "$1" "${2}${3}" "${@:4}"
		return $?
	else
		# Array regex search
		local _index
		local _flag=0
		_index=$($PLEDIT "$1" -c "Print ${2}" 2>/dev/null | searchPlistArray "${3}" | head -n 1)
		[[ -z "$_index" ]] && return 1 # Abort if the entry is missing
		#[[ -z "$_index" ]] && _flag=1 # Abort if the entry is missing
		getPlistHelper "$1" "${2}:${_index}" "${@:4}"
		return $?
		#return $_flag
	fi
}

function getPlistArrayIndexHelper() {
	# Helper function for search plist array, it return all found index's
	# $1 File path
	# $2 Plist path or array regex, use ":" for root
	# $last Must be array regex search
	# Ouptut to stdout, you should capture it using $()
	# Plist path need to be starting with ':'
	# Anything else is used as regex for array search
	# see searchPlistArray() for regex pattern info
	if [[ $# -le 1 ]]; then
		# Invalid, no pattern...
		return 1
	fi
	if [[ $# -eq 2 ]]; then
		if [[ "$(echo "$2" | cut -c1)" == ":" ]]; then
			errMsg "Expected regex parameter and got $2"
			return 1
		fi
		local _index
		_index=$($PLEDIT "$1" -c "Print :" 2>/dev/null | searchPlistArray "${2}" | perl -p -e 's/\n/ /')
		echo -n "$_index"
		return 0
	fi
	if [[ "$(echo "$3" | cut -c1)" == ":" ]]; then
		# Plist Path
		getPlistHelper "$1" "${2}${3}" "${@:4}"
	else
		# Array regex search
		local _index
		_index=$("$PLEDIT" "$1" -c "Print ${2}" 2>/dev/null | searchPlistArray "${3}" | perl -p -e 's/\n/ /')
		echo -n "$_index"
		#getPlistHelper "$1" "${2}:${_index}" "${@:4}"
	fi
}

function deletePlistIfNotExist() {
	# Check if a path exist in old efi file
	# And delete in new file if not exist
	# $1 Old EFI file
	# $2 New EFI file
	# $3+ Plist path or array regex
	while :; do
		local _path
		local _newPath
		local _missingInOld=0
		local _missingInNew=0
		_path=$(getPlistHelper "$1" "${@:3}") || _missingInOld=1
		_newPath=$(getPlistHelper "$2" "${@:3}") || _missingInNew=1
		local _oldVarXml
		_oldVarXml=$("$PLEDIT" "$1" -x -c "Print $_path" 2>/dev/null)
		#echo "oldVar=$_oldVarXml"
		# echo $_missingInNew $_newPath
		if [[ "$_missingInNew" -eq 0 ]] && { [[ "$_missingInOld" -eq 1 ]] || [[ -z "$_oldVarXml" ]]; }; then
			# Path missing in old config
			"$PLEDIT" "$2" -c "Delete ${_newPath}" || break
			echo -e "${GREEN}Deleted obsolete entry: ${BLUE}${*:3}${GREEN}!${OFF}"
		else
			echo -e "${WHITE}Skip deleting entry: ${*:3}!${OFF}"
		fi
		return 0
	done
	errMsg "Error deleting ${*:3}!"
	return 1

}

function setPlistIfNotExist() {
	# Check if a path exist in old efi file
	# And set `Value` in new file if not exist
	# $1 Old EFI file
	# $2 New EFI file
  # $3 Value to set
	# $4+ Plist path or array regex
	while :; do
		local _path
		local _newPath
		local _missingInOld=0
		local _missingInNew=0
		_path=$(getPlistHelper "$1" "${@:4}") || _missingInOld=1
		_newPath=$(getPlistHelper "$2" "${@:4}") || _missingInNew=1
		local _oldVarXml
		_oldVarXml=$("$PLEDIT" "$1" -x -c "Print $_path" 2>/dev/null)
		if [[ "$_missingInNew" -eq 0 ]] && { [[ "$_missingInOld" -eq 1 ]] || [[ -z "$_oldVarXml" ]]; }; then

      "$PLEDIT" "$2" -c "Set ${_newPath} ${3}"
			echo -e "${GREEN}Set entry: ${BLUE}${*:4}${GREEN}!${OFF} default value to $3"
		else
			echo -e "${WHITE}Skip setting default value to entry: ${*:4}!${OFF}"
		fi
		return 0
	done
	errMsg "Error deleting ${*:4}!"
	return 1

}

function getBinaryDataInBase64() {
	# Parse PlistBuddy xml format and filter data in base64
	# The input is PlistBuddy with -x flag
	# Return the data in base64 to stdout
	perl -0777 -ne 'if(/<data>\n(.*)\n<\/data>/s){print "$1";exit 0}else{exit 1}'
}

function getPlist() {
	# $1 PList file
	# $2+ Plist path or array regex
	local _path
	_path=$(getPlistHelper "$1" "${@:2}") || return 1
	local _result
	if _result="$("$PLEDIT" "$1" -c "Print $_path" 2>/dev/null)"; then
		echo -n "$_result"
		return 0
	fi
	return 1
}

function restorePlist() {
	# Set Old efi file value to new efi file, if the old value is missing nothing is changed
	# $! Old PList file
	# $2 New PList file
	# $3+ Plist path or array regex

	local _errMsg="Failed to restore ${*:3}..."
	# trap 'errMsg $_errMsg on command:\n$BASH_COMMAND L:${LINENO};break' ERR
	while :; do
		# Use || : to skip ERR trap
		local _path
		if ! _path=$(getPlistHelper "$1" "${@:3}"); then
			# trap - ERR
			echo -e "${WHITE}Missing value, skipping: ${*:3}${OFF}"
			return 0
		fi
		local _oldVar
		_oldVar=$("$PLEDIT" "$1" -c "Print $_path" 2>/dev/null | tr -d '\0')
		local _oldVarXml
		_oldVarXml=$("$PLEDIT" "$1" -x -c "Print $_path" 2>/dev/null | getBinaryDataInBase64)

		local _newPath
		if ! _newPath=$(getPlistHelper "$2" "${@:3}"); then
			# trap - ERR
			echo -e "${WHITE}Missing value, skipping: ${*:3}${OFF}"
			return 0
		fi
		local _newVar
		_newVar=$("$PLEDIT" "$2" -c "Print $_newPath" 2>/dev/null | tr -d '\0')
		local _newVarXml
		_newVarXml=$("$PLEDIT" "$2" -x -c "Print $_newPath" 2>/dev/null | getBinaryDataInBase64)
		#echo "$_oldVar|$_newVar"
		#echo "$_oldVarXml|$_newVarXml"
		if [[ -z "$_oldVarXml" && -z "$_oldVar" ]]; then
			# Same value or not found on old config
			#errMsg "Skiping!!!..."
			echo -e "${WHITE}Missing value, skipping: ${*:3}${OFF}"
			# trap - ERR
			return 0
		fi
		if [[ "$_oldVar" == "$_newVar" && "$_oldVarXml" == "$_newVarXml" ]]; then
			# Same value or not found on old config
			echo -e "${WHITE}Same value, skipping: ${*:3}${OFF}"
			# trap - ERR
			return 0
		fi
		if [[ -n "$_oldVarXml" ]]; then
			# Binary data
			# Switch to plutil as PlistBuddy expect binary input that bash cannot pass as parameters
			# And plutil take base64 for data.

			# Change path format, plutil use '.' as separetor and eliminate the starting ':' as well
			local _fixedNewPath
			_fixedNewPath=$(echo -n "$_path" | perl -pe 's/^://;' -e 's/:/\./g')

			#plutil should be at PATH
			"$PLUTIL" -replace "$_fixedNewPath" -data "$_oldVarXml" "$2"
			printf "${GREEN}Restored binary data in: ${BLUE}%s${GREEN} to ${BLUE}${_oldVarXml}${GREEN} !${OFF}\n" "${*:3}"
		else
			"$PLEDIT" "$2" -c "Set $_newPath $_oldVar"
			printf "${GREEN}Restored ${BLUE}%s${GREEN} to ${BLUE}${_oldVar}${GREEN} !${OFF}\n" "${*:3}"

		fi
		return 0
	done
	errMsg "Failed to restore a plist entry"
	return 1
}

function generateArrayPatch() {
	# $1 Plist file
	# $2 Regex or Plist path to a Dict
	# Please check whether the path exist before generating a patch....
	# Return the path of generated patch
	mkdir -p "./patch/"
	local _filePath
	_filePath=$(mktemp "./patch/gen_XXXXXXXXXX.plist")
	local _path
	_path=$(getPlistHelper "$1" "${@:2}")
	local _result
	if "$PLEDIT" "$1" -x -c "Print ${_path}" 2>/dev/null | perl -p -e 's/^<dict>$/<array>\n<dict>/;s/^<\/dict>$/<\/dict>\n<\/array>/' - >"$_filePath" 2>/dev/null; then
		echo -n "$_filePath"
		return 0
	fi
	return 1
}

function restoreBootArgs() {
	echo -e "${GREEN}Restoring boot args...${OFF}"
	[[ -z "$efi_work_dir" ]] && errMsg "No work directory found. Try to download firts?" && exit 1
	[[ -z "$EFI_DIR" ]] && mount_efi
	while :; do
		local _old_config
		_old_config="${EFI_DIR}/EFI/OC/config.plist"
		local _new_config
		_new_config="${efi_work_dir}/OC/config.plist"
		local _path
		_path=$(getPlistHelper "$_old_config" ':NVRAM:Add:7C436110-AB2A-4BBB-A880-FE41995C9F82:boot-args') || break
		local _newPath
		_newPath=$(getPlistHelper "$_new_config" ':NVRAM:Add:7C436110-AB2A-4BBB-A880-FE41995C9F82:boot-args') || break
		local _oldVar
		_oldVar=$("$PLEDIT" "$_old_config" -c "Print $_path" 2>/dev/null) || break
		local _newVar
		_newVar=$("$PLEDIT" "$_new_config" -c "Print $_newPath" 2>/dev/null) || break

		#tput sc
		echo -e "${BLUE}1:${OFF} Old boot args"
		echo -e "<${UNDERLINE}${_oldVar}${OFF}>\n"
		echo -e "${BLUE}2:${OFF} New boot args ${CYAN}${UNDERLINE}(Recommended)${OFF}"
		echo -e "<${UNDERLINE}${_newVar}${OFF}>\n"
		echo -e "${BLUE}3:${OFF} Custom boot args ${RED}${UNDERLINE}${BOLD}ADVANCED USER ONLY${OFF}\n"
		local _selection
		_selection=$(readInteger "Select a version" 1 3)
		# TODO Better selection menu with ability to go back
		#tput rc
		if [[ "${_selection}" -eq 1 ]]; then
			restorePlist "${_old_config}" "${_new_config}" ":NVRAM:Add:7C436110-AB2A-4BBB-A880-FE41995C9F82:boot-args"
		else
			if [[ ${_selection} -eq 3 ]]; then
				echo -e "Old boot args:<${UNDERLINE}${_oldVar}${OFF}>\n"
				echo -e "New boot args:<${UNDERLINE}${_newVar}${OFF}>\n"
				echo -e "${GREEN}Input a custom boot args:${OFF}"
				local _readVar
				read -er _readVar
				#tput rc
				echo -e "New boot args:<${UNDERLINE}${_readVar}${OFF}>\n"
				"$PLEDIT" "${_new_config}" -c "Set $_newPath ${_readVar}" || break
			fi
		fi
		return 0
	done
	errMsg "Error reading boot args... Aborting"
	exit 1
}

function restoreSIP() {
	echo -e "${GREEN}Restoring SIP...${OFF}"
	[[ -z "$efi_work_dir" ]] && errMsg "No work directory found. Try to download firts?" && exit 1
	[[ -z "$EFI_DIR" ]] && mount_efi
	while :; do
		local _old_config
		_old_config="${EFI_DIR}/EFI/OC/config.plist"
		local _new_config
		_new_config="${efi_work_dir}/OC/config.plist"
		local _path
		_path=$(getPlistHelper "$_old_config" ':NVRAM:Add:7C436110-AB2A-4BBB-A880-FE41995C9F82:csr-active-config') || break
		local _newPath
		_newPath=$(getPlistHelper "$_new_config" ':NVRAM:Add:7C436110-AB2A-4BBB-A880-FE41995C9F82:csr-active-config') || break
		local _oldVarXml
		_oldVarXml=$("$PLEDIT" "$_old_config" -x -c "Print $_path" 2>/dev/null | getBinaryDataInBase64)
		local _newVarXml
		_newVarXml=$("$PLEDIT" "$_new_config" -x -c "Print $_newPath" 2>/dev/null | getBinaryDataInBase64)

		if [[ "$_oldVarXml" == "$_newVarXml" ]]; then
			echo -e "${CYAN}Done!${OFF}\n"
		fi

		#tput sc
		echo -e "${BLUE}1:${OFF} Old SIP value"
		echo -e "<${UNDERLINE}${_oldVarXml}${OFF}>\n"
		echo -e "${BLUE}2:${OFF} New SIP value ${CYAN}${UNDERLINE}(Recommended)${OFF}"
		echo -e "<${UNDERLINE}${_newVarXml}${OFF}>\n"
		# No custom value because the user would need to type in base 64...
		# echo -e "${BLUE}3:${OFF} Custom SIP value ${RED}${UNDERLINE}${BOLD}ADVANCED USER ONLY${OFF}\n"
		local _selection
		_selection=$(readInteger "Select a SIP version" 1 2)
		# TODO Better selection menu with ability to go back
		#tput rc
		if [[ "${_selection}" -eq 1 ]]; then
			restorePlist "${_old_config}" "${_new_config}" ":NVRAM:Add:7C436110-AB2A-4BBB-A880-FE41995C9F82:csr-active-config"
		fi
		return 0
	done
	errMsg "Error reading SIP value(csr-active-config)... Aborting"
	exit 1
}

function restoreBluetooth() {
	echo -e "${GREEN}Restoring Bluetooth...${OFF}"
	[[ -z "$efi_work_dir" ]] && errMsg "No work directory found. Try to download firts?" && exit 1
	[[ -z "$EFI_DIR" ]] && mount_efi

	local _old_config="${EFI_DIR}/EFI/OC/config.plist"
	local _new_config="${efi_work_dir}/OC/config.plist"
	cp "${efi_work_dir}"/../Bluetooth/*.aml "${efi_work_dir}/OC/ACPI/"

	# SSDT
	restorePlist "${_old_config}" "${_new_config}" ":ACPI:Add" "Path = SSDT-USB.aml" ":Enabled"
  setPlistIfNotExist "${_old_config}" "${_new_config}" "false" ":ACPI:Add" "Path = SSDT-USB.aml"

	restorePlist "${_old_config}" "${_new_config}" ":ACPI:Add" "Path = SSDT-USB-USBBT.aml" ":Enabled"
  setPlistIfNotExist "${_old_config}" "${_new_config}" "false" ":ACPI:Add" "Path = SSDT-USB-USBBT.aml"

	restorePlist "${_old_config}" "${_new_config}" ":ACPI:Add" "Path = SSDT-USB-WLAN-LTEBT.aml" ":Enabled"
  setPlistIfNotExist "${_old_config}" "${_new_config}" "false" ":ACPI:Add" "Path = SSDT-USB-WLAN-LTEBT.aml"

	restorePlist "${_old_config}" "${_new_config}" ":ACPI:Add" "Path = SSDT-USB-FingerBT.aml" ":Enabled"
  setPlistIfNotExist "${_old_config}" "${_new_config}" "false" ":ACPI:Add" "Path = SSDT-USB-FingerBT.aml" 

	# Kext
	restorePlist "${_old_config}" "${_new_config}" ":Kernel:Add" "BundlePath = IntelBluetoothFirmware.kext" ":Enabled"

	restorePlist "${_old_config}" "${_new_config}" ":Kernel:Add" "BundlePath = IntelBluetoothInjector.kext" ":Enabled"

	restorePlist "${_old_config}" "${_new_config}" ":Kernel:Add" "BundlePath = BlueToolFixup.kext" ":Enabled"
}

function restoreDVMT() {
	echo -e "${GREEN}Restoring DVMT...${OFF}"
	[[ -z "$efi_work_dir" ]] && errMsg "No work directory found. Try to download firts?" && exit 1
	[[ -z "$EFI_DIR" ]] && mount_efi
	local _old_config="${EFI_DIR}/EFI/OC/config.plist"
	local _new_config="${efi_work_dir}/OC/config.plist"

	restorePlist "${_old_config}" "${_new_config}" ':DeviceProperties:Add:PciRoot(0x0)/Pci(0x2,0x0):AAPL,ig-platform-id'
	restorePlist "${_old_config}" "${_new_config}" ':DeviceProperties:Add:PciRoot(0x0)/Pci(0x2,0x0):framebuffer-flags'
	restorePlist "${_old_config}" "${_new_config}" ':DeviceProperties:Add:PciRoot(0x0)/Pci(0x2,0x0):framebuffer-flags'

	deletePlistIfNotExist "${_old_config}" "${_new_config}" ':DeviceProperties:Add:PciRoot(0x0)/Pci(0x2,0x0):framebuffer-fbmem'
	deletePlistIfNotExist "${_old_config}" "${_new_config}" ':DeviceProperties:Add:PciRoot(0x0)/Pci(0x2,0x0):framebuffer-stolenmem'
	deletePlistIfNotExist "${_old_config}" "${_new_config}" ':DeviceProperties:Add:PciRoot(0x0)/Pci(0x2,0x0):framebuffer-con0-enable'
	deletePlistIfNotExist "${_old_config}" "${_new_config}" ':DeviceProperties:Add:PciRoot(0x0)/Pci(0x2,0x0):framebuffer-con0-flags'
	deletePlistIfNotExist "${_old_config}" "${_new_config}" ':DeviceProperties:Add:PciRoot(0x0)/Pci(0x2,0x0):framebuffer-con1-flags'
	deletePlistIfNotExist "${_old_config}" "${_new_config}" ':DeviceProperties:Add:PciRoot(0x0)/Pci(0x2,0x0):framebuffer-con2-flags'
	echo -e "${CYAN}Done!${OFF}\n"
}

function restore0xE2() {
	echo -e "${GREEN}Restoring 0xE2...${OFF}"
	[[ -z "$efi_work_dir" ]] && errMsg "No work directory found. Try to download firts?" && exit 1
	[[ -z "$EFI_DIR" ]] && mount_efi
	local _old_config="${EFI_DIR}/EFI/OC/config.plist"
	local _new_config="${efi_work_dir}/OC/config.plist"

	restorePlist "${_old_config}" "${_new_config}" ':Kernel:Quirks:AppleXcpmCfgLock'

	echo -e "${CYAN}Done!${OFF}\n"
}

function restorePlatformInfo() {
	echo -e "${GREEN}Restoring PlatformInfo...${OFF}"
	[[ -z "$efi_work_dir" ]] && errMsg "No work directory found. Try to download firts?" && exit 1
	[[ -z "$EFI_DIR" ]] && mount_efi
	local _old_config="${EFI_DIR}/EFI/OC/config.plist"
	local _new_config="${efi_work_dir}/OC/config.plist"

	restorePlist "${_old_config}" "${_new_config}" ':PlatformInfo:Generic:ROM'
	restorePlist "${_old_config}" "${_new_config}" ':PlatformInfo:Generic:SystemSerialNumber'
	restorePlist "${_old_config}" "${_new_config}" ':PlatformInfo:Generic:SystemProductName'
	restorePlist "${_old_config}" "${_new_config}" ':PlatformInfo:Generic:SystemUUID'
	restorePlist "${_old_config}" "${_new_config}" ':PlatformInfo:Generic:MLB'

	echo -e "${CYAN}Done!${OFF}\n"
}

function restoreMiscPreference() {

	echo -e "${GREEN}Restoring Misc's...${OFF}"
	[[ -z "$efi_work_dir" ]] && errMsg "No work directory found. Try to download firts?" && exit 1
	[[ -z "$EFI_DIR" ]] && mount_efi
	local _old_config="${EFI_DIR}/EFI/OC/config.plist"
	local _new_config="${efi_work_dir}/OC/config.plist"

	restorePlist "${_old_config}" "${_new_config}" ':Misc:Boot:PickerMode'
	restorePlist "${_old_config}" "${_new_config}" ':Misc:Boot:Timeout'
	restorePlist "${_old_config}" "${_new_config}" ':Misc:Boot:ShowPicker'
	restorePlist "${_old_config}" "${_new_config}" ':Misc:Boot:TakeoffDelay'

	# For intel wifi
	restorePlist "${_old_config}" "${_new_config}" ':Misc:Security:DmgLoading'
	restorePlist "${_old_config}" "${_new_config}" ':Misc:Security:SecureBootModel'
	echo -e "${CYAN}Done!${OFF}\n"
}

function restoreBrcmPatchRAM() {
	#Untested
	echo -e "${GREEN}Restoring BrcmPatchRAM...${OFF}"
	[[ -z "$efi_work_dir" ]] && errMsg "No work directory found. Try to download firts?" && exit 1
	[[ -z "$EFI_DIR" ]] && mount_efi
	local _old_config="${EFI_DIR}/EFI/OC/config.plist"
	local _new_config="${efi_work_dir}/OC/config.plist"

	local _flag=0
	local _brcmInjector
	_brcmInjector=$(getPlist "${_old_config}" ':Kernel:Add' 'BundlePath = BrcmBluetoothInjector.kext' ':Enabled') && ((_var += 1))
	local _brcmFirmwareData
	_brcmFirmwareData=$(getPlist "${_old_config}" ':Kernel:Add' 'BundlePath = BrcmFirmwareData.kext' ':Enabled') && ((_var += 2))
	local _brcmRAM3
	_brcmRAM3=$(getPlist "${_old_config}" ':Kernel:Add' 'BundlePath = BrcmPatchRAM3.kext' ':Enabled') && ((_var += 4))

	if [[ "$_flag" -ne 0 ]]; then
		echo -e "${GREEN}Downloading BrcmPatchRAM...${OFF}"

		local _patchRAMLink
		_patchRAMLink=$(getGitHubLatestRelease "acidanthera/BrcmPatchRAM" 'RELEASE')

		curl -f -L -# -o "BrcmPatchRAM.zip" "${_patchRAMLink}" || networkWarn
		ditto -x -k "./BrcmPatchRAM.zip" .

		#local _dirname=$(echo ${_patchRAMLink}|grep -o '[^/]*\.zip'|sed -e 's/\.zip//g')

		if ! [[ -d "./BrcmBluetoothInjector.kext" && -d "./BrcmFirmwareData.kext" && -d "./BrcmPatchRAM3.kext" ]]; then
			errMsg "Download kext not found! Open a issue for a script update."
			return 1
		fi
		local _patchRAMDir="."

		echo -e "${GREEN}Downloading patch from github${OFF}"
		mkdir -p "./patch"

		curl -f -# -L -o "./patch/BrcmBluetoothInjector.plist" "https://raw.githubusercontent.com/${REPO_NAME}/${REPO_BRANCH}/Scripts/patch/BrcmBluetoothInjector.plist" || return 1
		curl -f -# -L -o "./patch/BrcmFirmwareData.plist" "https://raw.githubusercontent.com/${REPO_NAME}/${REPO_BRANCH}/Scripts/patch/BrcmFirmwareData.plist" || return 1
		curl -f -# -L -o "./patch/BrcmPatchRAM3.plist" "https://raw.githubusercontent.com/${REPO_NAME}/${REPO_BRANCH}/Scripts/patch/BrcmPatchRAM3.plist" || return 1

		echo "${GREEN}Adding BrcmPatchRAM Kext's entry to config.plist${OFF}"
		[[ "$_brcmInjector" == "true" ]] && cp -r "${_patchRAMDir}/BrcmBluetoothInjector.kext" "${efi_work_dir}/OC/Kexts/" && ${PLEDIT} -x -c "Merge ./patch/BrcmBluetoothInjector.plist :Kernel:Add" "${_new_config}" && echo -e "${GREEN}Restored BrcmBluetoothInjector${OFF}"
		[[ "$_brcmFirmwareData" == "true" ]] && cp -r "${_patchRAMDir}/BrcmFirmwareData.kext" "${efi_work_dir}/OC/Kexts/" && ${PLEDIT} -x -c "Merge ./patch/BrcmFirmwareData.plist :Kernel:Add" "${_new_config}" && echo -e "${GREEN}Restored BrcmFirmwareData${OFF}"
		[[ "$_brcmRAM3" == "true" ]] && cp -r "${_patchRAMDir}/BrcmPatchRAM3.kext" "${efi_work_dir}/OC/Kexts/" && ${PLEDIT} -x -c "Merge ./patch/BrcmPatchRAM3.plist :Kernel:Add" "${_new_config}" && echo -e "${GREEN}Restored BrcmPatchRAM3${OFF}"
	else
		echo -e "${WHITE}Nothing needed! Skipping..${OFF}"

	fi
	echo -e "${CYAN}Done!${OFF}\n"
}

function restoreAirportFixup() {
	echo -e "${GREEN}Restoring AirportBrcmFixup...${OFF}"
	[[ -z "$efi_work_dir" ]] && errMsg "No work directory found. Try to download firts?" && exit 1
	[[ -z "$EFI_DIR" ]] && mount_efi
	local _old_config="${EFI_DIR}/EFI/OC/config.plist"
	local _new_config="${efi_work_dir}/OC/config.plist"
	local _brcmAirport
	_brcmAirport=$(getPlist "${_old_config}" ':Kernel:Add' 'BundlePath = AirportBrcmFixup.kext' ':Enabled')
	#local _brcmAirport=true
	if [[ "$_brcmAirport" == "true" ]]; then
		echo -e "${GREEN}Downloading BrcmPatchRAM...${OFF}"
		local _airportBrcmLink
		_airportBrcmLink=$(getGitHubLatestRelease "acidanthera/AirportBrcmFixup" 'RELEASE')

		curl -L -f -# -o "AirportBrcmFixup.zip" "${_airportBrcmLink}" || networkWarn
		ditto -x -k "./AirportBrcmFixup.zip" .
		#local _dirname=$(echo "${_airportBrcmLink}"|grep -o '[^/]*\.zip'|sed -e 's/\.zip//g')

		if ! [[ -d "./AirportBrcmFixup.kext" ]]; then
			errMsg "Download ($_dirname) not found! Open a issue for a script update."
			return 1
		fi
		local _patchRAMDir="${PWD}/${_dirname}/"

		# Download patch
		echo -e "${GREEN}Downloading patch from github${OFF}"
		mkdir -p "./patch"
		curl -# -f -L -o "./patch/AirportBrcmFixup.plist" "https://raw.githubusercontent.com/${REPO_NAME}/${REPO_BRANCH}/Scripts/patch/AirportBrcmFixup.plist" || return 1

		echo "${GREEN}Adding AirportBrcmFixup Kext entry to config.plist${OFF}"
		cp -r "./AirportBrcmFixup.kext" "${efi_work_dir}/OC/Kexts/" && ${PLEDIT} -x -c "Merge ./patch/AirportBrcmFixup.plist :Kernel:Add" "${_new_config}" && echo -e "${GREEN}Restored AirportBrcmFixup${OFF}"

	else
		echo -e "${WHITE}Nothing needed! Skipping..${OFF}"
	fi
	echo -e "${CYAN}Done!${OFF}\n"

}

function restoreNVMeFix() {
	echo -e "${GREEN}Restoring NVMeFix...${OFF}"
	[[ -z "$efi_work_dir" ]] && errMsg "No work directory found. Try to download firts?" && exit 1
	[[ -z "$EFI_DIR" ]] && mount_efi
	local _kextName="NVMeFix"
	local _old_config="${EFI_DIR}/EFI/OC/config.plist"
	local _new_config="${efi_work_dir}/OC/config.plist"
	_oldEnabled=$(getPlist "${_old_config}" ':Kernel:Add' "BundlePath = ${_kextName}.kext" ':Enabled')
	if [[ "$_oldEnabled" == "true" ]]; then
		echo -e "${GREEN}Downloading ${_kextName}...${OFF}"
		local _link
		_link=$(getGitHubLatestRelease "acidanthera/${_kextName}" 'RELEASE')

		curl -L -f -o "${_kextName}.zip" "${_link}" || networkWarn
		ditto -x -k "./${_kextName}.zip" .

		if ! [[ -d "./${_kextName}.kext" ]]; then
			errMsg "Downloading ${_kextName} failed! Open a issue for a script update."
			return 1
		fi

		# Download patch
		echo -e "${GREEN}Downloading patch from github${OFF}"
		mkdir -p "./patch"
		curl -f -L -o "./patch/${_kextName}.plist" "https://raw.githubusercontent.com/${REPO_NAME}/${REPO_BRANCH}/Scripts/patch/${_kextName}.plist" || return 1

		echo "${GREEN}Adding ${_kextName} Kext entry to config.plist${OFF}"
		cp -r "./${_kextName}.kext" "${efi_work_dir}/OC/Kexts/" && ${PLEDIT} -x -c "Merge ./patch/${_kextName}.plist :Kernel:Add" "${_new_config}" && echo -e "${GREEN}Restored ${_kextName}${OFF}"

	else
		echo -e "${WHITE}Nothing needed! Skipping..${OFF}"
	fi
	echo -e "${CYAN}Done!${OFF}\n"

}

function restoreOptionalKext() {
	echo -e "${GREEN}Restoring Optional Kext's...${OFF}"
	[[ -z "$efi_work_dir" ]] && errMsg "No work directory found. Try to download firts?" && exit 1
	[[ -z "$EFI_DIR" ]] && mount_efi
	local _old_config="${EFI_DIR}/EFI/OC/config.plist"
	local _new_config="${efi_work_dir}/OC/config.plist"

	# Optional Kext that need to be disabled if not exist in old EFI.

	# Intel Wifi Force load kext
	restorePlist "${_old_config}" "${_new_config}" ':Kernel:Force' 'BundlePath = System/Library/Extensions/corecapture.kext' ':Enabled'

	restorePlist "${_old_config}" "${_new_config}" ':Kernel:Force' 'BundlePath = System/Library/Extensions/IO80211Family.kext' ':Enabled'

	# Detele those entry if not exist in old EFI
	restorePlist "${_old_config}" "${_new_config}" ':Kernel:Add' 'BundlePath = AirportItlwm_Big_Sur.kext' ':Enabled'

	restorePlist "${_old_config}" "${_new_config}" ':Kernel:Add' 'BundlePath = AirportItlwm_Catalina.kext' ':Enabled'

	restorePlist "${_old_config}" "${_new_config}" ':Kernel:Add' 'BundlePath = AirportItlwm_High_Sierra.kext' ':Enabled'

	restorePlist "${_old_config}" "${_new_config}" ':Kernel:Add' 'BundlePath = AirportItlwm_Mojave.kext' ':Enabled'

	restorePlist "${_old_config}" "${_new_config}" ':Kernel:Add' 'BundlePath = AirportItlwm_Monterey.kext' ':Enabled'

	restorePlist "${_old_config}" "${_new_config}" ':Kernel:Add' 'BundlePath = NullEthernet.kext' ':Enabled'

	restorePlist "${_old_config}" "${_new_config}" ':ACPI:Add' 'Path = SSDT-RMNE.aml' ':Enabled'

	restorePlist "${_old_config}" "${_new_config}" ':Kernel:Add' 'BundlePath = NVMeFix.kext' ':Enabled'

	restorePlist "${_old_config}" "${_new_config}" ':Kernel:Add' 'BundlePath = HibernationFixup.kext' ':Enabled'
	echo -e "${CYAN}Done!${OFF}\n"

}

function brightnessKeyestore() {
	echo -e "${GREEN}Restoring Brightness key aml...${OFF}"
	[[ -z "$efi_work_dir" ]] && errMsg "No work directory found. Try to download firts?" && exit 1
	[[ -z "$EFI_DIR" ]] && mount_efi
	local _old_config="${EFI_DIR}/EFI/OC/config.plist"
	local _new_config="${efi_work_dir}/OC/config.plist"

	# Brightness restore
	[[ -f "${efi_work_dir}/../GTX/SSDT-LGPAGTX.aml" ]] && cp "${efi_work_dir}/../GTX/SSDT-LGPAGTX.aml" "${efi_work_dir}/OC/ACPI/"
	[[ -f "${efi_work_dir}/../MX350/SSDT-LGPA350.aml" ]] && cp "${efi_work_dir}/../GTX/SSDT-LGPA350.aml" "${efi_work_dir}/OC/ACPI/"
	restorePlist "${_old_config}" "${_new_config}" ':ACPI:Add' 'Path = SSDT-LGPA.aml' ':Enabled'
	restorePlist "${_old_config}" "${_new_config}" ':ACPI:Add' 'Path = SSDT-LGPAGTX.aml' ':Enabled'
	restorePlist "${_old_config}" "${_new_config}" ':ACPI:Add' 'Path = SSDT-LGPA350.aml' ':Enabled'
	echo -e "${CYAN}Done!${OFF}\n"
}

function restoreSSDT() {
	# Iterate over old config and restore
	# Should run last
	echo -e "${GREEN}Restoring missing SSDT...${OFF}"
	[[ -z "$efi_work_dir" ]] && errMsg "No work directory found. Try to download firts?" && exit 1
	[[ -z "$EFI_DIR" ]] && mount_efi
	local _old_config="${EFI_DIR}/EFI/OC/config.plist"
	local _new_config="${efi_work_dir}/OC/config.plist"

	local _oldEnabledSSDT
	read -r -a _oldEnabledSSDT <<<"$(getPlistArrayIndexHelper "${_old_config}" ":ACPI:Add" "Enabled = true")"
	for i in "${_oldEnabledSSDT[@]}"; do
		local _ssdtName
		_ssdtName=$(getPlist "${_old_config}" ":ACPI:Add:${i}:Path")
		local _ssdtComment
		_ssdtComment=$(getPlist "${_old_config}" ":ACPI:Add:${i}:Comment")
		local _newPath
		_newPath=$(getPlistHelper "${_new_config}" ":ACPI:Add" "Path = ${_ssdtName}")
		local _newEnabled
		_newEnabled=$(getPlist "${_new_config}" "${_newPath}" ":Enabled")
		if [[ "$_newEnabled" == true ]]; then
			# Same SSDT are enabled in both config, skip
			continue
		fi

		if ! readYesNo "${YELLOW}Do you wish to restore SSDT: ${CYAN}${UNDERLINE}${_ssdtName}${OFF} ${WHITE}(${_ssdtComment})${YELLOW}?"; then
			continue
		fi

		# Restoring SSDT
		if [[ -z "$_newEnabled" ]]; then
			# New entry
			"$PLEDIT" "${_new_config}" -x -c "Merge $(generateArrayPatch ${_old_config} :ACPI:Add:"${i}") :ACPI:Add" 2>/dev/null || errMsg "Failed to merge SSDT."
			cp -n "${EFI_DIR}/EFI/OC/ACPI/${_ssdtName}" "${efi_work_dir}/OC/ACPI/"
		else
			# Existing entry, but need to restore enabled
			restorePlist "${_old_config}" "${_new_config}" ':ACPI:Add' "Path = ${_ssdtName}" ':Enabled'
			# Do not copy as the newer EFI should have a newer aml
		fi

	done
}

function restoreKext() {
	# Iterate over old config and restore
	# Should run last
	echo -e "${GREEN}Restoring missing Kext's...${OFF}"
	[[ -z "$efi_work_dir" ]] && errMsg "No work directory found. Try to download firts?" && exit 1
	[[ -z "$EFI_DIR" ]] && mount_efi
	local _old_config="${EFI_DIR}/EFI/OC/config.plist"
	local _new_config="${efi_work_dir}/OC/config.plist"

	local _oldEnabledKext
	read -r -a _oldEnabledKext <<<"$(getPlistArrayIndexHelper "${_old_config}" ":Kernel:Add" "Enabled = true")"
	for i in "${_oldEnabledKext[@]}"; do
		local _kextBundle
		_kextBundle=$(getPlist "${_old_config}" ":Kernel:Add:${i}:BundlePath")
		local _kextComment
		_kextComment=$(getPlist "${_old_config}" ":Kernel:Add:${i}:Comment")
		local _newPath
		_newPath=$(getPlistHelper "${_new_config}" ":Kernel:Add" "BundlePath = ${_kextBundle}")
		local _newEnabled
		_newEnabled=$(getPlist "${_new_config}" "${_newPath}" ":Enabled")
		if [[ "$_newEnabled" == true ]]; then
			# Same Kext are enabled in both config, skip
			continue
		fi

		if ! readYesNo "${YELLOW}Do you wish to restore Kext: ${CYAN}${UNDERLINE}${_kextBundle}${OFF} ${WHITE}(${_kextComment})${YELLOW}?"; then
			continue
		fi

		# Restoring Kext
		if [[ -z "$_newEnabled" ]]; then
			# New entry
			"$PLEDIT" "${_new_config}" -x -c "Merge $(generateArrayPatch ${_old_config} :Kernel:Add:"${i}") :Kernel:Add" 2>/dev/null || errMsg "Failed to merge Kext."
			cp -r -n "${EFI_DIR}/EFI/OC/Kexts/${_kextBundle}" "${efi_work_dir}/OC/Kexts/"
		else
			# Existing entry, but need to restore enabled
			restorePlist "${_old_config}" "${_new_config}" ':Kernel:Add' "BundlePath = ${_kextBundle}" ':Enabled'
			# Do not copy as the newer EFI should have a newer kext
		fi

	done
}

function checkIntegrity() {
	echo -e "${GREEN}Cheking integrity..${OFF}"
	[[ -z "$efi_work_dir" ]] && errMsg "No work directory found. Try to download firts?" && exit 1
	[[ -z "$EFI_DIR" ]] && mount_efi
	local _old_config="${EFI_DIR}/EFI/OC/config.plist"
	local _new_config="${efi_work_dir}/OC/config.plist"
	local _integrity=0

	#Check SSDT
	echo -e "${GREEN}Checking config.plist format..."
	if ! "$PLUTIL" -lint "${_new_config}" >/dev/null; then
		errMsg "The config's format is corrupted... please open an issue"
		_integrity=1
	else
		echo "${GREEN}OK...${OFF}"
	fi

	local _newEnabledSSDT
	read -r -a _newEnabledSSDT <<<"$(getPlistArrayIndexHelper "${_new_config}" ":ACPI:Add" "Enabled = true")"
	for i in "${_newEnabledSSDT[@]}"; do
		local _ssdtName
		_ssdtName=$(getPlist "${_new_config}" ":ACPI:Add:${i}:Path")
		if [[ ! -f "${efi_work_dir}/OC/ACPI/${_ssdtName}" ]]; then
			# SSDT file missing from ACPI folder...
			local _ssdtComment
			_ssdtComment=$(getPlist "${_old_config}" ":ACPI:Add:${i}:Comment")
			if [[ -f "${EFI_DIR}/EFI/OC/ACPI/${_ssdtName}" ]]; then
				# SSDT found in old EFI, ask about copying the old SSDT
				echo
				echo -e "${CYAN}${UNDERLINE}${_ssdtName}${OFF}${WHITE}(${_ssdtComment})${GREEN} is ${RED}${BOLD}missing${OFF}${GREEN} in the ${UNDERLINE}NEW EFI${OFF}${GREEN}, but it exist in the old EFI folder!"

				if readYesNo "${YELLOW}Do you wish to copy ${CYAN}${UNDERLINE}${_ssdtName}${OFF}${YELLOW} from old EFI?${OFF}"; then
					cp "${EFI_DIR}/EFI/OC/ACPI/${_ssdtName}" "${efi_work_dir}/OC/ACPI/" || ((_integrity++))
					continue
				fi

			fi
			# Failed to copy file or not found
			errMsg "SSDT: ${_ssdtName} (${_ssdtComment}) exist in config.plist but not in ACPI folder!"
			_integrity=1
		fi
	done

  # Check Kext file
	local _newEnabledKext
	read -r -a _newEnabledKext <<<"$(getPlistArrayIndexHelper "${_new_config}" ":Kernel:Add" "Enabled = true")"
	for i in "${_newEnabledKext[@]}"; do
		local _kextBundlePath
		_kextBundlePath=$(getPlist "${_new_config}" ":Kernel:Add:${i}:BundlePath")
		if [[ ! -d "${efi_work_dir}/OC/Kexts/${_kextBundlePath}" ]]; then
			local _kextComment
			_kextComment=$(getPlist "${_new_config}" ":Kernel:Add:${i}:Comment")
			if [[ -d "${EFI_DIR}/EFI/OC/Kexts/${_kextBundlePath}" ]]; then
				echo
				echo -e "${CYAN}${UNDERLINE}${_kextBundlePath}${OFF}${WHITE}(${_kextComment})${GREEN} is ${RED}${BOLD}missing${OFF}${GREEN} in the ${UNDERLINE}NEW EFI${OFF}${GREEN}, but it exist in the old EFI folder!"

				if readYesNo "${YELLOW}Do you wish to copy ${CYAN}${UNDERLINE}${_kextBundlePath}${OFF}${YELLOW} from old EFI?${OFF}"; then
					cp -r "${EFI_DIR}/EFI/OC/Kexts/${_kextBundlePath}" "${efi_work_dir}/OC/Kexts/" || ((_integrity++))
					continue
				fi

			fi
			# Failed to copy file or not found
			errMsg "Kext: ${_kextBundlePath} (${_kextComment}) is enabled in config.plist but missing from Kexts folder!"
			((_integrity++))
		fi
	done

	# Check new Kext
	local _newEnabledKext
	read -r -a _newEnabledKext <<<"$(getPlistArrayIndexHelper "${_new_config}" ":Kernel:Add" "Enabled = true")"
	for i in "${_newEnabledKext[@]}"; do
		local _kextBundlePath
		_kextBundlePath=$(getPlist "${_new_config}" ":Kernel:Add:${i}:BundlePath")
    if ! getPlistHelper "${_old_config}" ":Kernel:Add" "BundlePath = ${_kextBundlePath}" &>/dev/null ; then
      local _kextComment
      _kextComment=$(getPlist "${_new_config}" ":Kernel:Add:${i}:Comment")
      echo
      echo -e "${CYAN}${UNDERLINE}${_kextBundlePath}${OFF}${WHITE}(${_kextComment})${GREEN} is an ${RED}${BOLD}UNKNOWN KEXT  missing from OLD EFI${OFF}${GREEN} but present in ${UNDERLINE}NEW EFI${OFF}${GREEN}!"

      if readYesNo "${YELLOW}Do you wish to DISABLE ${CYAN}${UNDERLINE}${_kextBundlePath}${OFF}${YELLOW} in the new EFI?${OFF}"; then
        "$PLEDIT" "${_new_config}" -c "Set :Kernel:Add:${i}:Enabled false" || ((_integrity++))
        continue
      fi
    fi
  done

	# Check with ocvalidate
	local _ocvalidate="${efi_work_dir}/../Utilities/ocvalidate"
	if [[ -f "$_ocvalidate" ]] && [[ -x "$_ocvalidate" ]]; then
		if "$_ocvalidate" "$_new_config"; then
			echo -e "${GREEN}ocvalidate passed${OFF}"
		else
			errMsg "ocvalidate failed... Manual tweak is needed"
			((_integrity++))
		fi
	else
		echo -e "${RED}${BOLD}SKIPPING ocvalidate, the final config.plist is not validated!${OFF}"
	fi

	return "$_integrity"
}

function main() {

	clear
	setupEnviroment
	stty -echoctl # No ^C when Ctrl-C is pressed
	trap 'cleanUp' SIGINT
	trap 'cleanUp' EXIT
	downloadEFI
	mountEFI
	backupEFI

	# Plist restore
	restoreDVMT
	restore0xE2
	restoreBluetooth
	restoreMiscPreference
	restorePlatformInfo
	brightnessKeyestore
	echo

	# Patch restore
	restoreOptionalKext

	# Disabled due to patch not uploaded to main repo
	if ! restoreBrcmPatchRAM; then
		echo -e "${RED}Failed to download patch for BrcmPatchRAM${OFF}"
	fi
	if ! restoreAirportFixup; then
		echo -e "${RED}Failed to download patch for AirportFixup${OFF}"
	fi
  if ! restoreNVMeFix; then
		echo -e "${RED}Failed to download patch for NVMeFix${OFF}"
	fi
	echo

	# Interactive restore
	restoreBootArgs
	echo
	restoreSIP
	echo
	restoreSSDT
	echo
	restoreKext
	echo
	if checkIntegrity; then
		echo ""
		installEFI
	else
		errMsg "Failed checking integrity... Existing..."
		unmountEFI
	fi
	echo

	exit 0
}
main

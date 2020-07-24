#!/bin/bash
#set -x # for DEBUGGING

# Created by stevezhengshiqi on 6 Jun, 2020
#
# Build ACPI SSDTs for XiaoMi-Pro EFI
#
# Reference:
# https://github.com/williambj1/Hackintosh-EFI-Asus-Zephyrus-S-GX531/blob/master/Makefile.sh by @williambj1

# Colors
black=$(tput setaf 0)
red=$(tput setaf 1)
green=$(tput setaf 2)
yellow=$(tput setaf 3)
blue=$(tput setaf 4)
magenta=$(tput setaf 5)
cyan=$(tput setaf 6)
white=$(tput setaf 7)
reset=$(tput sgr0)
bold=$(tput bold)

# Exit on Network Issue
function networkErr() {
  echo "${yellow}[${reset}${red}${bold} ERROR ${reset}${yellow}]${reset}: Failed to download resources from ${1}, please check your connection!"
  exit 1
}

# Exit on Compile Issue
function compileErr() {
  echo "${yellow}[${reset}${red}${bold} ERROR ${reset}${yellow}]${reset}: Failed to compile dsl!"
  find . -maxdepth 1 -name "*.aml" -exec rm -rf {} + >/dev/null 2>&1
  exit 1
}

# Download iasl from Acidanthera's MaciASL repository
function download() {
  local URL="https://raw.githubusercontent.com/$1/$2/master/$3"
  echo "${green}[${reset}${blue}${bold} Downloading ${3##*\/} ${reset}${green}]${reset}"
  echo "${cyan}"
  curl -# -L -O "${URL}" || networkErr "${3##*\/}"
  echo "${reset}"
}

function init() {
  if [[ ${OSTYPE} != darwin* ]]; then
    echo "This script can only run in macOS, aborting"
    exit 1
  fi

  cd "$(dirname "$0")" || exit 1

  if [[ -f "iasl-stable" ]]; then
    rm -rf "iasl-stable"
  fi
}

function compile() {
  chmod +x iasl*
  echo "${green}[${reset}${magenta}${bold} Compiling ACPI Files ${reset}${green}]${reset}"
  echo
  find . -type f -name "*.dsl" -print0 | xargs -0 -I{} ./iasl* -vs -va {} >/dev/null 2>&1 || compileErr
}

function enjoy() {
  echo "${red}[${reset}${blue}${bold} Done! Enjoy! ${reset}${red}]${reset}"
  echo
  open ./
}

function main() {
  init
  download Acidanthera MaciASL Dist/iasl-stable
  compile
  enjoy
}

main

#!/bin/bash
#set -x # for DEBUGGING

# Created by stevezhengshiqi on 24 Jul, 2020
#
# Build XiaoMi-Pro-Hackintosh wiki pdf


# Vars
WIKI_NAME="XiaoMi-Pro-Hackintosh.wiki"

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
function buildErr() {
  echo "${yellow}[${reset}${red}${bold} ERROR ${reset}${yellow}]${reset}: Failed to build pdf!"
  exit 1
}

# Download wiki from daliansky's XiaoMi-Pro-Hackintosh repository
function download() {
  local URL="https://github.com/$1/$2.wiki.git"
  echo "${green}[${reset}${blue}${bold} Downloading $2.wiki ${reset}${green}]${reset}"
  echo "${cyan}"
  git clone "${URL}" >/dev/null 2>&1 || networkErr "$2.wiki"
  echo "${reset}"
}

function init() {
  if [[ ${OSTYPE} != darwin* ]]; then
    echo "This script can only run in macOS, aborting"
    exit 1
  fi
  
  if [ "$(which pandoc)" = "" ]; then
    echo "${yellow}[${reset}${red}${bold} ERROR ${reset}${yellow}]${reset}: Missing pandoc, exit!"
    exit 1
  fi
  echo "${yellow}[${bold} WARNING ${reset}${yellow}]${reset}: BasicTex or MacTeX or LaTeX is required!"

  cd "$(dirname "$0")" || exit 1

  if [[ -d "${WIKI_NAME}" ]]; then
    rm -rf "${WIKI_NAME}"
  fi
}

function build() {
  local wikiItems=(
    "FAQ"
    "Drive-Native-Intel-Wireless-Card"
    "Set-DVMT-to-64mb"
    "Unlock-0xE2-MSR"
    "Work-Around-with-Bluetooth"
    "常见问题解答"
    "驱动内置英特尔无线网卡"
    "设置64mb动态显存"
    "解锁0xE2寄存器"
    "蓝牙解决方案"
  )
  cd "${WIKI_NAME}" || exit 1
  echo "${green}[${reset}${magenta}${bold} Building PDF Docs ${reset}${green}]${reset}"
  echo
  for wikiItem in "${wikiItems[@]}"; do
    pandoc -V geometry:margin=1in "${wikiItem}.md" -o "${wikiItem}.pdf" --pdf-engine=xelatex -V mainfont:'PingFang SC' -V monofont:'PingFang SC-Semibold' || buildErr
  done
  cp -R ./*.pdf "../" || exit 1
  cd "../" || exit 1
}

function enjoy() {
  echo "${red}[${reset}${blue}${bold} Done! Enjoy! ${reset}${red}]${reset}"
  echo
  open ./
}

function main() {
  init
  download daliansky XiaoMi-Pro-Hackintosh
  build
  enjoy
}

main

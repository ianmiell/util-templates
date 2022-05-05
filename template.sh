#!/usr/bin/env bash

# From: https://betterdev.blog/minimal-safe-bash-script-template/

set -Eeuo pipefail

cleanup() {
  EXIT_CODE=$?  # This must be the first line of the cleanup
  trap - SIGINT SIGTERM ERR EXIT
  # script cleanup here
}
trap cleanup SIGINT SIGTERM ERR EXIT

script_dir=$(cd "$(dirname "${BASH_SOURCE[0]}")" &>/dev/null && pwd -P)
if [[ "$OSTYPE" == "linux-gnu"* ]]; then
  abs_script_dir=$(readlink -f ${script_dir})
elif [[ "$OSTYPE" == "darwin"* ]]; then
  abs_script_dir=$(greadlink -f ${script_dir})
elif [[ "$OSTYPE" == "cygwin" ]]; then
  abs_script_dir=$(readlink -f ${script_dir})
elif [[ "$OSTYPE" == "msys" ]]; then
  abs_script_dir=$(readlink -f ${script_dir})
elif [[ "$OSTYPE" == "win32" ]]; then
  abs_script_dir=$(readlink -f ${script_dir})
elif [[ "$OSTYPE" == "freebsd"* ]]; then
  abs_script_dir=$(readlink -f ${script_dir})
else
  abs_script_dir=$(readlink -f ${script_dir})
fi

usage() {
  cat << EOF # remove the space between << and EOF, this is due to web plugin issue
Usage: $(basename "${BASH_SOURCE[0]}") [-h] [-v] [-f] -p param_value arg1 [arg2...]

Script description here.

Available options:

-h, --help      Print this help and exit
-v, --verbose   Print script debug info
-f, --flag      Some flag description
-p, --param     Some param description
EOF
  exit
}


setup_colors() {
  if [[ -t 2 ]] && [[ -z "${NO_COLOR-}" ]] && [[ "${TERM-}" != "dumb" ]]; then
    NOFORMAT='\033[0m' RED='\033[0;31m' GREEN='\033[0;32m' ORANGE='\033[0;33m' BLUE='\033[0;34m' PURPLE='\033[0;35m' CYAN='\033[0;36m' YELLOW='\033[1;33m'
  else
    NOFORMAT='' RED='' GREEN='' ORANGE='' BLUE='' PURPLE='' CYAN='' YELLOW=''
  fi
}

msg() {
  echo >&2 -e "${1-}"
}

die() {
  local msg=$1
  local code=${2-1} # default exit status 1
  msg "$msg"
  exit "$code"
}

parse_params() {
  # default values of variables set from params
  flag=0
  param=''

  while :; do
    case "${1-}" in
    -h | --help) usage ;;
    -v | --verbose) set -x ;;
    --no-color) NO_COLOR=1 ;;
    -f | --flag) flag=1 ;; # example flag
    -p | --param) # example named parameter
      param="${2-}"
      shift
      ;;
    -?*) die "Unknown option: $1" ;;
    *) break ;;
    esac
    shift
  done

  args=("$@")

  # check required params and arguments
  [[ -z "${param-}" ]] && usage && die "Missing required parameter: param"
  [[ ${#args[@]} -eq 0 ]] && usage && die "Missing script arguments"

  return 0
}

parse_params "$@"
setup_colors

# script logic here

msg "${RED}Read parameters:${NOFORMAT}"
msg "- flag: ${flag}"
msg "- param: ${param}"
msg "- arguments: ${args[*]-}"

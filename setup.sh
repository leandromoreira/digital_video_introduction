#!/bin/bash
check_cmd()
{
  if ! which $1 &>/dev/null; then
    error "$1 command not found, you must install it before."
  fi
}

error()
{
  echo "Error: $*" >&2
  exit 1
}

check_cmd docker
check_cmd wget

./s/download_video.sh
./s/cut_smaller_video.sh

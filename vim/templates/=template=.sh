#!/bin/bash

debug=false

action()
{
    echo $@
    $debug || eval $@
}

die()
{
  echo "$@" 1>&2
  exit 1
}

usage()
{
  die "
  Usage ${0##*/} [-h|--help] [-d|--debug] %HERE%

  Description.

  ARGS Description.

  Options:
  -h, --help        Display this help message
  -d, --debug       Do not perform any actual actions, just output what would be done.
  "
}

options=$(getopt --name="${0##*/}" \
  --options="hd" \
  --longoptions="help,debug" -- "$@")
[[ $? != 0 ]] && usage

eval set -- "${options}"
while true; do
  case "$1" in
    -h|--help) usage; shift;;
    -d|--debug) debug=true; shift;;
    --) shift; break;;
  esac
done

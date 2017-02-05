#!/bin/bash

# ENVIRONMENT:
#
# $BASHGT_DOMAIN = Domain for gettext

# print message to stderr
#
# parameters:
# $1 = message
bashgt_print_stderr() {
  echo "$1" 1>&2
}

# translate simple string
#
# parameters:
# $1 = string to translate
_() {
  if [ -z "$1" ]
  then
    bashgt_print_stderr "bash-gettext (_('$1')): Parameter 1 missing."
    return 1
  fi

  if [ -z "$BASHGT_DOMAIN" ]
  then
    bashgt_print_stderr "bash-gettext (_($1)): No gettext domain set."
    return 1
  fi

  echo -n "$(gettext -d "$BASHGT_DOMAIN" "$1")"
}

# translate string with msgctxt
#
# parameters:
# $1 = message context
# $2 = string to translate
_p() {
  if [ -z "$1" ]
  then
    bashgt_print_stderr "bash-gettext (_p('$1', '$2')): Parameter 1 missing."
    return 1
  fi

  if [ -z "$2" ]
  then
    bashgt_print_stderr "bash-gettext (_p('$1', '$2')): Parameter 2 missing."
    return 1
  fi

  if [ -z "$BASHGT_DOMAIN" ]
  then
    bashgt_print_stderr "bash-gettext (_p('$1', '$2')): No gettext domain set."
    return 1
  fi

  echo -n "$(gettext -d "$BASHGT_DOMAIN" "$1" "$2")"
}

__() {
  if [ -z "$1" ]
  then
    bashgt_print_stderr "bash-gettext (__('$1', '$2', [replacments, ...])): Parameter 1 missing."
    return 1
  fi

  if [ -z "$2" ]
  then
    bashgt_print_stderr "bash-gettext (__('$1', '$2', [replacements, ...])): Parameter 2 missing."
    return 1
  fi

  if [ -z "$BASHGT_DOMAIN" ]
  then
    bashgt_print_stderr "bash-gettext (__('$1', '$2', [replacements, ...])): No gettext domain set."
    return 1
  fi

  ret=$(_ "$1")
  loops=0
  args=()

  for a in "$@"
  do
    # ignore first paramter, it is translated expression
    if [ $loops -lt 1 ]
    then
      loops=$(expr $loops + 1)
      continue
    fi

    args+=($a)
    loops=$(expr $loops + 1)
  done

  echo -n "$(printf "$ret" ${args[@]})"
}

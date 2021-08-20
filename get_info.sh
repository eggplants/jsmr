#!/usr/bin/env bash

set -e
MAX_PAGE_NUM=516

_mk() {
  curl "https://japaneseasmr.com/page/[1-${MAX_PAGE_NUM}]/" |
    grep -oP '(?<=https://japaneseasmr.com/)\d+(?=/)' |
    sort -n | uniq >ar_lis_nums
}

_mk_rj() {
  local len c i
  : >RJ_lis
  len="$(wc <ar_lis_nums -l)"
  c=1
  cat <ar_lis_nums | while read -r i; do
    echo -ne "[${c}/${len}]: page_id=$i\r"
    curl -s "https://japaneseasmr.com/$i/" |
      grep -oPm1 '(?<=src="https://pic.weeabo0.xyz/)RJ\d+(?=_img)' >>RJ_lis
    ((c++))
  done
  echo
}

_mk_za() {
  local len c i
  : >zippy_lis
  : >anon_lis
  len="$(wc <RJ_lis -l)"
  c=1
  cat <RJ_lis | while read -r i; do
    echo -ne "[${c}/${len}]: dl_id=$i\r"
    curl -w "%{redirect_url}\n" -s -o /dev/null "https://japaneseasmr.com/dlz.php?f=${i}" >>zippy_lis
    curl -w "%{redirect_url}\n" -s -o /dev/null "https://japaneseasmr.com/dla.php?f=${i}" >>anon_lis
    ((c++))
  done
  echo
  sed '/^$/d' zippy_lis >/tmp/_
  mv /tmp/_ zippy_lis
  sed '/^$/d' anon_lis >/tmp/_
  mv /tmp/_ anon_lis
}

_a() {
  [ "$1" = "-y" ] && {
    _mk
    return 0
  }
  if [ -f ar_lis_nums ]; then
    echo -n "[!]: update?(n/y): "
    read -r s
    [ "$s" = "y" ] && _mk
    return 0
  else
    _mk
  fi
}

_b() {
  [ "$1" = "-y" ] && {
    _mk_rj
    return 0
  }
  if [ -f RJ_lis ]; then
    echo -n "[!]: update?(n/y): "
    read -r s
    [ "$s" = "y" ] && _mk_rj
    return 0
  else
    _mk_rj
  fi
}

_c() {
  [ "$1" = "-y" ] && {
    _mk_za
    return 0
  }
  if { [ -f zippy_lis ] && [ -f anon_lis ]; }; then
    echo -n "[!]: update?(n/y): "
    read -r s
    [ "$s" = "y" ] && _mk_za
    return 0
  else
    _mk_za
  fi
}

main() {
  echo "[+]: making article list..."
  _a "$1"

  echo "[+]: making RJ list..."
  _b "$1"

  echo "[+]: get dl links..."
  _c "$1"

  echo "[+]: done!"
}

main "$@"
exit "$?"

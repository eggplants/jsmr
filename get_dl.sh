#!/usr/bin/env bash

_z() {
  [ "$DL" = 1 ] && echo "DL: enabled"
  local c len i d
  c=1
  grep 'zippyshare\.com/v/' | sort -V | sed -n '/www60/,$p' >/tmp/_
  len="$(wc </tmp/_ -l)"
  cat </tmp/_ | while read -r i; do
    echo -ne "[$((c++))/${len}]: $i\r"
    [ "$1" = "-d" ] && {
      echo
      continue
    }
    : >>zippy_dl_lis
    d=$(curl -s "$i" | grep -oE '"/d/[a-zA-Z0-9]+/" \+ [^;]+' |
      sed -E 's/^/print /;s/" \+ (\()/",\1/; s/(\)) \+ "/\1,"/' |
      bc | sed "s_.*_${i//\/v*/}&"$"\\n_")
    if [ -n "$d" ]; then
      echo "$d" >>zippy_dl_lis
      [ "$DL" = 1 ] && curl -OL "$d"
    fi
  done
}

_a() {
  [ "$DL" = 1 ] && echo "DL: enabled"
  local c len i d
  c=1
  grep 'anonfiles\.com/' >/tmp/_
  len="$(wc </tmp/_ -l)"
  cat </tmp/_ | while read -r i; do
    echo -ne "[$((c++))/${len}]: $i\r"
    [ "$1" = "-d" ] && {
      echo
      continue
    }
    : >>anon_dl_lis
    d="$(
      curl -s "$i" | tr -d \\n |
        sed -nE 's_^.*(cdn-[0-9]+\.anonfiles\.com\/[^"]+).*$_https://\1_p'
    )"
    if [ -n "$d" ]; then
      echo "$d" >>anon_dl_lis
      [ "$DL" = 1 ] && curl -OL "$d"
    fi
  done
}

main() {
  if [ "$1" = "z" ]; then
    _z "$2"
  elif [ "$1" = "a" ]; then
    _a "$2"
  else
    echo "[Usage]: cat zippy_lis | $0 <z|a> [-d]"
  fi
}

main "$@"
exit "$?"

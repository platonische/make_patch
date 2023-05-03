#!/bin/bash

ORIGIN='module-payment'
MODIFIED='module-payment-app'
PATCHNAME='modified-novalnet-payment'
PREFFIX='/vendor/novalnet'

FILE_PREPATCH=${PATCHNAME}.diff
FILE_PATCH=${PATCHNAME}-processed.diff


rm ./${FILE_PREPATCH} ./${FILE_PATCH}
diff -ruN ./${ORIGIN}/ ./${MODIFIED}/ > ./${FILE_PREPATCH}


while IFS= read -r line
do
  if [ -z "${line##*diff -ruN*}" ]; then
    line="==================================================================="
  fi

  if [ -z "${line##*--- .*}" ]; then

    if [ -z "${line##*1970-01-01*}" ]; then
      # true - new file
      line="--- /dev/null"
    else
      # false - file was exists
      line=${line//--- .\/${ORIGIN}/--- ..}
    fi
  fi
  if [ -z "${line##*+++ .*}" ]; then
   line=${line//${MODIFIED}\//${ORIGIN}\/}
   line=${line//+++ .\/${ORIGIN}/+++ ..}
  fi

  printf "%s\n" "$line" >> ./${FILE_PATCH}

done < ./${FILE_PREPATCH}
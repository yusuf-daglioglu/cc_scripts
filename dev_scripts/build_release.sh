#!/bin/bash

# run this script in the directory itself.

# maximum shell compatible exception handling.
# -e --> herhangi bir komut hata verirse script durur
# -u --> tanımsız değişken hata üretir
set -eu

cd ..
PROJECT_FOLDER_ROOT_PATH_ABSOLUTE=$(pwd)
RELEASE_FILE_FULL_PATH="$PROJECT_FOLDER_ROOT_PATH_ABSOLUTE/release/cc_scripts.sh"

printf '
###################################################
# PROJECT NAME: cc_scripts
# SHORT DESCRIPTION: Multi-purpose shell functions.
# URL: https://github.com/yusuf-daglioglu/cc_scripts
export CC_SCRIPTS_PROJECT_VERSION=6
################################################### \n\n' >"$RELEASE_FILE_FULL_PATH"

___appendToReleaseFile() {
   local -r SOURCE_FILE_NAME="$1"

   local -r SOURCE_FILE_FULL_PATH="$PROJECT_FOLDER_ROOT_PATH_ABSOLUTE/src/$SOURCE_FILE_NAME"
   local -r FILE_CONTENT="$(<"$SOURCE_FILE_FULL_PATH")"
   # %s --> print the string as literally (it will not fail if the the content has any shell syntax).
   printf '######\n# File name:%s\n#####\n\n%s\n\n' "$SOURCE_FILE_NAME" "$FILE_CONTENT" >>"$RELEASE_FILE_FULL_PATH"
}

for file in $PROJECT_FOLDER_ROOT_PATH_ABSOLUTE/src/*; do
    filename=$(basename "$file")
    ___appendToReleaseFile "$filename"
done

printf '%s\n' '
# PRINT VERSION WHEN CC_SCRIPT.SH FILE IS LOADED
printf "%s\n" "cc_scripts version: $CC_SCRIPTS_PROJECT_VERSION"' >>"$RELEASE_FILE_FULL_PATH"

printf "%s\n" "Build done."
printf "%s\n" "Sourcing the release file, in case of any syntax error..."
source "$RELEASE_FILE_FULL_PATH"
printf "%s\n" "Script sourced successfully."


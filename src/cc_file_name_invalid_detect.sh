___invalid_file_name() {
   printf "%s\n" "+++++ File: $2 ---> Invalid Reason: $1"
   printf "%s" "$2" >>"$INVALID_FILE_LIST"
   printf "%s" "$1" >>"$INVALID_FILE_ERROR_CODE_LIST"
}

cc_file_name_invalid_detect() {

   ##############################
   # ABOUT
   ##############################
   # This function detects the invalid file names for MS Windows.
   # The rules are taken from this page: https://docs.microsoft.com/en-us/windows/win32/fileio/naming-a-file ("web.archive.org" and "archive.is". archived date: 01/05/2020)
   #
   # This function also prints suggestions for file names. Example suggestions:
   # - if it includes non-alpha numeric caharacter
   # - if it includes non-pritable character
   # - if it includes ' character
   #
   # This function tested on:
   # - Fedora
   # - GNU grep 3.8
   # - ZSH5.9 (x86_64-redhat-linux-gnu)
   # - GNU bash, version 5.2.15(1)-release (x86_64-redhat-linux-gnu) 
   ##############################
   ##############################
   ##############################

   ##############################
   # FUNCTION PARAMETERS
   ##############################
   local -r DIRECTORY_TO_VALIDATE="$1"
   local -r EXCLUDE_REGEX="$2"
   ##############################
   ##############################
   ##############################

   # check if string empty
   if [ -z "$DIRECTORY_TO_VALIDATE" ] || [ -z "$EXCLUDE_REGEX" ]; then
      printf "%s\n" "+++++ DIRECTORY_TO_VALIDATE or EXCLUDE_REGEX must be given"
      return
   fi

   if ! command -v basename >/dev/null 2>&1 \
      || ! command -v grep >/dev/null 2>&1 \
      || ! command -v find >/dev/null 2>&1 \
      || ! command -v read >/dev/null 2>&1 \
      || ! command -v mktemp >/dev/null 2>&1 \
      || ! command -v test >/dev/null 2>&1 \
   ; then
      printf "%s\n" "+++++ required commands not exist"
      return
   fi

   # This is needed for unit tests.
   export INVALID_FILE_LIST="$(mktemp)" || {
      ___errorHandler "$?" 1012001
      return
   }
   export INVALID_FILE_ERROR_CODE_LIST="$(mktemp)" || {
      ___errorHandler "$?" 1012002
      return
   }

   local -r PREFIX_MS_WINDOWS="MS_WINDOWS_RULE___"
   local -r PREFIX_NIX_FAMILY="NIX_FAMILY_RULE___"
   local -r PREFIX_BOTH_NIX_AND_MS_WINDOWS="BOTH_NIX_AND_MS_WINDOWS_RULE___"
   local -r PREFIX_SUGGESTION="SUGGESTION___" # These are only suggestion. They are not mandatory by any OS/filesystem.

   local -r MAX_FILE_LENGTH="252" # Max path length is 255. But there is drive directory letters which is minimum 3 character (example: C:\ ).

   # do not use other loop types because they will break if file name have special character: https://stackoverflow.com/questions/9612090/how-to-loop-through-file-names-returned-by-find ("web.archive.org" and "archive.is". archived date: 01/05/2020)
   find "$DIRECTORY_TO_VALIDATE" -name "*" ! -path "*/$EXCLUDE_REGEX/*" -print0 |
      while IFS= read -r -d '' FILE_OR_DIR_FULL_PATH; do

         local FILE_OR_DIR_NAME="$(basename "$FILE_OR_DIR_FULL_PATH")"

         for RESERVED_NAME in "CON" "PRN" "AUX" "NUL" "COM1" "COM2" "COM3" "COM4" "COM5" "COM6" "COM7" "COM8" "COM9" "LPT1" "LPT2" "LPT3" "LPT4" "PT5" "LPT6" "LPT7" "LPT8" "LPT9"; do
            local REGEX1='^'"$RESERVED_NAME"'[.].*' # start with 'CON' & have dot character & have any character
            local REGEX2='^'"$RESERVED_NAME"'$'     # start with 'CON' & ends
            local REGEX3='^'"$RESERVED_NAME"'[.]$'  # start with 'CON' & have dot character & ends
            printf "%s" "$FILE_OR_DIR_NAME" | grep --basic-regexp "$REGEX1" >/dev/null 2>&1 && ___invalid_file_name "$PREFIX_MS_WINDOWS""CAN_NOT_START_WITH_$RESERVED_NAME""_AND_DOT" "$FILE_OR_DIR_FULL_PATH"
            printf "%s" "$FILE_OR_DIR_NAME" | grep --basic-regexp "$REGEX2" >/dev/null 2>&1 && ___invalid_file_name "$PREFIX_MS_WINDOWS""ONLY_$RESERVED_NAME""_IS_RESERVED" "$FILE_OR_DIR_FULL_PATH"
            printf "%s" "$FILE_OR_DIR_NAME" | grep --basic-regexp "$REGEX3" >/dev/null 2>&1 && ___invalid_file_name "$PREFIX_MS_WINDOWS""ONLY_$RESERVED_NAME""_AND_DOT_IS_RESERVED" "$FILE_OR_DIR_FULL_PATH"
         done

         local FILE_OR_DIR_FULL_PATH_LENGTH="$(expr length \""$FILE_OR_DIR_FULL_PATH"\")"
         local DIRECTORY_TO_VALIDATE_LENGTH="$(expr length \""$DIRECTORY_TO_VALIDATE"\")"
         local RELATIVE_PATH_LENGTH="$(expr $FILE_OR_DIR_FULL_PATH_LENGTH - $DIRECTORY_TO_VALIDATE_LENGTH)"
         # -gt -> greater than
         if [ "$RELATIVE_PATH_LENGTH" -gt "$MAX_FILE_LENGTH" ]; then
            ___invalid_file_name "$PREFIX_MS_WINDOWS""MAX_252_CHAR_LIMIT" "$FILE_OR_DIR_FULL_PATH"
         fi

         test "$FILE_OR_DIR_NAME" = '0' && ___invalid_file_name "$PREFIX_MS_WINDOWS""0_IS_RESERVED" "$FILE_OR_DIR_FULL_PATH"

         test "$FILE_OR_DIR_NAME" = '.' && ___invalid_file_name "$PREFIX_BOTH_NIX_AND_MS_WINDOWS""ONLY_DOT_IS_REZERVED" "$FILE_OR_DIR_FULL_PATH"

         test "$FILE_OR_DIR_NAME" = '..' && ___invalid_file_name "$PREFIX_BOTH_NIX_AND_MS_WINDOWS""ONLY_DUBLE_DOT_IS_REZERVED" "$FILE_OR_DIR_FULL_PATH"

         # condition: is directory exist
         if [ ! -d "$FILE_OR_DIR_FULL_PATH" ]; then

            printf "%s" "$FILE_OR_DIR_NAME" | grep --basic-regexp '[.]$' >/dev/null 2>&1 && ___invalid_file_name "$PREFIX_MS_WINDOWS""CAN_NOT_END_WITH_DOT" "$FILE_OR_DIR_FULL_PATH"
            printf "%s" "$FILE_OR_DIR_NAME" | grep --basic-regexp '[ ]$' >/dev/null 2>&1 && ___invalid_file_name "$PREFIX_MS_WINDOWS""CAN_NOT_END_WITH_SPACE" "$FILE_OR_DIR_FULL_PATH"
         fi

         for RESERVED_CHAR in '*' '?' ':' '"' '<' '>' '|' '\\'; do
            printf "%s" "$FILE_OR_DIR_NAME" | grep --basic-regexp "$RESERVED_CHAR" >/dev/null 2>&1 && ___invalid_file_name "$PREFIX_MS_WINDOWS""RESERVED_CHARACTER_$RESERVED_CHAR" "$FILE_OR_DIR_FULL_PATH"
         done

         for RESERVED_CHAR in '/'; do
            printf "%s" "$FILE_OR_DIR_NAME" | grep --basic-regexp "$RESERVED_CHAR" >/dev/null 2>&1 && ___invalid_file_name "$PREFIX_NIX_FAMILY""RESERVED_CHARACTER_$RESERVED_CHAR" "$FILE_OR_DIR_FULL_PATH"
         done

         # condition: string contains:
         [[ "$FILE_OR_DIR_NAME" == *" "* ]] && ___invalid_file_name "$PREFIX_SUGGESTION""INCLUDES_SPACE" "$FILE_OR_DIR_FULL_PATH"

         # condition: string contains:
         [[ "$FILE_OR_DIR_NAME" == *"'"* ]] && ___invalid_file_name "$PREFIX_SUGGESTION""'_CHARACTER_IS_NOT_RECOMMENDED" "$FILE_OR_DIR_FULL_PATH"

         printf "%s" "$FILE_OR_DIR_NAME" | grep --basic-regexp '[[:cntrl:]]' >/dev/null 2>&1 && ___invalid_file_name "$PREFIX_SUGGESTION""INCLUDES_CONTROL_CHARACTER" "$FILE_OR_DIR_FULL_PATH"

         printf "%s" "$FILE_OR_DIR_NAME" | grep --basic-regexp '[^[:print:]]' >/dev/null 2>&1 && ___invalid_file_name "$PREFIX_SUGGESTION""INCLUDES_NON_PRINTABLE_CHARACTER" "$FILE_OR_DIR_FULL_PATH"

         printf "%s" "$FILE_OR_DIR_NAME" | grep --invert-match --extended-regexp '^[a-zA-Z0-9_.-]{1,}$' >/dev/null 2>&1 && ___invalid_file_name "$PREFIX_SUGGESTION""IS_NOT_ALPHA_NUMERIC_AND_EXCEPT_UNDERSCORE_AND_DASH_AND_DOT" "$FILE_OR_DIR_FULL_PATH"
      done
}

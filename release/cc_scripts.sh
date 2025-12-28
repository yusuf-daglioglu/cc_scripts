
###################################################
# PROJECT NAME: cc_scripts
# SHORT DESCRIPTION: Multi-purpose shell functions.
# URL: https://github.com/yusuf-daglioglu/cc_scripts
export CC_SCRIPTS_PROJECT_VERSION=2
################################################### 

######
# File name:cc_color_line.sh
#####

cc_color_line_HELP_ONLY() {
   printf "%s\n" USAGE:
   printf "%s\n" 'ls -a | cc_color_line'
   printf "%s\n" 'ping google.com | cc_color_line'
}

# The color values below cannot be overridden by the terminal emulator theme.
__CC_TEXT_BOLD="$(tput bold)"
__CC_COLOR_TEXT_WHITE="$(printf '\033[38;2;255;255;255m')"
__CC_FONT_RESET="$(tput sgr0)"
__CC_COLOR_BACKGROUND_BLUE="$(printf '\033[48;2;0;90;255m')"
__CC_COLOR_BACKGROUND_GREEN="$(printf '\033[48;2;0;180;0m')"

__CC_COLOR_BLUE="${__CC_TEXT_BOLD}${__CC_COLOR_TEXT_WHITE}${__CC_COLOR_BACKGROUND_BLUE}"
__CC_COLOR_GREEN="${__CC_TEXT_BOLD}${__CC_COLOR_TEXT_WHITE}${__CC_COLOR_BACKGROUND_GREEN}"
__CC_COLOR_RESET="${__CC_FONT_RESET}"

cc_color_line() {
   while IFS= read -r line; do
      printf "%s\n" "${__CC_COLOR_BLUE}${line}${__CC_COLOR_RESET}"
      IFS= read -r line || break
      printf "%s\n" "${__CC_COLOR_GREEN}${line}${__CC_COLOR_RESET}"
   done
}

######
# File name:cc_file_name_invalid_detect.sh
#####

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

######
# File name:cc_notify_user.sh
#####

cc_notify_user_HELP_ONLY() {
   printf "%s\n" "USAGE"
   printf "%s\n" 'sleep 2; cc_notify_user 1 hello'
}

cc_notify_user() {

   # store last exit code
   local -r LAST_COMMAND_EXIT_CODE="$?"

   ##############################
   # FUNCTION PARAMETERS
   ##############################
   local TIME_TO_BEEP="$1"
   local MESSAGE="$2"
   ##############################
   ##############################
   ##############################

   local -r COMMAND_NAME="cc_notify_user command"

   # check if it is empty
   if [ -z "$MESSAGE" ]; then
      MESSAGE="notification by $COMMAND_NAME"
   fi

   printf "%s\n" "+++++ $MESSAGE"

   # MacOS GUI notification
   # condition: if command exist
   if command -v osascript >/dev/null 2>&1; then
      osascript -e "display notification \""$MESSAGE"\" with title "$COMMAND_NAME"";
   fi

   # Linux GUI notification
   # condition: if command exist
   if command -v notify-send >/dev/null 2>&1; then
      notify-send "$MESSAGE" --app-name "$COMMAND_NAME";
   fi

   local -r MS_WINDOWS_NOTIFY_COMMANDS='
   [reflection.assembly]::loadwithpartialname("System.Windows.Forms")
   [reflection.assembly]::loadwithpartialname("System.Drawing")
   $notify = new-object system.windows.forms.notifyicon
   $notify.icon = [System.Drawing.SystemIcons]::Information
   $notify.visible = $true
   $notify.showballoontip(20,"'$COMMAND_NAME'","'$MESSAGE'",[system.windows.forms.tooltipicon]::None)
   '

   if command -v powershell >/dev/null 2>&1; then
      powershell -c "$MS_WINDOWS_NOTIFY_COMMANDS";
   fi

   if ! command -v speaker-test >/dev/null 2>&1 || ! command -v timeout >/dev/null 2>&1; then
      return "$LAST_COMMAND_EXIT_CODE"
   fi

   # check if it is empty
   if [ -z "$TIME_TO_BEEP" ]; then
      TIME_TO_BEEP="3"
   fi

   timeout --kill-after=$TIME_TO_BEEP $TIME_TO_BEEP speaker-test --frequency 1000 --test sine >"/dev/null" 2>/dev/null

   # always return last exit code. never override last exit code.
   # Because this a simple notification function. It should be pure function.
   return $LAST_COMMAND_EXIT_CODE
}

######
# File name:cc_rename_files.sh
#####

cc_rename_files() {

   ##############################
   # ABOUT
   ##############################
   # massren alternative.
   # massren does not have any package installer (deb, rpm, snap, flatpak...).
   # massren depends on 'go' platform. this is a simple shell alternative.
   ##############################
   ##############################
   ##############################

   ##############################
   # FUNCTION PARAMETERS
   ##############################
   local DIRECTORY_TO_RENAME="$1"
   local EXCLUDE_REGEX="$2"
   ##############################
   ##############################
   ##############################

   printf "%s\n" "+++++ a bug exist for files which have $ character."

   # check if string empty
   if [ -z "$DIRECTORY_TO_RENAME" ] || [ -z "$EXCLUDE_REGEX" ]; then
      printf "%s\n" "+++++ DIRECTORY_TO_RENAME or EXCLUDE_REGEX must be given"
      return
   fi

   # sort command is required when we want same changes to apply on another (cloned) directory (like backup).
   if ! command -v mkdir >/dev/null 2>&1 \
      || ! command -v mv >/dev/null 2>&1 \
      || ! command -v expr >/dev/null 2>&1 \
      || ! command -v find >/dev/null 2>&1 \
      || ! command -v while >/dev/null 2>&1 \
      || ! command -v read >/dev/null 2>&1 \
      || ! command -v sort >/dev/null 2>&1 \
   ; then
      printf "%s\n" "+++++ required commands not exist"
      return
   fi

   if ! command -v sed >/dev/null 2>&1 && ! command -v awk >/dev/null 2>&1; then
      printf "%s\n" "+++++ sed or awk command not exist"
   fi

   local DIRECTORY_TO_RENAME_LENGTH="$(expr length \""$DIRECTORY_TO_RENAME"\")"
   DIRECTORY_TO_RENAME_LENGTH=$((DIRECTORY_TO_RENAME_LENGTH - 2))

   OLD_FILE_LIST="$HOME/old_files_list.txt"
   NEW_FILE_LIST="$HOME/new_files_list.txt"
   printf "%s" "" >"$OLD_FILE_LIST"
   printf "%s" "" >"$NEW_FILE_LIST"

   # do not use other loop types because they will break if file name have special character: https://stackoverflow.com/questions/9612090/how-to-loop-through-file-names-returned-by-find ("web.archive.org" and "archive.is". archived date: 01/05/2020)
   find "$DIRECTORY_TO_RENAME" -type f -name "*" ! -path "*/$EXCLUDE_REGEX/*" -print0 | sort -z |
      while IFS= read -r -d '' FILE_OR_DIR_FULL_PATH; do
         printf "%s\n" "$FILE_OR_DIR_FULL_PATH" >>"$OLD_FILE_LIST"
         printf "%s\n" "${FILE_OR_DIR_FULL_PATH:$DIRECTORY_TO_RENAME_LENGTH}" >>"$NEW_FILE_LIST"
      done

   printf "%s\n" "+++++ rename the files from: gnome-text-editor $NEW_FILE_LIST"

   printf "%s\n" '+++++ if you changed the file names, type "y" to resume...'
   read RESUME

   if [ "$RESUME" != "y" ]; then
      printf "%s\n" "+++++ script will exit."
      return
   fi

   local LINE_NUMBER="0"
   local FIRST_LINE_OF_OLD_FILE_LIST="TRUE"
   while read OLD_FILE_FULL_PATH; do
      
         LINE_NUMBER=$((LINE_NUMBER + 1))

         local NEW_RELATIVE_FILE_NAME=""

         if command -v sed >/dev/null 2>&1 ; then
            NEW_RELATIVE_FILE_NAME=$(sed "$LINE_NUMBER"'!d' "$NEW_FILE_LIST")
         elif command -v awk >/dev/null 2>&1 ; then
            NEW_RELATIVE_FILE_NAME=$(awk 'NR=='"$LINE_NUMBER" "$NEW_FILE_LIST")
         fi

         if [ "$OLD_FILE_FULL_PATH" != "$DIRECTORY_TO_RENAME$NEW_RELATIVE_FILE_NAME" ]; then
            # -p --> do not give error if dir already exist
            local FOLDER="$(dirname "$DIRECTORY_TO_RENAME$NEW_RELATIVE_FILE_NAME")"
            mkdir -p "$FOLDER"
            
            printf "%s\n" "+++++ command: mv \"$OLD_FILE_FULL_PATH\" \"$DIRECTORY_TO_RENAME$NEW_RELATIVE_FILE_NAME\""
            mv "$OLD_FILE_FULL_PATH" "$DIRECTORY_TO_RENAME$NEW_RELATIVE_FILE_NAME"
         fi
      
   done <"$OLD_FILE_LIST"
}

######
# File name:cc_sync_directories.sh
#####

cc_sync_directories() {

   ##############################
   # FUNCTION PARAMETERS
   ##############################
   local -r SOURCE_DIRECTORY="$1"
   local -r DESTINATION_DIRECTORY="$2"
   ##############################
   ##############################
   ##############################

   # check if string empty
   if [ -z "$SOURCE_DIRECTORY" ] || [ -z "$DESTINATION_DIRECTORY" ]; then
      printf "%s\n" "+++++ destination or source must be given"
      return
   fi

   # condition: if command exist
   if ! command -v rsync >/dev/null 2>&1; then
      printf "%s\n" "+++++ rsync command does not exist"
      return
   fi

   # --omit-dir-times --no-perms --inplace parameters are required for android usb devices.

   printf "%s\n" "+++++ list only changes first? (if you answer 'n' it will directly start to sync. CTRL+C to stop it now.)"
   printf "%s\n" "+++++ y/n"
   read listOnlyChanges

   if [ "$listOnlyChanges" = "y" ]; then

      rsync --recursive --archive -verbose --delete-excluded --size-only --progress --omit-dir-times --no-perms --recursive --inplace "$SOURCE_DIRECTORY"/ "$DESTINATION_DIRECTORY"/ --dry-run || { printf "%s\n" "rsync error. exit code: $?"; return; }

      printf "%s\n" "+++++ accept above changes?"
      printf "%s\n" "+++++ y/n"
      read choice

      if [ "$choice" != "y" ]; then
         printf "%s\n" "+++++ wrong choice or decline by user."
         return
      fi

   elif [ "$listOnlyChanges" != "n" ]; then

      printf "%s\n" "+++++ wrong choice."
      return
   fi

   printf "%s\n" "+++++ command executed: rsync --recursive --archive -verbose --delete-excluded --size-only --progress --omit-dir-times --no-perms --recursive --inplace \"$SOURCE_DIRECTORY\"/ \"$DESTINATION_DIRECTORY\"/"
   
   rsync --recursive --archive -verbose --delete-excluded --size-only --progress --omit-dir-times --no-perms --recursive --inplace "$SOURCE_DIRECTORY"/ "$DESTINATION_DIRECTORY"/

   cc_notify_user 5 "sync finished"
}


# PRINT VERSION WHEN CC_SCRIPT.SH FILE IS LOADED
printf "%s\n" "cc_scripts version: $CC_SCRIPTS_PROJECT_VERSION"


###################################################
# PROJECT NAME: cc_scripts
# SHORT DESCRIPTION: Multi-purpose shell functions.
# URL: https://github.com/yusuf-daglioglu/cc_scripts
export CC_SCRIPTS_PROJECT_VERSION=6
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
# File name:cc_notify_user.sh
#####

cc_notify_user_HELP_ONLY() {
   printf "%s\n" "USAGE"
   printf "%s\n" 'sleep 2; cc_notify_user 1 hello'
}

cc_notify_user() {

   # store last exit code
   local LAST_COMMAND_EXIT_CODE=$?

   ##############################
   # FUNCTION PARAMETERS
   ##############################
   local TIME_TO_BEEP="$1"
   local MESSAGE="$2"
   ##############################
   ##############################
   ##############################

   local COMMAND_NAME="cc_notify_user command"

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

   local MS_WINDOWS_NOTIFY_COMMANDS='
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
      return $LAST_COMMAND_EXIT_CODE
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
# File name:cc_sync_directories.sh
#####

cc_sync_directories() {

   ##############################
   # FUNCTION PARAMETERS
   ##############################
   local SOURCE_DIRECTORY="$1"
   local DESTINATION_DIRECTORY="$2"
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

      rsync --recursive --archive --verbose --delete-excluded --size-only --progress --omit-dir-times --no-perms --inplace "$SOURCE_DIRECTORY"/ "$DESTINATION_DIRECTORY"/ --dry-run || return $?

      cc_notify_user 1 "listing changes finished"

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

   printf "%s\n" "+++++ command executed: rsync --recursive --archive --verbose --delete-excluded --size-only --progress --omit-dir-times --no-perms --inplace \"$SOURCE_DIRECTORY\"/ \"$DESTINATION_DIRECTORY\"/"
   
   rsync --recursive --archive --verbose --delete-excluded --size-only --progress --omit-dir-times --no-perms --inplace "$SOURCE_DIRECTORY"/ "$DESTINATION_DIRECTORY"/

   cc_notify_user 5 "sync finished"
}


# PRINT VERSION WHEN CC_SCRIPT.SH FILE IS LOADED
printf "%s\n" "cc_scripts version: $CC_SCRIPTS_PROJECT_VERSION"

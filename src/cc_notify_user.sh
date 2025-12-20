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

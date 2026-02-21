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

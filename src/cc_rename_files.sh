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

___check_parameters() {

   if [ "$1" = "-h" ]; then
      ___print_parameters_help "$@"
      ___required_parameters=()
      return $CC_EXIT_CODE__PARAMETER_HELP_PRINTED
   fi

   local -r REQUIRED_PARAM_COUNT="${#___required_parameters[@]}"
   local -r USER_PASSED_PARAM_COUNT="$#"

   if [ "$REQUIRED_PARAM_COUNT" = "$USER_PASSED_PARAM_COUNT" ]; then
      ___required_parameters=()
      return 0
   else
      ___print_parameters_help "$@"
      ___required_parameters=()
      return $CC_EXIT_CODE__INVALID_USER_PARAMETER
   fi
}

___print_parameters_help(){

   ___print_title "required parameters"
   for param in "${___required_parameters[@]}"; do
      ___print_screen "$param"
   done
   ___required_parameters=()
   return 1
}

___do_files_exist() {

   for FILE in "$@"; do
      if [ ! -f "$FILE" ]; then
         ___print_screen "file does not exist: $FILE"
         return 1
      fi
   done
}

___do_directories_exist() {

   for DIRECTORY in "$@"; do
      if [ ! -d "$DIRECTORY" ]; then
         return 1
      fi
   done
}

___string_ends_with() {

   ##############################
   # FUNCTION PARAMETERS
   ##############################
   local -r ALL_STRING="$1"
   local -r ENDS_WITH="$2"
   ##############################
   ##############################
   ##############################

   if [[ "$ALL_STRING" == *"$ENDS_WITH" ]]; then
      return 0
   fi
   return 1
}

___string_starts_with() {

   ##############################
   # FUNCTION PARAMETERS
   ##############################
   local -r ALL_STRING="$1"
   local -r START_WITH="$2"
   ##############################
   ##############################
   ##############################

   if [[ "$ALL_STRING" == "$START_WITH"* ]]; then
      return 0
   fi
   return 1
}

___string_contains() {

   ##############################
   # FUNCTION PARAMETERS
   ##############################
   local -r ALL_STRING="$1"
   local -r SUB_STRING="$2"
   ##############################
   ##############################
   ##############################

   if [[ "$ALL_STRING" == *"$SUB_STRING"* ]]; then
      return 0
   fi
   return 1
}

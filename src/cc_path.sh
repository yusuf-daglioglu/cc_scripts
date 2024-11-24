c_path_search() {

   ##############################
   # FUNCTION PARAMETERS
   ##############################
   local -r KEYWORD="$1" # keyword to search inside $PATH
   ##############################
   ##############################
   ##############################

   # IGNORE CASE = -i
   # tr ':' '\n' = replaces : character to new-line
   ___execute_with_eval "printf \"%s\" \""'$PATH'"\" | tr ':' '\n' | grep \"$KEYWORD\" -i | color_line"
}

c_path_add() {

   ##############################
   # FUNCTION PARAMETERS
   ##############################
   local -r NEW_DIR="$1"
   ##############################
   ##############################
   ##############################

   ___is_empty_string "$NEW_DIR" && {
      ___print_screen "$NEW_DIR is empty."
      return
   }

   ___string_contains "$PATH" "$NEW_DIR" && {
      ___print_screen "$NEW_DIR already exist."
      return
   }

   PATH="$NEW_DIR:$PATH"

   ___print_screen "Path added. New PATH: $PATH"
}

c_path_search() {

   ##############################
   # FUNCTION PARAMETERS
   ##############################
   local -r KEYWORD="$1" # keyword to search inside $PATH
   ##############################
   ##############################
   ##############################

   ___do_executables_exist "grep" "tr" || return

   # IGNORE CASE = -i
   # tr ':' '\n' = replaces : character to new-line
   ___execute_with_eval "printf \"%s\" \""'$PATH'"\" | tr ':' '\n' | grep \"$KEYWORD\" -i | color_line"
}

c_path_add() {

   ##############################
   # FUNCTION PARAMETERS
   ##############################
   local -r DIR="$1"
   ##############################
   ##############################
   ##############################

   ___is_empty_string "$DIR" && {
      ___print_screen "$DIR is empty."
      return
   }

   ___string_contains "$PATH" "$DIR" && {
      ___print_screen "$DIR already exist."
      return
   }

   PATH="$DIR:$PATH"

   ___print_screen "Path added. New PATH: $PATH"
}

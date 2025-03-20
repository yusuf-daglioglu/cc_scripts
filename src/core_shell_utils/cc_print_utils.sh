# We have 2 printf wrapper functions.
# Only because we never format numbers, we always print literals.
# With these wrapper you don't have to write "%s\n" all of your codes.
___stdout() {
   printf "%s" "$*"
}

___stdout_and_new_line() {
   printf "%s\n" "$*"
}

___stdout_using_format() {
   printf "$@"
}

# We prefer to change the background color instead of text itself. because the background of terminal interpreter can be any color (same or similar color with our print output).
CC_COLOR_RED=""   # only ___print_title command will use it.
CC_COLOR_BLUE=""  # only ___print_screen command will use it (normal text color. Should not be use for titles.)
CC_COLOR_GREEN="" # use it only if you don't use ___print_screen function and use a different color than others.
CC_COLOR_RESET="" # should be use every end of print screen command.

if ___do_executables_exist "tput"; then
   TPUT_BOLD="$(tput bold)" # we prefer bold. text are cleaner/bigger.
   TPUT_WHITE="$(tput setf 7)"
   CC_COLOR_RED="$TPUT_BOLD$TPUT_WHITE$(tput setab 1)"
   CC_COLOR_GREEN="$TPUT_BOLD$TPUT_WHITE$(tput setab 2)"
   CC_COLOR_BLUE="$TPUT_BOLD$TPUT_WHITE$(tput setab 4)"
   CC_COLOR_RESET="$(tput sgr 0)"
else
   ___stdout_and_new_line "ERROR. tput command not exist. do not run any function."
   exit 241
fi

___print_screen() {

   ___is_empty_string "$@" && {
      ___stdout_and_new_line
      return
   }

   ___stdout_and_new_line "$CC_COLOR_BLUE""$*$CC_COLOR_RESET"
}

___print_title() {

   ___stdout_and_new_line "$CC_COLOR_RED""$*$CC_COLOR_RESET"
}

color_line_HELP_ONLY() {
   ___print_title USAGE
   ___print_screen 'ls -a | color_line'
   ___print_screen 'ping google.com | color_line'
}

color_line() {

   ___do_executables_exist "read" || return

   while read line; do
      ___stdout_and_new_line "$CC_COLOR_BLUE$line$CC_COLOR_RESET"
      read line
      ___stdout_and_new_line "$CC_COLOR_GREEN$line$CC_COLOR_RESET"
   done
}

cc_color_line_HELP_ONLY() {
   printf "%s\n" USAGE:
   printf "%s\n" 'ls -a | cc_color_line'
   printf "%s\n" 'ping google.com | cc_color_line'
}

__CC_COLOR_BLUE="$TPUT_BOLD$TPUT_WHITE$(tput setab 4)"
__CC_COLOR_GREEN="$TPUT_BOLD$TPUT_WHITE$(tput setab 2)"
__CC_COLOR_RESET="$(tput sgr 0)"

cc_color_line() {

   while read line; do
      printf "%s\n" "$__CC_COLOR_BLUE$line$__CC_COLOR_RESET"
      read line
      printf "%s\n" "$__CC_COLOR_GREEN$line$__CC_COLOR_RESET"
   done
}

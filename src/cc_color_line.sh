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

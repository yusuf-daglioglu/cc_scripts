___do_executables_exist() {

   ##############################
   # ABOUT
   ##############################
   # This function check all parameter if they are callable from command line.
   # In other words; it returns 0, if each parameter is an alias or command or executable or shell function or any callable...
   ##############################
   ##############################
   ##############################

   for COMMAND in "$@"; do
      # do not use 'which' command to check if executable exist.
      # we prefer 'command' because it is POSIX standard.
      # reason why: https://stackoverflow.com/a/677212 ("web.archive.org" and "archive.is". archived date: 01/05/2020)
      command -v "$COMMAND" >/dev/null 2>&1 || {
         ___print_screen "command does not exist: $COMMAND"
         return $CC_EXIT_CODE__COMMAND_NOT_FOUND
      }
   done
}

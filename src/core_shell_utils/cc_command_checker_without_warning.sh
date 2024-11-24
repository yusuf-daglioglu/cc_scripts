___do_executables_exist_without_output() {

   ##############################
   # ABOUT
   ##############################
   # This is same as ___do_executables_exist function.
   # The only difference is that this function does not print any warning if it finds any non-executable.
   ##############################
   ##############################
   ##############################

   for COMMAND in "$@"; do
      # Do not use 'which' command to check if executable exist.
      # We prefer 'command' because it is POSIX standard.
      # Reason why: https://stackoverflow.com/a/677212 ("web.archive.org" and "archive.is". archived date: 01/05/2020)
      command -v "$COMMAND" >/dev/null 2>&1 || return $CC_EXIT_CODE__COMMAND_NOT_FOUND
   done
}

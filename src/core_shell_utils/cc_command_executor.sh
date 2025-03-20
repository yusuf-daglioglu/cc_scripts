OUTPUT_PREFIX="** executing command:"

___print_execute_command_line_info() {
   # we can not use ___print_screen because ___print_screen does not support multiple colors in the same line.
   ___stdout_and_new_line "$CC_COLOR_RED$OUTPUT_PREFIX $CC_COLOR_GREEN $* $CC_COLOR_RESET"
}

___execute_and_color_line() {
   ___print_execute_command_line_info "$@ | color_line"
   "$@" | color_line
}

___execute_and_grep_and_color_line() {
   ___print_execute_command_line_info "$@ | grep -i $GREP_COMMAND_PARAM | color_line"
   "$@" | grep -i "$GREP_COMMAND_PARAM" | color_line
}

___execute() {
   ___print_execute_command_line_info "$@"
   "$@"
}

___execute_with_eval() {
   # eval is a must in some cases like:
   #
   # ___execute_with_eval 'docker stop $(docker ps -a -q)'
   #
   # $(docker ps -a -q) --> must be pass as string, so we can print which command runs.
   #
   # eval should not be preferred because:
   # A- eval should be installed on system otherwise command will not work.
   # B- eval may side effect on some platforms.
   # C- a command which runs with command should be wrapped with " (double quote).
   #    therefore it is unreadable (especially when the command is long).

   ___print_execute_command_line_info "eval $@"

   ___do_executables_exist "eval" && {
      eval "$@"
      return
   }
   ___print_title "'eval' command does not exist. could not run the command."
   return 1
}

___execute_with_eval_removed_long_lines() {

   ___print_execute_command_line_info "$@"
   c_line_remove_long_enable

   ___do_executables_exist "eval" && {
      eval "$@"
      LAST_COMMAND_EXIT_CODE="$?" # We save it, so we can return
      c_line_remove_long_disable
      return "$LAST_COMMAND_EXIT_CODE"
   }
   c_line_remove_long_disable
   ___print_title "'eval' command does not exist. could not run the command."
   return 1
}

___nohup_and_disown() {

   # This should be preferred only for background processes or GUI apps.

   ___do_executables_exist "nohup" || {
      ___print_screen "___nohup_and_disown warning:"
      ___print_screen "command does not exist: nohup"
      ___print_execute_command_line_info "$@ & disown"
      "$@" &
      disown
      return
   }

   ___do_executables_exist "disown" || {
      ___print_screen "___nohup_and_disown warning:"
      ___print_screen "command does not exist: disown"
      ___print_execute_command_line_info "nohup $@"
      nohup "$@"
      return
   }

   ___print_execute_command_line_info "nohup $@ & disown"
   nohup "$@" &
   disown
}

___run_command_as_root() {

   if ___do_executables_exist "sudo"; then
      # env "PATH=$PATH" = set environment variables for sudo command
      ___execute_with_eval "sudo env \"PATH=$PATH\" $@"
      return
   fi

   if ___do_executables_exist "su"; then
      # TODO pass environment variable like above (sudo case)
      ___execute_with_eval "su -c '""$@""'"
      return
   fi

   ___print_screen "'sudo' or 'su' commands not found. script will try to execute the command as current user."

   # maybe the current user is privileged
   ___execute_with_eval "$@"
}

c_line_remove_long_enable() {
   # enables "word wrap"
   if ___do_executables_exist "tput"; then
      tput rmam
   else
      ___stdout '\033[?7l'
   fi
}

c_line_remove_long_disable() {
   # disables "word wrap"
   if ___do_executables_exist "tput"; then
      tput smam
   else
      ___stdout '\033[?7h'
   fi
}

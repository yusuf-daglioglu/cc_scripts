# RESERVED CUSTOM EXIT CODE: 1010000 - 1011000
# RESERVED STANDART EXIT CODE: -

requestScriptPath() {

   ##############################################
   # CC_SCRIPTS_FILE_PATH is a global variable which indicates the script file path of cc_scripts.sh.
   #
   # This variable is using by some functions like:
   # - c_help
   # - c_download_with_curl_script
   #
   # It is not easy to detect (programmatically) the absolute file path of running current script. Because there are too many ways for running a script. Some examples:
   # - Where the script is running: Zsh or Bash and their different versions (and maybe some distro/terminal are overriding the behaviors)
   # - sourcing or executing script file
   # - sourcing or executing from another script file
   # - mingw (ms-windows) or subsystem linux (ms-windows) or linux or mac
   # - calling the script using it's relative path or absolute path
   #
   # Therefore we prefer to ask it to user.
   ##############################################

   if ___is_empty_string "$CC_SCRIPTS_FILE_PATH"; then

      ___print_screen "type below:"
      ___print_screen 'export CC_SCRIPTS_FILE_PATH="/absolute/path/to/cc_scripts.sh"'
      ___errorHandler "$?" 1010001
      return
   fi

   if ! ___do_files_exist "$CC_SCRIPTS_FILE_PATH"; then

      ___print_screen "You have exported CC_SCRIPTS_FILE_PATH as $CC_SCRIPTS_FILE_PATH"
      ___print_screen "But the file does not exist. Make sure and export it again as below:"
      ___print_screen 'export CC_SCRIPTS_FILE_PATH="/absolute/path/to/cc_scripts.sh"'
      ___errorHandler "$?" 1010002
      return
   fi
}

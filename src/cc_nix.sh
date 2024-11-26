___nix_install_app() {

   ##############################
   # FUNCTION PARAMETERS
   ##############################
   local -r ATTRIBUTE="$1"
   local -r APP_ID="$2"
   local -r ADDITIONAL_CONFIG="$3"
   ##############################
   ##############################
   ##############################

   ___required_parameters=("ATTRIBUTE" "APP_ID" "ADDITIONAL_CONFIG")
   ___check_parameters "$@" || return

   ___is_empty_string "$ATTRIBUTE" && ATTRIBUTE=""
   ___is_empty_string "$ADDITIONAL_CONFIG" && ADDITIONAL_CONFIG=""

   ___run_command_as_nix_user "$CC_NIX_BIN_ALL_PATH/nix-env -i$ATTRIBUTE $APP_ID --arg config \"{ allowUnfree = true; $ADDITIONAL_CONFIG }\""
}

c_nix_install_app() {

   ___nix_install_app "NULL" "$1" "NULL"
}

c_nix_install_app_by_attribute() {

   ___nix_install_app "A" "$1" "NULL"
}

c_nix_install_app_with_config() {

   ___nix_install_app "NULL" "$1" "$2"
}

c_nix_remove_app() {

   ___run_command_as_nix_user "$CC_NIX_BIN_ALL_PATH/nix-env -e $1"
}

c_nix_list_all_apps() {

   ___run_command_as_nix_user "$CC_NIX_BIN_ALL_PATH/nix-env -q"
}

c_nix_install_all_updates() {

   ___run_command_as_nix_user "$CC_NIX_BIN_ALL_PATH/nix-channel --update nixpkgs --arg config \"{ allowUnfree = true; }\""
   ___run_command_as_nix_user "$CC_NIX_BIN_ALL_PATH/nix-env -u \"*\" --arg config \"{ allowUnfree = true; }\""
}

___run_command_as_nix_user() {

   ##############################
   # FUNCTION PARAMETERS
   ##############################
   local -r COMMAND_WITH_PARAMS="$1"
   ##############################
   ##############################
   ##############################

   if ___do_executables_exist "su"; then
      # RUN THE COMMAND = -c
      ___execute_with_eval "su $CC_NIX_USER -c '""$COMMAND_WITH_PARAMS""'"
   else
      ___print_screen "could not run command as $NIXUSER. reason: 'su' command not found."
   fi
}

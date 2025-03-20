c_nix_install_app() {

   ___run_command_as_nix_user "NIXPKGS_ALLOW_UNFREE=1 $CC_NIX_BIN_ALL_PATH/nix-env $1"
}

c_nix_install_app_by_attribute() {

   ___run_command_as_nix_user "NIXPKGS_ALLOW_UNFREE=1 $CC_NIX_BIN_ALL_PATH/nix-env -i$1 $2"
}

c_nix_remove_app() {

   ___run_command_as_nix_user "$CC_NIX_BIN_ALL_PATH/nix-env -e $1"
}

c_nix_list_all_apps() {

   ___run_command_as_nix_user "$CC_NIX_BIN_ALL_PATH/nix-env -q"
}

c_nix_install_all_updates() {

   ___run_command_as_nix_user "NIXPKGS_ALLOW_UNFREE=1 $CC_NIX_BIN_ALL_PATH/nix-channel --update nixpkgs"
   ___run_command_as_nix_user "NIXPKGS_ALLOW_UNFREE=1 $CC_NIX_BIN_ALL_PATH/nix-env -u \"*\""
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

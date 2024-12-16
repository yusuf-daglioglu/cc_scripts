#!/bin/bash

# RESERVED CUSTOM EXIT CODE: 1000000 - 1001000
# RESERVED STANDART EXIT CODE: 255,254,253

source "./dev_exception_handler.sh" || exit 255
source "./dev_print_utils.sh" || exit 254
source "./../src/core_shell_utils/cc_exit_code.sh" || exit 253

cd ..
PROJECT_FOLDER_ROOT_PATH_ABSOLUTE=$(pwd)
RELEASE_FILE_FULL_PATH="$PROJECT_FOLDER_ROOT_PATH_ABSOLUTE/release/cc_scripts.sh"

printf '
###################################################
# PROJECT NAME: cc_scripts
# SHORT DESCRIPTION: Multi-purpose shell functions.
# URL: https://github.com/yusuf-daglioglu/cc_scripts
export CC_SCRIPTS_PROJECT_VERSION=1
################################################### \n\n' >"$RELEASE_FILE_FULL_PATH" || { ___devErrorHandler "$?" 1000000; exit; }

appendToReleaseFile() {
   ##############################
   # FUNCTION PARAMETERS
   ##############################
   local -r SOURCE_FILE_NAME="$1"
   ##############################
   ##############################
   ##############################

   local -r SOURCE_FILE_FULL_PATH="$PROJECT_FOLDER_ROOT_PATH_ABSOLUTE/src/$SOURCE_FILE_NAME"
   local -r FILE_CONTENT="$(<"$SOURCE_FILE_FULL_PATH")" || { ___devErrorHandler "$?" 1000026; return; }
   # %s --> print the string as literally (it will not fail if the the content has any shell syntax).
   printf '######\n# File name:%s\n#####\n\n%s\n\n' "$SOURCE_FILE_NAME" "$FILE_CONTENT" >>"$RELEASE_FILE_FULL_PATH" || { ___devErrorHandler "$?" 1000001; return; }
}

# order of below block is important.
appendToReleaseFile core_shell_utils/cc_exit_code.sh || { ___devErrorHandler "$?" 1000002; exit; }
appendToReleaseFile core_shell_utils/cc_is_empty_string.sh || { ___devErrorHandler "$?" 1000003; exit; }
appendToReleaseFile core_shell_utils/cc_core_utils.sh || { ___devErrorHandler "$?" 1000004; exit; }
appendToReleaseFile core_shell_utils/cc_command_checker.sh || { ___devErrorHandler "$?" 1000005; exit; }
appendToReleaseFile core_shell_utils/cc_print_utils.sh || { ___devErrorHandler "$?" 1000006; exit; }
appendToReleaseFile core_shell_utils/cc_command_checker_without_warning.sh || { ___devErrorHandler "$?" 1000007; exit; }
appendToReleaseFile core_shell_utils/cc_command_executor.sh || { ___devErrorHandler "$?" 1000008; exit; }
appendToReleaseFile core_shell_utils/cc_exception_handler.sh || { ___devErrorHandler "$?" 1000009; exit; }

# below order is not important.
appendToReleaseFile cc_docker.sh || { ___devErrorHandler "$?" 1000010; exit; }
appendToReleaseFile cc_download_media.sh || { ___devErrorHandler "$?" 1000011; exit; }
appendToReleaseFile cc_file_system.sh || { ___devErrorHandler "$?" 1000012; exit; }
appendToReleaseFile cc_git.sh || { ___devErrorHandler "$?" 1000013; exit; }
appendToReleaseFile cc_gui_apps.sh || { ___devErrorHandler "$?" 1000014; exit; }
appendToReleaseFile cc_maven.sh || { ___devErrorHandler "$?" 1000015; exit; }
appendToReleaseFile cc_media_file.sh || { ___devErrorHandler "$?" 1000016; exit; }
appendToReleaseFile cc_network.sh || { ___devErrorHandler "$?" 1000017; exit; }
appendToReleaseFile cc_nix.sh || { ___devErrorHandler "$?" 1000018; exit; }
appendToReleaseFile cc_notifier.sh || { ___devErrorHandler "$?" 1000019; exit; }
appendToReleaseFile cc_path.sh || { ___devErrorHandler "$?" 1000020; exit; }
appendToReleaseFile cc_script_utils/cc_scripts_help.sh || { ___devErrorHandler "$?" 1000021; exit; }
appendToReleaseFile cc_script_utils/cc_scripts_file_requestor.sh || { ___devErrorHandler "$?" 1000022; exit; }
appendToReleaseFile cc_script_utils/cc_scripts_dynamic_variables.sh || { ___devErrorHandler "$?" 1000023; exit; }

printf '
##############################################
# PRINT VERSION WHEN CC_SCRIPT.SH FILE IS LOADED
##############################################
___print_screen "cc_scripts version: $CC_SCRIPTS_PROJECT_VERSION" \n\n' >>"$RELEASE_FILE_FULL_PATH" || { ___devErrorHandler "$?" 1000024; exit; }

___dev_print_screen "Build done."
___dev_print_screen "Sourcing the builded script, in case of any syntax error..."
source "$RELEASE_FILE_FULL_PATH" || { ___devErrorHandler "$?" 1000025; exit; }
___dev_print_screen "Script sourced successfully."
___dev_print_screen "Some useful commands to run and test the new cc_scripts release:"
___dev_print_screen
___dev_print_screen "export CC_SCRIPTS_FILE_PATH='$RELEASE_FILE_FULL_PATH'"
___dev_print_screen
___dev_print_screen 'source "$CC_SCRIPTS_FILE_PATH"'

#!/bin/bash

# RESERVED CUSTOM EXIT CODE: 1001000 - 1002000
# RESERVED STANDART EXIT CODE: 250, 249, 248

source "./dev_exception_handler.sh" || exit 250
source "./dev_print_utils.sh" || exit 249
source "./../src/core_shell_utils/cc_exit_code.sh" || exit 248

# All test outputs are in yellow color.
# For example: If any test case will fail, it will print the error as yellow.
# And the remainig tests will resume.

cd ..
ROOT=$(pwd)

# Unit test files should not have hashbang on their first line. Because they should run both on zsh and bash.
readonly TEST_COMMANDS="
cd '$ROOT/test'

# UNIT TEST PRINT REQUIREMENT IMPORTS
IMPORT1="$ROOT/src/core_shell_utils/cc_exit_code.sh"
IMPORT2="$ROOT/dev_scripts/dev_print_utils.sh"
IMPORT3="$ROOT/test/test_error_print_util.sh"
IMPORT4="$ROOT/dev_scripts/dev_exception_handler.sh"

'$ROOT/test/cc_command_checker_unit_tests.sh' $ROOT \$IMPORT1 \$IMPORT2 \$IMPORT3 \$IMPORT4
'$ROOT/test/cc_command_checker_without_warning_unit_tests.sh' $ROOT \$IMPORT1 \$IMPORT2 \$IMPORT3 \$IMPORT4
'$ROOT/test/cc_command_executor_unit_tests.sh' $ROOT \$IMPORT1 \$IMPORT2 \$IMPORT3 \$IMPORT4
'$ROOT/test/cc_core_utils_unit_tests.sh' $ROOT \$IMPORT1 \$IMPORT2 \$IMPORT3 \$IMPORT4
'$ROOT/test/cc_exception_handler_unit_tests.sh' $ROOT \$IMPORT1 \$IMPORT2 \$IMPORT3 \$IMPORT4
'$ROOT/test/cc_is_empty_string_unit_tests.sh' $ROOT \$IMPORT1 \$IMPORT2 \$IMPORT3 \$IMPORT4
'$ROOT/test/cc_file_system_unit_tests.sh' $ROOT \$IMPORT1 \$IMPORT2 \$IMPORT3 \$IMPORT4
"

___dev_print_screen "Running all tests on zsh"
zsh -c 'printf "%s\n" "ZSH version: $ZSH_VERSION"' || { ___devErrorHandler "$?" 1001000; exit; }
zsh -c "$TEST_COMMANDS" || { ___devErrorHandler "$?" 1001001; exit; }

___dev_print_screen "Running all tests on bash"
bash -c 'printf "%s\n" "Bash version: $BASH_VERSION"' || { ___devErrorHandler "$?" 1001002; exit; }
bash -c "$TEST_COMMANDS" || { ___devErrorHandler "$?" 1001003; exit; }

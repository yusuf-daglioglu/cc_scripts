# RESERVED CUSTOM EXIT CODE: 1003000 - 1004000
# RESERVED STANDART EXIT CODE: -

ROOT="$1"

# UNIT TEST PRINT REQUIREMENT IMPORTS
source "$2"
source "$3"
source "$4"
source "$5"

# UNIT TEST CASE SPESIFIC DEPENDENCIES
source "$ROOT/src/core_shell_utils/cc_is_empty_string.sh"   || { ___devErrorHandler "$?" 1003001; exit; }
source "$ROOT/src/core_shell_utils/cc_command_checker.sh"   || { ___devErrorHandler "$?" 1003001; exit; }
source "$ROOT/src/core_shell_utils/cc_print_utils.sh"       || { ___devErrorHandler "$?" 1003002; exit; }

___unit_test___do_executables_exist() {
    ___do_executables_exist "printf" || return 1
    ___do_executables_exist "sh" || return 2
    ___do_executables_exist "this_not_exist" && return 3
    ___do_executables_exist "___unit_test___do_executables_exist" || return 4
    ___do_executables_exist "" && return 5
    ___do_executables_exist "sh" "printf" || return 6
    ___do_executables_exist "sh" "this_not_exist" && return 7
    ___do_executables_exist "this_not_exist" "sh" && return 8
    return 0
}

___unit_test___do_executables_exist || ___printUnitTestError "___unit_test___do_executables_exist" "$?"

# RESERVED CUSTOM EXIT CODE: 1004000 - 1005000
# RESERVED STANDART EXIT CODE: -

ROOT="$1"

# UNIT TEST PRINT REQUIREMENT IMPORTS
source "$2"
source "$3"
source "$4"
source "$5"

# UNIT TEST CASE SPESIFIC DEPENDENCIES
source "$ROOT/src/core_shell_utils/cc_is_empty_string.sh"                 || { ___devErrorHandler "$?" 1004004; exit; }
source "$ROOT/src/core_shell_utils/cc_command_checker_without_warning.sh" || { ___devErrorHandler "$?" 1004005; exit; }

___unit_test___do_executables_exist_without_output() {
    ___do_executables_exist_without_output "printf" || return 1
    ___do_executables_exist_without_output "sh" || return 2
    ___do_executables_exist_without_output "this_not_exist" && return 3
    ___do_executables_exist_without_output "___unit_test___do_executables_exist_without_output" || return 4
    ___do_executables_exist_without_output "" && return 5
    ___do_executables_exist_without_output "sh" "printf" || return 6
    ___do_executables_exist_without_output "sh" "this_not_exist" && return 7
    ___do_executables_exist_without_output "this_not_exist" "sh" && return 8
    return 0
}

___unit_test___do_executables_exist_without_output ||___printUnitTestError "___unit_test___do_executables_exist_without_output" "$?"

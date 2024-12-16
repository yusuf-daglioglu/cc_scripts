# RESERVED CUSTOM EXIT CODE: 1006000 - 1007000
# RESERVED STANDART EXIT CODE: -

ROOT="$1"

# UNIT TEST PRINT REQUIREMENT IMPORTS
source "$2"
source "$3"
source "$4"
source "$5"

# UNIT TEST CASE SPESIFIC DEPENDENCIES
source "$ROOT/src/core_shell_utils/cc_is_empty_string.sh" || { ___devErrorHandler "$?" 1006000; exit; }
source "$ROOT/src/core_shell_utils/cc_command_checker.sh" || { ___devErrorHandler "$?" 1006001; exit; }
source "$ROOT/src/core_shell_utils/cc_print_utils.sh"     || { ___devErrorHandler "$?" 1006002; exit; }
source "$ROOT/src/core_shell_utils/cc_core_utils.sh"      || { ___devErrorHandler "$?" 1006003; exit; }

___unit_test___string_ends_with() {
    ___string_ends_with "any text" "ext" || return 1
    ___string_ends_with "any text" " text" || return 2
    ___string_ends_with "any text" "y text" || return 3
    ___string_ends_with "any text" "any text" || return 4
    ___string_ends_with "any text" "any text " && return 5
    ___string_ends_with "any text" " " && return 6
    ___string_ends_with "any text" "x" && return 7
    ___string_ends_with "" "" || return 8
    ___string_ends_with " " " " || return 9
    return 0
}

___unit_test___string_starts_with() {
    ___string_starts_with "any text" "an" || return 1
    ___string_starts_with "any text" "any " || return 2
    ___string_starts_with "any text" "any t" || return 3
    ___string_starts_with "any text" "any text" || return 4
    ___string_starts_with "any text" " any text" && return 5
    ___string_starts_with "any text" " " && return 6
    ___string_starts_with "any text" "x" && return 7
    ___string_starts_with "" "" || return 8
    ___string_starts_with " " " " || return 9
    return 0
}

___unit_test___string_contains() {
    ___string_contains "any text" "an" || return 1
    ___string_contains "any text" "any " || return 2
    ___string_contains "any text" " " || return 3
    ___string_contains " " " " || return 4
    ___string_contains "  " "  " || return 5
    ___string_contains "  " " " || return 6
    return 0
}

___unit_test___do_directories_exist() {
    ___do_directories_exist "$(pwd)" "$(pwd)" || return 1
    ___do_directories_exist "$(pwd)" || return 2
    ___do_directories_exist "/this_not_exist" && return 3
    ___do_directories_exist "/this_not_exist" "$(pwd)" && return 3
    ___do_directories_exist "$(pwd)" "/this_not_exist" && return 3
    ___do_directories_exist " " && return 4
    ___do_directories_exist "" && return 5
    return 0
}

___unit_test___do_files_exist() {
    local -r TEMP_FILE_FULL_PATH="$(mktemp)" || return 1
    ___do_files_exist "$TEMP_FILE_FULL_PATH" "$TEMP_FILE_FULL_PATH" || return 2
    ___do_files_exist "$TEMP_FILE_FULL_PATH" || return 3
    ___do_files_exist "/this_not_exist" && return 4
    ___do_files_exist "/this_not_exist" "$TEMP_FILE_FULL_PATH" && return 5
    ___do_files_exist "$TEMP_FILE_FULL_PATH" "/this_not_exist" && return 6
    ___do_files_exist " " && return 7
    ___do_files_exist "" && return 8
    rm "$TEMP_FILE_FULL_PATH" || return 9
    return 0
}

___unit_test___check_parameters() {
    ___unit_test___check_parameters_test1 "paramX" "paramY" || return 1
    ___unit_test___check_parameters_test2 "paramX" "paramY" && return 2
    ___unit_test___check_parameters_test2 "paramX" || return 3
    return 0
}

___unit_test___check_parameters_test1() {
    ___required_parameters=("param1" "param2")
    ___check_parameters "$@" || return 1
    return 0
}

___unit_test___check_parameters_test2() {
    ___required_parameters=("param1")
    ___check_parameters "$@" || return 1
    return 0
}

___unit_test___string_ends_with || ___printUnitTestError "___unit_test___string_ends_with" "$?"
___unit_test___string_starts_with || ___printUnitTestError "___unit_test___string_starts_with" "$?"
___unit_test___string_contains || ___printUnitTestError "___unit_test___string_contains" "$?"
___unit_test___do_directories_exist || ___printUnitTestError "___unit_test___do_directories_exist" "$?"
___unit_test___do_files_exist || ___printUnitTestError "___unit_test___do_files_exist" "$?"
___unit_test___check_parameters || ___printUnitTestError "___unit_test___check_parameters" "$?"

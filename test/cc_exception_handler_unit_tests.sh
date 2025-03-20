# RESERVED CUSTOM EXIT CODE: 1007000 - 1008000
# RESERVED STANDART EXIT CODE: -

ROOT="$1"

# UNIT TEST PRINT REQUIREMENT IMPORTS
source "$2"
source "$3"
source "$4"
source "$5"

# UNIT TEST CASE SPESIFIC DEPENDENCIES
source "$ROOT/src/core_shell_utils/cc_command_checker.sh"   || { ___devErrorHandler "$?" 1007002; exit; }
source "$ROOT/src/core_shell_utils/cc_exception_handler.sh" || { ___devErrorHandler "$?" 1007000; exit; }
source "$ROOT/src/core_shell_utils/cc_print_utils.sh"       || { ___devErrorHandler "$?" 1007001; exit; }

___unit_test___errorHandler() {
    
    ___errorHandler 1 2
    test "$?" -eq "$CC_EXIT_CODE__APP_LOGIC_EXCEPTION" || return 1

    return 0
}

#___unit_test___errorHandler || ___printUnitTestError "___unit_test___errorHandler" "$?"

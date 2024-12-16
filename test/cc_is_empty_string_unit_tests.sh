# RESERVED CUSTOM EXIT CODE: 1009000 - 1010000
# RESERVED STANDART EXIT CODE: -

ROOT="$1"

# UNIT TEST PRINT REQUIREMENT IMPORTS
source "$2"
source "$3"
source "$4"
source "$5"

# UNIT TEST CASE SPESIFIC DEPENDENCIES
source "$ROOT/src/core_shell_utils/cc_is_empty_string.sh" || { ___devErrorHandler "$?" 1009000; exit; }

___unit_test___is_empty_string() {
   ___is_empty_string "" || return 1
   ___is_empty_string " " && return 2
   ___is_empty_string " a" && return 3
   ___is_empty_string "NULL" || return 4
   return 0
}

___unit_test___is_empty_string ||___printUnitTestError "___unit_test_empty_string" "$?"

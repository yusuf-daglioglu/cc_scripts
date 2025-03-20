___errorHandler() {
    ___print_title "last command exit code: $1"
    ___print_title "cc_script custom exit code: $2"
    return $CC_EXIT_CODE__APP_LOGIC_EXCEPTION
}

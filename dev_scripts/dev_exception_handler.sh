# this function can not catch exceptions which is throwing by "source" command. this is only happennig on Zsh. Bash can detect those exceptions. 
___devErrorHandler() {
    ___dev_print_screen "last command exit code: $1"
    ___dev_print_screen "cc_script development stage custom exit code: $2"
    return $CC_EXIT_CODE__DEVELOPMENT_STAGE_EXCEPTION
}

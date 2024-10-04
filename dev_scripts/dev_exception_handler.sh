# this function can not cacth excepitons which is throwing by "source" command. this is only happenng on Zsh. Bash can detect excepitons. 
___devErrorHandler() {
    ___dev_print_screen "last command exit code: $1"
    ___dev_print_screen "exit code: $2"
    return $CC_EXIT_CODE__DEVELOPMENT_STAGE_EXCEPTION
}

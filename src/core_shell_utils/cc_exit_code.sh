# Do not use reserved exit codes. more information:
# - https://tldp.org/LDP/abs/html/exitcodes.html
# - https://unix.stackexchange.com/questions/604260/best-range-for-custom-exit-code-in-linux
# I prefer to use max values of available ones, because generally lower ones are using by other executables.
export CC_EXIT_CODE__APP_LOGIC_EXCEPTION=246 # generic exceptions for runtime.
export CC_EXIT_CODE__INVALID_USER_PARAMETER=245
export CC_EXIT_CODE__PARAMETER_HELP_PRINTED=247
export CC_EXIT_CODE__COMMAND_NOT_FOUND=244
export CC_EXIT_CODE__DEVELOPMENT_STAGE_EXCEPTION=243

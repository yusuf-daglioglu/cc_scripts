# Function names should start with c_ prefix and they should be lower case.

# the private functions (private means end-user should not call them directly) should start with triple underscore (___).
# The first word should be the object and the remaining should be the action. Example valid function names:
# - c_path_search  ---> lists and searches inside PATH variable
# - c_path_add ---> adds a new PATH directory

# If the function will only print help output, then the function should get _HELP_ONLY suffix.
# Those functions should be pure.

c_demo_function() {

    ##############################
    # ABOUT
    ##############################
    # This is DEMO function.
    # All notes/comments should be written here (inside ABOUT section).
    ##############################
    ##############################
    ##############################

    ##############################
    # FUNCTION PARAMETERS
    ##############################
    # Parameters should be assign to local variables.
    # From now on, never access it as $1 or $2.
    # Only access as $DIRECTORY_NAME and $FILE_NAME.
    # That makes function more human readable.
    # -r --> final value. It can never change.
    local -r DIRECTORY_NAME="$1"
    local -r FILE_NAME="$2"
    ##############################
    ##############################
    ##############################

    # If the above parameters are required, then use below 2 lines.
    # If parameters not exist it prints a help text.
    # Also this function returns all parameters name if the user pass -h parameter.
    ___required_parameters=("DIRECTORY_NAME" "FILE_NAME")
    ___check_parameters "$@" || return

    # Add this line if you use $CC_SCRIPTS_FILE_PATH variable.
    requestScriptPath || return

    # Use below line for required commands. cp and grep commands are required for this function.
    ___do_executables_exist "rm" "ping" || return

    # Business logic should be always after above lines.

    # Always use "local" for variables and upper case.
    # Always use -r (readonly) if you don't have a good reason.
    local -r MY_VAR_1="Hello"

    # Exceptions should be catch using ___errorHandler.
    # ___errorHandler prints both last command exit-code and custom-exit code which is sending as parameter.
    # "1999999" is demo's custom exit-code. you define custom exit-code unique for each error case.)
    # Our custom-error codes start from 1000000. This is not because the lower values are reverved,
    # this is only because we can search them with grep to find directly on cc_script.sh file or simply via any text editor.
    ___string_ends_with "HELLO WORLD" "ABC" && {
        ___errorHandler "$?" 1999999
        return
    }

    # Always use those functions to print anything on the screen.
    # Never use echo or printf or any other command.
    # Because ___print_title and ___print_screen functions will have it's own color.
    # So the end use may know which output is printed by executed command and which one from cc_script function.
    ___print_title "Hello! This is title!"
    ___print_screen "Hello! This is normal title!"

    # Always execute command with the functions of cc_command_executor.sh file. Some of these functions are:
    # - ___execute
    # - ___execute_and_color_line
    # - ___execute_and_grep_and_color_line
    # It's very important that the end user should see what executed on it's local machine.
    # So he may revert manually or trace what's going on.
    ___execute ping "google.com"

    # Always explain what is the parameters like below as comment:
    # -f --> Force delete

    # Or you can print on output:
    ___print_title '-f --> Force delete'
    rm -f "/path/to/delete"

    # If your business logic may take time, then put the below line at the end of your function.
    # c_notify_user will do those for you:
    # 1- a "beep" sound.
    # 2- call the OS native notification system.
    # 3- print the message on terminal.
    c_notify_user '2' "ping finished"
}

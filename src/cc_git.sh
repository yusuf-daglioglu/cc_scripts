c_git_log_all_branches() {
   ___execute git log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit
}

c_git_log_current_branch() {
   local -r CURRENT_BRANCH=$(git branch --show-current)
   ___execute git log "$CURRENT_BRANCH"
}

c_git_list_all_references() {

   # printing column headers for ouput.
   # only standard colors of cc_scripts will be define globally. therefore we define these colors locally.
   local -r COLOR_YELLOW="$TPUT_BOLD$TPUT_WHITE$(tput setab 3)"
   local -r COLOR_PURPLE="$TPUT_BOLD$TPUT_WHITE$(tput setab 5)"
   ___stdout "$CC_COLOR_RED""REF""$CC_COLOR_RESET" "$CC_COLOR_BLUE""TRACKING REF""$CC_COLOR_RESET" "$COLOR_YELLOW""LATEST COMMIT TIME""$CC_COLOR_RESET" "$COLOR_PURPLE""AUTHOR""$CC_COLOR_RESET" "$CC_COLOR_GREEN""COMMIT SHA(SHORT)""$CC_COLOR_RESET" "COMMIT COMMENT"

   ___print_screen
   ___print_screen

   ___execute git for-each-ref --sort=-committerdate --format='%(color:red bold)%(refname)%(color:reset) %(color:blue bold)%(upstream)%(color:reset) %(color:yellow)%(committerdate:relative)%(color:reset) %(color:magenta bold)%(authorname)%(color:reset) %(color:green)%(objectname:short)%(color:reset) %(contents:subject)'
}

c_git_checkout_by_remote_branch_name__HELP_ONLY() {
   ___print_screen 'git checkout -b $BRANCH_NAME "origin/$BRANCH_NAME'
}

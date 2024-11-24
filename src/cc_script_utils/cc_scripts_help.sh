c_help_open_cc_scripts_with_text_editor() {
   requestScriptPath || return
   "$CC_TEXT_EDITOR_FOR_NON_ROOT_FILES" "$CC_SCRIPTS_FILE_PATH"
}

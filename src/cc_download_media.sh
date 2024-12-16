c_download_media_HELP_ONLY() {

   local -r DOWNLOADER_EXECUTABLE="$(c_file_system___return_file_or_directory_which_contains "$CC_STANDALONE_APPS_PATH_ROOT" yt-dlp)"
   local -r PHANTOMJS_EXECUTABLE="$(c_file_system___return_file_or_directory_which_contains "$CC_STANDALONE_APPS_PATH_ROOT" phantomjs)""/bin"

   ___print_screen '- yt-dlp command downloads from many services. Not only from Youtube.'
   ___print_screen '- If zsh will give "no matches found" error, make sure URL is quoted string with ".'
   ___print_screen '- Do not use audio download command. Because it downloads the full video and then extracts the audio. Prefer the split video via ffmpeg command.'

   ___print_title "Update the application"
   ___print_screen "$DOWNLOADER_EXECUTABLE -U"

   ___print_title "Adding PhantomJS to PATH for some web sites."
   ___print_screen "c_path_add $PHANTOMJS_EXECUTABLE"

   ___print_title "PARAMETERS"
   ___print_screen "--write-sub --> download subtitles. subtitle details are given in: --sub-lang"
   ___print_screen "-i --> ignore errors. if any error happens then resumes with the next media (if the URL is list)"
   ___print_screen "--rm-cache-dir --> it removes cache. sometimes cache make bugs. it does not store too much files. so it is better to clean everytime."
   ___print_screen "-v ---> show all logs"

   ___print_screen "$DOWNLOADER_EXECUTABLE -v --rm-cache-dir -i --write-sub --sub-lang eng,tr,el,en,en-US,en-UK,en-GB "'$VIDEO_URL'
}

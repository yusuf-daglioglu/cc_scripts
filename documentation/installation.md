# INSTALLATION

There's not an installation. You just load the __cc_script.sh__ file. 2 way to do that:

- __1- USING GIT__

  ```sh
  git clone "https://github.com/yusuf-daglioglu/cc_scripts"
  cd "cc_scripts"
  cd "release"
  source "cc_scripts.sh"
  ```

- __2- USING CURL__

  If you don't have "git" command, you only need a single file:

  ```sh
  FILE_PATH="$HOME/cc_scripts.sh" # or anywhere you want

  curl --output "$FILE_PATH" "https://raw.githubusercontent.com/yusuf-daglioglu/cc_scripts/master/release/cc_scripts.sh"

  source "$FILE_PATH"
  ```

Ready! Now type on terminal __C__ and press __TAB__, terminal will show you all available functions.

#!/bin/bash

# RESERVED CUSTOM EXIT CODE: -
# RESERVED STANDART EXIT CODE: 247, 246, 245, 244, 243, 242

readonly PROJECT_ROOT_DIR_FULL_PATH="$(dirname "$0")/.."
source "$PROJECT_ROOT_DIR_FULL_PATH/dev_scripts/dev_print_utils.sh" || exit 247

docker stop $(docker ps -a -q)
rm -f "$PROJECT_ROOT_DIR_FULL_PATH/test/docker_test/cc_scripts.sh"
"$PROJECT_ROOT_DIR_FULL_PATH/dev_scripts/build_release.sh" || exit 246
cp "$PROJECT_ROOT_DIR_FULL_PATH/release/cc_scripts.sh" "$PROJECT_ROOT_DIR_FULL_PATH/test/docker_test/cc_scripts.sh" || exit 245
cd "$PROJECT_ROOT_DIR_FULL_PATH/test/docker_test" || exit 244
docker build -t "cc_scripts_immortal_container" . || exit 243
readonly CONTAINER_ID=$(docker run -dit "cc_scripts_immortal_container") || exit 242
___dev_print_screen ""
___dev_print_screen "#####################"
___dev_print_screen "EXECUTE THIS COMMAND:"
___dev_print_screen 'export CC_SCRIPTS_FILE_PATH="/cc_scripts/cc_scripts.sh"'
___dev_print_screen 'source "$CC_SCRIPTS_FILE_PATH"'
___dev_print_screen "#####################"
___dev_print_screen
docker exec -i -t "$CONTAINER_ID" bash

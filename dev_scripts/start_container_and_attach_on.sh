#!/bin/bash

readonly PROJECT_ROOT_DIR_FULL_PATH="$(dirname "$0")/.."
source "$PROJECT_ROOT_DIR_FULL_PATH/dev_scripts/dev_print_utils.sh" || exit 246

docker stop $(docker ps -a -q)
rm -f "$PROJECT_ROOT_DIR_FULL_PATH/test/docker_test/cc_scripts.sh"
"$PROJECT_ROOT_DIR_FULL_PATH/dev_scripts/build_release.sh" || exit 245
cp "$PROJECT_ROOT_DIR_FULL_PATH/release/cc_scripts.sh" "$PROJECT_ROOT_DIR_FULL_PATH/test/docker_test/cc_scripts.sh" || exit 244
cd "$PROJECT_ROOT_DIR_FULL_PATH/test/docker_test" || exit 243
docker build -t "cc_scripts_immortal_container" . || exit 199
readonly CONTAINER_ID=$(docker run -dit "cc_scripts_immortal_container") || exit 198
___dev_print_screen ""
___dev_print_screen "#####################"
___dev_print_screen "EXECUTE THIS COMMAND:"
___dev_print_screen 'export CC_SCRIPTS_FILE_PATH="/cc_scripts/cc_scripts.sh"'
___dev_print_screen 'source "$CC_SCRIPTS_FILE_PATH"'
___dev_print_screen "#####################"
___dev_print_screen
docker exec -i -t "$CONTAINER_ID" bash

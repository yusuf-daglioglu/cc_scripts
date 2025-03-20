##############################################
# OPTIONAL DYNAMIC VARIABLES
##############################################

# we don't use nix daemon. we prefer to create a new user only for nix installations.
# so any user who knows the password of $CC_NIX_USER can install packages on nix.
# otherwise nix does not allow multi-users installation of nix packages.
CC_NIX_USER='nix_user'

# this is the directory where the nix binaries storing.
CC_NIX_BIN_ALL_PATH="/home/$CC_NIX_USER/.nix-profile/bin"

# text editors
CC_TEXT_EDITOR_FOR_NON_ROOT_FILES='gnome-text-editor'
CC_TEXT_EDITOR_FOR_ROOT_FILES='gnome-text-editor'

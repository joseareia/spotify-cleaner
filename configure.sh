#!/bin/bash

# Constants.
APP_PATH="$HOME/.cache/spotify/Storage"
CONF_FILE="$HOME/.local/share/spotify-cleaner/settings.conf"
CONF_DIR="$(dirname "$CONF_FILE")" 

# Colors.
CLR_GREEN="\033[92m"
CLR_RESET="\033[0m"
CLR_RED="\033[91m"

# Function to check if the directory exists.
check_directory() {
    if [ -d "$APP_PATH" ]; then
        echo -e "[ ${CLR_GREEN}OK${CLR_RESET} ] The directory '$APP_PATH' exists."
    else
        echo -e "[ ${CLR_RED}NOK${CLR_RESET} ] The directory '$APP_PATH' does not exist."
        prompt_user
    fi
}

# Function to ensure the configuration directory exists.
ensure_config_directory() {
    if [ ! -d "$CONF_DIR" ]; then
        echo -e "[ ${CLR_GREEN}OK${CLR_RESET} ] The configuration directory '$CONF_DIR' does not exist. Creating it..."
        mkdir -p "$CONF_DIR"
        if [ $? -eq 0 ]; then
            echo -e "[ ${CLR_GREEN}OK${CLR_RESET} ] Directory '$CONF_DIR' created successfully."
        else
            echo -e "[ ${CLR_RED}NOK${CLR_RESET} ] Failed to create directory '$CONF_DIR'. Exiting."
            exit 1
        fi
    fi
}

# Function to prompt the user for a new directory path.
prompt_user() {
    while true; do
        read -p "Please enter a valid directory path for the Spotify storage cache: " user_input
        if [ -d "$user_input" ]; then
            echo -e "[ ${CLR_GREEN}OK${CLR_RESET} ] The directory '$user_input' exists. Saving it to $CONF_FILE."
            save_settings "$user_input"
            APP_PATH="$user_input"  # Update APP_PATH for future checks.
            break
        else
            echo -e "[ ${CLR_RED}NOK${CLR_RESET} ] The directory '$user_input' does not exist. Please try again."
        fi
    done
}

# Function to save the settings to the config file.
save_settings() {
    ensure_config_directory
    echo -e "user_settings = {" > "$CONF_FILE"
    echo -e "    app_name='spotify'," >> "$CONF_FILE"
    echo -e "    path='$1'" >> "$CONF_FILE"
    echo -e "}" >> "$CONF_FILE"
    echo -e "[ ${CLR_GREEN}OK${CLR_RESET} ] Settings saved successfully in $CONF_FILE."
}

# Main logic.
if [ -f "$CONF_FILE" ]; then
    # Extract saved path from the config file.
    saved_path=$(grep "path=" "$CONF_FILE" | cut -d "'" -f 2)
    echo -e "[ ${CLR_GREEN}OK${CLR_RESET} ] Checking saved directory path: $saved_path"
    APP_PATH="$saved_path"  # Update APP_PATH with saved value.
    check_directory
else
    # echo -e "[ INFO ] No configuration file found. Checking default path."
    check_directory
fi
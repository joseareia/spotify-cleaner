#!/bin/bash

APP_PATH="$HOME/.cache/spotify/Storage"
CONF_FILE="settings.conf"

# Function to check if the directory exists
check_directory() {
  if [ -d "$APP_PATH" ]; then
    echo "[ OK ] The directory '$APP_PATH' exists."
  else
    echo "[ NOK ] The directory '$APP_PATH' does not exist."
    prompt_user
  fi
}

# Function to prompt the user for a new directory path
prompt_user() {
  while true; do
    read -p "Please enter a valid directory path for the app: " user_input
    if [ -d "$user_input" ]; then
      echo "[ OK ] The directory '$user_input' exists. Saving it to $CONF_FILE."
      save_settings "$user_input"
      APP_PATH="$user_input"  # Update APP_PATH for future checks
      break
    else
      echo "[ NOK ] The directory '$user_input' does not exist. Please try again."
    fi
  done
}

# Function to save the settings to the config file
save_settings() {
  echo "user_settings = {" > "$CONF_FILE"
  echo "    app_name='spotify'," >> "$CONF_FILE"
  echo "    path='$1'" >> "$CONF_FILE"
  echo "}" >> "$CONF_FILE"
  echo "[ OK ] Settings saved successfully in $CONF_FILE."
}

# Main logic
if [ -f "$CONF_FILE" ]; then
  # Extract saved path from the config file
  saved_path=$(grep "path=" "$CONF_FILE" | cut -d "'" -f 2)
  echo "[ INFO ] Checking saved directory path: $saved_path"
  APP_PATH="$saved_path"  # Update APP_PATH with saved value
  check_directory
else
  echo "[ INFO ] No configuration file found. Checking default path."
  check_directory
fi
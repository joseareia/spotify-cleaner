#!/bin/bash

APP_PATH="$HOME/.cache/spotify/Storage"
CONF_FILE="$HOME/.local/share/spotify-cleaner/settings.conf"
CONF_DIR="$(dirname "$CONF_FILE")" 

CLR_GREEN="\033[92m"
CLR_RED="\033[91m"
CLR_YELLOW="\033[93m"
CLR_RESET="\033[0m"

OK="[ ${CLR_GREEN}OK${CLR_RESET} ]"
NOK="[ ${CLR_RED}NOK${CLR_RESET} ]"

check_make() {
    if ! command -v make 2>&1 >/dev/null; then
        echo -e "${NOK} Make is not installed. Installing it..."
        sudo apt -y install make gcc build-essential
        echo -e "${OK} Installation completed for: make."
    else
        echo -e "${OK} ${CLR_YELLOW}Make${CLR_RESET} is installed."
    fi
}

check_lua() {
    if ! command -v lua 2>&1 >/dev/null; then
        echo -e "${NOK} Lua is not installed. Installing it..."
        curl -R -O http://www.lua.org/ftp/lua-5.3.5.tar.gz
        tar -zxf lua-5.3.5.tar.gz; cd lua-5.3.5
        make linux test
        sudo make install
        echo -e "${OK} Installation completed for 'lua'."
    else
        echo -e "${OK} ${CLR_YELLOW}Lua${CLR_RESET} is installed."
    fi
}

check_luarocks() {
    if ! command -v luarocks 2>&1 >/dev/null; then
        echo -e "${NOK} Luarocks is not installed. Installing it..."
        curl -R -O http://luarocks.github.io/luarocks/releases/luarocks-3.11.1.tar.gz
        tar -zxf luarocks-3.11.1.tar.gz; cd luarocks-3.11.1
        ./configure --with-lua-include=/usr/local/include
        make
        sudo make install
        echo -e "${OK} Installation completed for 'luarocks'."
    else
        echo -e "${OK} ${CLR_YELLOW}Luarocks${CLR_RESET} is installed."
    fi
}

check_luastatic() {
    if ! command -v luastatic 2>&1 >/dev/null; then
        echo -e "${NOK} Luastatic is not installed. Installing it..."
        luarocks install luastatic
        echo -e "${OK} Installation completed for 'luastatic'."
    else
        echo -e "${OK} ${CLR_YELLOW}Luastatic${CLR_RESET} is installed."
    fi
}

# Check if the app cache directory exists.
check_directory() {
    if [ -d "$APP_PATH" ]; then
        echo -e "${OK} The default cache directory exists. Exiting."
    else
        echo -e "${NOK} The default cache directory does not exist."
        prompt_user
    fi
}

# Ensure that the configuration directory exists.
ensure_config_directory() {
    if [ ! -d "$CONF_DIR" ]; then
        echo -e "${OK} The configuration directory does not exist. Creating it..."
        mkdir -p "$CONF_DIR"
        if [ $? -eq 0 ]; then
            echo -e "${OK} Configuration directory created successfully."
        else
            echo -e "${NOK} Failed to create directory '$CONF_DIR'. Exiting."
            exit 1
        fi
    fi
}

prompt_user() {
    while true; do
        read -p "Please specify a valid directory for the storage cache: " user_input
        if [ -d "$user_input" ]; then
            echo -e "${OK} The directory provided exists. Saving it to configuration file."
            data_path=$(echo $user_input | sed 's/Storage/Data/')
            save_settings "$user_input" "$data_path"
            APP_PATH="$user_input"
            break
        else
            echo -e "${NOK} The directory provided does not exist. Please try again."
        fi
    done
}

# Template for the 'settings.conf' file.
save_settings() {
    ensure_config_directory
    echo -e "user_settings = {" > "$CONF_FILE"
    echo -e "    app_name='spotify'," >> "$CONF_FILE"
    echo -e "    cache_path='$1'," >> "$CONF_FILE"
    echo -e "    data_path='$2'" >> "$CONF_FILE"
    echo -e "}" >> "$CONF_FILE"
    echo -e "${OK} Settings saved successfully in '$CONF_FILE'."
}

# Check if the dependecies are installed. Do not alter the order below.
echo -e "${OK} Ensuring the installation of dependencies."
check_make
check_lua
check_luarocks
check_luastatic

# Check if the default cache directory exists. If not, let the user define one.
check_directory

echo -e "${OK} Configuration completed successfully. Ready to proceed with the Makefile."
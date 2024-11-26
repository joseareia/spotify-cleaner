#!/bin/bash
set -e

APP_CACHE_DIR="$HOME/.cache/spotify/Storage"
CONFIG_FILE="$HOME/.local/share/spotify-cleaner/settings.conf"
CONFIG_DIR="$(dirname "$CONFIG_FILE")"

# Colors for output.
CLR_GREEN="\033[92m"
CLR_RED="\033[91m"
CLR_YELLOW="\033[93m"
CLR_RESET="\033[0m"

OK="[ ${CLR_GREEN}OK${CLR_RESET} ]"
NOK="[ ${CLR_RED}NOK${CLR_RESET} ]"

# Clean up temporary files on exit.
cleanup() {
    rm -f lua-5.4.7.tar.gz luarocks-3.11.1.tar.gz
}
trap cleanup EXIT

# Check and install a given package.
check_and_install() {
    local package="$1"
    if ! command -v "$package" >/dev/null 2>&1; then
        echo -e "${NOK} The package ${CLR_YELLOW}$package${CLR_RESET} is not installed. Installing."
        sudo apt-get -y update && sudo apt-get -y install "$package" "build-essential"
        echo -e "${OK} The package ${CLR_YELLOW}$package${CLR_RESET} was installed successfully."
    else
        echo -e "${OK} The package ${CLR_YELLOW}$package${CLR_RESET} is already installed."
    fi
}

# Download and extract tar compressed files.
download_and_extract() {
    local url="$1"
    local tar_file="$2"
    echo -e "${OK} Downloading $tar_file."
    curl -s -S -L -R -O "$url"
    tar -zxf "$tar_file"
    cd "${tar_file%.tar.gz}" || exit
}

check_make() {
    check_and_install "make"
}

check_gcc() {
    check_and_install "gcc"
}

check_lua() {
    if ! command -v lua >/dev/null 2>&1; then
        echo -e "${NOK} The package ${CLR_YELLOW}lua${CLR_RESET} is not installed. Installing it."
        download_and_extract "http://www.lua.org/ftp/lua-5.4.7.tar.gz" "lua-5.4.7.tar.gz"
        make linux test
        sudo make install
        echo -e "${OK} The package ${CLR_YELLOW}lua${CLR_RESET} installed successfully."
        cd ..
    else
        echo -e "${OK} The package ${CLR_YELLOW}lua${CLR_RESET} is already installed."
    fi
}

check_luarocks() {
    if ! command -v luarocks >/dev/null 2>&1; then
        echo -e "${NOK} The package ${CLR_YELLOW}luarocks${CLR_RESET} is not installed. Installing it."
        download_and_extract "http://luarocks.github.io/luarocks/releases/luarocks-3.11.1.tar.gz" "luarocks-3.11.1.tar.gz"
        ./configure --with-lua-include=/usr/local/include
        make
        sudo make install
        echo -e "${OK} The package ${CLR_YELLOW}luarocks${CLR_RESET} was installed successfully."
        cd ..
    else
        echo -e "${OK} The package ${CLR_YELLOW}luarocks${CLR_RESET} is already installed."
    fi
}

check_luastatic() {
    if ! command -v luastatic >/dev/null 2>&1; then
        echo -e "${NOK} The package ${CLR_YELLOW}luastatic${CLR_RESET} is not installed. Installing it via Luarocks."
        luarocks install luastatic
        echo -e "${OK} The package ${CLR_YELLOW}luastatic${CLR_RESET} was installed successfully."
    else
        echo -e "${OK} The package ${CLR_YELLOW}luastatic${CLR_RESET} is already installed."
    fi
}

check_cache_directory() {
    if [ -d "$APP_CACHE_DIR" ]; then
        echo -e "${OK} Default cache directory exists."
    else
        echo -e "${NOK} Default cache directory does not exist."
        prompt_user_for_directory
    fi
}

# Create configuration directory if it doesn't exist
ensure_config_directory() {
    if [ ! -d "$CONFIG_DIR" ]; then
        echo -e "${OK} Configuration directory does not exist. Creating it."
        mkdir -p "$CONFIG_DIR"
        echo -e "${OK} Configuration directory created."
    fi
}

# Prompt user to specify a directory
prompt_user_for_directory() {
    while true; do
        read -rp "Please specify a valid directory for the storage cache: " user_input
        if [ -d "$user_input" ]; then
            echo -e "${OK} Directory exists. Saving configuration."
            local data_path
            data_path=$(echo "$user_input" | sed 's/Storage/Data/')
            save_configuration "$user_input" "$data_path"
            APP_CACHE_DIR="$user_input"
            break
        else
            echo -e "${NOK} Directory does not exist. Try again."
        fi
    done
}

# Save settings to the configuration file
save_configuration() {
    local cache_path="$1"
    local data_path="$2"
    ensure_config_directory
    cat <<EOL >"$CONFIG_FILE"
user_settings = {
    app_name = 'spotify',
    cache_path = '$cache_path',
    data_path = '$data_path'
}
EOL
    echo -e "${OK} Configuration saved."
}

# Main script execution
echo -e "${OK} Ensuring required dependencies are installed."
check_gcc
check_make
check_lua
check_luarocks
check_luastatic

echo -e "${OK} Checking application cache directory."
check_cache_directory

echo -e "${OK} Configuration completed successfully. Ready to proceed with the Makefile."
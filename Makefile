# Author: José Areia (jose.apareia@gmail.com)
# Date: 2024-11-22
# Version: 1.0.0
# Dependencies: ["luastatic"]

PROG_NAME=spotify-cleaner
LUA_INTERPRETER_VERSION=liblua5.4.a
INSTALL_DIR=/usr/local/bin
CRON_FILE=/etc/cron.d/spotify-cleaner
CLR_GREEN=\033[92m
CLR_RESET=\033[0m
CLR_RED=\033[91m

all:
	@echo "[ $(CLR_GREEN)OK$(CLR_RESET) ] Starting compilation of the utility. Using '$(LUA_INTERPRETER_VERSION)' Lua interpreter."
	@luastatic src/main.lua src/utils.lua /usr/lib/x86_64-linux-gnu/$(LUA_INTERPRETER_VERSION) -o src/bin/spotify-cleaner
	@echo "[ $(CLR_GREEN)OK$(CLR_RESET) ] Compilation completed successfully."

clean:
	@echo "[ $(CLR_GREEN)OK$(CLR_RESET) ] Removing generated files and binaries."
	@rm *.c src/bin/spotify-cleaner
	@echo "[ $(CLR_GREEN)OK$(CLR_RESET) ] Cleanup completed."

install: all
	@if [ "$$(id -u)" -ne 0 ]; then \
		echo "[ $(CLR_RED)NOK$(CLR_RESET) ] Installation requires superuser privileges. Please run 'sudo make install'."; \
		exit 1; \
	fi
	
	@echo "[ $(CLR_GREEN)OK$(CLR_RESET) ] Installing '$(PROG_NAME)' to $(INSTALL_DIR)."
	@install -m 0755 src/bin/spotify-cleaner $(INSTALL_DIR)/$(PROG_NAME)
	@echo "[ $(CLR_GREEN)OK$(CLR_RESET) ] Installation completed."
	@echo "[ $(CLR_GREEN)OK$(CLR_RESET) ] Setting up a cron job for '$(PROG_NAME)'."
	@echo "0 */5 * * * root $(INSTALL_DIR)/$(PROG_NAME)" > $(CRON_FILE)
	@chmod 0644 $(CRON_FILE)
	@echo "[ $(CLR_GREEN)OK$(CLR_RESET) ] Cron job installed."

uninstall:
	@echo "[ $(CLR_GREEN)OK$(CLR_RESET) ] Removing '$(PROG_NAME)' from $(INSTALL_DIR)."
	@rm -f $(INSTALL_DIR)/$(PROG_NAME)
	@echo "[ $(CLR_GREEN)OK$(CLR_RESET) ] Removing cron job for '$(PROG_NAME)'."
	@rm -f $(CRON_FILE)
	@echo "[ $(CLR_GREEN)OK$(CLR_RESET) ] Uninstallation completed."
# Author: José Areia (jose.apareia@gmail.com)
# Date: 2024-11-22
# Version: 1.0.2
# Dependencies: ["luastatic"]

PROG_NAME=spotify-cleaner
LUA_INTERPRETER_VERSION=liblua5.4.a
INSTALL_DIR=/usr/local/bin
CRON_FILE=/etc/cron.d/spotify-cleaner
LOGROTATE_FILE=/etc/logrotate.d/spotify-cleaner
LOG_FILE=/var/log/spotify-cleaner.log

USER=$$SUDO_USER

CLR_GREEN=\033[92m
CLR_YELLOW=\033[93m
CLR_RED=\033[91m
CLR_RESET=\033[0m

all:
	@if [ "$$(id -u)" -ne 0 ]; then \
		echo "[ $(CLR_RED)ERROR$(CLR_RESET) ] Installation requires superuser privileges. Please run 'sudo make install'."; \
		exit 1; \
	fi

	@echo "[ $(CLR_GREEN)OK$(CLR_RESET) ] Starting compilation of the utility. Using $(CLR_YELLOW)$(LUA_INTERPRETER_VERSION)$(CLR_RESET) Lua interpreter."
	@mkdir -p src/bin >/dev/null 2>&1
	@rm -f *.c src/bin/spotify-cleaner >/dev/null 2>&1
	@luastatic src/main.lua src/utils.lua /usr/lib/x86_64-linux-gnu/$(LUA_INTERPRETER_VERSION) -o src/bin/spotify-cleaner >/dev/null 2>&1
	@echo "[ $(CLR_GREEN)OK$(CLR_RESET) ] Compilation completed successfully."

clean:
	@if [ "$$(id -u)" -ne 0 ]; then \
		echo "[ $(CLR_RED)ERROR$(CLR_RESET) ] Installation requires superuser privileges. Please run 'sudo make install'."; \
		exit 1; \
	fi

	@echo "[ $(CLR_GREEN)OK$(CLR_RESET) ] Removing generated files and binaries."
	@rm -f *.c src/bin/spotify-cleaner >/dev/null 2>&1
	@echo "[ $(CLR_GREEN)OK$(CLR_RESET) ] Cleanup completed."

install: all
	@if [ "$$(id -u)" -ne 0 ]; then \
		echo "[ $(CLR_RED)DEPEND$(CLR_RESET) ] Installation requires superuser privileges. Please run 'sudo make install'."; \
		exit 1; \
	fi

	@echo "[ $(CLR_GREEN)OK$(CLR_RESET) ] Installing $(CLR_YELLOW)$(PROG_NAME)$(CLR_RESET) to $(INSTALL_DIR)."
	@install -m +x src/bin/spotify-cleaner $(INSTALL_DIR)/$(PROG_NAME) >/dev/null 2>&1
	@echo "[ $(CLR_GREEN)OK$(CLR_RESET) ] Installation completed."
	@echo "[ $(CLR_GREEN)OK$(CLR_RESET) ] Setting up a cron job for $(CLR_YELLOW)$(PROG_NAME)$(CLR_RESET)."
	@echo "PATH=/usr/local/bin/:/usr/bin:/bin\n0 * * * * $(USER) $(PROG_NAME) >> /var/log/spotify-cleaner.log 2>&1" > $(CRON_FILE)
	@echo "[ $(CLR_GREEN)OK$(CLR_RESET) ] Setting up a log rotate for $(CLR_YELLOW)$(PROG_NAME)$(CLR_RESET)."
	@touch $(LOG_FILE)
	@chown $(USER):$(USER) $(LOG_FILE)
	@chmod 644 $(LOG_FILE)
	@cp spotify-cleaner.logrotate $(LOGROTATE_FILE)
	@chmod 0644 $(CRON_FILE)
	@echo "[ $(CLR_GREEN)OK$(CLR_RESET) ] Cron job and log rotation successfully configured."

uninstall:
	@if [ "$$(id -u)" -ne 0 ]; then \
		echo "[ $(CLR_RED)ERROR$(CLR_RESET) ] Operation requires superuser privileges. Please run 'sudo make install'."; \
		exit 1; \
	fi

	@echo "[ $(CLR_GREEN)OK$(CLR_RESET) ] Removing $(CLR_YELLOW)$(PROG_NAME)$(CLR_RESET) from $(INSTALL_DIR)."
	@rm -f $(INSTALL_DIR)/$(PROG_NAME) >/dev/null 2>&1
	@echo "[ $(CLR_GREEN)OK$(CLR_RESET) ] Removing cron job for $(CLR_YELLOW)$(PROG_NAME)$(CLR_RESET)."
	@rm -f $(CRON_FILE) >/dev/null 2>&1
	@echo "[ $(CLR_GREEN)OK$(CLR_RESET) ] Uninstallation completed."
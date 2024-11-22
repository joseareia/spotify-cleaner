# Author: José Areia (jose.apareia@gmail.com)
# Date: 2024-11-22
# Version: 1.0.0
# Dependencies: ["luastatic"]

PROG_NAME=spotify-cleaner
LUA_INTERPRETER_VERSION=liblua5.4.a

all:
	@echo "[ INFO ] Starting compilation of the utility. Using '$(LUA_INTERPRETER_VERSION)' Lua interpreter."
	@luastatic src/main.lua src/utils.lua /usr/lib/x86_64-linux-gnu/$(LUA_INTERPRETER_VERSION) -o src/bin/spotify-cleaner
	@echo "[ SUCCESS ] Compilation completed successfully."

clean:
	@echo "[ INFO ] Removing generated files and binaries."
	@rm *.c src/bin/spotify-cleaner
	@echo "[ SUCCESS ] Cleanup completed."

# TODO: Make install globally and write in crontab.
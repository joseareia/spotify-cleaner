# Spotify Cleaner
[![made-with-lua](https://img.shields.io/badge/Made%20with-Lua-1f425f.svg?color=blue)](https://www.lua.org/)
[![GitHub license](https://img.shields.io/badge/License-GPL_3.0-green.svg)](https://www.gnu.org/licenses/gpl-3.0.html#license-text)

A simple utility that cleans the Spotify cache based on a user-defined threshold. Simple, right?

## Why?
Spotify is notorious for creating a cache that can grow significantly over time. Sure, you can manually clear it via Spotify's app settings by pressing `Clear Cache`, but let’s face it — I’m lazy. To address this, I created a simple Lua utility that automatically clears the cache when it exceeds 100 MB.

But why **exactly** do I care about clearing Spotify’s cache? One day, I noticed Spotify consuming an absurd amount of CPU and memory. After investigating, I discovered that the app had accumulated over 3 GB of cache. Once I cleared it and restarted Spotify, the app stopped hogging system resources.

So here we are—a straightforward, automated solution for lazy people like me!

P.S.: I know Spotify allows you to set a cache limit, but where’s the fun in that when you can over-engineer a solution? 😉

## Dependecies

This project requires the following utilities:
1. **Lua**
The programming language used for this project. You can download and install Lua from its [official website](https://www.lua.org/download.html). **Tip:** After following the installation steps on Lua's website, don't forget to run `make install` after executing `make all test`. Additionally, consider installing [`luarocks`](http://luarocks.org), a package manager for Lua modules.

2. **Luastatic**
A command-line tool that compiles a Lua program into a standalone executable. Learn more and install it from [GitHub](https://github.com/ers35/luastatic) or via [luarocks](http://luarocks.org/modules/ers35/luastatic).

3. **Make** 
A build automation tool. If it’s not already installed, you can install it on most Linux (debian-based) systems with: `sudo apt install make`.

## Installation

To install this utility, simply run the following commands:

```bash
git clone https://github.com/joseareia/spotify-cleaner
cd spotify-cleaner
sudo make install
sudo make clean % If you want to clean the project directory.
sudo make uninstall % If you want to uninstall the utility.
```

If you need to run `luastatic` with `sudo`, you may have to add its path to the `secure_path` in the `sudoers` file. This allows `sudo` to recognize and execute the `luastatic` command.

> [!WARNING]
> This method is a quick workaround, but it's not recommended for security reasons. Adding executable paths to `secure_path` should be done with caution. A safer approach would be to configure `luastatic` to be available system-wide without needing `sudo`.

After the installation is completed you should have the `spotify-cleaner` usable system-wide and a new `cronjob` (that checks the cache size every five hours) created! After that, you can safely remove the cloned repository.

## Configurations

If you wish to modify the utility (e.g., path, cache size, etc.), you can edit the file located at `src/main.lua`.

Also, make sure the Lua interpreter version on your system matches the version used during compilation (as specified in the `Makefile`). If you're unsure, check for the Lua library in `/usr/lib/x86_64-linux-gnu`. If it's missing, you can install it by running: `sudo apt install liblua5.4-dev`, or the version of your Lua interpreter.

## Getting Help
If you have any questions regarding the utility, its usage, or encounter any errors you're struggling with, please feel free to open an issue in this repository, or contact me via email at <a href="mailto:jose.apareia@gmail.com">jose.apareia@gmail.com</a>.

## Contributing
Contributions to this utility are welcome! If you encounter any issues, have suggestions for improvements, or would like to add new features, please submit a pull request. I appreciate your feedback and contributions to make this utility even better.

## License
This project is under the [GPL 3.0](https://www.gnu.org/licenses/gpl-3.0.html#license-text) license.
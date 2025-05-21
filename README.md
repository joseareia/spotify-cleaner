# Spotify Cleaner
[![made-with-lua](https://img.shields.io/badge/Made%20with-Lua-1f425f.svg?color=blue)](https://www.lua.org/)
[![GitHub license](https://img.shields.io/badge/License-GPL_3.0-green.svg)](https://www.gnu.org/licenses/gpl-3.0.html#license-text)
[![Release](https://img.shields.io/github/v/tag/joseareia/spotify-cleaner?label=Release&color=green)](https://github.com/joseareia/spotify-cleaner/releases)
[![Maintenance](https://img.shields.io/badge/Maintained%3F-Yes-green.svg)](https://github.com/joseareia/spotify-cleaner/graphs/commit-activity)

A simple utility that cleans the Spotify cache based on a user-defined threshold. Simple, right?

## Why?
Spotify is notorious for creating a cache that can grow significantly over time. Sure, you can manually clear it via Spotify's app settings by pressing `Clear Cache`, but let’s face it — I’m lazy. To address this, I created a simple Lua utility that automatically clears the cache when it exceeds 150 MB.

But why **exactly** do I care about clearing Spotify’s cache? One day, I noticed Spotify consuming an absurd amount of CPU and memory. After investigating, I discovered that the app had accumulated over 3 GB of cache. Once I cleared it and restarted Spotify, the app stopped hogging system resources.

So here we are—a straightforward, automated solution for lazy people like me!

P.S.: I know Spotify allows you to set a cache limit, but where’s the fun in that when you can over-engineer a solution? 😉

## Dependecies

This project requires the following utilities:
1. **Lua**: The programming language used for this project. You can download and install Lua from its [official website](https://www.lua.org/download.html).

2. **Luastatic**: A command-line tool that compiles a Lua program into a standalone executable. Learn more and install it from [GitHub](https://github.com/ers35/luastatic) or via [luarocks](http://luarocks.org/modules/ers35/luastatic).

3. **Make**: A build automation tool. If it’s not already installed, you can install it on most Linux (debian-based) systems with: `sudo apt install make`.

> [!TIP]
> By running the `configure` binary, all these dependencies will be checked, and, if needed, they will be installed for you. Even the default directory of the storage and data files of Spotify.

## Installation

To install, and therefore use this utility, first download the most [recent release](https://github.com/joseareia/spotify-cleaner/releases). Then simply run the following commands:

```console
./configure
```
This command will check every dependency that you may need in your system, and it will install everything for you. After that, just run:

```console
sudo make install
```

After the installation is completed you should have the `spotify-cleaner` usable system-wide and a new `cronjob` (that checks the cache size every five hours) created! After that, **you can safely remove the project release downloaded.**

## Additional Configurations

If you wish to modify the utility (e.g., path, cache size, etc.), you can edit the file located at `src/main.lua` and then proceed again with the installation steps.

If you desire to uninstall the utility, you can simply run:

```console
sudo make uninstall
```

This command will remove both the `spotify-cleaner` utility installed system-wide and the `cronjob` created during the installation process.

## Getting Help
If you have any questions regarding the utility, its usage, or encounter any errors you're struggling with, please feel free to open an issue in this repository, or contact me via email at <a href="mailto:jose.apareia@gmail.com">jose.apareia@gmail.com</a>.

## Contributing
Contributions to this utility are welcome! If you encounter any issues, have suggestions for improvements, or would like to add new features, please submit a pull request. I appreciate your feedback and contributions to make this utility even better.

## License
This project is under the [GPL 3.0](https://www.gnu.org/licenses/gpl-3.0.html#license-text) license.
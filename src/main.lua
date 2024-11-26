local utils = require("src.utils")

-- TODO: Deprecate these variables and the logic behind them. Does not make any sense!
local is_installed = nil
local app_name = 'spotify'
local username = utils.get_username()

-- Global variable that can be alter in the future.
cache_path = '/home/' .. username .. '/.cache/spotify/Storage'

-- Check if directory exists. 
-- If not (default logic) a try-out to get into a custom setting file will be done.
if utils.directory_exists(cache_path) == nil then
    local config_env = {}
    local home_env = os.getenv("HOME")
    local f, err = loadfile(home_env .. "/.local/share/spotify-cleaner/settings.conf", "t", config_env)

    if f then
        f()
        cache_path = config_env.user_settings.path
        print("Loadfile " .. cache_path)
    else
        print(err)
    end
end

-- Check is Spotify is installed.
local handle = io.popen('which ' .. app_name)
if not handle then
    print("[ ERROR ] The command failed to execute.")
else
    local result = handle:read("*a")
    handle:close()
    if result ~= "" then is_installed = true end
end

-- If Spotify is installed, checks the cache size. If the cache exceeds 100MB, it is deleted.
if is_installed then
    local cache_exists = utils.directory_exists(cache_path)
    if cache_exists then cache_size = utils.get_directory_size(cache_path) end   
    cache_size = tonumber(string.format("%.2f", cache_size / 1024)) -- Convert from kB to MB.

    if cache_size >= 100 then
        local cmd_delete_dir = "rm -r " .. cache_path .. "/*"
        local ok, exit = os.execute(cmd_delete_dir)
        if ok ~= true then
            print("[ ERROR ] Could not delete the directory due to: '" .. exit .. "'.")
        end
    end
end
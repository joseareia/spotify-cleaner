local utils = require("src.utils")

-- Local $HOME variable environment.
local home_env = os.getenv("HOME")

-- Global variable that can be alter in the future.
cache_path = home_env .. '/.cache/spotify/Storage'
data_path = home_env .. '/.cache/spotify/Data'

-- Current date and time. To be used in logs.
current_time = os.date("%Y-%m-%dT%X")

-- Limit cache size in MB.
limit_cache_size = 150

-- Check if directory exists. If not (default logic) a try-out to get into a custom file setting will be done.
if utils.directory_exists(cache_path) == nil then
    local config_env = {}
    local f, err = loadfile(home_env .. "/.local/share/spotify-cleaner/settings.conf", "t", config_env)

    if f then
        f()
        cache_path = config_env.user_settings.cache_path
        data_path = config_env.user_settings.data_path
    else
        print(err)
    end
end

-- Checks the cache size. If the cache exceeds the given value, it is deleted.
local cache_exists = utils.directory_exists(cache_path)
if cache_exists then cache_size = utils.get_directory_size(cache_path) end   
cache_size = tonumber(string.format("%.2f", cache_size / 1024)) -- Convert from kB to MB.

if cache_size >= limit_cache_size then
    local cmd_delete_dir = "rm -r " .. cache_path .. "/*"
    local ok, exit = os.execute(cmd_delete_dir)
    if ok ~= true then
        print(current_time .. " spotify-cleaner: Cache was not cleared due to error: '" .. exit .. "'.")
    else
        print(current_time .. " spotify-cleaner: Cache was cleared (" .. cache_size .. "MB).")
    end
else
    print(current_time ..
    " spotify-cleaner: Cache not cleared (" ..
    cache_size .. "MB) as it is below the threshold (" .. limit_cache_size .. "MB).")
end

-- Checks the data size. If the cache exceeds the given value, it is deleted.
local data_exists = utils.directory_exists(data_path)
if data_exists then data_size = utils.get_directory_size(data_path) end
data_size = tonumber(string.format("%.2f", data_size / 1024)) -- Convert from kB to MB.

if data_size >= limit_cache_size then
    local cmd_delete_dir = "rm -r " .. data_path .. "/*"
    local ok, exit = os.execute(cmd_delete_dir)
    if ok ~= true then
        print(current_time .. " spotify-cleaner: Data was not cleared due to error: '" .. exit .. "'.")
    else
        print(current_time .. " spotify-cleaner: Data was cleared (" .. data_size .. "MB).")
    end
else
    print(current_time ..
    " spotify-cleaner: Data not cleared (" ..
    data_size .. "MB) as it is below the threshold (" .. limit_cache_size .. "MB).")
end

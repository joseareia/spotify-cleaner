local utils = require("src.utils")

-- Local $HOME variable environment.
local home_env = os.getenv("HOME")

-- Global variable that can be alter in the future.
cache_path = home_env .. '/.cache/spotify/Storage'
data_path = home_env .. '/.cache/spotify/Data'

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

-- Checks the cache size. If the cache exceeds 100MB, it is deleted.
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

-- Checks the data size. If the data exceeds 100MB, it is deleted.
local data_exists = utils.directory_exists(data_path)
if data_exists then data_size = utils.get_directory_size(data_path) end
data_size = tonumber(string.format("%.2f", data_size / 1024)) -- Convert from kB to MB.

if data_size >= 100 then
    local cmd_delete_dir = "rm -r " .. data_path .. "/*"
    local ok, exit = os.execute(cmd_delete_dir)
    if ok ~= true then
        print("[ ERROR ] Could not delete the directory due to: '" .. exit .. "'.")
    end
end
local utils = require("src.utils")

local is_installed = nil
local app_name = 'spotify'
local username = utils.get_username()
local cache_path = '/home/' .. username .. '/.cache/spotify/Storage'

-- Check is Spotify is installed.
local handle = io.popen('which ' .. app_name)
if not handle then
    print("[ ERROR ] The command failed to execute.")
else
    local result = handle:read("*a")
    handle:close()
    if result ~= "" then is_installed = true end
end

-- If Spotify is installed, checks the cache size. If the cache exceeds 50MB, it is deleted.
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
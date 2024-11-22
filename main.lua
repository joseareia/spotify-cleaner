local utils = require("spotify-cleaner.utils")

local is_installed = nil
local app_name = 'spotify'
local spotify_cache_path = '/home/joseareia/.cache/spotify/Storage'

local handle = io.popen('which ' .. app_name)

if not handle then
    print("[ ERROR ] The command failed to execute.")
else
    local result = handle:read("*a")
    handle:close()
    if result ~= "" then is_installed = true end
end

-- If Spotify is installed, checks the cache size. If the cache exceeds 50MB, it is deleted.
if is_installed ~= nil then
    local cache_exists = utils.directory_exists(spotify_cache_path)
    if cache_exists then cache_size = utils.get_directory_size(spotify_cache_path) end   
    cache_size = tonumber(string.format("%.2f", cache_size / 1024)) -- Convert from kB to MB.

    if cache_size < 100 then
        local cmd_delete_dir = "rm -r " .. spotify_cache_path .. "/*"
        local ok, exit = os.execute(cmd_delete_dir)
        if ok ~= true then
            print("[ ERROR ] Could not delete the directory due to: '" .. exit .. "'.")
        else
            print("[ SUCCESS ] Spotify cache cleaned.")
        end
    end
end
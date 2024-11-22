-- @module src.utils
local utils = {}

-- Check if a directory exists.
function utils.directory_exists(directory)
    local ok, err, code = os.rename(directory, directory)
    if not ok then
        if code == 13 then
            return true
        end
    end
    return ok, err
end

-- Get the size of a directory.
function utils.get_directory_size(directory)
    local handle = io.popen('du -s "' .. directory .. '" 2>/dev/null') -- Execute 'du' command.
    if handle then
        local result = handle:read("*a")
        handle:close()
        return result:match("^(%S+)") -- Extract size from the output.
    else
        return nil, "[ ERROR ] Failed to calculate size."
    end
end

-- Get the username in which the program is being executed.
function utils.get_username()
    username = os.getenv("USER") or os.getenv("LOGNAME")
    if not username then
        print("[ ERROR ] Unable to determine the username.")
        return nil
    end
    return username
end

return utils
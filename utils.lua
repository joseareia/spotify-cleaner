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

return utils
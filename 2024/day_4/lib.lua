local lib = {}

function lib.searchHowManyInLine(str, toSearch)
    local founds = {}
    for found in string.gmatch(str, toSearch) do
        table.insert(founds, found)
    end
    return #founds
end

function lib.transformRowInTable(str, vertical)
    local index = 1
    for char in string.gmatch(str, '.') do
        if (vertical[index] == nil) then vertical[index] = "" end
        vertical[index] = vertical[index] .. char
        index = index + 1
    end

    return vertical
end

function lib.buildRowDiagonalTable(str, diagonal, rowIndex, toSearch)
    local index = 1
    local pos = {}
    pos['string'] = ""
    pos['coords'] = {}

    for char in string.gmatch(str, '.') do
        if (char == startChar) then vertical[index] = "" end
        vertical[index] = vertical[index] .. char
        index = index + 1
    end

    return diagonal
end

return lib
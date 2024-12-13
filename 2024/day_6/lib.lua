local lib = {}

function lib.buildMatrixRow(str)
    local row = {}
    for char in string.gmatch(str, '.') do
        table.insert(row, char)
    end
    return row
end

function lib.split(str, pattern)
    local results = string.gmatch(str, pattern)
    local resultsTable = {}
    for result in results do
        table.insert(resultsTable, result)
    end
    return resultsTable
end

function lib.inTable(tbl, toSearch)
    if (tbl == nil) then return nil end
    for k, v in pairs(tbl) do
        if (v == toSearch) then return k end
    end
    return nil
end

function lib.implodeTable(values, separator)
    local str = ""
    for k, el in pairs(values) do
        if (k == 1) then
            str = str .. el
        else
            str = str .. separator .. el
        end
    end
    return str
end

function lib.guardTurn90(currentDir)
    local newDirections = { ['up'] = 'right', ['right'] = 'down', ['down'] = 'left', ['left'] = 'up' }
    return newDirections[currentDir]
end

function lib.guessNextMove(currentDir)
    local newDirections = { ['up'] = { -1, 0 }, ['right'] = { 0, 1 }, ['down'] = { 1, 0 }, ['left'] = { 0, -1 } }
    return newDirections[currentDir]
end

function lib.moveGuard(guardCurrentPos, nextMove)
    guardCurrentPos[1] = guardCurrentPos[1] + nextMove[1]
    guardCurrentPos[2] = guardCurrentPos[2] + nextMove[2]
    return guardCurrentPos
end

function lib.isAnObstacle(places, guardCurrentPos, nextMove)
    local rowIndex = guardCurrentPos[1] + nextMove[1]
    local colIndex = guardCurrentPos[2] + nextMove[2]
    if (places[rowIndex] == nil) then return false end
    if (places[rowIndex][colIndex] == nil) then return false end
    if (places[rowIndex][colIndex] == '#') then
        return true
    end
    return false
end

function lib.isGuardLeftTheMap(map, totalRows, guardCurrentPos)
    local rowLength = #map[1]
    if (guardCurrentPos[2] > rowLength) then return true end
    if (guardCurrentPos[1] > totalRows - 1) then return true end
    if (guardCurrentPos[2] <= 0) then return true end
    if (guardCurrentPos[1] <= 0) then return true end
    return false
end

function lib.updateSymbol(map, guardCurrentPos, symbol)
    if (map[guardCurrentPos[1]] == nil) then return map end
    if (map[guardCurrentPos[1]][guardCurrentPos[2]] == nil) then return map end
    map[guardCurrentPos[1]][guardCurrentPos[2]] = symbol
    return map
end

function lib.isMapEnded(map, guardCurrentPos, nextMove)
    local rowIndex = guardCurrentPos[1] + nextMove[1]
    local colIndex = guardCurrentPos[2] + nextMove[2]
    if (map[rowIndex] == nil) then return true end
    if (map[rowIndex][colIndex] == nil) then return true end
    return false
end

return lib

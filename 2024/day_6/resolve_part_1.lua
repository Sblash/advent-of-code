local startTime = os.clock()
local lib = require("lib")

local file = io.open("input_file.txt", "r")
if file == nil then os.exit() end

local map = {}
local placesVisited = {}
local guardDirections = { ['up'] = '^', ['down'] = 'v', ['right'] = '>', ['left'] = '<' }
local guardCurrentDirection = ''
local guardCurrentPos = {}
local rowIndex = 1

for line in file:lines() do
    local row = lib.buildMatrixRow(line)
    table.insert(map, row)

    for dir, dirSymbol in pairs(guardDirections) do
        local guardPos = string.find(line, '%' .. dirSymbol)
        if (guardPos ~= nil) then
            guardCurrentDirection = dir
            guardCurrentPos[1] = rowIndex
            guardCurrentPos[2] = guardPos
            break
        end
    end
    rowIndex = rowIndex + 1
end

print('rows: ' .. rowIndex)
print('current dir: ' .. guardCurrentDirection)
print('current pos: ' .. lib.implodeTable(guardCurrentPos, ' '))
table.insert(placesVisited, lib.implodeTable(guardCurrentPos, '-'))

while (lib.isGuardLeftTheMap(map, rowIndex, guardCurrentPos) == false) do
    local nextMove = lib.guessNextMove(guardCurrentDirection)
    local placeVisitedString = lib.implodeTable(guardCurrentPos, '-')
    if (lib.isAnObstacle(map, guardCurrentPos, nextMove)) then
        guardCurrentDirection = lib.guardTurn90(guardCurrentDirection)
        map = lib.updateSymbol(map, guardCurrentPos, guardDirections[guardCurrentDirection])
        goto continue
    end

    if (lib.isMapEnded(map, guardCurrentPos, nextMove)) then
        map = lib.updateSymbol(map, guardCurrentPos, 'X')
        if (lib.inTable(placesVisited, placeVisitedString) == nil) then table.insert(placesVisited, placeVisitedString) end
        guardCurrentPos = lib.moveGuard(guardCurrentPos, nextMove)
        goto continue
    end

    map = lib.updateSymbol(map, guardCurrentPos, 'X')
    if (lib.inTable(placesVisited, placeVisitedString) == nil) then table.insert(placesVisited, placeVisitedString) end
    guardCurrentPos = lib.moveGuard(guardCurrentPos, nextMove)
    map = lib.updateSymbol(map, guardCurrentPos, guardDirections[guardCurrentDirection])

    ::continue::
end

-- for k, places in pairs(map) do
--     print(lib.implodeTable(places, ''))
-- end

print('Total position visited: ' .. #placesVisited)

local endTime = os.clock()
local execTime = endTime - startTime
print()
print("Execution time: " .. execTime .. " seconds")

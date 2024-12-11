local startTime = os.clock()
local lib = require("lib")

local file = io.open("input_file.txt", "r")
local countXmas = 0

if file == nil then os.exit() end

local vertical = {}
local matrix = {}
local i = 1

for line in file:lines() do
    local inLine = lib.searchHowManyInLine(line, "XMAS")
    local inLineBack = lib.searchHowManyInLine(line, "SAMX")

    vertical = lib.transformRowInTable(line, vertical)

    local row = lib.buildMatrixRow(line)
    table.insert(matrix, row)

    countXmas = countXmas + inLine + inLineBack
    i = i + 1
end

for k, row in pairs(vertical) do
    local inLine = lib.searchHowManyInLine(row, "XMAS")
    local inLineBack = lib.searchHowManyInLine(row, "SAMX")
    countXmas = countXmas + inLine + inLineBack
end

-- for i, row in pairs(matrix) do
--     local str = ''
--     for j, char in pairs(row) do
--         str = str .. '\t' .. char
--     end
--     str = string.gsub(str, "\t", "", 1)
--     print(str)
-- end

local foundInMatrix = lib.searchInMatrix(matrix, {'X', 'M', 'A', 'S'}, 4)
local foundInMatrixReverse = lib.searchInMatrix(matrix, {'S', 'A', 'M', 'X'}, 4)

-- for _, f in pairs(foundInMatrix) do
--     print(f)
-- end
-- print(#foundInMatrix)

countXmas = countXmas + #foundInMatrix

-- for _, f in pairs(foundInMatrixReverse) do
--     print(f)
-- end
-- print(#foundInMatrixReverse)

countXmas = countXmas + #foundInMatrixReverse

print("Total XMAS: " .. countXmas)

local endTime = os.clock()
local execTime = endTime - startTime 

print("Execution time: " .. execTime .. " seconds")
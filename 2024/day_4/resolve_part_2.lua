local startTime = os.clock()
local lib = require("lib")

local file = io.open("input_file.txt", "r")

if file == nil then os.exit() end

local matrix = {}

for line in file:lines() do
    local row = lib.buildMatrixRow(line)
    table.insert(matrix, row)
end

-- for i, row in pairs(matrix) do
--     local str = ''
--     for j, char in pairs(row) do
--         str = str .. '\t' .. char
--     end
--     str = string.gsub(str, "\t", "", 1)
--     print(str)
-- end

local foundXInMatrix = lib.searchXPatternInMatrix(matrix, {'M', 'A', 'S'}, 'A', pattern)

print("Total X-MAS: " .. foundXInMatrix)
local endTime = os.clock()
local execTime = endTime - startTime 

print("Execution time: " .. execTime .. " seconds")
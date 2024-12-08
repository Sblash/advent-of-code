local lib = require("lib")

local file = io.open("input_file.txt", "r")
local countXmas = 0

if file == nil then os.exit() end

local vertical = {}
local diagonal = {}
local diagonalBack = {}
local i = 1

for line in file:lines() do
    local inLine = lib.searchHowManyInLine(line, "XMAS")
    local inLineBack = lib.searchHowManyInLine(line, "SAMX")

    vertical = lib.transformRowInTable(line, vertical)

    countXmas = countXmas + inLine + inLineBack
    i = i + 1
    print()
end

for k, row in pairs(vertical) do
    local inLine = lib.searchHowManyInLine(row, "XMAS")
    local inLineBack = lib.searchHowManyInLine(row, "SAMX")
    countXmas = countXmas + inLine + inLineBack
end

print("Total XMAS: " .. countXmas)

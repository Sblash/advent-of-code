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

local function inTable(table, toSearch)
    for k, v in pairs(table) do
        if (v == toSearch) then return k end
    end
    return nil
end

function lib.buildMatrixRow(str)
    local row = {}
    for char in string.gmatch(str, '.') do
        table.insert(row, char)
    end
    return row
end

function lib.searchInMatrix(matrix, charsToSearch, maxLength)
    local found = {}
    local jDirection = {1, -1}

    for i, row in pairs(matrix) do
        -- print('@@@ ROW ' .. i .. ' @@@')
        for j, char in pairs(row) do
            -- print('Processing char: ' .. char)
            for _, jDir in pairs(jDirection) do
                local str = ''
                local modI = 1
                local modJ = 1
                -- print('Search next char in direction: ' .. jDir)
                modJ = modJ * jDir
                for charIndex, charToSearch in pairs(charsToSearch) do
                    if (charIndex == 1 and char ~= charToSearch) then 
                        -- print('Skip char: ' .. char)
                        break 
                    end
                    if (charIndex == 1 and char == charToSearch) then 
                        str = str .. charToSearch
                        -- print('Found ' .. charToSearch .. ' in ' .. i, j)
                        goto continue
                    end
                    if (string.len(str) > 0) then
                        if (matrix[i + modI] == nil) then goto continue end
                        if (matrix[i + modI][j + modJ] == nil) then goto continue end
        
                        if (matrix[i + modI][j + modJ] ~= charsToSearch[charIndex]) then
                            str = ''
                            break
                        end
                        if (matrix[i + modI][j + modJ] == charsToSearch[charIndex]) then
                            -- print('Found ' .. matrix[i + modI][j + modJ] .. ' in ' .. i + modI, j + modJ)
                            str = str .. matrix[i + modI][j + modJ]
                            charIndex = charIndex + 1
                            modI = modI + 1
                            if (jDir > 0) then
                                modJ = modJ + 1
                            else
                                modJ = modJ - 1
                            end
                        end
                    end

                    if (string.len(str) == maxLength) then
                        table.insert(found, str)
                        str = ''
                    end
                    ::continue::
                end
            end
        end
    end
    return found
end

local function ImplodeTable(values)
	local str = ""
	for k,el in pairs(values) do
		str = str..el
	end
	return str
end

local function reverseTable(mytable)
    local newTable = {}
    for i = #mytable, 1, -1 do
        table.insert(newTable, mytable[i])
    end
    return newTable
end

function lib.searchXPatternInMatrix(matrix, charsToSearch, startingChar)
    local pattern = {{-1, -1}, {0, 0}, {1, 1}, {-1, 1}, {0, 0}, {1, -1}}
    local found = 0
    local maxLength = #charsToSearch * 2

    for i, row in pairs(matrix) do
        -- print('@@@ ROW ' .. i .. ' @@@')
        for j, char in pairs(row) do
            -- print('Processing char: ' .. char)
            if (char ~= startingChar) then
                goto next_char
            end
            -- print('Found startingChar: ' .. startingChar .. ' in ' .. i, j)
            local lastCharIndex = 0
            local str = ''
            for _, dir in pairs(pattern) do
                local modI = dir[1]
                local modJ = dir[2]
                -- print('Searching in ', modI, modJ)
                if (matrix[i + modI] == nil) then goto continue end
                if (matrix[i + modI][j + modJ] == nil) then goto continue end

                local charIndex = inTable(charsToSearch, matrix[i + modI][j + modJ])
                if (charIndex == nil) then break end
                if (lastCharIndex == charIndex) then break end
                lastCharIndex = charIndex
                
                -- print('Found ' .. matrix[i + modI][j + modJ] .. ' in ' .. i + modI, j + modJ)
                str = str .. matrix[i + modI][j + modJ]

                if (string.len(str) == #charsToSearch) then
                    lastCharIndex = 0
                end

                if (string.len(str) == maxLength) then
                    local mAsc = lib.searchHowManyInLine(str, ImplodeTable(charsToSearch))
                    local reversedChars = reverseTable(charsToSearch)
                    local mDesc = lib.searchHowManyInLine(str, ImplodeTable(reversedChars))
                    if (mAsc + mDesc == 2) then
                        found = found + 1
                    end
                end
                ::continue::
            end
            ::next_char::
        end
    end
    return found
end

return lib
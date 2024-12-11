local startTime = os.clock()
local lib = require("lib")

local rulesFile = io.open("rules_file.txt", "r")
local updatesFile = io.open("updates_file.txt", "r")

if rulesFile == nil then os.exit() end
if updatesFile == nil then os.exit() end

local rules = {}
local sumMiddlePages = 0

for line in rulesFile:lines() do
    local ruleParts = lib.split(line, '([^|]+)')
    if (rules[ruleParts[1]] == nil) then
        rules[ruleParts[1]] = {}
    end
    table.insert(rules[ruleParts[1]], ruleParts[2])
end

for k, v in pairs(rules) do
    for _, c in pairs(v) do
        print(k, c)
    end
end

print()

for line in updatesFile:lines() do
    local pages = lib.split(line, '([^,]+)')
    local correct = true
    for i = 1, #pages do
        if (correct == false) then break end
        local pageRules = rules[pages[i]]
        for j = 1, #pages do
            if (i == j) then goto continue end
            if (lib.inTable(pageRules, pages[j]) ~= nil) then
                if (j < i) then
                    print(pages[i] .. ' and ' .. pages[j] .. ' are not in the correct order')
                    correct = false
                    goto continue
                end
            end
            ::continue::
        end
    end
    if (correct) then
        print('Correct: ', lib.implodeTable(pages, ','))
        local middleNumber = lib.findMiddleNumber(pages)
        print(middleNumber)
        sumMiddlePages = sumMiddlePages + middleNumber
    else
        print('Not Correct: ', lib.implodeTable(pages, ','))
    end
    
    print()
end

print('Sum middle pages: ' .. sumMiddlePages)

local endTime = os.clock()
local execTime = endTime - startTime 

print("Execution time: " .. execTime .. " seconds")
local file = io.open("input_file.txt", "r")
local total = 0

if file == nil then os.exit() end

for line in file:lines() do
    local resultsMul = string.gmatch(line, 'mul%(%d+,%d+%)')
    for mul in resultsMul do
        local resultNumbers = string.gmatch(mul, '%d+')
        local numbers = {}
        for v in resultNumbers do
            table.insert(numbers, v)
        end
        total = total + numbers[1] * numbers[2]
    end
end

print('Total: ' .. total)
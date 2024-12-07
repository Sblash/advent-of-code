local file = io.open("input_file.txt", "r")
local total = 0

if file == nil then os.exit() end

function Mul(mul)
	local resultNumbers = string.gmatch(mul, '%d+')
	local numbers = {}
	for v in resultNumbers do
		table.insert(numbers, v)
	end
	return numbers[1] * numbers[2]
end

function IsMul(instruction)
	return instruction:find('mul') ~= nil
end

local canSum = true

for line in file:lines() do
	-- since it seems lua patterns can't do "multi selections" like regular regex (i mean this: mul%(%d+,%d+%)|do%b()|don't%b() )
	-- i did this thing below
	local posMul = string.find(line, 'mul%(%d+,%d+%)')
	local posDo = string.find(line, 'do%b()')
	local posDont = string.find(line, "don't%b()")

	while (posMul ~= nil or posDo ~= nil or posDont ~= nil) do
		local positions = {}
		local found = {}
 		local mul = ''
		local _do = ''
		local dont = ''
		-- print('posMul: ' .. tostring(posMul))
		-- print('posDo: ' .. tostring(posDo))
		-- print('posDont: ' .. tostring(posDont))
		if (posMul ~= nil) then
			table.insert(positions, posMul)
			mul = string.match(line, "mul%(%d+,%d+%)")
			found[posMul] = mul
			-- print('mul: ' .. mul)
		end
		if (posDo ~= nil) then
			table.insert(positions, posDo)
			_do = string.match(line, "do%b()")
			found[posDo] = _do
			-- print('do: ' .. _do)
		end
		if (posDont ~= nil) then
			table.insert(positions, posDont)
			dont = string.match(line, "don't%b()")
			found[posDont] = dont
			-- print('dont: ' .. dont)
		end

		table.sort(positions)
		local instruction = found[positions[1]]
		-- print(instruction)
		local toCancel = found[positions[1]]
		toCancel = string.gsub(toCancel, '%(', '%%(', 1)
		toCancel = string.gsub(toCancel, '%)', '%%)', 1)
		line = string.gsub(line, toCancel, '', 1)

		if (instruction == 'do()') then canSum = true end
		if (instruction == 'don\'t()') then canSum = false end

		if (IsMul(instruction) and canSum) then
			total = total + Mul(instruction)
		end

		posMul = string.find(line, 'mul%(%d+,%d+%)')
		posDo = string.find(line, 'do%b()')
		posDont = string.find(line, "don't%b()")
	end
	-- print(line)
end

print('Total: ' .. total)

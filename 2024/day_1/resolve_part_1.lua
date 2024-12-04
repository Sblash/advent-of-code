local file = io.open("input_file.txt", "r")
local distance = 0
local firstList = {}
local secondList = {}

for line in file:lines() do 
    	local results = string.gmatch(line, "%S+")
	local parts = {}

	for part in results do
		table.insert(parts, part)
	end

	for i, part in pairs(parts) do
		if (i == 1) then 
			table.insert(firstList, part)
		else
			table.insert(secondList, part)
		end
	end
end

table.sort(firstList)
table.sort(secondList)

local countList = 1000

for i=1,countList do
	local difference = firstList[i] - secondList[i]
	if (difference < 0) then
		difference = difference * -1
	end
	distance = distance + difference
end

print(distance)

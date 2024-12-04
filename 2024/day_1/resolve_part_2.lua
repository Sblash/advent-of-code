local file = io.open("input_file.txt", "r")
local similarity = 0
local firstList = {}
local secondList = {}

if file == nil then os.exit() end

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

local countList = #firstList
local occurrences = {}

for i=1,countList do
	local currNum = firstList[i]
	local count = 0
	for j=1,countList do
		if (currNum == secondList[j]) then
			count = count + 1
		end
	end
	occurrences[currNum] = count
end

for k,v in pairs(occurrences) do
	similarity = similarity + (k * v)
end

print(similarity)

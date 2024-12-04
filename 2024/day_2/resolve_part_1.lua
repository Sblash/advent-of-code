function IsTableIncrementing(differences)
        for i=1, #differences-1 do
                if (tonumber(differences[i+1]) < tonumber(differences[i])) then return false end
        end
        return true
end

function IsTableDecrementing(differences)
        for i=1, #differences-1 do
                if (tonumber(differences[i]) < tonumber(differences[i+1])) then return false end
        end
        return true
end

function IsValueDifferenceBetween(reportValues, minValue, maxValue)
        for i=1, #reportValues-1 do
                local difference = reportValues[i] - reportValues[i+1]
                if (difference < 0) then difference = difference * -1 end
                if (difference > maxValue or difference < minValue) then
			return false
                end
        end
	return true
end

function Split(str, delimiter)
        local results = string.gmatch(str, delimiter)
        local resultsTable = {}
        for result in results do
                table.insert(resultsTable, result)
        end
        return resultsTable
end

function ImplodeTable(values)
	local str = ""
	for k,el in pairs(values) do
		str = str.." "..el
	end
	return str
end

local file = io.open("input_file.txt", "r")
local countSafeReport = 0

if file == nil then os.exit() end

for line in file:lines() do
	local reportValues = Split(line, "%S+")
	print('Analyzing report: '..ImplodeTable(reportValues))
	local isValueDifferenceInRange = IsValueDifferenceBetween(reportValues, 1, 3)
	print('	Levels difference in range: '..tostring(isValueDifferenceInRange))
	print('	Levels are increasing: '..tostring(IsTableIncrementing(reportValues)))
	print('	Levels are decreasing: '..tostring(IsTableDecrementing(reportValues)))
	local isIncrementingOrDecrementing = IsTableIncrementing(reportValues) or IsTableDecrementing(reportValues)

	local isCandidateSafe = isValueDifferenceInRange and isIncrementingOrDecrementing
	if (isCandidateSafe) then
		print('safe: '..ImplodeTable(reportValues))
		countSafeReport = countSafeReport + 1
	else
		print('unsafe: '..ImplodeTable(reportValues))
	end
	print()
end

print("Total safe reports: "..countSafeReport)

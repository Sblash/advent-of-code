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

function SearchForSortChangesToRemove(reportValues)
	local results = {}
	results['increment']['count'] = 0
	results['increment']['values'] = {}
	results['decrement']['count'] = 0
	results['decrement']['values'] ={}
	results['nothing']['count'] = 0
	results['nothing']['values'] = {}

	for i=1, #reportValues-1 do
		local key = reportValues[i].."_"..reportValues[i+1]
        	if (tonumber(reportValues[i]) < tonumber(reportValues[i+1])) then
			table.insert(results['increment']['values'], key)
			results["increment"]['count'] = results["increment"]['count'] + 1
		elseif (tonumber(reportValues[i]) > tonumber(reportValues[i+1])) then
			table.insert(results['increment']['values'], key)
			results["decrement"]['count'] = results["decrement"]['count'] + 1
		else
			table.insert(results['increment']['values'], key)
			results["nothing"]['count'] = results["nothing"]['count'] + 1
		end
        end

	for k,v in pairs(results) do
		print("	"..k..": "..tostring(v))
	end

	if (results['nothing']['count'] > 0) then
		return Split(results['nothing']['values'][1], "_")[1]
	end

	if (results['increment']['count'] > 0 and results['decrement']['count'] > 0) then
		if (results['increment']['count'] < results['decrement']['count']) then 
			return Split(results['increment']['values'][1], '_')[1]
		else
			return Split(results['decrement']['values'][1], '_')[1]
		end
	end

        return nil
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
		print('candidate unsafe: '..ImplodeTable(reportValues)..' Trying to fix it...')
		print('Analyzing for sort changes...')
		local sortChanges = SearchForSortChangesToRemove(reportValues)
		--local differenceLevelToRemove = 
		if (sortChanges ~= nil) then
			--print('unsafe: there are more than 1 sort change, can\t fix it.')
		--else
			print('Found 1 sort change, applying the Problem Dampener...')
		elseif (true) then
		
		else
			print('unsafe')
		end
	end
	print()
	print()
end

print("Total safe reports: "..countSafeReport)

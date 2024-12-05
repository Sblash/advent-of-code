-- it's not working, wasted time
-- start functions
function IsTableIncrementing(differences)
	for i = 1, #differences - 1 do
		if (tonumber(differences[i + 1]) <= tonumber(differences[i])) then return false end
	end
	return true
end

function IsTableDecrementing(differences)
	for i = 1, #differences - 1 do
		if (tonumber(differences[i]) <= tonumber(differences[i + 1])) then return false end
	end
	return true
end

function IsValueDifferenceBetween(reportValues, minValue, maxValue)
	for i = 1, #reportValues - 1 do
		local difference = reportValues[i] - reportValues[i + 1]
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
	for k, el in pairs(values) do
		str = str .. " " .. el
	end
	return str
end

function SearchForSortChangesToRemove(reportValues)
	local results = {}
	results['increment'] = {}
	results['decrement'] = {}
	results['nothing'] = {}
	results['increment']['count'] = 0
	results['increment']['values'] = {}
	results['decrement']['count'] = 0
	results['decrement']['values'] = {}
	results['nothing']['count'] = 0
	results['nothing']['values'] = {}

	for i = 1, #reportValues - 1 do
		local key = reportValues[i] .. "_" .. reportValues[i + 1]
		local indexes = i .. "_" .. i + 1
		if (tonumber(reportValues[i]) < tonumber(reportValues[i + 1])) then
			table.insert(results['increment']['values'], key)
			table.insert(results['increment']['values'], indexes)
			results["increment"]['count'] = results["increment"]['count'] + 1
		elseif (tonumber(reportValues[i]) > tonumber(reportValues[i + 1])) then
			table.insert(results['decrement']['values'], key)
			table.insert(results['decrement']['values'], indexes)
			results["decrement"]['count'] = results["decrement"]['count'] + 1
		else
			table.insert(results['nothing']['values'], key)
			table.insert(results['nothing']['values'], indexes)
			results["nothing"]['count'] = results["nothing"]['count'] + 1
		end
	end

	print('	increment: ' .. tostring(results['increment']['count']))
	print('	increment: ' .. ImplodeTable(results['increment']['values']))
	print('	decrement: ' .. tostring(results['decrement']['count']))
	print('	decrement: ' .. ImplodeTable(results['decrement']['values']))
	print('	nothing: ' .. tostring(results['nothing']['count']))
	print('	nothing: ' .. ImplodeTable(results['nothing']['values']))

	if (results['nothing']['count'] > 0) then
		return Split(results['nothing']['values'][2], "([^_]+)")[1]
	end

	if (results['increment']['count'] > 0 and results['decrement']['count'] > 0) then
		if (results['increment']['count'] < results['decrement']['count']) then
			-- decrementing
			local values = Split(results['increment']['values'][1], '%S+')
			local indexes = Split(results['increment']['values'][2], '([^_]+)')
			for i = 1, #indexes do
				local testReport = ApplyProblemDampener(reportValues, indexes[i])
				if (IsTableDecrementing(testReport)) then
					return indexes[i]
				end
			end
		else
			-- incrementing
			local values = Split(results['decrement']['values'][1], '%S+')
			local indexes = Split(results['decrement']['values'][2], '([^_]+)')
			for i = 1, #indexes do
				local testReport = ApplyProblemDampener(reportValues, indexes[i])
				if (IsTableIncrementing(testReport)) then
					return indexes[i]
				end
			end
		end
	end

	return nil
end

function SearchForDiffLevelToRemove(reportValues, minValue, maxValue)
	for i = 1, #reportValues - 1 do
		local difference = reportValues[i] - reportValues[i + 1]
		if (difference < 0) then difference = difference * -1 end
		if (difference > maxValue or difference < minValue) then
			local indexes = {}
			table.insert(indexes, i)
			table.insert(indexes, i + 1)
			for z = 1, #indexes do
				local testReport = ApplyProblemDampener(reportValues, indexes[z])
				if (IsValueDifferenceBetween(testReport, minValue, maxValue)) then
					return indexes[z]
				end
			end
		end
	end
	return nil
end

function ApplyProblemDampener(reportValues, levelToRemoveIndex)
	local newReportValues = {}
	for i = 1, #reportValues do
		if (i ~= tonumber(levelToRemoveIndex)) then
			table.insert(newReportValues, reportValues[i])
		end
	end
	return newReportValues
end

-- end functions

local file = io.open("input_file.txt", "r")
local countSafeReport = 0

if file == nil then os.exit() end

for line in file:lines() do
	local reportValues = Split(line, "%S+")
	print('Analyzing report: ' .. ImplodeTable(reportValues))
	local isValueDifferenceInRange = IsValueDifferenceBetween(reportValues, 1, 3)
	print('	Levels difference in range: ' .. tostring(isValueDifferenceInRange))
	print('	Levels are increasing: ' .. tostring(IsTableIncrementing(reportValues)))
	print('	Levels are decreasing: ' .. tostring(IsTableDecrementing(reportValues)))
	local isIncrementingOrDecrementing = IsTableIncrementing(reportValues) or IsTableDecrementing(reportValues)

	local isCandidateSafe = isValueDifferenceInRange and isIncrementingOrDecrementing
	if (isCandidateSafe) then
		print('safe: ' .. ImplodeTable(reportValues))
		countSafeReport = countSafeReport + 1
	else
		print('candidate unsafe: ' .. ImplodeTable(reportValues) .. ' Trying to fix it...')
		print('Analyzing for sort changes...')
		local sortChanges = SearchForSortChangesToRemove(reportValues)
		print('Analyzing for level with difference too high...')
		local differenceLevelToRemove = SearchForDiffLevelToRemove(reportValues, 1, 3)

		if (sortChanges ~= nil) then
			print('Found 1 sort change, applying the Problem Dampener...')
			print('Removing level index: ' .. sortChanges)
			reportValues = ApplyProblemDampener(reportValues, sortChanges)
		elseif (differenceLevelToRemove ~= nil) then
			print('Found 1 level with difference too high, applying the Problem Dampener...')
			print('Removing level index: ' .. differenceLevelToRemove)
			reportValues = ApplyProblemDampener(reportValues, differenceLevelToRemove)
		end
		print('New report: ' .. ImplodeTable(reportValues))
		print('Reanalyzing report: ' .. ImplodeTable(reportValues))
		local isValueDifferenceInRange = IsValueDifferenceBetween(reportValues, 1, 3)
		print('	Levels difference in range: ' .. tostring(isValueDifferenceInRange))
		print('	Levels are increasing: ' .. tostring(IsTableIncrementing(reportValues)))
		print('	Levels are decreasing: ' .. tostring(IsTableDecrementing(reportValues)))
		local isIncrementingOrDecrementing = IsTableIncrementing(reportValues) or IsTableDecrementing(reportValues)

		local isCandidateSafe = isValueDifferenceInRange and isIncrementingOrDecrementing
		if (isCandidateSafe) then
			print('safe (fixed): ' .. ImplodeTable(reportValues))
			countSafeReport = countSafeReport + 1
		else
			print('unsafe: after the Problem Dampener was applied there still some errors, can\t fix it.')
		end
	end
	print()
	print()
end

print("Total safe reports: " .. countSafeReport)

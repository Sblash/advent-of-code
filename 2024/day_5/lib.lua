local lib = {}

function lib.split(str, pattern)
    local results = string.gmatch(str, pattern)
    local resultsTable = {}
    for result in results do
        table.insert(resultsTable, result)
    end
    return resultsTable
end

function lib.inTable(tbl, toSearch)
    if (tbl == nil) then return nil end
    for k, v in pairs(tbl) do
        if (v == toSearch) then return k end
    end
    return nil
end

function lib.implodeTable(values, separator)
	local str = ""
	for k,el in pairs(values) do
        if (k == 1) then 
            str = str .. el
        else
            str = str .. separator .. el
        end
		
	end
	return str
end

function lib.findMiddleNumber(pages)
    local half = math.ceil(#pages / 2)
    return pages[half]
end

return lib
xpcall(function() dofile("expansions/script/c20099999.lua") end,function() dofile("script/c20099999.lua") end)
if fusf then return end
fusf = { }
--------------------------------------"Support function"
function fusf.CutString(_str, _cut, _dis, _from)
	if type(_str) ~= "string" then Debug.Message(_from) end
	local _str = _str.._cut
	if _dis and _dis ~= "" then 
		for _,D in ipairs(fusf.CutString(_dis, _cut, nil, "CutString1")) do
			D = D.._cut
			_str = _str:gsub(D, "", 1)
		end
	end
	local list, index, ch = {}, 1, ""
	while index <= #_str do
		if _str:sub(index, index):match(_cut) then
			list[#list + 1] = ch
			ch = ""
		else
			_, index, ch = _str:find("^([^".._cut.."]+)", index)
		end
		index = index + 1
	end
	return list
end
function fusf.GetCardTable(c)
	local C = {}
	if aux.GetValueType(c) == "Effect" then
		C[1] = c:GetHandler()
	elseif aux.GetValueType(c) == "Card" then
		C[1] = c
	elseif aux.GetValueType(c) == "Group" then
		for i in aux.Next(c) do
			C[#C+1] = i
		end
	end
	return C 
end
function fusf.NotNil(_val)   --table or string
	if type(_val) == "table" or type(_val) == "string" then return #_val > 0 end
	return _val
end
function fusf.Get_Constant(_constable, _vals)
	-- string chk
	if type(_vals) ~= "string" then return _vals end
	-- find _constable
	local _res,_first = 0
	for i,_val in ipairs(fusf.CutString(_vals, "+", nil, "fusf.Get_Constant(".._constable.._vals..")")) do
		if i == 1 then _first = _val end
		_res = _res + (fusf.NotNil(_val) and fucs[_constable][_val:upper()] or 0)
	end
	return _res,_first
end
function fusf.Get_Code_Constant(_m, _val)
	-- EVENT_CUSTOM
	if type(_val) == "string" and _val:match("CUS") then
		local _res = 0
		for _,_var in ipairs(fusf.CutString(_val, "+", nil, "fuef:COD")) do
			if _var == "CUS" then 
				_res = _res + EVENT_CUSTOM 
			-- owner code
			elseif _var == "m" then 
				_res = _res + _m
			-- number
			elseif tonumber(_var) then 
				_res = _res + tonumber(_var)
			end
		end
		return _res
	end
	-- other event
	return fusf.Get_Constant("cod", _val)
end
function fusf.Get_Loc(_loc1, _loc2, _Debug_Message)
	-- nil chk
	if not fusf.NotNil({_loc1, _loc2}) then 
		Debug.Message(_Debug_Message)
		return nil
	end
	local _locs = {0, 0}
	-- _loc2 chk
	if _loc2 then _locs[2] = _loc2 end
	-- _loc1 string chk
	if type(_loc1) ~= "string" then 
		_locs[1] = _loc1 
		return table.unpack(_locs)
	end
	-- _loc1 is string and find fucs.ran
	local _res = 0
	for i,_loc in ipairs(fusf.CutString(_loc1, "+", nil, "fusf.Get_Loc")) do
		for j = 1,#_loc do
			_locs[i] = _locs[i] + fucs.ran[_loc:sub(j,j):upper()]
		end
	end
	return table.unpack(_locs)
end
function fusf.PostFix_Trans(str,val)
	local tTrans, tStack, index = { }, { }, 1
	while index <= #str do
		local ch = str:sub(index, index)
		if ch:match("%a") then
			_, index, ch = str:find("^([%a]+)", index)
			table.insert(tTrans, ch)
		elseif ch == "%" then
			local chk = table.remove(val, 1)
			if type(chk) == "boolean" then
				local b = chk
				chk = function() return b end
			end
			table.insert(tTrans, chk)
		elseif ch == "(" or ch == "~" then
			table.insert(tStack, ch)
		elseif ch == ")" then
			while #tStack > 0 and tStack[#tStack] ~= "(" do
				table.insert(tTrans, table.remove(tStack))
			end
			table.remove(tStack)
		elseif ch == "+" or ch == "-" then
			while #tStack > 0 and tStack[#tStack] ~= "(" do
				table.insert(tTrans, table.remove(tStack))
			end
			table.insert(tStack, ch)
		elseif ch == "/" then
			while #tStack > 0 and tStack[#tStack] == "/" do
				table.insert(tTrans, table.remove(tStack))
			end
			table.insert(tStack, ch)
		end
		if tStack[#tStack] == "~" and ch:match("^[%a%)%%]") then
			table.insert(tTrans, table.remove(tStack))
		end
		index = index + 1
	end
	while #tStack > 0 do
		table.insert(tTrans, table.remove(tStack))
	end
	return tTrans
end
function fusf.Value_Trans(...)
	local vals,var = {...},{ }
	for i,val in ipairs(vals) do
		if type(val) == "string" then
			for _,unit in ipairs(fusf.CutString(val,",",nil,"Value_Trans")) do
				table.insert(var, unit == "%" and table.remove(vals, i + 1) or unit == "" and { } or unit)
			end
		else
			table.insert(var, val or { })
		end
	end
	return var
end
function fusf.Check_Constant(func,chktable)
	return function(c,cons)
		if cons and type(cons) ~= "string" then return func(c,cons) end
		local Cons, tStack = fusf.PostFix_Trans(cons), { }
		local CalL, CalR
		for _,val in ipairs(Cons) do
			if val:match("[%-%~]") then
				tStack[#tStack] = not tStack[#tStack]
			elseif val:match("[%+%/]") then
				CalR = table.remove(tStack)
				CalL = table.remove(tStack)
				local tCal = {
					["+"] = CalL and CalR,
					["/"] = CalL or CalR
				}
				table.insert(tStack, tCal[val])
			else
				table.insert(tStack, func(c,chktable[val:upper()]))
			end
		end
		return tStack[#tStack]
	end
end
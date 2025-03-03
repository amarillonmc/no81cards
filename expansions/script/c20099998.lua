dofile("expansions/script/c20099999.lua")
if fusf then return end
fusf = { }
--------------------------------------"Support function"
function fusf.CutString(_str, _cut, _from)
	if type(_str) ~= "string" then Debug.Message("Invalid _str in CutString <- ".._from) end
	if type(_cut) ~= "string" or #_cut == 0 then Debug.Message("Invalid _cut in CutString <- ".._from) end
	local str, list, char = _str.._cut, {}, ""
	for unit in str:gmatch(".") do
		if unit == _cut then
			table.insert(list, char)
			char = ""
		else
			char = char..unit
		end
	end
	return list
end
function fusf.GetCardTable(_c)
	local cs, typ = { }, aux.GetValueType(_c)
	if typ == "Effect" then
		cs[1] = _c:GetHandler()
	elseif typ == "Card" then
		cs[1] = _c
	elseif typ == "Group" then
		for c in aux.Next(_c) do
			cs[#cs+1] = c
		end
	end
	return cs
end
function fusf.IsNil(...)
	local vals = {...}
	if #vals == 0 then return true end
	vals = #vals == 1 and vals[1] or vals
	if type(vals) == "string" then
		return vals == ""  -- 非空字串
	elseif type(vals) == "table" then
		return not next(vals)  -- 表有內容
	end
	return not vals
end
function fusf.NotNil(...)
	return not fusf.IsNil(...)
end
function fusf.Get_Constant(_constable, _vals)
	-- string chk
	if type(_vals) ~= "string" then return _vals end
	local _res = 0
	-- cod chk
	if _constable == "cod" then 
		-- EVENT_CUSTOM
		if _vals:match("CUS") then
			_vals = _vals:sub(5)
			-- owner code or number
			_res = EVENT_CUSTOM + fusf.M_chk(_vals)
		-- EVENT_PHASE or EVENT_PHASE_START
		elseif _vals:match("PH") then
			for _, _var in ipairs(fusf.CutString(_vals, "+", "Get_Constant_1")) do
				local _constable = _var:match("PH") and "cod" or "pha"
				_res = _res + fucs[_constable][_var]
			end
		end
		if _res ~= 0 then return _res end
	end
	-- find _constable
	local vals, cons, _des = fusf.CutString(_vals, "+", "Get_Constant_2"), fucs[_constable]
	for i = #vals, 1, -1 do
		local _val = vals[i]
		_des = fucs.des[_val] or _des
		_res = _res + cons[_val]
	end
	return _res, _des
end
function fusf.Get_Loc(_loc1, _loc2, _from)
	-- nil chk
	if not fusf.NotNil(_loc1, _loc2) then 
		Debug.Message(_from..", Get_Loc")
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
	for i,_loc in ipairs(fusf.CutString(_loc1, "+", "Get_Loc")) do
		for j = 1,#_loc do
			_locs[i] = _locs[i] + fucs.ran[_loc:sub(j,j):upper()]
		end
	end
	return table.unpack(_locs)
end
function fusf.M_chk(val) -- val : number|string
	val = tonumber(val)
	if val < 19999999 then return val + 20000000 end
	return val
end
function fusf.PostFix_Trans(_str, ...)
	local vals, res, temp, i = {...}, { }, { }, 1
	while i <= #_str do
		local ch = _str:sub(i, i)
		if ch:match("%a") then
			_, i, ch = _str:find("(%a+)", i)
			table.insert(res, ch)
		elseif ch == "%" then
			_, i, ch = _str:find("(%d+)", i)
			ch = vals[tonumber(ch)]
			if type(ch) == "boolean" then
				local b = ch
				ch = function() return b end
			end
			table.insert(res, ch)
		elseif ch == "(" or ch == "~" then
			table.insert(temp, ch)
		elseif ch == ")" then
			while #temp > 0 and temp[#temp] ~= "(" do
				table.insert(res, table.remove(temp))
			end
			table.remove(temp)
		elseif ch == "+" or ch == "-" then
			while #temp > 0 and temp[#temp] ~= "(" do
				table.insert(res, table.remove(temp))
			end
			table.insert(temp, ch)
		elseif ch == "/" then
			while #temp > 0 and temp[#temp] == "/" do
				table.insert(res, table.remove(temp))
			end
			table.insert(temp, ch)
		end
		if temp[#temp] == "~" and ch:match("^[%a%)%%]") then
			table.insert(res, table.remove(temp))
		end
		i = i + 1
	end
	while #temp > 0 do
		table.insert(res, table.remove(temp))
	end
	return res
end
function fusf.IsN(_func)
	return function(_c, _val, _exval)
		local c_val = Card[_func](_c, _exval)
		if type(_val) == "string" then
			local oper, _val = _val:match("%+%-"), _val:match("%d+")
			_val = tonumber(_val)
			if oper == "+" then 
				return c_val >= _val
			elseif oper == "-" then 
				return c_val <= _val			 
			end
			return c_val == _val	
		end
		if _val > 0 then return c_val == _val end
		return c_val <= -_val -- _val = -n
	end
end
function fusf.Is_Cons(_func, _key, _cal)
	_cal = _cal or function(card_val, val) return card_val & val == val end
	return function(c, _cons)
		if type(_cons) ~= "string" then return _cal(Card[_func](c), _cons) end
		local res, valL, valR = { }
		for _, val in ipairs(fusf.PostFix_Trans(_cons)) do
			if val:match("[%-%~]") then
				res[#res] = not res[#res]
			elseif val:match("[%+%/]") then
				valR = table.remove(res)
				valL = table.remove(res)
				local Cal = {
					["+"] = valL and valR,
					["/"] = valL or valR
				}
				table.insert(res, Cal[val])
			else
				table.insert(res, _cal(Card[_func](c), fucs[_key][val:upper()]))
			end
		end
		return res[#res]
	end
end
function fusf.Get_Func(_c, _func, _val)
	if type(_func) ~= "string" then return _func end
	local lib = _c.lib or {}
	local res = function(_func) return _func end
	if _func:match("~") then
		_func = _func:sub(2)
		res = function(_func) return function(...) return not _func(...) end end
	end
	-- find cm, lib, fuef, aux
	if not _val then 
		return res(_c[_func] or lib[_func] or fuef[_func] or aux[_func])
	end
	-- translate vals 
	for i, val in ipairs(_val) do
		_val[i] = tonumber(val) or val
	end
	-- find cm, lib, fuef, aux
	for _, Lib in ipairs({_c, lib, fuef, aux}) do
		if Lib[_func] then return res(Lib[_func](table.unpack(_val))) end
	end
	Debug.Message("Get_Func not found : ".._func)
	return nil
end
function fusf.Val_Cuts(_val, ...) -- "f1,f2(v1,v2),(v3)" -> {"f1", {"f2", "v1", "v2"}, {"v3"}}, ... use in vi = %i
	local res, res_ind, temp = { }, 0, { }
	--local place, f_chk, f_temp, sets = 1, 0, "", { }
	for _, val in ipairs(fusf.CutString(_val, ",", "Val_Cuts_1")) do
		res_ind = res_ind + 1
		local is_st = val:match("%(")
		local is_ed = val:match("%)")
		-- is f(v1)
		if is_st and is_ed then -- f(v1) -> {"f", "v1"}
			res[res_ind] = fusf.Val_Cuts_Table_Process(val, ...)
		elseif is_st then -- f(v1,v2,v3) st f(v1
			temp, res_ind = val, res_ind - 1
		elseif is_ed then -- f(v1,v2,v3) ed v3) -> {"f", "v1", "v2", "v3"}
			res[res_ind] = fusf.Val_Cuts_Table_Process(temp..","..val, ...)
			temp = ""
		elseif #temp > 0 then -- f(v1,v2,v3) mid v2
			temp, res_ind = temp..","..val, res_ind - 1
		elseif val:match("%%") then
			res[res_ind] = ({...})[tonumber(val:sub(2))]
		elseif val ~= "" then
			res[res_ind] = val
		end
	end
	res.len = res_ind
	return res
end
function fusf.Val_Cuts_Table_Process(_str, ...) -- "f(%1,,3)" -> {"f", vals[1], nil, "3"}
	local vals, res, st = {...}, { }, _str:find("%(")
	if st ~= 1 then res[1] = _str:sub(1, st - 1) end -- has f
	if st + 1 == #_str then return res end -- "f()" -> {"f"}
	_str = _str:sub(st + 1, #_str - 1)
	local res_ind = #res
	for _, val in ipairs(fusf.CutString(_str, ",", "Val_Cuts_Table_Process")) do
		res_ind = res_ind + 1
		if val:match("%%") then
			res[res_ind] = vals[tonumber(val:sub(2))]
		elseif val ~= "" then
			res[res_ind] = val
		end
	end
	res.len = res_ind
	return res
end
function fusf.Creat_CF(_func, _val, ...)
	if not _func then return function(c) return true end end
	-- trans _val 
	if type(_val) ~= "table" then _val = { _val } end
	local temp_val, v_ind = { }, 0
	for _, f_val in ipairs(_val) do
		if type(f_val) == "string" then
			for _, val in fusf.ForTable(fusf.Val_Cuts(f_val, ...)) do
				v_ind = v_ind + 1
				temp_val[v_ind] = val
			end
		else
			v_ind = v_ind + 1
			temp_val[v_ind] = f_val
		end
	end
	_val, temp_val = temp_val
	-- _func is function
	if type(_func) == "function" then 
		return function(c) 
			return _func(c, table.unpack(_val, 1, v_ind))
		end 
	end 
	-- _func is string
	_func = fusf.PostFix_Trans(_func, ...)
	local fucf, Card, aux = fucf, Card, aux
	if #_func == 1 then -- _func just one
		_func = fucf[_func[1] ] or Card[_func[1] ] or aux[_func[1] ]
		return function(c) 
			return _func(c, table.unpack(_val, 1, v_ind))
		end 
	end
	-- _func is multi
	return function(c)
		local stack, v_ind, temp_val = { }, 1
		for _, func in ipairs(_func) do
			if func == "~" then
				stack[#stack] = not stack[#stack]
			elseif type(func) == "string" and #func == 1 then
				local valR, valL = table.remove(stack), table.remove(stack)
				local Cal = {
					["+"] = valL and valR,
					["-"] = valL and not valR,
					["/"] = valL or valR 
				}
				stack[#stack + 1] = Cal[func]
			else
				if type(func) == "string" then 
					func = fucf[func] or Card[func] or aux[func]
				end
				temp_val, v_ind = _val[v_ind], v_ind + 1
				if type(temp_val) ~= "table" then temp_val = {temp_val, len = 1} end
				stack[#stack + 1] = func(c, table.unpack(temp_val, 1, temp_val.len))
			end
		end
		return table.remove(stack)
	end
end
function fusf.Creat_GF(_func, _val, ...)
	local ex_val = {...}
	return function(g, n)
		g = g:Filter(fusf.Creat_CF(_func, _val, table.unpack(ex_val)), nil)
		if not n then return g end
		return n > 0 and #g >= n or #g <= -n
	end
end
function fusf.ForTable(t, n)
	local i, max = 0, t.len or n
	return function()
		if i >= max then return nil end
		i = i + 1
		return i, t[i]
	end
end
function fusf.GetDES(_code, _id, m) -- (0), ("n"), (m), ("+1")
	if _id then
		if type(_code) == "number" then
			_code = fusf.M_chk(_code)
		else	-- ("-1", 0)
			_code = m + tonumber(_code)
		end
	elseif type(_code) == "number" then
		if _code < 17 then  -- in cdb and code is owner card code
			_code, _id = m, _code
		else
			_code, _id = fusf.M_chk(_code), 0
		end
	elseif type(_code) == "string" then
		if tonumber(_code) then -- code = m +- _code
			_code, _id = m + tonumber(_code), 0
		else	-- in fucs.des
			_code, _id = 0,  fucs.des[_code]
		end
	end
	return aux.Stringid(_code, _id)  -- _code*16 + _id
end
function fusf.GetRES(_flag, _count) -- _flag = a + b/b1/b2 + c | 1 
	if type(_flag) ~= "string" then return {_flag or 0, _count} end
	if not _count then -- cut count
		_flag = fusf.CutString(_flag, "|", "RES")
		_flag, _count = _flag[1], tonumber(_flag[2] or 1)
	end
	local stack = { }
	for _, unit in ipairs(fusf.PostFix_Trans(_flag)) do
		if unit:match("[+-/]") then
			local valR, valL = table.remove(stack), table.remove(stack)
			table.insert(stack, unit == "-" and valL - valR or valL | valR)
		else
			table.insert(stack, fucs.res[unit] or fucs.pha[unit])
		end
	end
	_flag = table.remove(stack)
	if _flag & 0xfff0000 > 0 then _flag = _flag | RESET_EVENT end
	if _flag & 0x00003ff > 0 then _flag = _flag | RESET_PHASE end
	return {_flag, _count}
end
--------------------------------------"Other Support function"
function fusf.RegFlag(val, cod, res, pro, lab, des) -- val : Card|Effect|player(number)
	cod, res, pro = fusf.M_chk(cod), fusf.GetRES(res), fusf.Get_Constant("pro", pro) or 0
	if des then des, pro = fusf.GetDES(des, nil, cod), (pro or 0)|EFFECT_FLAG_CLIENT_HINT end
	local typ = aux.GetValueType(val)
	if typ == "Card" then 
		val:RegisterFlagEffect(cod, res[1], pro, res[2] or 1, lab or 0, des)
	elseif typ == "Effect" then 
		val:GetHandler():RegisterFlagEffect(cod, res[1], pro, res[2] or 1, lab or 0, des)
	else
		Duel.RegisterFlagEffect(val, cod, res[1], pro, res[2] or 1, lab or 0)
	end
end
function fusf.GetFlag(val, cod) -- val : Card|Effect|player(number)
	cod = fusf.M_chk(cod)
	local typ = aux.GetValueType(val)
	if typ == "Card" then 
		return val:GetFlagEffect(cod)
	elseif typ == "Effect" then 
		return val:GetHandler():GetFlagEffect(cod)
	end
	return Duel.GetFlagEffect(val, cod)
end
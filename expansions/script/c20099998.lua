if fusf then return end
dofile("expansions/script/c20099999.lua")
fusf = {}
fudf = {}
fudf.__index = fudf
--------------------------------------"Debug function"
--- 若处于调试模式则输出函数调用信息和参数
-- @param log fudf|fuef|number log 实例/fuef 实例/层级数字
-- @param name string 函数名称
-- @param ... any 参数列表
-- @return fudf log 实例
function fudf.StartLog(log, name, ...)
	if not fuef.DebugMode then return fudf end
	local typ = fusf.CheckArgType("StartLog", 1, log, "number/fudf/fuef")
	fusf.CheckArgType("StartLog", 2, name, "string")

	local lv
	if typ == "number" then
		lv = log
	elseif typ == "fuef" then
		lv = log.isinit and 2 or 0
	else
		lv = log.depth
	end
	local indent = ("\t"):rep(lv)

	local arg_str = ""
	local args = {...}
	local len = select("#", ...)
	if len > 0 then
		local out = {}
		for i = 1, len do
			local val = args[i]
			local typ = type(val)
			if typ == "userdata" then
				typ = fusf.Type(val)
			elseif typ == "number" or typ == "boolean" then
				typ = tostring(val)
			elseif typ == "string" then
				typ = '"'..val..'"'
			end
			table.insert(out, typ)
		end
		arg_str = table.concat(out, ", ")
	end

	Debug.Message(("\t%s[CALL] : %s(%s)"):format(indent, name, arg_str))
	return setmetatable({ depth = lv + 1 }, fudf)
end

--- 若处于调试模式则印出 msg
-- @param msg any 调试信息
function fudf:Info(msg)
	if not fuef.DebugMode then return end
	local indent = ("\t"):rep(self.depth)
	Debug.Message("\t"..indent.."[INFO] : "..msg)
end

--- 若处于调试模式则印出 msg
-- @param msg any 调试信息
function fusf.Info(msg)
	if not fuef.DebugMode then return end
	Debug.Message("\t[INFO] : "..msg)
end

--------------------------------------"String function"
--- 将字串以指定字元切割，保留空字串片段
-- @param cut string 分隔符，预设为逗号 ","
-- @return table 字串片段阵列，连续分隔符中间的空字串也会被保留
-- @raise 当 self 或 cut 非字串型态时抛出错误
function string:Cut(cut)
	cut = cut or ","
	if type(cut) ~= "string" then 
		error("Cut : param 1 should be string, got "..type(cut), 2)
	end
	local res, part = {}, ""
	for char in (self .. cut):gmatch(".") do
		if char == cut then
			table.insert(res, part)
			part = ""
		else
			part = part .. char
		end
	end
	return res
end

--- 返回一个迭代器，遍历按指定分隔符切割后的字符串片段
-- @param cut string 分隔符，默认值为逗号 ","
-- @return function 迭代函数，每次调用返回当前索引和对应的字符串片段
-- @usage
-- for i, s in ("a,b,,c"):ForCut(",") do
--   print(i, s)
-- end
function string:ForCut(cut)
	local list = self:Cut(cut)
	local ind, max = 0, #list
	return function()
		if ind >= max then return nil end
		ind = ind + 1
		return ind, list[ind]
	end
end

--------------------------------------"Error function"
--- 检查 from 函数的参数是否为空，若为空则报错
-- @param from string 呼叫来源，用于错误提示
-- @param ... any 任意数量的参数
-- @raise 若参数皆为空，则触发错误，提示呼叫位置
function fusf.CheckEmptyArgs(from, ...)
	if not fusf.IsEmpty(...) then return end
	error(from.." : Argument cannot be empty", 3)
end

--- 检查 from 函数的第 i 个参数 val 的类型是否为 typs，否则报错
-- @param from string 呼叫来源，用于错误提示
-- @param i number 参数位置（从 1 开始）
-- @param val any 要检查的值
-- @param typs string 允许的类型，类型名以 `/` 分隔（如 "string/number"）
-- @return string, any 若匹配，返回其匹配的类型及原值
-- @raise 若类型不符，报错并显示位置与类型资讯
function fusf.CheckArgType(from, i, val, typs)
	local is_typ, typ = pcall(fusf.CheckTypes, val, typs)
	if is_typ then return typ, val end
	local err_msg = "%s : param %d should be %s, got %s"
	err_msg = err_msg:format(from, i, typs, fusf.Type(val))
	error(err_msg, 3)
end

--------------------------------------"Support function"
--- 更精确地取得物件的类型名称，支援 Card/Effect/Group/fuef 等
-- @param val 任意值
-- @return string 自定义类型名称或 Lua 原生类型名称
function fusf.Type(val)
	local typ = type(val)
	if typ == "userdata" then
		return aux.GetValueType(val)
	elseif typ == "table" then
		local metatable = getmetatable(val)
		if metatable == fuef then
			return "fuef"
		elseif metatable == fudf then
			return "fudf"
		end
	end
	return typ
end

--- 验证 val 的类型是否为 typ，若为 "player" 类型则进一步检查值是否合法（0 或 1）
-- @param val any 欲检查的值
-- @param typ string 预期的类型名称（如 "Card", "string", "number", "player" 等）
-- @return any 若类型正确，返回原值
-- @raise 若类型不符，会根据 arg_ind 抛出更明确的错误（包含参数编号）
function fusf.CheckType(val, typ)
	if type(typ) ~= "string" then
		error(("param %d should be %s, got %s"):format(2, "string", type(typ)), 2)
	end
	if typ == "player" then
		if val == 0 or val == 1 then
			return val
		else
			error("invalid player index '"..val.."' (expected 0 or 1)", 3)
		end
	end
	local val_type = fusf.Type(val)
	if val_type == typ then return val end
	error(("should be %s, got %s"):format(typ, val_type), 3)
end

--- 验证 val 的 type 是否在 typs 内（以 "/" 分隔）
-- @param val any 欲检查的值
-- @param typs string 多个类型名称组成的字符串，如 "number/string"
-- @return string, any 若匹配，返回其匹配的类型及原值
-- @raise 若不符合任何类型，会抛出详细错误信息
function fusf.CheckTypes(val, typs)
	typs = fusf.CheckType(typs, "string")
	local val_type = fusf.Type(val)
	for _, typ in typs:ForCut("/") do
		if pcall(fusf.CheckType, val, typ) then return typ, val end
	end
	error(("should be %s, got %s"):format(typs, val_type), 3)
end

--- 从 fucs 下指定子表中查找常量值，或返回整个表
-- @param table_key string 欲查找的子表名称（如 "cod"）
-- @param key? string   欲查找的键名称（可省略，省略时返回整个子表）
-- @return any   找到的值或整个子表
-- @raise 若子表不存在、键无效，则报错
function fusf.Findfucs(table_key, key)
	fusf.CheckArgType("Findfucs", 1, table_key, "string")
	local const_table = fusf.CheckType(fucs[table_key], "table")
	if not key then return const_table end
	return fusf.FindTables(key, const_table)
end

--- 在多个表中依序查找键值
-- @param key string 欲查找的键名称
-- @param ... table 可变参数，每个都是待查找的表格
-- @return any 若找到键，返回对应的值；否则抛出错误
function fusf.FindTables(key, ...)
	fusf.CheckArgType("FindTables", 1, key, "string")
	for i, tab in ipairs{ ... } do
		fusf.CheckArgType("FindTables", i + 1, tab, "table")
		if tab[key] then return tab[key] end
	end
	error("unknown constant key '"..key.."' in table", 2)
end

--- 将 val 转为对应的 Group
-- @param val Card|Effect|Group 欲处理的对象
-- @param is_owner  boolean 若为 Effect 时，是否取其 owner 而非 handler
-- @return Group 对应的 Group
-- @raise 若类型非 Card/Effect/Group，则抛出错误
function fusf.ToGroup(val, is_owner)
	local typ = fusf.CheckArgType("ToGroup", 1, val, "Card/Effect/Group")
	if typ == "Effect" then
		return Group.FromCards(is_owner and val:GetOwner() or val:GetHandler())
	elseif typ == "Card" then
		return Group.FromCards(val)
	end
	return val -- typ == "Group"
end

--- 将 val 转为对应的卡片组 table
-- @param val Card|Effect|Group 欲处理的对象
-- @return table 对应的 table
-- @raise 若无法转换为非空 Group，则抛出错误
function fusf.ToGroupTable(val)
	local g = fusf.ToGroup(val)
	if #g == 0 then
		error("ToGroup(" .. fusf.Type(val) .. ") is empty Group", 2)
	end
	local tab = {}
	for c in aux.Next(g) do
		table.insert(tab, c)
	end
	return tab
end

--- 将 val 转为对应的 Card
-- @param val Card|Effect|Group 欲处理的对象
-- @param is_owner  boolean 若为 Effect 时，是否取其 owner 而非 handler
-- @return Card 对应的 Card
-- @raise 若无法转换为非空 Group，则抛出错误
function fusf.ToCard(val, is_owner)
	local c = fusf.ToGroup(val, is_owner):GetFirst()
	if c then return c end
	error("ToGroup(" .. fusf.Type(val) .. ") is empty Group", 2)
end

--- 判断传入值是否为 nil, "", {}
-- @param ... 任意数量的参数
-- @return boolean 是否为 nil, "", {}
function fusf.IsEmpty(...)
	local vals = { ... }
	if select("#", ...) == 0 then return true end
	vals = #vals == 1 and vals[1] or vals
	if type(vals) == "string" then
		return vals == ""
	elseif type(vals) == "table" then
		return next(vals) == nil
	end
	return vals == nil
end

--- 根据 val 取得其对应的全局 cm 表
-- @param val Card|Effect|Group|fuef
-- @return table 对应的 cm 表
-- @raise 若无法取得卡片对象则抛出错误
function fusf.Getcm(val)
	local typ = fusf.CheckArgType("Getcm", 1, val, "Card/Effect/Group/fuef")
	local c
	if typ == "fuef" then
		c = fusf.CheckType(val.e, "Effect"):GetOwner()
	else
		c = fusf.ToCard(val, true)
	end
	return fusf.CheckType(_G["c" .. c:GetCode()], "table")
end

--- 规范化卡号，若小于 1000，则加上 base (20000000)
-- @param id number|string
-- @param base number 可选，若卡号 < 1000，将加上此值（默认 20000000）
-- @return number 规范化后的卡号
-- @raise 若 id 无法转为数字，或 base 非数字，将抛出错误
function fusf.NormalizeID(id, base)
	id = tonumber(id)
	fusf.CheckArgType("NormalizeID", 1, id, "number")
	fusf.CheckArgType("NormalizeID", 2, base, "nil/number")
	base = base or 20000000
	return id < 1000 and id + base or id
end

--- 解析 val 并回传一个对应的卡号 table
-- @param val any 可以是 Group、Card、Effect、number、string（用 + 分隔的代码）、table 等
-- @return table<number> 包含标准化过的卡号 table
function fusf.GetCodeTable(val)
	local result = {}
	local to_g, g = pcall(fusf.ToGroup, val)
	if to_g then
		for gc in aux.Next(g) do
			for _, cod in ipairs{ gc:GetCode() } do
				table.insert(result, cod)
			end
		end
		return result
	end

	local code_table = {}
	local typ = fusf.CheckTypes(val, "number/string/table")
	if typ == "number" then
		code_table = { val }
	elseif typ == "string" then
		code_table = val:Cut("+")
	elseif typ == "table" then
		code_table = val
	end
	for _, cod in ipairs(code_table) do
		table.insert(result, fusf.NormalizeID(cod))
	end
	if #result > 0 then return result end
	error("GetCodeTable : get empty table", 3)
end

--- 将整数转换为 16 进制 string 表示（以 ", " 或指定符号连接）
-- @param val number|string 欲转换的数值，若为字串则直接返回
-- @return string 分解后的 16 进制表示，如 "0x1, 0x2, 0x8"
-- @raise 当参数类型不符时抛出错误
function fusf.CutHex(val)
	local typ = fusf.CheckArgType("CutHex", 1, val, "string/number")
	if typ == "string" then return val end

	local parts, bit = {}, 1
	while val > 0 do
		if val % 2 == 1 then
			table.insert(parts, 1, string.format("0x%X", bit))
		end
		val = math.floor(val / 2)
		bit = bit * 2
	end
	return table.concat(parts, ", ")
end

--- 转换成前后两个区域后传回(self_loc包含两个区域时以+分开)
-- @param self_loc string|number 自己的区域表示，可为形如 "HM+M" 的字串，或直接为数值
-- @param oppo_loc number|nil 对方的区域数值
-- @return number, number 自己和对方的区域值
-- @raise 当 self_loc 和 oppo_loc 同时为空时抛出错误
-- @raise 当 oppo_loc 非 number or nil 时抛出错误
-- @raise 当 self_loc 字符无法在 fucs.ran 中找到对应值时抛出错误
function fusf.GetLoc(self_loc, oppo_loc)
	fusf.CheckEmptyArgs("GetLoc", self_loc, oppo_loc)
	local typ = fusf.CheckArgType("GetLoc", 1, self_loc, "string/number")
	fusf.CheckArgType("GetLoc", 2, oppo_loc, "nil/number")

	local loc_list = { 0, 0 }
	if oppo_loc then
		loc_list[2] = oppo_loc
	end

	if typ == "number" then
		loc_list[1] = self_loc
		return table.unpack(loc_list)
	end
	for i, locs in self_loc:ForCut("+") do
		for j = 1, #locs do
			local ch = locs:sub(j, j):upper()
			loc_list[i] = loc_list[i] + fusf.Findfucs("ran", ch)
		end
	end
	return table.unpack(loc_list)
end

--- 将带变量占位符的中缀表达式转换成后缀表达式（逆波兰表达式）
-- 支持字母变量、占位符 %n 替换参数、括号以及 + - / ~ 运算符
-- @param expr string 形如 "A+(B-%1)/C" 的表达式字符串
-- @param ... 传入参数，用于替换表达式中的 %n 占位符（n为数字）
-- @return table 后缀表达式数组，元素为字符串或函数
function fusf.InfixToPostfix(expr, ...)
	fusf.CheckArgType("InfixToPostfix", 1, expr, "string")
	if expr == "" then error("InfixToPostfix : param 1 is invalid param", 2) end

	local args, res, temp, i = { ... }, {}, {}, 1
	while i <= #expr do
		local ch = expr:sub(i, i)
		if ch:match("%a") then
			_, i, ch = expr:find("(%a+)", i)
			table.insert(res, ch)
		elseif ch == "%" then
			_, i, ch = expr:find("(%d+)", i)
			if not ch then
				error("'%' must be followed by a number at position : " .. expr, 2)
			end
			local val = args[tonumber(ch)]
			if val == nil then
				error("argument %" .. ch .. " is nil", 2)
			elseif type(val) == "boolean" then
				local b = val
				val = function() return b end
			end
			table.insert(res, val)
		elseif ch == "(" or ch == "~" then
			table.insert(temp, ch)
		elseif ch == ")" then
			local found_left_paren = false
			while #temp > 0 do
				local op = table.remove(temp)
				if op == "(" then
					found_left_paren = true
					break
				else
					table.insert(res, op)
				end
			end
			if not found_left_paren then
				error("unexpected symbol near ')' : " .. expr, 2)
			end
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
		else
			error("unexpected character '" .. ch .. "' : " .. expr, 2)
		end
		if temp[#temp] == "~" and ch:match("^[%a%)%%]") then
			table.insert(res, table.remove(temp))
		end
		i = i + 1
	end
	while #temp > 0 do
		local op = table.remove(temp)
		if op == "(" then
			error("expected ')' to close '(' : " .. expr, 2)
		end
		table.insert(res, op)
	end
	return res
end

--- 构造一个用于判断卡片某个数值大小关系的函数
-- @param getter string Card 的函数名，如 "GetLevel"
-- @return function(c, target, ...) -> boolean
function fusf.MakeValCheck(getter)
	local card_func = fusf.CheckType(Card[getter], "function")
	local from = "MakeValCheck("..getter

	return function(c, target, ...)
		fusf.CheckArgType(from, 1, c, "Card")
		local typ = fusf.CheckArgType(from, 2, target, "number/string")
		local card_val = fusf.CheckType(card_func(c, ...), "number")

		if typ == "number" then
			return target > 0 and card_val == target or card_val <= -target
		end

		local oper = target:match("[%+%-]")
		local num = tonumber(target:match("%d+"))
		if oper == "+" then
			return card_val >= num
		elseif oper == "-" then
			return card_val <= num
		end
		return card_val == num
	end
end

--- 构造一个用于判断卡片某个数值是否符合常量条件的函数
-- @param getter string 要呼叫的 Card 方法名称，例如 "GetType"
-- @param table_key string 常量表名称，如 "cod"、"pha"（会传给 fusf.FindTables）
-- @param cal_type string? 校验类型（"&" 代表包含、"|" 代表允许并集），预设为 "|"
-- @return function(card: Card, value: string|number): boolean 回传是否符合条件
function fusf.MakeConsCheck(getter, table_key, cal_type)
	local card_func = fusf.CheckType(Card[getter], "function")
	local const_table = fusf.Findfucs(table_key)

	cal_type = cal_type or "|"
	local cal_func
	if cal_type == "&" then
		cal_func = function(c, target) return card_func(c) & target == target end
	elseif cal_type == "|" then
		cal_func = function(c, target) return card_func(c) | target == target end
	end

	return function(c, target)
		local from = "MakeConsCheck("..getter
		fusf.CheckArgType(from, 1, c, "Card")
		local typ = fusf.CheckArgType(from, 2, target, "number/string")

		if typ == "number" then return cal_func(c, target) end

		local stack = {}
		for _, val in ipairs(fusf.InfixToPostfix(target)) do
			if val:match("[%-%~]") then
				stack[#stack] = not stack[#stack]
			elseif val:match("[%+%/]") then
				local valR, valL = table.remove(stack), table.remove(stack)
				local Cal = {
					["+"] = valL and valR,
					["/"] = valL or valR
				}
				table.insert(stack, Cal[val])
			else
				local temp = fusf.FindTables(val:upper(), const_table)
				table.insert(stack, cal_func(c, temp))
			end
		end
		return stack[#stack]
	end
end

--- 从常量表找寻对应 keys 合计值
-- @param table_key string 常量表名称，如 "cod", "pha"
-- @param keys number|string 欲解析的常量名，多个以 "+" 连接
-- @return number 合并的常量值, 可选返回常量描述
-- @raise 当参数类型错误或无法找到对应常量时抛出错误
function fusf.ParseConstantKey(table_key, keys)
	local typ = fusf.CheckArgType("ParseConstantKey", 2, keys, "number/string")
	if typ == "number" then return keys end

	if keys == "" then error("ParseConstantKey : param 2 is invalid param", 2) end

	local keys_list, res = keys:Cut("+"), 0
	-- is special keys in cod table
	if table_key == "cod" then
		if keys_list[1] == "CUS" then
			res = EVENT_CUSTOM + fusf.NormalizeID(keys_list[2])
			-- EVENT_PHASE or EVENT_PHASE_START + PHASE_
		elseif keys_list[1]:match("PH") then
			for _, key in ipairs(keys_list) do
				res = res + fusf.FindTables(key, fucs.cod, fucs.pha)
			end
		end
		if res > 0 then return res end
	end
	-- find table_key
	local const_table = fusf.Findfucs(table_key)
	local des
	for i = #keys_list, 1, -1 do
		local key = keys_list[i]
		res = res + fusf.FindTables(key, const_table)
		des = fucs.des[key] or des
	end
	return res, des
end

--- 查找并解析函数 func，支持反向逻辑
-- @param func string|function 函数名称或函数对象，若为字串则从 c/lib/fuef/aux 中查找，支持 "~" 前缀取反
-- @param args table? 若存在则立即调用目标函数，并传入该参数表
-- @param ... table 可选优先查找表，最后搜索 fuef, aux
-- @return function|any 若有 args，返回函数执行结果
-- @raise 若 func 为字串且无法解析为有效函数，将抛出错误
function fusf.ResolveFunction(func, args, ...)
	fusf.CheckArgType("ResolveFunction", 2, args, "nil/table")
	local typ = fusf.CheckArgType("ResolveFunction", 1, func, "string/function")
	if typ == "function" then return func end

	local fix = function(f) return f end
	local f = func
	if func:match("~") then
		f = func:sub(2)
		fix = function(f) return function(...) return not f(...) end end
	end

	local tabs = {...}
	table.insert(tabs, fuef)
	table.insert(tabs, aux)
	f = fusf.FindTables(f, table.unpack(tabs))
if func == "tgoval" then
	Debug.Message(type(f))
end
	fusf.CheckType(f, "function")
	if args then
		if args.n then
			f = f(table.unpack(args, 1, args.n))
		else
			f = f(table.unpack(args))
		end
	end
	return fix(f)
end

--- 将可能包含多个函数呼叫与括号参数的表达式字串解析为表结构（支援嵌套与占位符替换）
-- 如 "f1,,f2(%1,%2),(%3)" 会被解析为 { "f1", nil, { "f2", {replace[1], replace[2]} }, { replace[3] } }
-- @param expr_str string 欲解析的整体表达式，如 "f1,,f2(%1,%2),(%3)"
-- @param replace_table table 替换占位符用的参数表
-- @return table 解析结果为表结构，内含函数名与参数的混合列表，巢状呼叫以子表表示，附加栏位 n 表示数量
-- @raise 若有未关闭括号或非法占位符，将抛出错误
function fusf.ParseCallGroupString(expr_str, replace_table)
	local result, length, pending = {}, 0, ""
	for _, unit in expr_str:ForCut() do
		length = length + 1
		local is_st = unit:match("%(")
		local is_ed = unit:match("%)")
		-- is f(v1)
		if is_st and is_ed then
			local fname, args = fusf.ParseCallExprString(unit, replace_table)
			if fname == "" then
				result[length] = args
			else
				result[length] = {fname, args}
			end
		elseif is_st then
			pending, length = unit, length - 1
		elseif is_ed then
			local fname, args = fusf.ParseCallExprString(pending .. "," .. unit, replace_table)
			if fname == "" then
				result[length] = args
			else
				result[length] = {fname, args}
			end
			pending = ""
		elseif #pending > 0 then
			pending, length = pending .. "," .. unit, length - 1
		elseif unit:match("%%") then
			local ind = tonumber(unit:sub(2))
			if not ind or ind < 1 then
				error("invalid replace_table index : " .. expr_str)
			end
			result[length] = replace_table[ind]
		elseif unit ~= "" then
			result[length] = unit
		end
	end
	if pending ~= "" then
		error("unclosed in ParseCallGroupString : " .. expr_str)
	end
	result.n = length
	return result
end

--- 解析可能带有函数名称与括号参数的呼叫字串，并进行占位替换
-- 如 "Func(%1,,3)" 会被解析为 "Func"，与参数表 { replace[1], nil, "3" }
-- @param expr_str string 表达式形式的呼叫字串，如 "Func(%1,,3)"
-- @param replace_table table 替换占位符用的参数表
-- @return string, table 函数名称以及对应参数表，附加栏位 len 表示参数数量
-- @raise 当占位符无效或格式错误时会报错
function fusf.ParseCallExprString(expr_str, replace_table)
	local fname, start_pos = "", expr_str:find("%(")
	if start_pos ~= 1 then
		fname = expr_str:sub(1, start_pos - 1)
	end
	if start_pos + 1 == #expr_str then -- "f()" -> {"f"}
		return fname, {len = 0}
	end
	local args_str = expr_str:sub(start_pos + 1, -2)
	return fname, fusf.ParseArgsString(args_str, replace_table)
end

--- 解析以逗号分隔的参数字串，并替换其中的占位符（如 %1, %2 等）
-- 如 "%1,,3" 会被解析为 { replace[1], nil, "3" }
-- @param args_str string 欲解析的字串，如 "%1,,3"
-- @param replace_table table 替换占位符用的参数表
-- @return table 解析后的参数 table ，附加栏位 n 表示参数数量
-- @raise 若占位符无效（非正整数）则触发错误
function fusf.ParseArgsString(args_str, replace_table)
	local result, length = {}, 0
	for _, arg in args_str:ForCut() do
		length = length + 1
		if arg:match("%%") then
			local ind = tonumber(arg:sub(2))
			if not ind or ind < 1 then
				error("invalid replace_table index : " .. args_str)
			end
			result[length] = replace_table[ind]
		elseif arg ~= "" then
			result[length] = arg
		end
	end
	result.n = length
	return result
end

--- 遍历一个表（table），支援带 .n 栏位的自订长度
-- @param t table 欲遍历的表
-- @param n number? 若无 t.n，则使用此值作为最大索引（可选）
-- @return function 叠代器函数，返回 (index, value)
function fusf.ForTable(t, n)
	local i, max = 0, t.n or n
	return function()
		if i >= max then return nil end
		i = i + 1
		return i, t[i]
	end
end

--- 解析文字讯息代码，支持多种输入格式（数字/字符串/偏移量）
-- @param code number|string 原始代码或偏移字符串，如 "+1"、"-2"
-- @param id number? 可选的消息编号（如 Stringid(code, id) 中的 id）
-- @param m number? 可选基准卡号，用于计算相对偏移
-- @return number 返回 aux.Stringid(code, id) 的值
function fusf.ResolveDescription(code, id, m) -- (0), ("n"), (m), ("+1")
	local cod_typ = fusf.CheckArgType("ResolveDescription", 1, code, "number/string")
	local id_typ = fusf.CheckArgType("ResolveDescription", 2, id, "nil/number")
	fusf.CheckArgType("ResolveDescription", 3, m, "number")

	if id_typ == "number" then
		if id < 17 then
			code = fusf.NormalizeID(code, m)
		end
	elseif cod_typ == "number" then
		if code < 17 then -- in cdb and code is owner card code
			code, id = m, code
		elseif code > 1000 then
			code, id = 0, code
		else
			code, id = fusf.NormalizeID(code, m), 0
		end
	elseif cod_typ == "string" then
		if tonumber(code) then -- code = m +- code
			code, id = fusf.NormalizeID(code, m), 0
		else			 -- in fucs.des
			code, id = 0, fusf.CheckType(fucs.des[code], "number")
		end
	end
	return aux.Stringid(code, id) -- code * 16 + id
end

--- 解析重置条件字串，支援简单运算与预设数量
-- @param flag string|number 条件描述（如 "a + b - c , 1"）
-- @param count number? 可选的重置次数，若省略则从字串中解析
-- @return table {flag: number, count: number} 重置条件与次数 table
function fusf.ResolveReset(flag, count)
	local typ = fusf.CheckArgType("ResolveReset", 1, flag, "number/string")
	fusf.CheckArgType("ResolveReset", 2, count, "nil/number")

	if typ == "number" then return flag, count end

	if not count then -- cut count
		local parts = flag:Cut()
		flag, count = parts[1], tonumber(parts[2] or 1)
	end
	local stack = {}
	local res, pha = fucs.res, fucs.pha
	for _, unit in ipairs(fusf.InfixToPostfix(flag)) do
		if unit:match("[+-]") then
			local valR, valL = table.remove(stack), table.remove(stack)
			local cal = (unit == "-") and (valL - valR) or (valL | valR)
			table.insert(stack, cal)
		else
			table.insert(stack, fusf.FindTables(unit, res, pha))
		end
	end
	flag = table.remove(stack)
	if flag & 0xfff0000 > 0 then flag = flag | RESET_EVENT end
	if flag & 0x00003ff > 0 then flag = flag | RESET_PHASE end
	return flag, count
end

--- 建立与事件 e 绑定的函数快取区（每个效果唯一识别），供函数查找与快取使用
-- @param e Effect 效果物件，用于识别对应的快取区
-- @return table 快取表，带栏位 lib 表示可供查找函数的函式库
function fusf.MakeFuncCatch(e)
	local cm = fusf.Getcm(e)
	local id = tostring(e):sub(-8)
	cm[id] = cm[id] or {lib = cm}
	return cm[id]
end

--- 查找指定键值对应的函数，若未快取则解析后快取
-- @param catch table 快取区（来自 MakeFuncCatch）
-- @param key string 作为函数的识别名称（快取键）
-- @param func string|function 欲查找的函数或其字串表示，可带 "~" 表示反向逻辑
-- @return function 查找到的函数物件（已快取）
function fusf.FindFuncCatch(catch, key, func)
	if catch[key] then return catch[key] end
	catch[key] = fusf.ResolveFunction(func, nil, catch.lib)
	return catch[key]
end

--------------------------------------"Other Support function"

--- 为卡片、效果、玩家或卡片群组注册一个标识用效果（FlagEffect）
-- @param val Card|Group|Effect|number 目标对象，可为单张卡、卡组、效果对象，或玩家编号
-- @param cod number|string 标识效果的代码，可为数值或偏移表达式（将被规范化）
-- @param res string|number 标识的重置条件，可用表达式，如 "event1 + pha1 , 1"
-- @param pro string|number? 效果的属性（效果标志），默认值为 0，可为常量名或数值
-- @param des string|number? 效果提示描述（字符串ID），传入描述名或偏移，如 "+1"
-- @param lab number? 标签参数，可用于额外传值（如标记内容），默认 0
function fusf.RegFlag(val, cod, res, pro, des, lab)
	local typ = fusf.CheckArgType("RegFlag", 1, val, "Card/Group/Effect/player")
	fusf.CheckArgType("RegFlag", 6, lab, "nil/number")

	cod = fusf.NormalizeID(cod)   -- 规范化代码（如字符串转数值）
	res = {fusf.ResolveReset(res)}  -- 转换表达式或数值为 {flag, count}
	pro = fusf.ParseConstantKey("pro", pro or 0) -- 效果属性，默认为 0

	if des then
		des = fusf.ResolveDescription(des, nil, cod)
		pro = pro|EFFECT_FLAG_CLIENT_HINT
	end

	if typ == "player" then
		Duel.RegisterFlagEffect(val, cod, res[1], pro, res[2] or 1, lab or 0)
		return
	end

	for c in aux.Next(fusf.ToGroup(val)) do
		c:RegisterFlagEffect(cod, res[1], pro, res[2] or 1, lab or 0, des)
	end
end

--- 检查 val 的种类为 cod 的标识效果的数量, 有 n 则传回比较结果
-- @param val Card|Effect|number 目标对象，可为卡片、效果对象或玩家编号（0或1）
-- @param cod number|string FlagEffect 的代码，会被标准化（如偏移表达式 "+1"）
-- @param n number? 可选，若指定则判断是否达到 n，负数则判断不到 -n
-- @return number|boolean 返回数量，或是否满足条件
function fusf.GetFlag(val, cod, n)
	local typ = fusf.CheckArgType("GetFlag", 1, val, "Card/Effect/player")
	fusf.CheckArgType("GetFlag", 3, n, "nil/number")

	cod = fusf.NormalizeID(cod)
	local count
	if typ == "player" then
		count = Duel.GetFlagEffect(val, cod)
	else
		count = fusf.ToCard(val):GetFlagEffect(cod)
	end
	if not n then return count end
	return n > 0 and count >= n or count <= -n
end

--- 检查 val 的种类为 cod 的标识效果的 Label, 有 lab 則傳回是否相等
-- @param val Card|Effect|player 要查询的对象，可以是卡片、效果或玩家
-- @param cod number|string FlagEffect 的代码，会被标准化（如偏移表达式 "+1"）
-- @param lab any? 可选，用于比较 label 是否等于特定值
-- @return any|boolean 若提供 lab，则回传是否相等；否则回传该 Label（或 nil）
function fusf.GetFlagLabel(val, cod, lab)
	local typ = fusf.CheckArgType("GetFlagLabel", 1, val, "Card/Effect/player")
	fusf.CheckArgType("GetFlagLabel", 3, lab, "nil/number")

	cod = fusf.NormalizeID(cod)
	local label
	if typ == "player" then
		label = {Duel.GetFlagEffectLabel(val, cod)}
	else
		label = {fusf.ToCard(val):GetFlagEffectLabel(cod)}
	end
	if lab then return label[1] == lab end
	return table.unpack(label)
end

--- 取得成为对象的卡（若存在），并检测是否与 e 有联系
-- @param e Effect 当前效果物件
-- @param pos number|nil 过滤位置（可选，用于指定表示形式，如 POS_FACEUP）
-- @param is_imm boolean|nil 是否过滤能否被效果影响的卡片（可选）
-- @return Card|false 返回对象，若无或不满足条件则返回 false
function fusf.GetTarget(e, pos, is_imm)
	local tg = fusf.GetTargets(e, pos, is_imm)
	if tg then tg = tg:GetFirst() end
	return tg
end

--- 取得成为对象的卡片组（若存在），并检测是否与 e 有联系
-- @param e Effect 当前效果物件
-- @param pos number|nil 过滤位置（可选，用于指定表示形式，如 POS_FACEUP）
-- @param is_imm boolean|nil 是否过滤能否被效果影响的卡片（可选）
-- @return Group|false 返回满足条件的对象卡片组，若无或都不满足条件则返回 false
function fusf.GetTargets(e, pos, is_imm)
	local tg = Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if pos then tg = fugf.Filter(tg, "IsPos", pos) end
	if is_imm then tg = fugf.Filter(tg, "~IsImm", e) end
	if #tg == 0 then return false end
	return tg
end

--- 让玩家 tp 把卡片或卡片组 eg 作为装备卡装备给卡片 c，返回值表示是否成功
-- @param e Effect 装备效果
-- @param tp number 装备的玩家，必须为 0 或 1
-- @param eg Group|Card 要装备的卡片，支持单张或群组
-- @param c nil|Card 装备目标卡片，必须为面朝上的卡
-- @return boolean 装备成功返回 true，失败返回 false
function fusf.Equip(e, tp, eg, c)
	fusf.CheckArgType("Equip", 1, e, "Effect")
	fusf.CheckArgType("Equip", 2, tp, "player")

	local typ = fusf.CheckArgType("Equip", 3, eg, "Group/Card")
	eg = fusf.ToGroup(eg)
	if Duel.GetLocationCount(tp, LOCATION_SZONE) < #eg then return false end

	c = fusf.CheckArgType("Equip", 4, c or e:GetHandler(), "Card")
	if c:IsFacedown() then return false end

	local limit = function(e, c) return c == e:GetLabelObject() end
	if typ == "Card" then
		local ec = eg:GetFirst()
		if not Duel.Equip(tp, ec, c) then return false end
		if ec:IsType(TYPE_MONSTER) then
			fuef.S(e, EFFECT_EQUIP_LIMIT, ec):PRO("CD"):VAL(limit):OBJ(c):RES("STD")
		end
		return true
	end
	for ec in aux.Next(eg) do
		Duel.Equip(tp, ec, c, true, true)
		if ec:IsType(TYPE_MONSTER) then
			fuef.S(e, EFFECT_EQUIP_LIMIT, ec):PRO("CD"):VAL(limit):OBJ(c):RES("STD")
		end
	end
	Duel.EquipComplete()
	return true
end

--- 检查计数器 id 的数量, 有 n 则传回比较结果
-- @param id number|string 计数器的 ID，会规范化
-- @param p number 玩家编号（0 或 1）
-- @param typ number|string 操作类型
-- @param n number? 可选，若指定则判断是否达到 n，负数则判断不到 -n
-- @return number|boolean 返回数量，或是否满足条件
function fusf.GetCounter(id, p, typ, n)
	id = fusf.NormalizeID(id)
	typ = fusf.ParseConstantKey("act", typ)
	local ct = Duel.GetCustomActivityCount(id, p, typ)
	if not n then return ct end
	return n > 0 and ct >= n or ct <= -n
end

--- 判断目前是否处于指定的 Phase（支援逻辑运算）
-- 支援表达式：单一阶段（如 "BP"）、多个阶段的 OR（如 "BP/M2"）、NOT（如 "~EP"）
-- @param pha number|string 阶段代码或逻辑表达式
-- @return boolean 是否处于该阶段
function fusf.IsPhase(pha)
	local phase = Duel.GetCurrentPhase()
	local typ = fusf.CheckArgType("IsPhase", 1, pha, "number/string")
	if typ == "number" then return phase == pha end

	local stack = {}
	for _, val in ipairs(fusf.InfixToPostfix(pha)) do
		if val:match("[%-%~]") then
			stack[#stack] = not stack[#stack]
		elseif val == "/" then
			local valR, valL = table.remove(stack), table.remove(stack)
			table.insert(stack, valL or valR)
		elseif val == "BP" then
			table.insert(stack, Duel.IsBattlePhase())
		else
			local _pha = fusf.Findfucs("pha", val)
			table.insert(stack, phase == _pha)
		end
	end
	return stack[#stack]
end
--------------------------------------------------------------------------"initial function"
--- 为卡片脚本提供统一初始化接口
-- @param lib   table  (可选）卡片使用的函式库
-- @param glo_key string   (可选）表示是否有全域注册条件
-- @return cm   卡片表（即全局脚本的局部名 cm）
-- @return m			   卡片 ID（编号）
function fusf.Initial(lib, glo_key)
	local cm, m = GetID()
	if cm.initial_effect then return cm, m end

	local log = fudf.StartLog(0, "fusf.Initial", lib, glo_key)
	log:Info(m)

	fusf.CheckArgType("Initial", 1, lib, "nil/table")
	fusf.CheckArgType("Initial", 2, glo_key, "nil/string")

	cm.lib = lib or {}
	cm.e_list = {}
	cm.init_list = {}

	local function apply(log, c, name, val)
		log:Info("try InitSetOwner "..name)
		local i = 1
		local key = name .. i
		while cm[key] do
			local E = fusf.CheckType(cm[key], "fuef")
			c.e_list[key] = E:InitSetOwner(key, c, val)
			i = i + 1
			key = name .. i
		end
		log:Info(("set %d %s"):format(i - 1, name))
	end

	cm.initial_effect = function(c)
		local log = fudf.StartLog(0, "cm.initial_effect", c)
		log:Info(m)

		apply(log, c, "pe")  -- pe1, pe2, ...
		apply(log, c, "e")  -- e1, e2, ...

		log:Info("try ipairs cm.init_list")
		for _, f in ipairs(cm.init_list) do
			f(c)
		end
		log:Info("set cm.init_list down")

		if not glo_key or cm[glo_key] then return end
		cm[glo_key] = {0, 0}
		apply(log, c, "ge", 1)  -- ge1, ge2, ...
	end
	log:Info("set cm.initial_effect down")

	return cm, m
end

--- 在卡片的 initial_effect 中插入额外初始化函数
-- @param func function 需要插入的初始化函数
-- @raise 如果 cm.initial_effect 不存在或不是函数，则报错 "INITIAL"
function fusf.InsertInitial(func, log)
	log = fudf.StartLog(log or 0, "fusf.InsertInitial", func)

	fusf.CheckArgType("InsertInitial", 1, func, "function")

	local cm, m = GetID()

	if not cm.init_list then error("You must call fusf.Initial first", 2) end
	table.insert(cm.init_list, func)
end

--- 为卡片添加卡名记述 ...
-- @param ... number|string 可为卡号、字符串（如 "100+200"）、或多个卡号
--  字符串会用 "+" 切割后批量处理，转换为标准卡号格式
function fusf.AddCode(...)
	local log = fudf.StartLog(0, "fusf.AddCode", ...)

	fusf.CheckEmptyArgs("AddCode", ...)

	local codes = { }
	for i, val in ipairs{...} do
		local typ = fusf.CheckArgType("AddCode", i, val, "string/number")
		if typ == "string" then 
			for _, code in ipairs(fusf.GetCodeTable(val)) do
				log:Info("add "..code)
				table.insert(codes, code)
			end
		else
			local code = fusf.NormalizeID(val)
			log:Info("add "..code)
			table.insert(codes, code)
		end
	end

	local function AddFunc(c)
		aux.AddCodeList(c, table.unpack(codes))
	end
	fusf.InsertInitial(AddFunc, log)
end

--- 为卡片添加苏生限制
function fusf.ReviveLimit()
	local log = fudf.StartLog(0, "fusf.ReviveLimit")
	local function AddFunc(c)
		c:EnableReviveLimit()
	end
	fusf.InsertInitial(AddFunc, log)
end

--- 添加自定义计数器
-- @param id number|string 计数器的 ID，会规范化
-- @param typ number|string 操作类型
-- @param func function|string 判断计数的过滤函数
function fusf.AddCounter(id, typ, func)
	local log = fudf.StartLog(0, "fusf.AddCounter", id, typ, func)

	local id = fusf.NormalizeID(id)
	log:Info("NormalizeID id : "..id)
	local typ = fusf.ParseConstantKey("act", typ)
	log:Info("got act typ : "..fusf.CutHex(typ))

	if fusf.CheckArgType("AddCounter", 3, func, "function/string") == "string" then
		func = "~"..func
	else
		func = function(...) return not func(...) end
	end

	local function AddFunc(c)
		func = fusf.ResolveFunction(func, nil, fusf.Getcm(c), c.lib)
		Duel.AddCustomActivityCounter(id, typ, func)
	end
	fusf.InsertInitial(AddFunc, log)
end
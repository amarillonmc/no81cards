if fucf then return end
fucf, fugf = { }, { }
dofile("expansions/script/c20099998.lua")
-------------------------------------- Group function
--- 根据卡片过滤条件构造一个群组过滤器（可回传过滤后的卡片群组或判断数量）
-- @param f string|function 过滤函数或名称，传入 MakeCardFilter 使用
-- @param v any 传入过滤函数的参数，可为单值或表
-- @param ... 可选占位参数，传给 MakeCardFilter
-- @return function function(Group, number?): Group | boolean
--   若不提供 n，返回符合条件的子群组；
--   若提供正整数 n，返回群组中符合条件的卡片数量是否 ≥ n；
--   若提供负整数 -n，返回是否 ≤ -n。
function fugf.MakeGroupFilter(f, v)
	return function(g, n, ...)
		fusf.CheckArgType("MakeGroupFilter", 1, g, "Group")
		local ok, res = pcall(fusf.CheckArgType,"MakeGroupFilter", 2, n, "nil/number")
if not ok then
	error(res, 2)
end
		g = g:Filter(fucf.MakeCardFilter(f, v, ...), nil)
		if not n then return g end
		return n > 0 and #g >= n or #g <= -n
	end
end
--- 返回以 p 来看的 loc (自己以及对方区域以+分开)位置的卡片组
-- @param p number 玩家编号（必须是 0 或 1）
-- @param loc string 表示区域的字符串（如 "H+HM" 等）
-- @return Group 返回该区域内所有卡片的 Group
function fugf.Get(p, loc)
	fusf.CheckArgType("Get", 1, p, "player")
	return Duel.GetFieldGroup(p, fusf.GetLoc(loc))
end
--- 以指定条件过滤 Group 中的卡片（支持数量判断）
-- @param g Group 要过滤的卡片群组
-- @param f string|function 用于 MakeCardFilter 的过滤函数或名称
-- @param v any 用于传入过滤器的参数（可为单值、表等）
-- @param n number|nil 可选值：
--   - 若为 nil，返回过滤后的 Group；
--   - 若为正数，判断是否有 ≥ n 张符合条件的卡片，返回 boolean；
--   - 若为负数，判断是否有 ≤ n 张符合条件的卡片，返回 boolean。
-- @param ... any 可选参数，传入 MakeCardFilter，用于额外参数或占位
-- @return Group|boolean 返回过滤后的 Group，或符合数量条件的布尔值
function fugf.Filter(g, f, v, n, ...)
	return fugf.MakeGroupFilter(f, v)(g, n, ...)
end
--- 获取并过滤指定玩家区域内的卡片
-- @param p number 玩家编号（必须是 0 或 1）
-- @param loc string 表示区域的字符串（如 "H+HM" 等）
-- @param f string|function 过滤函数或名称，传入 MakeCardFilter 使用
-- @param v any 传入过滤函数的参数（可为单值或表）
-- @param n number|nil 可选数量条件（正数：≥n，负数：≤n，nil：返回过滤后的 Group）
-- @param ... 可选额外参数，传给 MakeCardFilter
-- @return Group|boolean 返回过滤后的 Group，或是否符合数量条件
function fugf.GetFilter(p, loc, f, v, n, ...)
	return fugf.Filter(fugf.Get(p, loc), f, v, n, ...)
end
--- 构造一个带默认位置与过滤条件的 Group 过滤器函数
-- @param loc string 预设区域字符串（如 "M", "H+M"）
-- @param f string|function 过滤函数或名称，用于 MakeCardFilter
-- @param v any 传给过滤函数的参数
-- @param n number|nil 数量要求（正：≥n，负：≤n，nil：返回过滤后的 Group）
-- @return function(p: number, ...): Group|boolean
--   返回一个函数，该函数接受 p 及 ... 并执行过滤
function fugf.MakeFilter(loc, f, v, n)
	return function(p, ...)
		return fugf.GetFilter(p, loc, f, v, n, ...)
	end
end
--- 从卡片组中选择卡片（带筛选、数量控制）
-- @param p number 控制玩家编号（0或1）
-- @param g Group|string 卡片组，或为关键字字符串（如 "HAND+MONSTER"）
-- @param f function|number 筛选函数或最小选择数量
-- @param v any 若 f 为函数时传入的首个额外参数
-- @param min number? 最小选择数量（若 f 为 number，此值会从 f 推出）
-- @param max number? 最大选择数量（默认与 min 相同）
-- @param ... any 筛选函数的其它额外参数
-- @return Group 返回选择的卡片组（Group 类型）
function fugf.Select(p, g, f, v, min, max, ...)
	local g_typ = fusf.CheckArgType("Select", 2, g, "Group/string")
	if g_typ == "string" then g = fugf.Get(p, g) end
	if type(f) == "number" then -- f is min
		min, max = f, v
	elseif f then -- f is func
		g = fugf.Filter(g, f, v, nil, ...)
	end
	min = min or 1
	max = max or min
	if #g == min then return g end
	return g:Select(p, min, max, nil)
end
--- 从指定卡组中选择目标卡并设定为效果目标
-- @param p number 玩家编号（0 或 1）
-- @param g Group|string 卡片群组，或表示卡片来源的字符串（会调用 fugf.Get）
-- @param f function|string|number 可选过滤函数或数量
--   - 若为 number，代表 min 数量，v 将视为 max；
--   - 若为 function/string，则视为过滤器（将用于 Filter）
-- @param v any 过滤器附加参数
-- @param min number 最小选择数量（默认 1）
-- @param max number 最大选择数量（默认等于 min）
-- @param ... 其他传给过滤器的参数
-- @return Group 被选择并设定为目标的卡片群组
function fugf.SelectTg(p, g, f, v, min, max, ...)
	local g = fugf.Select(p, g, f, v, min, max, ...)
	Duel.SetTargetCard(g)
	return g
end
--------------------------------------"Card function"

--- 根据函数与参数构造一个卡片过滤器（返回一个 function(Card) -> bool）
-- @param func string|function 过滤函数或其名称，支援组合逻辑与反向（如 "~IsType+IsRace"）
-- @param args table|string|number 传入的参数，可为字符串（含占位符）或具体值
-- @param ... 可选的占位参数（会传给 %1、%2 等）
-- @return function 过滤器函数，接受卡片并返回布林值
function fucf.MakeCardFilter(func, args, ...)
	if not func then return function(c) return true end end
	local typ = fusf.CheckArgType("MakeCardFilter", 1, func, "string/function")
	-- trans args
	if type(args) ~= "table" then args = { args } end

	local arg_table, arg_count = {}, 0
	for _, arg in ipairs(args) do
		if type(arg) == "string" then
			for _, v in fusf.ForTable(fusf.ParseCallGroupString(arg, { ... })) do
				arg_count = arg_count + 1
				arg_table[arg_count] = v
			end
		else
			arg_count = arg_count + 1
			arg_table[arg_count] = arg
		end
	end
	-- func is function
	if typ == "function" then
		return function(c)
			fusf.CheckArgType("MakeCardFilter", 1, c, "Card")
			return func(c, table.unpack(arg_table, 1, arg_count))
		end
	end
	-- func is string
	local func_expr = fusf.InfixToPostfix(func, ...)
	local fucf, Card, aux = fucf, Card, aux
	if #func_expr == 1 then -- func just one
		local find_func = fusf.FindTables(func_expr[1], fucf, Card, aux)
		fusf.CheckType(find_func, "function")
		return function(c)
			fusf.CheckArgType("MakeCardFilter", 1, c, "Card")
			return find_func(c, table.unpack(arg_table, 1, arg_count))
		end
	end
	-- func is multi
	return function(c)
		fusf.CheckArgType("MakeCardFilter", 1, c, "Card")
		local stack, arg_ind = {}, 1
		for _, func in ipairs(func_expr) do
			if func == "~" then
				stack[#stack] = not stack[#stack]
			elseif type(func) == "string" and #func == 1 then
				local valR, valL = table.remove(stack), table.remove(stack)
				local Cal = {
					["+"] = valL and valR,
					["-"] = valL and not valR,
					["/"] = valL or valR
				}
				local temp = Cal[func]
				if temp == nil then
					error("invalid operators : " .. func)
				end
				stack[#stack + 1] = temp
			else
				if type(func) == "string" then
					func = fusf.FindTables(func, fucf, Card, aux)
					fusf.CheckType(func, "function")
				end
				local arg = arg_table[arg_ind]
				arg_ind = arg_ind + 1
				if type(arg) ~= "table" then arg = { arg, n = 1 } end
				stack[#stack + 1] = func(c, table.unpack(arg, 1, arg.n))
			end
		end
		return table.remove(stack)
	end
end

--- 判断卡片是否满足给定的过滤条件
-- @param c Card 欲判断的卡片对象
-- @param f string|function 过滤器（可为函数或其名称）
-- @param args table|string|number 传入的参数，可为字符串（含占位符）或具体值
-- @param ... 可选的占位参数（会传给 %1、%2 等）
-- @return boolean 若卡片符合条件，返回 true，否则返回 false
function fucf.Filter(c, f, v, ...)
	fusf.CheckArgType("Filter", 1, c, "Card")
	return fucf.MakeCardFilter(f, v, ...)(c)
end
fucf.IsRk   = fusf.MakeValCheck("GetRank")
fucf.IsLv   = fusf.MakeValCheck("GetLevel")
fucf.IsRLv  = fusf.MakeValCheck("GetRitualLevel")
fucf.IsLk   = fusf.MakeValCheck("GetLink")
fucf.IsAtk  = fusf.MakeValCheck("GetAttack")
fucf.IsDef  = fusf.MakeValCheck("GetDefense")
fucf.IsSeq  = fusf.MakeValCheck("GetSequence")
fucf.IsPSeq = fusf.MakeValCheck("GetPreviousSequence")
--- 判断卡片 c 是否“不等于”给定的 val
-- @param c Card 需要判断的卡片对象
-- @param val Card|Effect|Group|function 参考值，可以是卡片、效果、卡片组或过滤函数
-- @return boolean 如果 c 与 val 不匹配则返回 true，否则 false
--
-- - 若 val 是 Card，则比较是否为不同卡片
-- - 若 val 是 Effect，则比较 c 是否不是该效果的持有者
-- - 若 val 是 Group，则判断 c 是否不包含在该组内
-- - 若 val 是 function，则调用该函数传入 c，结果取反
-- - 其他情况返回 false
function fucf.Not(c, val)
	fusf.CheckArgType("Not", 1, c, "Card")
	local typ = fusf.CheckArgType("Not", 2, val, "Card/Effect/function")
	if typ == "Card" then
		return c ~= val
	elseif typ == "Effect" then
		return c ~= val:GetHandler()
	elseif typ == "function" then
		return not val(c)
	end
end
--- 判断卡片是否属于指定系列（Set）
-- @param c Card 要检查的卡片
-- @param sets number|string 系列编号或由多个系列编号组成的字串（用 "/" 分隔）
-- @return boolean 若属于任一指定系列则返回 true，否则返回 false
--
--   fucf.IsSet(c, 0xfd1)   → 检查是否属于系列 0xfd1
--   fucf.IsSet(c, "fd1+fd2")   → 检查是否属于 0xfd1 或 0xfd2
function fucf.IsSet(c, sets)
	fusf.CheckArgType("IsSet", 1, c, "Card")
	local typ = fusf.CheckArgType("IsSet", 2, sets, "number/string")
	if typ == "number" then return c:IsSetCard(sets) end
	for _, set in sets:ForCut("+") do
		set = tonumber(set, 16)
		if set and c:IsSetCard(set) then return true end
	end
	return false
end
--- 判断卡片是否能以指定方式送去特定区域
-- @param c Card 要检查的卡片
-- @param loc string 目标区域代号，可选前缀 "*" 表示作为 cost
--   可用区域代号：
--   "H" = 手牌（Hand）
--   "D" = 卡组（Deck）
--   "G" = 墓地（Grave）
--   "R" = 除外（Remove）
--   "E" = 额外卡组（Extra）
--   例："*G" 表示是否能作为 cost 被送去墓地
-- @return boolean 若能送去指定区域，则返回 true，否则返回 false
-- @raise 若 loc 非法，将抛出错误
function fucf.AbleTo(c, loc)
	fusf.CheckArgType("AbleTo", 1, c, "Card")
	fusf.CheckArgType("AbleTo", 2, loc, "string")
	local iscos = loc:match("*")
	loc = loc:match("[HDGRE]")
	if not loc then error("InfixToPostfix : param 1 is invalid param", 2) end
	local locs = {
		["H"] = "Hand"   ,
		["D"] = "Deck"   ,
		["G"] = "Grave"  ,
		["R"] = "Remove",
		["E"] = "Extra"  ,
	}
	return Card["IsAbleTo"..locs[loc]..(iscos and "AsCost" or "")](c)
end
--- 检查 c 是否可以特殊召唤
-- @param c Card 要特殊召唤的卡片
-- @param e Effect 用于特殊召唤的效果
-- @param typ number|string 特召方式类型（数值或缩写，如 "RI" 表示仪式召唤）
-- @param tp number 特召的执行玩家（预设为 e:GetHandlerPlayer()）
-- @param pos number|string 特召时卡片的表示形式（预设为 POS_FACEUP，可用字串）
-- @param lg Card |Group|nil 检查 lg 离开后的区域数量(有的话)
-- @param nochk boolean 是否忽略召唤条件（预设视 typ 而定）
-- @param nolimit boolean 是否忽略召唤次数限制（预设视 typ 而定）
-- @param totp number 特召后控制该卡的玩家（预设为 tp）
-- @param zone number 特召位置的区域 mask（预设为 0xff，即所有主怪兽区）
-- @return boolean 是否可以被特殊召唤
function fucf.CanSp(c, e, typ, tp, pos, lg, nochk, nolimit, totp, zone)
	fusf.CheckArgType("CanSp", 1, c, "Card")
	if not c:IsType(TYPE_MONSTER) then return false end
	fusf.CheckArgType("CanSp", 2, e, "Effect")
	local _, tp = fusf.CheckArgType("CanSp", 4, tp or e:GetHandlerPlayer(), "player")
	fusf.CheckArgType("CanSp", 6, lg, "nil/Card/Group")
	if c:IsLocation(LOCATION_EXTRA) then
		if Duel.GetMZoneCount(tp, lg) == 0 then return false end
	else
		if Duel.GetLocationCountFromEx(tp, tp, lg, c) == 0 then return false end
	end
	-- default chk
	local _, nochk = fusf.CheckArgType("CanSp", 7, nochk, "nil/boolean")
	local _, nolimit = fusf.CheckArgType("CanSp", 8, nolimit, "nil/boolean")
	-- special default
	local _, typ = fusf.CheckArgType("CanSp", 3, typ or 0, "number/string")
	if typ == "RI" then
		typ = SUMMON_TYPE_RITUAL
		if nochk == nil then nochk = false end
		if nolimit == nil then nolimit = true end
	end
	-- normal default
	if nochk == nil then nochk = false end
	if nolimit == nil then nolimit = false end
	--
	local _, pos = fusf.CheckArgType("CanSp", 5, pos or POS_FACEUP, "number/string")
	pos = fusf.ParseConstantKey("pos", pos)
	local _, totp = fusf.CheckArgType("CanSp", 9, totp or tp, "player")
	local _, zone = fusf.CheckArgType("CanSp", 10, zone or 0xff, "number")
	return c:IsCanBeSpecialSummoned(e, typ, tp, nochk, nolimit, pos, totp, zone)
end
--- 判断 c 是否属于指定的卡号
-- @param c Card 要检查的卡片
-- @param cod number|string|table|Effect|Card|Group 可为单个卡号、以 "+" 分隔的字符串、卡号数组，或包含卡的 Group
-- @return boolean 是否匹配任意一个卡号
function fucf.IsCode(c, cod)
	fusf.CheckArgType("IsCode", 1, c, "Card")
	return c:IsCode(table.unpack(fusf.GetCodeTable(cod)))
end
--- 判断 c 是否有卡名记述
-- @param c Card 要检查的卡片
-- @param cod number|string|table|Effect|Card|Group 为单个卡号、以 "+" 分隔的字符串、卡号数组，或包含卡的 Group
-- @return boolean 是否匹配任意一个卡名记述
function fucf.HasCode(c, cod)
	fusf.CheckArgType("HasCode", 1, c, "Card")
	local code_list = c.card_code_list
	if not code_list then return false end
	for _, code in ipairs(fusf.GetCodeTable(cod)) do
		if code_list[code] then return true end
	end
	return false
end
--- 判断是否能将多张装备卡（eg）装备到指定怪兽卡 c
-- @param c Card 欲装备的目标怪兽
-- @param eg Effect|Card|Group 欲装备的卡（可为单一卡片或卡片群组）
-- @param tp number? 控制玩家（预设为 c 的控制者）
-- @return boolean 是否所有卡片都能合法装备给 c
function fucf.CanEq(c, eg, tp)
	fusf.CheckArgType("CanEq", 1, c, "Card")
	eg = fusf.ToGroup(eg)
	tp = tp or c:GetControler()
	fusf.CheckArgType("CanEq", 3, tp, "player")
	if Duel.GetLocationCount(tp, LOCATION_SZONE) < #eg then return false end
	for ec in aux.Next(eg) do
		if not fucf.CanBeEq(ec, tp, c, true) then return false end
	end
	return true
end
--- 判断卡片是否可以作为装备卡装备给指定对象
-- @param c Card 欲检查的装备卡（可为怪兽或装备魔法）
-- @param tp number? 预设视为控制装备卡的玩家，若 ec 存在则预设为 ec 的控制者
-- @param ec Card? 欲装备的目标怪兽卡
-- @param chk_loc boolean? 若为 true，跳过地区检查（例如已有预留 zone）
-- @return boolean 是否可被当作装备卡使用
function fucf.CanBeEq(c, tp, ec, chk_loc)
	fusf.CheckArgType("CanBeEq", 1, c, "Card")
	if ec then
		fusf.CheckArgType("CanBeEq", 3, ec, "Card")
		tp = tp or ec:GetControler()
	end
	fusf.CheckArgType("CanBeEq", 2, tp, "player")
	if not (chk_loc or Duel.GetLocationCount(tp, LOCATION_SZONE) > 0) then return false end
	if c:IsLocation(LOCATION_ONFIELD) then
		if not c:IsFaceup() then return false end
	else
		if not c:CheckUniqueOnField(tp) then return false end
	end
	if c:IsType(TYPE_MONSTER) then
		return c:IsControler(tp) or c:IsAbleToChangeControler()
	elseif c:IsType(TYPE_EQUIP) then
		return c:CheckEquipTarget(ec)
	end
	error("CanBeEq : mismatch card type", 2)
end
--- 检查卡片 c 的种类为 cod 的标识效果的数量比较 n 的结果
-- @param c Card 要检查的卡片
-- @param cod number|string 旗标代码，可为数值或字串（将会正规化）
-- @param n number 可选，若提供则检查是否具有至少 n 层该 Flag
-- @return boolean Flag count 或 count 比较 n
function fucf.IsFlag(c, cod, n)
	fusf.CheckArgType("IsFlag", 1, c, "Card")
	fusf.CheckArgType("IsFlag", 3, n, "number")
	return fusf.GetFlag(c, cod, n)
end
--- 检查卡片 c 的种类为 cod 的标识效果的 Label 是否是 lab
-- @param c Card 要检查的卡片
-- @param cod number|string 旗标代码，可为数值或字串（将会正规化）
-- @param lab number 要比较的 Label
-- @return boolean Label 或 Label == lab
function fucf.IsFlagLab(c, cod, lab)
	fusf.CheckArgType("IsFlagLab", 1, c, "Card")
	fusf.CheckArgType("IsFlagLab", 3, lab, "number")
	return fusf.GetFlagLabel(c, cod, lab)
end
--- 检查卡片 c 的当前控制者是否是 p
-- @param c Card 要检查的卡片
-- @param p number 要比较的控制者玩家（0 或 1）
-- @return boolean 卡片 c 的当前控制者是否是 p
function fucf.IsCon(c, p)
	fusf.CheckArgType("IsCon", 1, c, "Card")
	fusf.CheckArgType("IsCon", 2, p, "player")
	return c:IsControler(p)
end
--- 检查卡片组 g 中是否存在卡片 c
-- @param c Card 要检查的卡片
-- @param g Group 要检查的卡片组
-- @return boolean 卡片组 g 中是否存在卡片 c
function fucf.InG(c, g)
	fusf.CheckArgType("InG", 1, c, "Card")
	fusf.CheckArgType("InG", 2, g, "Group")
	return g:IsContains(c)
end
--- 检查卡片 c 没有受王家长眠之谷的影响，并且检查当前连锁能否被无效
-- @param c Card 要检查的卡片
-- @return boolean 卡片 c 没有受王家长眠之谷的影响，并且当前连锁能被无效
function fucf.GChk(c)
	fusf.CheckArgType("GChk", 1, c, "Card")
	return not c:IsHasEffect(EFFECT_NECRO_VALLEY) and Duel.IsChainDisablable(0)
end
--- 检查卡片 c 当前位置是否是 loc
-- 注：loc == M 时，怪兽召唤(广义的)之际或被无效会返回 false
-- loc == S 时，魔陷发动无效会返回false
-- @param c Card 要检查的卡片
-- @param loc string|number 区域表示
-- @return boolean 检查卡片 c 当前位置是否是 loc
function fucf.IsLoc(c, loc)
	fusf.CheckArgType("IsLoc", 1, c, "Card")
	loc = fusf.GetLoc(loc)
	return c:IsLocation(loc)
end
--- 检查卡片 c 之前的位置是否是 loc
-- @param c Card 要检查的卡片
-- @param loc string|number 区域表示
-- @return boolean 检查卡片 c 之前的位置是否是 loc
function fucf.IsPLoc(c, loc)
	fusf.CheckArgType("IsPLoc", 1, c, "Card")
	loc = fusf.GetLoc(loc)
	return c:IsPreviousLocation(loc)
end
fucf.TgChk  = Card.IsCanBeEffectTarget
fucf.IsImm  = Card.IsImmuneToEffect
fucf.IsPCon = Card.IsPreviousControler
fucf.IsRea  = fusf.MakeConsCheck("GetReason", "rea", "&")
fucf.IsTyp  = fusf.MakeConsCheck("GetType", "typ", "&")
fucf.IsSTyp = fusf.MakeConsCheck("GetSummonType", "styp", "&")
fucf.IsOTyp = fusf.MakeConsCheck("GetOriginalType", "typ", "&")
fucf.IsAtt  = fusf.MakeConsCheck("GetAttribute", "att", "&")
fucf.IsRac  = fusf.MakeConsCheck("GetRace", "rac", "&")
fucf.IsPos  = fusf.MakeConsCheck("GetPosition", "pos", "|")
fucf.IsPPos = fusf.MakeConsCheck("GetPreviousPosition", "pos", "|")
--[[
---------------------------------------------------------------- procedure
function fucf.RMFilter(c, rf, e, tp, g1, g2, level_function, greater_or_equal, chk)
	if rf and not rf(c, e, tp, chk) then return false end
	if not fucf.Filter(rc, "IsTyp+CanSp", "RI+M", {e, "RI"}) then return false end
	local g = g1:Filter(Card.IsCanBeRitualMaterial, c, c) + (g2 or Group.CreateGroup())
	g = g:Filter(c.mat_filter or aux.TRUE, c, tp)
	local lv = level_function(c)
	Auxiliary.GCheckAdditional = Auxiliary.RitualCheckAdditional(c, lv, greater_or_equal)
	local res = g:CheckSubGroup(Auxiliary.RitualCheck, 1, lv, tp, c, lv, greater_or_equal)
	Auxiliary.GCheckAdditional = nil
	return res
end
--]]
if fuef then return end --2025/7/16
fuef = { }
fuef.__index = fuef
fuef.DebugMode = false -- 调试模式
dofile("expansions/script/c20099997.lua")
----------------------------------------------------------------
--- 建立一个 IGNITION 的 fuef
-- @param owner Card|Effect|nil 效果的持有者（若为 nil，仅建立效果表；需后续补设）
-- @param target boolean|Card|Group|player 注册目标
-- @param force boolean 是否强制注册
-- @return fuef 新创建的效果表实例
function fuef.I(owner, target, force)
	local log = fudf.StartLog(0, "fuef.I", owner, target, force)
	return fuef.New(log, "I", nil, owner, target, force)
end

--- 建立一个 FIELD + GRANT 的 fuef
-- @param owner Card|Effect|nil 效果的持有者（若为 obj，仅建立效果表；需后续补设）
-- @param obj Effect|fuef|string 要赋予的效果（effect object）
-- @param target boolean|Card|Group|player 注册目标
-- @param force boolean 是否强制注册
-- @return fuef 新创建的效果表实例
function fuef.FG(owner, obj, target, force)
	local log = fudf.StartLog(0, "fuef.FG", owner, obj, target, force)

	local is_obj = pcall(fusf.CheckTypes, owner, "string/fuef/Effect")
	if is_obj then
		owner, obj, target, force = nil, owner, obj, target
	end

	return fuef.New(log, "F+G", nil, owner, target, force):OBJ(obj)
end

--- 建立剩余需要 cod 的 fuef
for i, typs in ipairs{"S,F,E,S+C,F+C,E+C,F+TO,F+TF,S+TO,S+TF,X", "A,QO,QF"} do
	for _, typ in typs:ForCut() do
		local name = typ:gsub("+", "")
		fuef[name] = function(owner, cod, target, force)
			local log = fudf.StartLog(0, "fuef."..name, owner, cod, target, force)

			local is_cod = pcall(fusf.CheckTypes, owner, "string/number")
			if is_cod then
				owner, cod, target, force = nil, owner, cod, target
			end

			if i == 2 then cod = cod or "FC" end -- A,QO,QF

			return fuef.New(log, typ, cod, owner, target, force)
		end
	end
end
---------------------------------------------------------------- XYZ Proc
function fuef.ProcXyzLv(lv, cf, min, max)
	fusf.CheckArgType("fuef.ProcXyzLv", 1, lv, "number")
	fusf.CheckArgType("fuef.ProcXyzLv", 2, cf, "nil/function")
	local lvf = fucf.MakeCardFilter("IsLv", lv)
	local _cf = function(c, xyzc)
		return lvf(c) and (not cf or cf(c, xyzc))
	end
	return fuef.ProcXyz(_cf, nil, min, max)
end
function fuef.ProcXyzAlter(cf, gf, min, max, ex_op, ex_cf)
	return fuef.ProcXyz(cf, gf, min, max, ex_op, ex_cf):Lab(1)
end
function fuef.ProcXyz(cf, gf, min, max, ex_op, ex_cf)
	fusf.CheckArgType("fuef.ProcXyz", 1, cf, "nil/string/function")
	fusf.CheckArgType("fuef.ProcXyz", 2, gf, "nil/string/function")
	local _, min = fusf.CheckArgType("fuef.ProcXyz", 3, min or 2, "number")
	local _, max = fusf.CheckArgType("fuef.ProcXyz", 4, max or min, "number")
	fusf.CheckArgType("fuef.ProcXyz", 5, ex_op, "nil/string/function")
	fusf.CheckArgType("fuef.ProcXyz", 6, ex_cf, "nil/string/function")
	local e = fuef.F(EFFECT_SPSUMMON_PROC):Des(1165):Pro("OE"):Ran("E"):Val("XYZ")
	e:Con("PX_con", cf, gf, min, max, ex_op, ex_cf)
	e:Tg("PX_tg", cf, gf, min, max, ex_op, ex_cf)
	return e:Op(aux.XyzLevelFreeOperation())
end
function fuef.PX_goal(g, tp, xyzc, gf)
	return (not gf or gf(g, tp, xyzc)) and Duel.GetLocationCountFromEx(tp, tp, g, xyzc) > 0
end
function fuef.PX_con(cf, gf, minc, maxc, ex_op, ex_cf)
	return function(e, c, og, min, max)
		if c == nil then return true end
		if c:IsType(TYPE_PENDULUM) and c:IsFaceup() then return false end
		local minc, maxc = math.max(minc, min or minc), math.min(maxc, max or maxc)
		if maxc < minc then return false end

		local catch = fusf.MakeFuncCatch(e)
		local tp = c:GetControler()
		if ex_op then
			if type(ex_op) == "string" then ex_op = fusf.FindFuncCatch(catch, "ex_op", ex_op) end
			if not ex_op(e, c, tp, 0) then return false end
		end
		if cf and type(cf) == "string" then cf = fusf.FindFuncCatch(catch, "cf", cf) end
		local mg = fugf.Filter(og or fugf.Get(tp, "M"), "XyzLevelFreeFilter", {c, cf})

		if ex_cf then
			local mg2 = fugf.GetFilter(tp, "A", "IsTyp/IsCanBeXyzMaterial", "S/T,%1", nil, c) - mg
			if type(ex_cf) == "string" then ex_cf = fusf.FindFuncCatch(catch, "ex_cf", ex_cf) end
			mg = mg + fugf.Filter(mg2, ex_cf, c)
		end

		local sg = Duel.GetMustMaterial(tp, EFFECT_MUST_BE_XMATERIAL)
		if #mg > #(mg + sg) then return false end
		Duel.SetSelectedCard(sg)
		Auxiliary.GCheckAdditional = Auxiliary.TuneMagicianCheckAdditionalX(EFFECT_TUNE_MAGICIAN_X)
		if gf and type(gf) == "string" then gf = fusf.FindFuncCatch(catch, "gf", gf) end
		local res = mg:CheckSubGroup(fuef.PX_goal, minc, maxc, tp, c, gf)
		Auxiliary.GCheckAdditional = nil
		return res
	end
end
function fuef.PX_tg(cf, gf, minc, maxc, ex_op, ex_cf)
	return function(e, tp, eg, ep, ev, re, r, rp, chk, c, og, min, max)
		if og and not min then return true end
		minc, maxc = math.max(minc, min or minc), math.min(maxc, max or maxc)

		local catch = fusf.MakeFuncCatch(e)
		if cf and type(cf) == "string" then cf = fusf.FindFuncCatch(catch, "cf", cf) end
		local mg = fugf.Filter(og or fugf.Get(tp,"M"), "XyzLevelFreeFilter", {c, cf})

		if ex_cf then
			local mg2 = fugf.GetFilter(tp, "A", "IsTyp/IsCanBeXyzMaterial", "S/T,%1", nil, c) - mg
			if type(ex_cf) == "string" then ex_cf = fusf.FindFuncCatch(catch, "ex_cf", ex_cf) end
			mg = mg + fugf.Filter(mg2, ex_cf, c)
		end

		Duel.SetSelectedCard(Duel.GetMustMaterial(tp,EFFECT_MUST_BE_XMATERIAL))
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
		Auxiliary.GCheckAdditional = Auxiliary.TuneMagicianCheckAdditionalX(EFFECT_TUNE_MAGICIAN_X)
		if gf and type(gf) == "string" then gf = fusf.FindFuncCatch(catch, "gf", gf) end
		mg = mg:SelectSubGroup(tp, fuef.PX_goal, Duel.IsSummonCancelable(), minc, maxc, tp, c, gf)
		Auxiliary.GCheckAdditional = nil

		if ex_op then
			if type(ex_op) == "string" then ex_op = fusf.FindFuncCatch(catch, "ex_op", ex_op) end
			ex_op(e, c, tp, 1)
		end

		if not mg or #mg == 0 then return false end
		mg:KeepAlive()
		e:SetLabelObject(mg)
		return true
	end
end
---------------------------------------------------------------- local
--- 修正效果建立时的三个参数：赋予者(owner)、被赋予者(target)、是否强制注册(force)
-- 根据参数类型推断调用者的意图，并统一为标准形式返回，用于 fuef.New
-- @param owner Card/Effect/player/boolean/nil - 效果赋予者；若为 player/boolean/nil，将视为 target
-- @param target Card/Group/player/boolean/nil - 效果被赋予对象；若为 true 表示强制注册
-- @param force boolean/nil - 是否强制注册；预设为 false
-- @return owner(Card/Effect/nil), target(Card/Group/player/nil), force(boolean)
local function FixEffectAssignArgs(owner, target, force)
	if owner == false or owner == 0 or owner == 1 then
		owner, target = nil, owner
	else
		fusf.CheckTypes(owner, "nil/Card/Effect")
	end

	if target == true then
		target, force = nil, true
	elseif target ~= false then
		local typ = fusf.CheckTypes(target, "nil/Card/Group/table/player")
		if typ == "Card" or typ == "Group" then
			target = fusf.ToGroupTable(target)
		end
	end

	force = fusf.CheckType(force or false, "boolean")

	return owner, target, force
end

--- 检查 val 是否为有效的 value 格式，用于 fuef:Func
-- @param val any 欲检查的值
-- @param val_typ string 值的型别
-- @return boolean 是否符合格式
local function MatchValFormat(val, val_typ)
	if val_typ ~= "string" then return true end
	if val:match("%,") then return false end
	return tonumber(val) or fucs.val[val] or (val:sub(-4, -2):lower() == "val")
end

---------------------------------------------------------------- 
--- 建立一个新的效果表（fuef 物件），初始化基本栏位
--
-- - 若 `owner` 为 nil，仅建立效果表而不创建 Effect 实体，需后续呼叫 `:InitSetOwner(owner)` 补足。
-- - 若 `owner` 为 Effect 或 Card，则立即创建 Effect 并进行注册。
----- 建立一个新的效果表（fuef 物件），初始化基本栏位
--
-- - 若 `owner` 为 nil，仅建立效果表而不创建 Effect 实体，需后续呼叫 `:InitSetOwner(owner)` 补足。
-- - 若 `owner` 为 Effect 或 Card，则立即创建 Effect 并进行注册。
--
-- @param log 日志对象或层级（用于调试记录）
-- @param typ string|number 效果类型（支援常数名或数值，将转换为 EFFECT_TYPE_* 常数）
-- @param cod string|number|nil 效果代码（支援常数名或数值，将转换为 EVENT_* 常数，可为 nil）
-- @param owner nil|Effect|Card 效果实体的持有者（若为 nil，仅建立表，不创建实体）
-- @param target boolean|Card|Group|player 注册目标（传入至 Reg 中），若为 boolean 则视为 force
-- @param force boolean 是否强制注册，跳过效果限制检查
-- @return table fuef 物件（含 typ, cod, handler, force 等栏位）
-- @raise 若 owner 非 nil 且无法转为卡片时，建立 Effect 可能触发错误
function fuef.New(log, typ, cod, owner, target, force)
	local log = fudf.StartLog(log, "fuef.New", typ, cod, owner, target, force)

	local E = setmetatable({}, fuef)

	E.typ = fusf.ParseConstantKey("etyp", typ)
	log:Info("set self.typ : "..fusf.CutHex(E.typ))

	if cod then 
		E.cod = fusf.ParseConstantKey("cod", cod)
		log:Info("set self.cod : "..E.cod)
	end

	owner, target, force = FixEffectAssignArgs(owner, target, force)

	E.handler = target
	log:Info("set handler : "..fusf.Type(target))

	E.force = force
	log:Info("set force : "..tostring(force))

	log:Info("has owner : "..tostring(not not owner))
	if not owner then return E end

	E.e = Effect.CreateEffect(fusf.ToCard(owner))
	log:Info("set self.e")

	E.e:SetType(E.typ)
	log:Info("self.e SetType : "..fusf.CutHex(E.typ))

	if E.cod then 
		E.e:SetCode(E.cod)
		log:Info("self.e SetCode : "..E.cod)
	end

	return E:Reg(log)
end

-- 注册 fuef 给 self.handler, 没有则注册给 owner
-- @param log 日志对象或层级（用于调试记录）
-- @return table 返回调用者 self，支持链式调用
function fuef:Reg(log, target, force)
	if self.isinit then return self end
	local log = fudf.StartLog(log, "fuef:Reg")

	if self.handler == false then
		log:Info("no RegisterEffect")
		self.handler = false
		return self
	end

	local tg_typ = fusf.CheckTypes(self.handler, "nil/table/player")

	if tg_typ == "player" then
		log:Info("RegisterEffect to player")
		Duel.RegisterEffect(self.e, self.handler)
		return self
	elseif tg_typ == "nil" then
		self.handler = { self.e:GetOwner() }
		log:Info("set self.handler is owner")
	end

	if self.force == nil then
		self.force = false
		log:Info("set self.force is false")
	end

	local rg = self.handler
	local fc = rg[1]
	fc:RegisterEffect(self.e, self.force)
	if #rg > 1 then
		self.clones = { }
		for i = 2, #rg do
			local e = self.e:Clone()
			table.insert(self.clones, e)
			local c = rg[i]
			c:RegisterEffect(e, self.force)
		end
	end

	log:Info("RegisterEffect to "..(#rg).." Card")
	return self
end

--- 支援语法糖：fuef物件可直接以 () 调用以复制自身
-- 等同于 self:Clone(...)
function fuef:__call(cod, target, force)
	return self:Clone(cod, target, force)
end

--- 复制当前 fuef 效果对象，可用于复制已有效果结构
-- @param cod string|number|fuef 替换的 cod, 赋予效果会将 cod 放到 OBJ
-- @param target 注册目标，同 Reg 函数
-- @param force 是否强制注册，同 Reg 函数
-- @return table 新的 fuef 对象，可链式调用
-- @raise cod 为 number 且用于 GRANT 类型时抛错；self.e 类型不正确时报错
function fuef:Clone(cod, target, force)
	local log = fudf.StartLog(0, "fuef:Clone", cod, target, force)

	local cod_typ = fusf.CheckArgType("Clone", 1, cod, "string/number/fuef")

	local E = setmetatable({}, fuef)
	log:Info("try Clone All key")
	local keys = "typ,des,cat,pro,ran,tran,ctl,val,con,cos,tg,op,func,res,lab,obj,pl,handler,force"
	for _,key in keys:ForCut() do
		E[key] = self[key] or nil
	end

	log:Info("check self.typ is F+G")
	if E.typ == EFFECT_TYPE_FIELD + EFFECT_TYPE_GRANT then
		E:OBJ(cod)
	else
		E.cod = fusf.ParseConstantKey("cod", cod)
		log:Info("set self.cod : "..E.cod)
	end

	local e_typ, e = fusf.CheckTypes(self.e, "nil/Effect")
	if e_typ == "Effect" then
		log:Info("Clone Effect E")
		E.e = e:Clone()

		local _, target, force = FixEffectAssignArgs(nil, target, force)

		if target then
			E.handler = target
			log:Info("set E.handler : "..fusf.Type(target))
		end

		E.force = force
		log:Info("set E.force : "..tostring(force))

		E.depth = log.depth
		return E:SetKey(log):Reg(log)
	end

	E.pre = self
	self.aft = E
	log:Info("set E.pre and self.aft")
	return E
end

--- 初始化 fuef 链条的 Effect 实体，并设置所有字段属性
--
-- - 本方法用于延迟注册效果表（fuef），在 `initial_effect` 中设定持有者（owner）并依序初始化整条链。
-- - 链的起点是最早创建的 fuef（无 pre），终点为当前对象或后续的 aft。
-- - 每个节点会调用 `fuef.New` 创建 Effect 实体，依照字段依序设置属性（des、cat、val 等）。
-- - 所有链条节点都会生成独立实体效果，并注册（呼叫 `:Reg()`）。
--
-- ⚠ 若创建时未传入 owner，此函数为唯一可创建 Effect 实体的注册点。
--
-- @param name string 名称（用于日志打印）
-- @param owner Card|Effect 效果持有者（会被转为卡片用作 Effect.CreateEffect）
-- @param target nil|player 注册目标（用于设置 handler 字段，或 Reg 注册位置）
-- @return fuef 链尾节点（最后一个完成注册的效果表）
function fuef:InitSetOwner(name, owner, target)
	local log = fudf.StartLog(1, "fuef:InitSetOwner", name, owner, target)

	local tg_typ = fusf.CheckArgType("InitSetOwner", 2, target, "nil/player")

	log:Info("find root")
	local root = self
	while root.pre do
		root = root.pre
	end

	log:Info("set root owner")
	local keys = "des,cat,pro,ran,tran,ctl,val,con,cos,tg,op,func,res,lab,obj,pl"
	local last
	repeat
		if tg_typ == "player" then
			root.handler = target
		end
		last = fuef.New(log, root.typ, root.cod, owner, root.handler)
		last.isinit = true
		for _, key in keys:ForCut() do
			if root[key] then
				local method = key:sub(1,1):upper()..key:sub(2)
				log:Info("try call fuef:"..method)
				fuef[method](last, table.unpack(root[key], 1, root[key].n))
			end
		end
		last.isinit = nil
		last:Reload(log)
		root = root.aft
	until not root
	log:Info(name.." set owner down")

	return last
end

-- 设置单个 Effect 属性（适用于非解包参数）
-- @param log 日志对象或层级（用于调试记录）
-- @param set_key Effect 的方法名，例如 "SetType"
-- @param val_key 当前对象中的字段名，例如 "typ"
-- @param val_typ 允许的类型，可以是字符串（"number"）或多个类型的字符串（"function/number"）或表
-- @return fuef 返回调用者 self，支持链式调用
function fuef:SetEffVal(log, set_key, val_key, val_typ)
	local val = self[val_key]
	if not val then return self end
	fusf.CheckTypes(val, val_typ)
	Effect[set_key](self.e, val)
	log:Info(set_key)
	return self
end

-- 设置需要 unpack 参数的 Effect 属性（适用于参数为 table 的字段）
-- @param log 日志对象或层级（用于调试记录）
-- @param set_key Effect 的方法名，例如 "SetTargetRange"
-- @param val_key 当前对象中的字段名，例如 "tran"
-- @return fuef 返回调用者 self，支持链式调用
function fuef:SetEffValUnpack(log, set_key, val_key)
	local val = self[val_key]
	if not val then return self end
	fusf.CheckType(val, "table")
	Effect[set_key](self.e, table.unpack(val))
	log:Info(set_key)
	return self
end

-- 主设置函数：设置当前对象（fuef）中所有已定义的 Effect 关键字段
-- 支持类型检查、空值跳过、调试输出
-- @param log 日志对象或层级（用于调试记录）
-- @return fuef 返回调用者 self，支持链式调用
function fuef:SetKey(log)
	local log = fudf.StartLog(log, "fuef:SetKey")

	self:SetEffVal(log, "SetType", "typ", "number")
	self:SetEffVal(log, "SetCode", "cod", "number")
	self:SetEffVal(log, "SetDescription", "des", "number")
	self:SetEffVal(log, "SetCategory", "cat", "number")
	self:SetEffVal(log, "SetProperty", "pro", "number")
	self:SetEffVal(log, "SetRange", "ran", "number")
	self:SetEffValUnpack(log, "SetTargetRange", "tran")
	self:SetEffValUnpack(log, "SetCountLimit", "ctl")
	self:SetEffVal(log, "SetValue", "val", "function/number/boolean")
	self:SetEffVal(log, "SetCondition", "con", "function")
	self:SetEffVal(log, "SetCost", "cos", "function")
	self:SetEffVal(log, "SetTarget", "tg", "function")
	self:SetEffVal(log, "SetOperation", "op", "function")
	self:SetEffValUnpack(log, "SetReset", "res")
	self:SetEffValUnpack(log, "SetLabel", "lab")
	self:SetEffVal(log, "SetLabelObject", "obj", "Card/Group/Effect")
	self:SetEffVal(log, "SetOwnerPlayer", "pl", "player")

	return self
end

-- 输出当前 fuef 对象的字段信息，用于调试
function fuef:Info()
	if self.typ then Debug.Message("typ : "..fusf.CutHex(self.typ))end
	if self.cod then Debug.Message("cod : "..self.cod) end
	if self.des then Debug.Message("des : "..(self.des//16)..", "..(self.des%16)) end
	if self.cat then Debug.Message("cat : "..fusf.CutHex(self.cat)) end
	if self.pro then Debug.Message("pro : "..fusf.CutHex(self.pro)) end
	if self.ran then Debug.Message("ran : "..self.ran) end
	if self.tran then Debug.Message("tran : "..table.concat(self.tran, ", ")) end
	if self.ctl then Debug.Message("ctl : "..table.concat(self.ctl, ", ")) end
	if self.val then Debug.Message("val : "..tostring(self.val)) end
	if self.con then Debug.Message("con : "..tostring(self.con)) end
	if self.cos then Debug.Message("cos : "..tostring(self.cos)) end
	if self.tg then Debug.Message("tg : "..tostring(self.tg)) end
	if self.op then Debug.Message("op : "..tostring(self.op)) end
	if self.res then Debug.Message("res : "..fusf.CutHex(self.res[1])..", "..self.res[2]) end
	if self.lab then Debug.Message("lab : "..table.concat(self.lab, ", ")) end
	if self.obj then Debug.Message("obj : "..fusf.Type(self.obj)) end
	if self.handler then Debug.Message("handler : "..fusf.Type(self.handler)) end
end

--- initial 检查，仅当尚未创建效果实体（self.e 为 nil）时执行初始化
-- @param log 日志对象或层级（用于调试记录）
-- @param key string 要初始化的字段名（会转为小写）
-- @param ... any 初始化值，将作为 table 存入字段
-- @return boolean 是否在 initial 调用
function fuef:InitCheck(log, key, ...)
	if self.e then return false end
	local log = fudf.StartLog(log, "fuef:InitCheck", key, ...)

	self[key] = table.pack(...)
	log:Info("set self."..key)
	return true
end

--- 重置 fuef.e 并以 fuef.e 的 owner 再创建一个效果并重新应用 Key
-- 会先 Reset 原本的效果实体并重新创建，清除 clones
-- @param log 日志对象或层级（用于调试记录）
-- @return fuef 返回 self（可链式调用）
function fuef:Reload(log)
	if self.isinit then return self end
	local log = fudf.StartLog(log, "fuef:Reload")

	log:Info("recreate Effect")
	local owner = self.e:GetOwner()
	self.e:Reset()
	self.e = Effect.CreateEffect(owner)

	if self.clones and #self.clones > 0 then
		log:Info("clean self.clones")
		for _, e in ipairs(self.clones) do
			e:Reset()
		end
		self.clones = nil
	end

	return self:SetKey(log):Reg(log)
end

----------------------------------------------------------------DES

--- 设置描述字段（des），支持延迟初始化
-- 若尚未创建效果实体，则记录并延后设置；否则立即设置并重载
-- @param code string|number 描述代码（将传入 ResolveDescription）
-- @param id string|number 描述 ID（将传入 ResolveDescription）
-- @return fuef 返回 self（可链式调用）
function fuef:Des(code, id)
	local log = fudf.StartLog(self, "fuef:Des", code, id)

	fusf.CheckEmptyArgs("Des", code, id)

	if self:InitCheck(log, "des", code, id) then return self end

	local m = self.e:GetOwner():GetOriginalCode()
	self.des = fusf.ResolveDescription(code, id, m)
	log:Info("set self.des : "..self.des)
	return self:Reload(log)
end

----------------------------------------------------------------Const

--- 设定常数型栏位（如 typ、cod、cat 等），若尚未建立效果物件则先记录初始值
-- 若已存在效果物件则立即重新加载
-- @param log 日志对象或层级（用于调试记录）
-- @param key string 栏位名称（如 "typ", "cod", "cat" 等）
-- @param val any 欲设定的常数值（支援名称字串或数值）
-- @return self fuef 物件
function fuef:SetConstField(log, key, val)
	local log = fudf.StartLog(log, "fuef:SetConstField", key, val)

	fusf.CheckArgType(key, 1, val, "number/string")
	key = key:lower()

	if self:InitCheck(log, key, val) then return self end

	local table_key = (key == "typ") and "etyp" or key
	local val, des = fusf.ParseConstantKey(table_key, val)
	self[key] = val
	log:Info(("set self.%s : %s"):format(key, val))

	if key == "cat" and des then 
		self.des = self.des or des
		log:Info("set self.des : "..self.des)
	end

	return self:Reload(log)
end

--- 设定 type
function fuef:Typ(typ)
	local log = fudf.StartLog(self, "fuef:Typ", typ)
	return self:SetConstField(log, "Typ", typ)
end

--- 设定 code
function fuef:Cod(code)
	local log = fudf.StartLog(self, "fuef:Cod", code)
	return self:SetConstField(log, "Cod", code)
end

--- 设定 category
function fuef:Cat(category)
	local log = fudf.StartLog(self, "fuef:Cat", category)
	return self:SetConstField(log, "Cat", category)
end

--- 设定 property
function fuef:Pro(property)
	local log = fudf.StartLog(self, "fuef:Pro", property)
	return self:SetConstField(log, "Pro", property)
end
----------------------------------------------------------------Range

--- 设定效果适用的区域（Range）
-- @param loc string|number 区域常数或其字串名称
-- @return self fuef 物件
function fuef:Ran(loc)
	local log = fudf.StartLog(self, "fuef:Ran", loc)

	fusf.CheckArgType("Ran", 1, loc, "number/string")

	if self:InitCheck(log, "ran", loc) then return self end

	loc = fusf.GetLoc(loc)

	self.ran = loc
	log:Info("set self.ran : "..loc)
	return self:Reload(log)
end

--- 设定效果于自己与对手区域的作用范围（TargetRange）
-- @param self_loc string|number 自己场地的区域
-- @param oppo_loc string|number 对手场地的区域
-- @return self fuef 物件
function fuef:Tran(self_loc, oppo_loc)
	local log = fudf.StartLog(self, "fuef:Tran", self_loc, oppo_loc)

	fusf.CheckEmptyArgs("Tran", self_loc, oppo_loc)

	if self:InitCheck(log, "tran", self_loc, oppo_loc) then return self end

	self_loc, oppo_loc = fusf.GetLoc(self_loc, oppo_loc)

	self.tran = {self_loc, oppo_loc}
	log:Info(("set self.tran : %s / %s"):format(self_loc, oppo_loc))
	return self:Reload(log)
end

----------------------------------------------------------------CountLimit

--- 设定效果限制条件（Count Limit），支援多种输入格式。
-- @param count number|string 可为数字（使用次数）或字串（如 "100+O"）
-- @param code number|string|nil 可为卡号、字符串（含限制类型 "O/D/C"），或留空
-- @param pro string|nil 限制类型（"O"=OATH, "D"=DUEL, "C"=CHAIN）
-- @return fuef 返回自身以支援链式调用
function fuef:Ctl(count, code, pro)
	local log = fudf.StartLog(self, "fuef:Ctl", count, code, pro)

	fusf.CheckEmptyArgs("Ctl", count, code, pro)

	if self:InitCheck(log, "ctl", count, code, pro) then return self end

	local ct_typ = fusf.CheckArgType("Ctl", 1, count, "number/string")
	if ct_typ == "string" or count > 99 then -- ("n+D") or (m) -> (1, "n+D") or (1, m)
		count, code, pro = 1, count, code
	end

	local cod_typ = fusf.CheckArgType("Ctl", 2, code, "nil/number/string")
	local m = self.e:GetOwner():GetOriginalCode()   
	local ctl_consts = fusf.Findfucs("ctl")
	local _code, _pro = 0, 0
	
	fusf.CheckArgType("Ctl", 3, pro, "nil/string")
	if pro then
		_pro = fusf.FindTables(pro, ctl_consts)
	end

	if cod_typ == "number" then
		_code = fusf.NormalizeID(code, m)
	elseif cod_typ == "string" then
		for _, val in code:ForCut("+") do
			local match = val:match("[ODC]")
			if match then
				if _pro ~= 0 then
					error("repeat set fuef:Ctl pro in string", 2)
				end
				_pro = fusf.FindTables(match, ctl_consts)
			else
				_code = fusf.NormalizeID(val, m)
			end
		end
	end

	if _code == 0 and (_pro == ctl_consts["O"] or _pro == ctl_consts["D"]) then
		_code = m
	end

	self.ctl = {count, _code + _pro}
	log:Info(("set self.ctl : %s / %s"):format(count, self.ctl[2]))
	return self:Reload(log)
end
----------------------------------------------------------------VAL, CON, COS, TG and OP

--- 设定函数型栏位，如 val、con、tar、op 等，可接受函数名、表达式或函数本体
-- @param log 日志对象或层级（用于调试记录）
-- @param key string 欲设定的栏位名称
-- @param func string|function|number 欲指定的函数或值
-- @param ... 可选的参数，用于传递给 ResolveFunction 或 ParseCallExprString
-- @return fuef 返回自身以支援链式调用
function fuef:SetFuncField(log, key, func, ...)
	local log = fudf.StartLog(log, "fuef:SetFuncField", key, func, ...)
	fusf.CheckEmptyArgs(key, func, ...)
	key = key:lower()

	local types = "string/function"
	if key == "val" then types = types.."/number" end
	local f_typ = fusf.CheckArgType(key, 1, func, types)

	if self:InitCheck(log, key, func, ...) then return self end

	local has_arg = select("#", ...) > 0

	if f_typ == "function" then
		if has_arg then func = func(...) end
		self[key] = func
		log:Info(("set self.%s : %s"):format(key, tostring(func)))
		return self:Reload(log)
	end

	if key == "val" then
		local val = tonumber(func) or fucs.val[func] or aux[func]

		if val ~= nil then 
			self.val = val
			log:Info("set self.val : "..tostring(val))
			return self:Reload(log)
		end
	end

	local f, args = func, nil
	if has_arg then args = table.pack(...) end
	if func:match("%(") then
		f, args = fusf.ParseCallExprString(func, args)
	end
	local c = self.e:GetOwner()
	f = fusf.ResolveFunction(f, args, fusf.Getcm(c), c.lib)

	self[key] = f
	log:Info(("set self.%s : %s"):format(key, tostring(f)))
	return self:Reload(log)
end

--- 设定效果的 value（数值或函数），可为 number|string|function
-- @param val number|string|function 数值或函数（或名称）
-- @param ... 可选的额外参数（若 val 是函数字串会带入）
-- @return fuef 返回自身以支援链式调用
function fuef:Val(val, ...)
	local log = fudf.StartLog(self, "fuef:Val", val, ...)
	return self:SetFuncField(log, "Val", val, ...)
end

--- 设定效果的 condition（条件），可为 string|function
-- @param condition function|string 条件函数或其名称
-- @param ... 可选的额外参数（若为函数字串会带入）
-- @return fuef 返回自身以支援链式调用
function fuef:Con(condition, ...)
	local log = fudf.StartLog(self, "fuef:Con", condition, ...)
	return self:SetFuncField(log, "Con", condition, ...)
end

--- 设定效果的 cost（代价），可为 string|function
-- @param cost function|string 条件函数或其名称
-- @param ... 可选的额外参数（若为函数字串会带入）
-- @return fuef 返回自身以支援链式调用
function fuef:Cos(cost, ...)
	local log = fudf.StartLog(self, "fuef:Cos", cost, ...)
	return self:SetFuncField(log, "Cos", cost, ...)
end

--- 设定效果的 target（目标），可为 string|function
-- @param target function|string 条件函数或其名称
-- @param ... 可选的额外参数（若为函数字串会带入）
-- @return fuef 返回自身以支援链式调用
function fuef:Tg(target, ...)
	local log = fudf.StartLog(self, "fuef:Tg", target, ...)
	return self:SetFuncField(log, "Tg", target, ...)
end

--- 设定效果的 operation（执行动作），可为 string|function
-- @param operation function|string 条件函数或其名称
-- @param ... 可选的额外参数（若为函数字串会带入）
-- @return fuef 返回自身以支援链式调用
function fuef:Op(operation, ...)
	local log = fudf.StartLog(self, "fuef:Op", operation, ...)
	return self:SetFuncField(log, "Op", operation, ...)
end

--- 依据传入的函数结构设定 fuef 物件的多个栏位（val/con/cos/tg/op）
-- 支援多种格式的输入，并自动解析每一段功能模块，依照顺序填入栏位
-- @param val 可能是 val 值，或实际的函数名（视情况而定）
-- @param func 字串描述或 table 结构，代表要设置的功能函数模块
-- @param ... 其他额外参数，可能为 val 的对应值，或函数模块的参数
-- @return fuef 返回自身以支援链式调用
function fuef:Func(val, func, ...)
	local log = fudf.StartLog(self, "fuef:Func", val, func, ...)

	fusf.CheckEmptyArgs("Func", val, func, ...)

	if self:InitCheck(log, "func", val, func, ...) then return self end

	local val_typ = fusf.CheckArgType(up_key, 1, val, "string/function/number")

	log:Info("try match val")
	local args = {...}
	if MatchValFormat(val, val_typ) then
		self:SetFuncField(log, "val", val, ...)
	else
		func, args = val, {func, ...}
	end

	local c = self.e:GetOwner()
	local cm = fusf.Getcm(c)
	local keys, key_ind = {"val", "con", "cos", "tg", "op"}, 1
	local func_table = fusf.ParseCallGroupString(func, args)
	if func_table.n > 5 then error("Func : invalid func len", 2) end

	log:Info("try match keys")
	for i, unit in fusf.ForTable(func_table) do
		local fname, fargs = unit
		if type(unit) == "table" then
			fname, fargs = unit[1], unit[2]
		end
		log:Info(i.." : "..fname)

		local f = fusf.ResolveFunction(fname, fargs, cm, c.lib)

		local match = 0
		for j = key_ind, 5 do
			local ind = fname:find(keys[j])
			if ind and ind > match then
				key_ind, match = j, ind
			end
		end
		if match == 0 then key_ind = i end

		local key = keys[key_ind]
		log:Info("match "..key)
		self:SetFuncField(log, key, f)
	end
	log:Info("all match down")

	return self
end
----------------------------------------------------------------RES

--- 设定效果的 reset（重置条件）
-- @param flag string|number 条件描述（如 "a + b - c , 1"）
-- @param count number? 可选的重置次数，若省略则从字串中解析
-- @return fuef 返回自身以支援链式调用
function fuef:Res(flag, count)
	local log = fudf.StartLog(self, "fuef:Res", flag, count)

	fusf.CheckEmptyArgs("Res", flag, count)

	if self:InitCheck(log, "res", flag, count) then return self end

	flag, count = fusf.ResolveReset(flag, count)
	self.res = {flag, count}
	log:Info(("set self.res : %s / %d"):format(fusf.CutHex(flag), count))
	return self:Reload(log)
end
----------------------------------------------------------------LAB & OBJ

--- 设定 label 参数，支援数字、字串（可用 "+" 拆分）与特别标记 "m"
-- @param ... 可为数字、字串（如 "1+2+m"）等，会转为数字阵列
-- @return fuef 返回自身，用于链式调用
function fuef:Lab(...)
	local log = fudf.StartLog(self, "fuef:Lab", ...)

	fusf.CheckEmptyArgs("Lab", ...)

	if self:InitCheck(log, "lab", ...) then return self end

	local m = self.e:GetOwner():GetOriginalCode()
	local args = {}
	for i, val in ipairs{...} do
		local typ = fusf.CheckArgType("Lab", i, val, "string/number")
		if typ == "string" then
			for _, lab in val:ForCut("+") do
				args[#args + 1] = (lab == "m") and m or tonumber(lab)
			end
		else
			args[#args + 1] = val
		end
	end

	self.lab = args
	log:Info(("set self.lab : %d arg"):format(#args))
	return self:Reload(log)
end

--- 设置效果的关联对象（object），可为字符串代号或实际对象
-- @param val string|Card|Group|Effect 关联对象，字符串将解析为 cm.elist 的键
-- @return fuef 返回自身，用于链式调用
-- @raise 类型不符时抛出错误
function fuef:Obj(val)
	local log = fudf.StartLog(self, "fuef:Obj", val)

	local typ = fusf.CheckArgType("Obj", 1, val, "string/fuef/Card/Group/Effect")

	if self:InitCheck(log, "obj", val) then return self end

	if typ == "string" then
		local e = fusf.Getcm(self).elist[val]
		if not e or not e.e then
			error("Obj: elist entry for '" .. val .. "' is missing or invalid", 2)
		end
		val = fusf.CheckType(e.e, "Effect")
	end

	self.obj = val
	log:Info("set self.obj : "..typ)
	return self:Reload(log)
end
---------------------------------------------------------------- OwnerPlayer
--- 设置效果的 OwnerPlayer 属性为 player
-- @param p player 玩家
-- @return self fuef 物件
function fuef:Pl(p)
	local log = fudf.StartLog(self, "fuef:Pl", p)

	fusf.CheckArgType("Pl", 1, p, "player")

	if self:InitCheck(log, "Pl", p) then return self end

	self.pl = p
	log:Info("set self.pl : "..p)
	return self:Reload(log)
end

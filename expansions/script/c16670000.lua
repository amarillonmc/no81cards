--存在之间
it = it or {}
local cm = nil
if it.to == true then return end
it.to = true
--简易区域
QY_kz = LOCATION_DECK
QY_sp = LOCATION_HAND
QY_sk = LOCATION_HAND
QY_gs = LOCATION_MZONE
QY_mx = LOCATION_SZONE
QY_md = LOCATION_GRAVE
QY_cw = LOCATION_REMOVED
QY_ew = LOCATION_EXTRA
QY_cl = LOCATION_OVERLAY
QY_cs = LOCATION_ONFIELD
--简易重置时点
CZ_lcjs = RESET_EVENT + RESETS_STANDARD + RESET_OVERLAY + RESET_MSCHANGE + RESET_PHASE + PHASE_END --离场+结束阶段
CZ_lc = RESET_EVENT + RESETS_STANDARD + RESET_OVERLAY + RESET_MSCHANGE                             --离场重置
CZ_js = RESET_PHASE + PHASE_END                                                                    --结束阶段重置
--增加卡片组库函数
-- Group.gf=Group.GetFirst
--简易设置效果
xg = xg or {}
function xg.epp(c, id, su, ...) --XG.epp(c,id,su,...) 不推荐使用
	local e1 = Effect.CreateEffect(c)
	if su ~= nil then
		local l1 = { "Range", "HintTiming", "Code", "Type", "Property", "Category", "Description" }
		local l2 = { "Target", "Cost", "Condition" }
		for _, o in pairs(l1) do
			if su[o] == nil or su[o] == "" then
				su[o] = 0
			end
		end
		for _, o in pairs(l2) do
			if su[o] == nil or su[o] == "" then
				su[o] = aux.TRUE
			end
		end
	else
		local su = {}
		local ext_params = { ... }
		su["Description"], su["Category"], su["Property"], su["Type"], su["Code"], su["HintTiming"]
		, su["Range"], su["Condition"], su["Cost"], su["Target"], su["Operation"] = table.unpack(ext_params)
		for _, o in pairs(l1) do
			if su[o] == nil or su[o] == "" then
				su[o] = 0
			end
		end
		for _, o in pairs(l2) do
			if su[o] == nil or su[o] == "" then
				su[o] = cm.TRUE
			end
		end
	end
	e1:SetDescription(aux.Stringid(id, su["Description"]))
	e1:SetCategory(su["Category"])
	e1:SetProperty(su["Property"])
	e1:SetType(su["Type"])
	e1:SetCode(su["Code"])
	e1:SetHintTiming(su["HintTiming"])
	e1:SetRange(su["Range"])
	e1:SetCondition(su["Condition"])
	e1:SetCost(su["Cost"])
	e1:SetTarget(su["Target"])
	e1:SetOperation(su["Operation"])
	return e1
end

function xg.epp2(c, id, cf, co, ta, qy, h1, h2, h3, h4, zc) --XG.epp2(c,m,2,nil,3,QY_sp)
	--卡,卡号,效果类型,效果内容或时点,特殊性质,生效区域,检测,cost,对象,内容,是否直接注册
	local c1, c2, c3, c4 = 0, 0, 0, 0
	local e1 = Effect.CreateEffect(c)
	if cf == 1 then
		c1 = EFFECT_TYPE_IGNITION
	elseif cf == 2 then
		c1 = EFFECT_TYPE_QUICK_O
		c2 = EVENT_FREE_CHAIN
	elseif cf == 3 then
		c1 = EFFECT_TYPE_SINGLE|EFFECT_TYPE_TRIGGER_O
	elseif cf == 4 then
		c1 = EFFECT_TYPE_FIELD|EFFECT_TYPE_TRIGGER_O
	elseif cf == 5 then
		c1 = EFFECT_TYPE_SINGLE|EFFECT_TYPE_CONTINUOUS
	elseif cf == 6 then
		c1 = EFFECT_TYPE_FIELD|EFFECT_TYPE_CONTINUOUS
	elseif cf ~= nil then
		c1 = cf
	end
	if co ~= nil then
		c2 = c2|co --永续效果或诱发时点
	end
	if c2 < 1000 then
		c3 = c3|EFFECT_FLAG_SINGLE_RANGE
	end
	if (ta == 1 or c2 < 1000) and (ta ~= nil and ta > 1) then
		c3 = c3|EFFECT_FLAG_SINGLE_RANGE
	elseif ta == 2 then
		c3 = c3|EFFECT_FLAG_PLAYER_TARGET
	elseif ta == 3 then
		c3 = c3|EFFECT_FLAG_CARD_TARGET
	elseif ta == 4 then
		c3 = c3|EFFECT_FLAG_UNCOPYABLE + EFFECT_FLAG_CANNOT_DISABLE
	elseif ta ~= nil then
		c3 = c3|ta
	end
	if qy ~= nil then
		e1:SetRange(qy)
	end
	e1:SetType(c1)
	e1:SetCode(c2)
	e1:SetProperty(c3)
	if zc == true then
		c:RegisterEffect(e1)
	end
	if h1 ~= nil then
		e1:SetCondition(h1)
	end
	if h2 ~= nil then
		e1:SetCost(h2)
	end
	if h3 ~= nil then
		e1:SetTarget(h3)
	end
	if h4 ~= nil then
		e1:SetOperation(h4)
	end
	return e1
end

function xg.ky(tp, id, zh) --简易选择是否
	return Duel.SelectYesNo(tp, aux.Stringid(id, zh))
end

--失落之魂
sl = sl or {}
function sl.fuslimit(e, c, sumtype)
	return sumtype == SUMMON_TYPE_FUSION
end

function sl.sc(c)
	local e1 = Effect.CreateEffect(c) --额外特招素材限制
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE + EFFECT_FLAG_UNCOPYABLE + EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(1)
	c:RegisterEffect(e1)
	local e3 = e1:Clone()
	e3:SetCode(EFFECT_CANNOT_BE_FUSION_MATERIAL)
	e3:SetValue(sl.fuslimit)
	c:RegisterEffect(e3)
	local e5 = e1:Clone()
	e5:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL)
	c:RegisterEffect(e5)
	local e6 = e1:Clone()
	e6:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
	c:RegisterEffect(e6)
	return e1, e3, e5, e6
end

--噩梦再临
ez = ez or {}
function ez.zs(c, tp) --非对方回合不能特招和盖放自诉
	local e1 = Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetTargetRange(1, 0)
	e1:SetCondition(function(e, tp2)
		local tp3 = Duel.GetTurnPlayer()
		return tp3 == tp
	end)
	e1:SetValue(1)
	e1:SetReset(RESET_PHASE + PHASE_END, 2)
	Duel.RegisterEffect(e1, tp)
	local e2 = e1:Clone()
	e2:SetCode(EFFECT_CANNOT_SUMMON)
	Duel.RegisterEffect(e2, tp)
	local e4 = e1:Clone()
	e4:SetCode(EFFECT_CANNOT_SSET)
	Duel.RegisterEffect(e4, tp)
	local e3 = e1:Clone()
	e3:SetCode(EFFECT_CANNOT_MSET)
	Duel.RegisterEffect(e3, tp)
end

--魂精 (勿删)
hj = hj or {}

--泛用
cm = it
function cm.GetEffectValue(e, ...) --检测e是否函数，是的场合执行函数内容
	local v = e:GetValue()
	if aux.GetValueType(v) == "function" then
		return v(e, ...)
	else
		return v
	end
end

--
function cm.replace_function(of) --执行函数of，在那个场合，先/后执行一段其他命令（可修改）
	return function(e, tp, eg, ep, ev, re, r, rp, chk, chkc)
		local f = Duel.IsPlayerAffectedByEffect
		Duel.IsPlayerAffectedByEffect = cm.replace_play(f)

		local res = (not of or of(e, tp, eg, ep, ev, re, r, rp, chk, chkc))

		Duel.IsPlayerAffectedByEffect = f
		return res
	end
end

function cm.replace_play(f) --检测玩家是否受到某种类效果影响时可更换tp
	return function(tp, code)
		local p = tp
		return f(p, code)
	end
end

--
function cm.num(num, tp) --检测无尽贪婪已减少多少张卡的使用
	if Duel.GetFlagEffect(tp, 16602091) > 0 then
		local num2 = Duel.GetFlagEffect(tp, 16602091) * 5
		num = num - num2
		if num < 0 then num = 0 end
	end
	return num
end

function cm.sxbl()            --所谓伊人相关检测全种族全属性全等级可特招
	local zzjc = { RACE_WARRIOR, --战士
		RACE_SPELLCASTER,     --魔法师
		RACE_FAIRY,           --天使
		RACE_FIEND,           --恶魔
		RACE_ZOMBIE,          --不死
		RACE_MACHINE,         --机械
		RACE_AQUA,            --水
		RACE_PYRO,            --炎
		RACE_ROCK,            --岩石
		RACE_WINDBEAST,       --鸟兽
		RACE_PLANT,           --植物
		RACE_INSECT,          --昆虫
		RACE_THUNDER,         --雷
		RACE_DRAGON,          --龙
		RACE_BEAST,           --兽
		RACE_BEASTWARRIOR,    --兽战士
		RACE_DINOSAUR,        --恐龙
		RACE_FISH,            --鱼
		RACE_SEASERPENT,      --海龙
		RACE_REPTILE,         --爬虫类
		RACE_PSYCHO,          --念动力
		RACE_DIVINE,          --幻神兽
		RACE_CREATORGOD,      --创造神
		RACE_WYRM,            --幻龙
		RACE_CYBERSE,         --电子界
		RACE_ILLUSION         --幻想魔
	}
	local sxjc = { 0x01, 0x02, 0x04, 0x08, 0x10, 0x20, 0x40 }
	local zzl = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12 }
	local zzx = 0 --可选种族
	for _, z in ipairs(zzjc) do
		zzx = zzx + z
	end
	local sxx = 0 --可选属性
	for _, z in ipairs(sxjc) do
		sxx = sxx + z
	end
	local kx = {} --不可选组合
	for u1, sz in ipairs(zzjc) do
		local num1 = 0
		local sc = true
		for u2, sx in ipairs(sxjc) do
			local num2 = 0
			for ss, sd in ipairs(zzl) do
				if not Duel.IsPlayerCanSpecialSummonMonster(tp, m, 0, TYPE_NORMAL + TYPE_MONSTER, 0, 0, sd, sz, sx) then
					if not kx[sz] then kx[sz] = {} end
					if not kx[sz][sx] then
						num1 = num1 + 1
						kx[sz][sx] = {}
					end
					kx[sz][sx][ss] = sd
					if num1 == #sxjc and sc then
						sc = false
						zzx = zzx - sz
					end
				end
			end
		end
	end
	return kx, zzx, sxx, zzjc, sxjc, zzl --kx为组，zzx大于0代表有可以特招的种族怪兽
end

function cm.sxblx(tp, kx, zzx, sxx, zzl) --宣言1个可特招的种族属性等级 通常配合 it.sxbl() 用
	local zz = Duel.AnnounceRace(tp, 1, zzx)
	for sz, _ in pairs(kx) do
		if sz == zz then
			for sx, _ in pairs(kx[sz]) do
				if #kx[sz][sx] == #zzl then sxx = sxx - sx end
			end
		end
	end
	local slv = {}
	local sx = Duel.AnnounceAttribute(tp, 1, sxx)
	for sz, _ in pairs(kx) do
		if sz == zz then
			for sxxx, _ in pairs(kx[sz]) do
				if sxxx == sx then
					slv = kx[zz][sx]
				end
			end
		end
	end
	local lv = Duel.AnnounceLevel(tp, 1, 12, table.unpack(slv))
	return zz, sx, lv
end

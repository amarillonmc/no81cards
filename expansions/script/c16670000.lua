--存在之间
--V1.0.1.2
local m = 16670000
it = it or {}
it.diyai = { "AI_Nf.ydk", "AI_TheDreamLand.ydk", "AI_best-friend.ydk", "AI_stars.ydk", "AI_Tianjuelong.ydk",
	"AI_RecurringNightmare.ydk" }

it.book = { 16670007, 16670009, 16670012, 16670013, 16670025, 16670030, 16670035, 16670040, 16670045, 16670055, 16670070
, 16670085 }
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
				su[o] = aux.TRUE
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

function xg.epp3(c) --简易创建开局生效
	local e1 = Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD + EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PHASE_START|PHASE_DRAW)
	e1:SetRange(0xffff)
	e1:SetCountLimit(1)
	c:RegisterEffect(e1)
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

--魂精
hj = hj or {}

--泛用
function it.GetEffectValue(e, ...) --检测e的val是否函数，是的场合执行函数内容
	local v = e:GetValue()
	if aux.GetValueType(v) == "function" then
		return v(e, ...)
	else
		return v
	end
end

function it.GetEffect(e, ...) --检查e是否函数
	if aux.GetValueType(v) == "function" then
		return v(e, ...)
	else
		return v
	end
end

--
function it.replace_function(of) --执行函数of，在那个场合，先/后执行一段其他命令
	return function(e, tp, eg, ep, ev, re, r, rp, chk, chkc)
		local f = Duel.IsPlayerAffectedByEffect
		Duel.IsPlayerAffectedByEffect = it.replace_play(f)

		local res = (not of or of(e, tp, eg, ep, ev, re, r, rp, chk, chkc))

		Duel.IsPlayerAffectedByEffect = f
		return res
	end
end

function it.replace_play(f) --检测玩家是否受到某种类效果影响时可更换tp
	return function(tp, code)
		local p = tp
		return f(p, code)
	end
end

--
function it.num(num, tp) --检测无尽贪婪已减少多少张卡的使用
	if Duel.GetFlagEffect(tp, 16602091) > 0 then
		local num2 = Duel.GetFlagEffect(tp, 16602091) * 5
		num = num - num2
		if num < 0 then num = 0 end
	end
	return num
end

function it.sxbl()            --所谓伊人相关检测全种族全属性全等级可特招
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

function it.sxblx(tp, kx, zzx, sxx, zzl) --宣言1个可特招的种族属性等级 通常配合 it.sxbl() 用
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

--为效果e添加模拟魔法发动，如自由时点效果变魔法发动,具体表现为发动前先移到场上，但并未修改实际发动位置，后续可能会有问题
function it.EmulateSZONE(c, e)
	if not it.gall then
		it.gall = true
		it.global_jc = {}
		--
		local l = Effect.IsHasType
		Effect.IsHasType = function(ea, le)
			if ea:GetLabel() == m then return true end
			for z, v in pairs(it.global_jc) do
				for i = 1, #v do
					if v[i] == ea and le == EFFECT_TYPE_ACTIVATE then
						return true
					end
				end
			end
			return l(ea, le)
		end
		local l2 = Card.GetActivateEffect
		Card.GetActivateEffect = function(c)
			local ob = { l2(c) }
			for z, v in pairs(it.global_jc) do
				if z == c then
					for i = 1, #v do
						ob[#ob + 1] = v[i]
					end
				end
			end
			return table.unpack(ob)
		end
		local l3 = Effect.Clone
		Effect.Clone = function(ea)
			local qe = l3(ea)
			if ea:GetLabel() == m then
				return qe
			end
			for z, v in pairs(it.global_jc) do
				for i = 1, #v do
					if v[i] == ea then
						it.global_jc[z][#it.global_jc[z] + 1] = qe
						return qe
					end
				end
			end
			return qe
		end
		--模拟魔法
		local ge13 = Effect.CreateEffect(c)
		ge13:SetType(EFFECT_TYPE_FIELD)
		ge13:SetCode(EFFECT_ACTIVATE_COST)
		ge13:SetTargetRange(1, 1)
		ge13:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		ge13:SetTarget(function(e, te, tp)
			local c = te:GetHandler()
			local e1 = e:GetLabelObject()
			if te:GetLabel() == m then return true end
			for z, v in pairs(it.global_jc) do
				for i = 1, #v do
					if v[i] == te then
						e:SetLabelObject(z)
						return true
					end
				end
			end
			return false
		end)
		ge13:SetOperation(function(e, tp, eg, ep, ev, re, r, rp)
			local c = e:GetLabelObject()
			tp = c:GetControler()
			if c:IsLocation(LOCATION_HAND) then
				if not c:IsType(TYPE_FIELD) then
					Duel.MoveToField(c, tp, tp, LOCATION_SZONE, POS_FACEUP, true)
				else
					local fc = Duel.GetFieldCard(tp, LOCATION_FZONE, 0)
					if fc then
						Duel.SendtoGrave(fc, REASON_RULE)
						Duel.BreakEffect()
					end
					Duel.MoveToField(c, tp, tp, LOCATION_FZONE, POS_FACEUP, true)
				end
				if not c:IsType(TYPE_CONTINUOUS) and not c:IsType(TYPE_FIELD) and not c:IsType(TYPE_EQUIP) then
					c:CancelToGrave(false)
				end
			end
			if c:IsLocation(LOCATION_SZONE) and c:IsType(TYPE_FIELD) then
				local fc = Duel.GetFieldCard(tp, LOCATION_FZONE, 0)
				if fc then
					Duel.SendtoGrave(fc, REASON_RULE)
					Duel.BreakEffect()
				end
				local ta = Duel.GetMatchingGroup(aux.TRUE, tp, 0xfff - LOCATION_MZONE, 0xfff - LOCATION_MZONE, nil)
				local tc = ta:GetFirst()
				Duel.Overlay(tc, c)
				Duel.MoveToField(c, tp, tp, LOCATION_FZONE, POS_FACEUP, true)
			end
			Duel.ChangePosition(c, POS_FACEUP)

			local e1 = Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_FIELD + EFFECT_TYPE_CONTINUOUS)
			e1:SetCode(EVENT_CHAIN_END)
			e1:SetOperation(function(e, tp, eg, ep, ev, re, r, rp)
				if not c:IsType(TYPE_CONTINUOUS) and not c:IsType(TYPE_FIELD) and
					(not c:IsType(TYPE_EQUIP) or (c:IsType(TYPE_EQUIP) and not c:GetEquipTarget())) and c:IsLocation(LOCATION_SZONE) and c:IsHasEffect(EFFECT_REMAIN_FIELD) == nil then
					Duel.SendtoGrave(c, REASON_RULE)
				end
				e:Reset()
			end)
			Duel.RegisterEffect(e1, 0)
		end)
		Duel.RegisterEffect(ge13, 0)
	end
	it.global_jc[c] = it.global_jc[c] or {}
	it.global_jc[c][#it.global_jc[c] + 1] = e

	local co = e:GetCondition()
	e:SetCondition(function(e, tp, eg, ep, ev, re, r, rp)
		local c = e:GetHandler()
		return (not co or co(e, tp, eg, ep, ev, re, r, rp)) and (not c:IsLocation(LOCATION_SZONE) or c:IsFacedown())
	end)
end

function it.AddMonsterate(c, type, attribute, race, level, atk, def) --不会因盖放而重置属性的魔陷怪兽
	local e1_1 = Effect.CreateEffect(c)
	e1_1:SetType(EFFECT_TYPE_SINGLE)
	e1_1:SetCode(EFFECT_CHANGE_TYPE)
	e1_1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE + EFFECT_FLAG_UNCOPYABLE)
	e1_1:SetValue(type)
	e1_1:SetReset(RESET_EVENT + RESETS_STANDARD - RESET_TEMP_REMOVE - RESET_TOFIELD - RESET_LEAVE - RESET_TURN_SET)
	c:RegisterEffect(e1_1, true)
	-- Debug.Message(attribute)
	-- Debug.Message(race)
	-- Debug.Message(level)
	if attribute then
		local e11 = e1_1:Clone()
		e11:SetCode(EFFECT_CHANGE_ATTRIBUTE)
		e11:SetValue(attribute)
		c:RegisterEffect(e11)
	end
	if race then
		local e12 = e1_1:Clone()
		e12:SetCode(EFFECT_CHANGE_RACE)
		e12:SetValue(race)
		c:RegisterEffect(e12)
	end
	if not level then
		level = 1
	end
	local e123 = e1_1:Clone()
	e123:SetCode(EFFECT_UPDATE_LEVEL)
	e123:SetValue(level)
	c:RegisterEffect(e123)
	if atk then
		local e1234 = e1_1:Clone()
		e1234:SetCode(EFFECT_SET_ATTACK)
		e1234:SetValue(atk)
		c:RegisterEffect(e1234)
	end
	if def then
		local e1 = e1_1:Clone()
		e1:SetCode(EFFECT_SET_ATTACK)
		e1:SetValue(def)
		c:RegisterEffect(e1)
	end
end

--模拟装备，让tp为c1建立与c2的模拟装备关系，当c2离场时，c1自毁
function it.CopyEquip(tp, c1, c2, up)
	if not it.mnzb then
		it.mnzb = true
		local l = Card.GetEquipGroup
		Card.GetEquipGroup = function(c)
			local g = l(c)
			if c:IsHasEffect(m) ~= nil then
				local g2 = Duel.GetMatchingGroup(function(c0)
					local e = c0:IsHasEffect(m + 1)
					return e ~= nil and e:GetOwner() == c
				end, tp, 0xfff, 0xfff, nil)
				g:Merge(g2)
			end
			return g
		end
		local l = Card.GetEquipCount
		Card.GetEquipCount = function(c)
			local g = l(c)
			if c:IsHasEffect(m) ~= nil then
				local g2 = Duel.GetMatchingGroup(function(c0)
					local e = c0:IsHasEffect(m + 1)
					return e ~= nil and e:GetOwner() == c
				end, tp, 0xfff, 0xfff, nil)
				g:Merge(g2)
			end
			return #g
		end
		local l = Card.GetEquipTarget
		Card.GetEquipTarget = function(c)
			if c:IsHasEffect(m + 1) ~= nil then
				local e = c:IsHasEffect(m + 1)
				local tg = e:GetOwner()
				return tg
			end
			return l(c)
		end
		local l = Card.GetPreviousEquipTarget
		Card.GetPreviousEquipTarget = function(c)
			if c:IsHasEffect(m + 2) ~= nil then
				local e = c:IsHasEffect(m + 2)
				local tg = e:GetOwner()
				return tg
			end
			return l(c)
		end
	end
	local c = c1
	local e1_1 = Effect.CreateEffect(c) --装备的对象标识
	e1_1:SetType(EFFECT_TYPE_SINGLE)
	e1_1:SetCode(m)
	e1_1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE + EFFECT_FLAG_UNCOPYABLE)
	e1_1:SetValue(1)
	e1_1:SetReset(RESET_EVENT + RESETS_STANDARD)
	c2:RegisterEffect(e1_1, true)
	local e1_2 = Effect.CreateEffect(c2) --被装备卡的标识
	e1_2:SetType(EFFECT_TYPE_SINGLE)
	e1_2:SetCode(m + 1)
	e1_2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE + EFFECT_FLAG_UNCOPYABLE)
	e1_2:SetValue(1)
	e1_2:SetReset(RESET_EVENT + RESETS_STANDARD)
	c:RegisterEffect(e1_2, true)
	local e1_3 = Effect.CreateEffect(c2) --之前装备的卡的标识
	e1_3:SetType(EFFECT_TYPE_SINGLE)
	e1_3:SetCode(m + 2)
	e1_3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE + EFFECT_FLAG_UNCOPYABLE)
	e1_3:SetValue(1)
	c:RegisterEffect(e1_3, true)
	local e1_4 = Effect.CreateEffect(c2) --e1_3的重置条件
	e1_4:SetType(EFFECT_TYPE_FIELD + EFFECT_TYPE_CONTINUOUS)
	e1_4:SetCode(EVENT_EQUIP)
	e1_4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE + EFFECT_FLAG_UNCOPYABLE)
	e1_4:SetOperation(function(e, tp, eg, ep, ev, re, r, rp)
		local c = e:GetHandler()
		if aux.IsInGroup(c, eg) then
			e:Reset()
			e1_3:Reset()
		end
	end)
	c:RegisterEffect(e1_4, true)

	local e9 = Effect.CreateEffect(c2) --持续赋予永续对象
	e9:SetType(EFFECT_TYPE_FIELD + EFFECT_TYPE_CONTINUOUS)
	e9:SetCode(EVENT_ADJUST)
	e9:SetProperty(EFFECT_FLAG_CANNOT_DISABLE + EFFECT_FLAG_UNCOPYABLE)
	e9:SetOperation(function(e, tp, eg, ep, ev, re, r, rp)
		local c = e:GetHandler()
		local tc = Duel.GetMatchingGroup(function(c0)
			local e0 = c0:IsHasEffect(m)
			return e0 ~= nil and e0:GetOwner() == c
		end, tp, 0xfff, 0xfff, nil):GetFirst()
		if tc ~= nil and not tc:IsHasCardTarget(c) then
			c:SetCardTarget(tc)
		elseif tc == nil then
			e:Reset()
		end
	end)
	c:RegisterEffect(e9, true)

	local e1 = Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE + EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_MOVE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE + EFFECT_FLAG_UNCOPYABLE + EFFECT_FLAG_IGNORE_IMMUNE +
		EFFECT_FLAG_SET_AVAILABLE)
	e1:SetOperation(function(e, tp, eg, ep, ev, re, r, rp)
		local c = e:GetHandler()
		if e:GetOwner():IsHasEffect(m + 1) ~= nil and not c:IsLocation(LOCATION_MZONE) and not c:IsLocation(LOCATION_SZONE) then
			Duel.Destroy(e:GetOwner(), REASON_RULE + REASON_LOST_TARGET)
		end
		if (not c:IsLocation(LOCATION_MZONE) and not c:IsLocation(LOCATION_SZONE)) or c:IsFacedown() then
			e:Reset()
		end
	end)
	c2:RegisterEffect(e1, true)
	local e2 = e1:Clone()
	e2:SetCode(EVENT_CHANGE_POS)
	e2:SetOperation(function(e, tp, eg, ep, ev, re, r, rp)
		local c = e:GetHandler()
		if e:GetOwner():IsHasEffect(m + 1) ~= nil and c:IsFacedown() then
			Duel.Destroy(e:GetOwner(), REASON_RULE + REASON_LOST_TARGET)
		end
		if (not c:IsLocation(LOCATION_MZONE) and not c:IsLocation(LOCATION_SZONE)) or c:IsFacedown() then
			e:Reset()
		end
	end)
	c2:RegisterEffect(e2, true)

	if c:IsType(TYPE_CONTINUOUS) or c:IsType(TYPE_FIELD) or c:IsType(TYPE_EQUIP) then
		c:CancelToGrave()
	end
	c1:SetCardTarget(c2)
	local func = function(c)
		local eg = it.Etabe[c]
		for _, v in ipairs(eg) do
			if v ~= nil and aux.GetValueType(v) == "Effect" and v:GetType() == EFFECT_TYPE_EQUIP then
				local v2 = v:Clone()
				v2:SetType(EFFECT_TYPE_FIELD)
				v2:SetRange(0xfff)
				v2:SetTargetRange(0xfff, 0xfff)
				v2:SetTarget(function(e, c2)
					return c2 == c:GetEquipTarget()
				end)
				c:RegisterEffect(v2)
				v:Reset()
			end
		end
	end
	func(c)
	local e12 = Effect.CreateEffect(c)
	e12:SetType(EFFECT_TYPE_FIELD + EFFECT_TYPE_CONTINUOUS)
	e12:SetCode(EVENT_ADJUST)
	e12:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e12:SetReset(RESET_EVENT + RESETS_STANDARD)
	e12:SetOperation(function(e, tp, eg, ep, ev, re, r, rp)
		local c = e:GetHandler()
		func(c)
	end)
	c:RegisterEffect(e12, true)
	local eg = Group.FromCards(c1)
	Duel.RaiseEvent(eg, EVENT_EQUIP, nil, 0, tp, tp, 0)
end

--读取库时的初始化设置
local tableclone = function(tab, mytab)
	local res = mytab or {}
	for i, v in pairs(tab) do res[i] = v end
	return res
end
local _Card = tableclone(Card)
local _Duel = tableclone(Duel)
local _Group = tableclone(Group)

--记录所有被写入到卡上的效果
Card.RegisterEffect = function(c, e, ...)
	if not it.Etabe then
		it.Etabe = {}
	end
	local ab = it.Etabe
	ab[c] = ab[c] or {}
	ab[c][#ab[c] + 1] = e
	return _Card.RegisterEffect(c, e, ...)
end

--尝试使用非k端时的代替函数 （失败了）
-- if not Effect.GetCountLimit then
-- 	local _SetCountLimit = Effect.SetCountLimit
-- 	Effect.SetCountLimit = function(e, num1, num2, ...)
-- 		it[e] = it[e] or {}
-- 		if num1 then
-- 			it[e][#it[e] + 1] = num1
-- 		end
-- 		if num2 then
-- 			it[e][#it[e] + 1] = num2
-- 		end
-- 		return _SetCountLimit(e, num1, num2, ...)
-- 	end
-- 	function Effect.GetCountLimit(e)
-- 		local l = {}
-- 		if it[e] and it[e] > 0 then
-- 			l[1] = it[e][1]
-- 		end
-- 		if it[e] and it[e] > 1 then
-- 			l[2] = it[e][2]
-- 		end
-- 		return table.unpack(l)
-- 	end
-- end

--笨方法
--服务器禁用io库，只能用这种方法了
it.benai = { "AI_LienChan.ydk", "AI_Test.ydk", "AI_Nf.ydk" }
it.ai = {
	["card"] = { [1] = { [1] = 32731036, [2] = 25451383, [3] = 60242223, [4] = 62962630, [5] = 62962630, [6] = 62962630, [7] = 68468459, [8] = 68468459, [9] = 45484331, [10] = 45883110, [11] = 95515789, [12] = 19096726, [13] = 14558127, [14] = 14558127, [15] = 14558127, [16] = 23434538, [17] = 23434538, [18] = 23434538, [19] = 36577931, [20] = 1984618, [21] = 1984618, [22] = 6498706, [23] = 6498706, [24] = 34995106, [25] = 44362883, [26] = 75500286, [27] = 81439173, [28] = 24224830, [29] = 24224830, [30] = 29948294, [31] = 36637374, [32] = 65681983, [33] = 82738008, [34] = 18973184, [35] = 10045474, [36] = 10045474, [37] = 10045474, [38] = 19271881, [39] = 32756828, [40] = 17751597, [41] = 11321089, [42] = 38811586, [43] = 44146295, [44] = 44146295, [45] = 92892239, [46] = 70534340, [47] = 3410461, [48] = 24915933, [49] = 72272462, [50] = 1906812, [51] = 41373230, [52] = 51409648, [53] = 87746184, [54] = 87746184, [55] = 53971455 }, [2] = { [1] = 52927340, [2] = 53143898, [3] = 53143898, [4] = 53143898, [5] = 42790071, [6] = 42790071, [7] = 14558127, [8] = 14558127, [9] = 89538537, [10] = 89538537, [11] = 23434538, [12] = 23434538, [13] = 23434538, [14] = 25533642, [15] = 25533642, [16] = 25533642, [17] = 2295440, [18] = 18144506, [19] = 35261759, [20] = 49238328, [21] = 49238328, [22] = 68462976, [23] = 68462976, [24] = 10045474, [25] = 10045474, [26] = 10045474, [27] = 10813327, [28] = 23924608, [29] = 35146019, [30] = 35146019, [31] = 27541563, [32] = 27541563, [33] = 53936268, [34] = 53936268, [35] = 53936268, [36] = 61740673, [37] = 40605147, [38] = 40605147, [39] = 41420027, [40] = 41420027, [41] = 99916754, [42] = 86221741, [43] = 85289965, [44] = 85289965, [45] = 49725936, [46] = 49725936, [47] = 1508649, [48] = 1508649, [49] = 1508649, [50] = 50588353, [51] = 41999284, [52] = 41999284, [53] = 41999284, [54] = 94259633, [55] = 94259633 }, [3] = { [1] = 16306932, [2] = 13015713, [3] = 92107604, [4] = 16306932, [5] = 94145022, [6] = 13090003, [7] = 94445733, [8] = 31562086, [9] = 16306932, [10] = 13090004, [11] = 67835547, [12] = 13015713, [13] = 23434538, [14] = 68957034, [15] = 13090020, [16] = 23434538, [17] = 92107604, [18] = 94145022, [19] = 31562086, [20] = 13015712, [21] = 68957034, [22] = 94445733, [23] = 23434538, [24] = 31562086, [25] = 67835547, [26] = 30430448, [27] = 93229151, [28] = 94145021, [29] = 13090004, [30] = 67835547, [31] = 94445733, [32] = 13090021, [33] = 13015712, [34] = 13090005, [35] = 68957034, [36] = 30430448, [37] = 30430448, [38] = 73628505, [39] = 13090004, [40] = 13015713, [41] = 29301450, [42] = 13090011, [43] = 13090011, [44] = 13090011, [45] = 13090012, [46] = 13090012, [47] = 13090012, [48] = 13090013, [49] = 13090013, [50] = 13090013, [51] = 93039339, [52] = 5041348, [53] = 13015725, [54] = 55990317, [55] = 28373620 }, [4] = { [1] = 75498415, [2] = 75498415, [3] = 75498415, [4] = 81105204, [5] = 81105204, [6] = 81105204, [7] = 58820853, [8] = 58820853, [9] = 58820853, [10] = 49003716, [11] = 49003716, [12] = 49003716, [13] = 85215458, [14] = 85215458, [15] = 85215458, [16] = 2009101, [17] = 2009101, [18] = 2009101, [19] = 22835145, [20] = 22835145, [21] = 22835145, [22] = 46710683, [23] = 46710683, [24] = 46710683, [25] = 53129443, [26] = 5318639, [27] = 5318639, [28] = 5318639, [29] = 91351370, [30] = 91351370, [31] = 91351370, [32] = 44095762, [33] = 44095762, [34] = 44095762, [35] = 59839761, [36] = 59839761, [37] = 59839761, [38] = 70342110, [39] = 70342110, [40] = 70342110, [41] = 33236860, [42] = 33236860, [43] = 33236860, [44] = 9012916, [45] = 9012916, [46] = 9012916, [47] = 69031175, [48] = 69031175, [49] = 69031175, [50] = 76913983, [51] = 76913983, [52] = 76913983, [53] = 17377751, [54] = 17377751, [55] = 17377751 }, [5] = { [1] = 89631139, [2] = 89631139, [3] = 89631139, [4] = 38517737, [5] = 38517737, [6] = 38517737, [7] = 45467446, [8] = 45467446, [9] = 71039903, [10] = 71039903, [11] = 71039903, [12] = 79814787, [13] = 79814787, [14] = 8240199, [15] = 8240199, [16] = 8240199, [17] = 5133471, [18] = 5133471, [19] = 6853254, [20] = 6853254, [21] = 6853254, [22] = 18144506, [23] = 35261759, [24] = 35261759, [25] = 38120068, [26] = 38120068, [27] = 38120068, [28] = 39701395, [29] = 39701395, [30] = 39701395, [31] = 41620959, [32] = 41620959, [33] = 48800175, [34] = 48800175, [35] = 48800175, [36] = 54447022, [37] = 83764718, [38] = 87025064, [39] = 87025064, [40] = 87025064, [41] = 63422098, [42] = 40908371, [43] = 40908371, [44] = 40908371, [45] = 59822133, [46] = 59822133, [47] = 59822133, [48] = 58820923, [49] = 2530830, [50] = 39030163, [51] = 31801517, [52] = 18963306, [53] = 63767246, [54] = 63767246, [55] = 33909817 }, [6] = { [1] = 89631139, [2] = 55410871, [3] = 89631139, [4] = 80701178, [5] = 31036355, [6] = 38517737, [7] = 80701178, [8] = 80701178, [9] = 95492061, [10] = 95492061, [11] = 95492061, [12] = 53303460, [13] = 53303460, [14] = 53303460, [15] = 14558127, [16] = 14558127, [17] = 23434538, [18] = 55410871, [19] = 55410871, [20] = 31036355, [21] = 31036355, [22] = 48800175, [23] = 48800175, [24] = 48800175, [25] = 70368879, [26] = 70368879, [27] = 70368879, [28] = 21082832, [29] = 46052429, [30] = 46052429, [31] = 46052429, [32] = 24224830, [33] = 24224830, [34] = 24224830, [35] = 73915051, [36] = 10045474, [37] = 10045474, [38] = 37576645, [39] = 37576645, [40] = 37576645, [41] = 31833038, [42] = 85289965, [43] = 74997493, [44] = 5043010, [45] = 65330383, [46] = 38342335, [47] = 2857636, [48] = 28776350, [49] = 75452921, [50] = 3987233, [51] = 3987233, [52] = 99111753, [53] = 98978921, [54] = 41999284, [55] = 41999284 }, [7] = { [1] = 2563463, [2] = 81866673, [3] = 72090076, [4] = 63362460, [5] = 30680659, [6] = 30680659, [7] = 30680659, [8] = 26202165, [9] = 26202165, [10] = 26202165, [11] = 91646304, [12] = 14558127, [13] = 14558127, [14] = 14558127, [15] = 72291078, [16] = 72291078, [17] = 23434538, [18] = 23434538, [19] = 9742784, [20] = 97268402, [21] = 3285551, [22] = 3285551, [23] = 3285551, [24] = 18144506, [25] = 52947044, [26] = 52947044, [27] = 52947044, [28] = 81439173, [29] = 83764718, [30] = 24224830, [31] = 24224830, [32] = 65681983, [33] = 65681983, [34] = 39568067, [35] = 38745520, [36] = 10045474, [37] = 10045474, [38] = 10045474, [39] = 40605147, [40] = 40605147, [41] = 15291624, [42] = 60461804, [43] = 84815190, [44] = 92519087, [45] = 27548199, [46] = 42566602, [47] = 90953320, [48] = 98558751, [49] = 21915012, [50] = 44097050, [51] = 50588353, [52] = 70369116, [53] = 98978921, [54] = 98978921, [55] = 60303245 }, [8] = { [1] = 102380, [2] = 102380, [3] = 102380, [4] = 2851070, [5] = 2851070, [6] = 97396380, [7] = 97396380, [8] = 97396380, [9] = 26302522, [10] = 26302522, [11] = 26302522, [12] = 31305911, [13] = 31305911, [14] = 31305911, [15] = 23205979, [16] = 23205979, [17] = 23205979, [18] = 44789585, [19] = 44789585, [20] = 44789585, [21] = 20264508, [22] = 20264508, [23] = 46918794, [24] = 46918794, [25] = 46918794, [26] = 72302403, [27] = 72302403, [28] = 72302403, [29] = 79323590, [30] = 79323590, [31] = 85562745, [32] = 85562745, [33] = 29843091, [34] = 36468556, [35] = 62279055, [36] = 62279055, [37] = 62279055, [38] = 98139712, [39] = 98139712, [40] = 98139712 }, [9] = { [1] = 33015627, [2] = 33015627, [3] = 33015627, [4] = 7733560, [5] = 7733560, [6] = 7733560, [7] = 41386308, [8] = 3549275, [9] = 45812361, [10] = 45812361, [11] = 45812361, [12] = 19665973, [13] = 19665973, [14] = 19665973, [15] = 60990740, [16] = 60990740, [17] = 60990740, [18] = 35261759, [19] = 35261759, [20] = 59750328, [21] = 59750328, [22] = 98645731, [23] = 98645731, [24] = 98645731, [25] = 91623717, [26] = 91623717, [27] = 12607053, [28] = 12607053, [29] = 18252559, [30] = 18252559, [31] = 18252559, [32] = 24068492, [33] = 24068492, [34] = 24068492, [35] = 27053506, [36] = 27053506, [37] = 27053506, [38] = 29843091, [39] = 29843091, [40] = 29843091, [41] = 36361633, [42] = 36361633, [43] = 36361633, [44] = 37576645, [45] = 37576645, [46] = 37576645, [47] = 62279055, [48] = 62279055, [49] = 62279055, [50] = 67443336, [51] = 67443336, [52] = 67443336, [53] = 75249652, [54] = 75249652, [55] = 75249652, [56] = 83555666, [57] = 41999284, [58] = 41999284, [59] = 41999284 }, [10] = { [1] = 4162088, [2] = 68774379, [3] = 70095154, [4] = 70095154, [5] = 70095154, [6] = 59281922, [7] = 59281922, [8] = 59281922, [9] = 3370104, [10] = 67159705, [11] = 26439287, [12] = 26439287, [13] = 26439287, [14] = 76986005, [15] = 23893227, [16] = 23893227, [17] = 23893227, [18] = 3657444, [19] = 11961740, [20] = 11961740, [21] = 24094653, [22] = 24094653, [23] = 37630732, [24] = 37630732, [25] = 37630732, [26] = 52875873, [27] = 52875873, [28] = 53129443, [29] = 66607691, [30] = 95286165, [31] = 29401950, [32] = 29401950, [33] = 44095762, [34] = 44095762, [35] = 91989718, [36] = 92773018, [37] = 92773018, [38] = 97077563, [39] = 97077563, [40] = 3819470, [41] = 1546123, [42] = 1546123, [43] = 1546123, [44] = 74157028, [45] = 74157028, [46] = 74157028, [47] = 10443957, [48] = 10443957, [49] = 10443957, [50] = 58069384, [51] = 58069384, [52] = 58069384 }, [11] = { [1] = 46986414, [2] = 46986414, [3] = 46986414, [4] = 30603688, [5] = 30603688, [6] = 30603688, [7] = 71007216, [8] = 71007216, [9] = 7084129, [10] = 7084129, [11] = 7084129, [12] = 43722862, [13] = 43722862, [14] = 14558127, [15] = 14558127, [16] = 14824019, [17] = 23434538, [18] = 70117860, [19] = 1784686, [20] = 1784686, [21] = 2314238, [22] = 23314220, [23] = 70368879, [24] = 70368879, [25] = 89739383, [26] = 41735184, [27] = 73616671, [28] = 47222536, [29] = 47222536, [30] = 47222536, [31] = 67775894, [32] = 67775894, [33] = 7922915, [34] = 7922915, [35] = 7922915, [36] = 48680970, [37] = 48680970, [38] = 48680970, [39] = 40605147, [40] = 40605147, [41] = 41721210, [42] = 41721210, [43] = 50954680, [44] = 58074177, [45] = 90036274, [46] = 14577226, [47] = 16691074, [48] = 22110647, [49] = 80117527, [50] = 71384012, [51] = 71384012, [52] = 71384012, [53] = 1482001 }, [12] = { [1] = 51522296, [2] = 51522296, [3] = 62849088, [4] = 69680031, [5] = 69680031, [6] = 95679145, [7] = 72270339, [8] = 60303688, [9] = 60303688, [10] = 60303688, [11] = 14558127, [12] = 14558127, [13] = 14558127, [14] = 23434538, [15] = 23434538, [16] = 23434538, [17] = 10158145, [18] = 10158145, [19] = 10158145, [20] = 1984618, [21] = 1984618, [22] = 1984618, [23] = 31002402, [24] = 60921537, [25] = 16240772, [26] = 24224830, [27] = 24224830, [28] = 65681983, [29] = 80845034, [30] = 80845034, [31] = 80845034, [32] = 35569555, [33] = 35569555, [34] = 35569555, [35] = 10045474, [36] = 10045474, [37] = 10045474, [38] = 82956214, [39] = 82956214, [40] = 82956214, [41] = 24915933, [42] = 41373230, [43] = 11765832, [44] = 11765832, [45] = 80532587, [46] = 80532587, [47] = 80532587, [48] = 53971455, [49] = 53971455, [50] = 74586817, [51] = 79606837, [52] = 93039339, [53] = 2220237, [54] = 24842059, [55] = 60303245 }, [13] = { [1] = 46986414, [2] = 46986414, [3] = 74677422, [4] = 74677422, [5] = 67300516, [6] = 10802915, [7] = 10802915, [8] = 26202165, [9] = 91646304, [10] = 14558127, [11] = 14558127, [12] = 72291078, [13] = 72291078, [14] = 72291078, [15] = 23434538, [16] = 23434538, [17] = 23434538, [18] = 97631303, [19] = 97631303, [20] = 97631303, [21] = 1845204, [22] = 1845204, [23] = 6172122, [24] = 6172122, [25] = 6172122, [26] = 11827244, [27] = 11827244, [28] = 18144506, [29] = 81439173, [30] = 83764718, [31] = 92353449, [32] = 92353449, [33] = 24224830, [34] = 24224830, [35] = 24224830, [36] = 10045474, [37] = 10045474, [38] = 10045474, [39] = 40605147, [40] = 40605147, [41] = 37818794, [42] = 37818794, [43] = 37818794, [44] = 96334243, [45] = 63519819, [46] = 50588353, [47] = 70369116, [48] = 70369116, [49] = 98978921, [50] = 98978921, [51] = 31226177, [52] = 31226177, [53] = 60303245, [54] = 60303245, [55] = 60303245 }, [14] = { [1] = 61257789, [2] = 61257789, [3] = 61257789, [4] = 876330, [5] = 876330, [6] = 876330, [7] = 3431737, [8] = 3431737, [9] = 3431737, [10] = 28183605, [11] = 28183605, [12] = 28183605, [13] = 59755122, [14] = 59755122, [15] = 59755122, [16] = 29863101, [17] = 29863101, [18] = 39701395, [19] = 39701395, [20] = 70368879, [21] = 70368879, [22] = 71490127, [23] = 73628505, [24] = 81439173, [25] = 5318639, [26] = 5318639, [27] = 57103969, [28] = 57103969, [29] = 60004971, [30] = 62265044, [31] = 62265044, [32] = 62265044, [33] = 44095762, [34] = 58120309, [35] = 58120309, [36] = 70342110, [37] = 70342110, [38] = 80280737, [39] = 80280737, [40] = 80280737, [41] = 99267150, [42] = 50954680, [43] = 50954680, [44] = 76774528, [45] = 76774528, [46] = 76774528, [47] = 44508094, [48] = 44508094, [49] = 44508094, [50] = 34116027, [51] = 34116027, [52] = 34116027, [53] = 21249921, [54] = 21249921, [55] = 21249921 }, [15] = { [1] = 77542832, [2] = 77542832, [3] = 77542832, [4] = 40921545, [5] = 79785958, [6] = 79785958, [7] = 79785958, [8] = 59546797, [9] = 59546797, [10] = 72429240, [11] = 4756629, [12] = 4756629, [13] = 4756629, [14] = 8814959, [15] = 8814959, [16] = 8814959, [17] = 85138716, [18] = 85138716, [19] = 85138716, [20] = 23434538, [21] = 23434538, [22] = 911883, [23] = 1475311, [24] = 1475311, [25] = 18144506, [26] = 32807846, [27] = 8267140, [28] = 27541267, [29] = 27541267, [30] = 26708437, [31] = 26708437, [32] = 5851097, [33] = 35419032, [34] = 58921041, [35] = 58921041, [36] = 40605147, [37] = 40605147, [38] = 40605147, [39] = 41420027, [40] = 84749824, [41] = 88754763, [42] = 9272381, [43] = 56832966, [44] = 86532744, [45] = 36757171, [46] = 93568288, [47] = 21044178, [48] = 91279700, [49] = 46772449, [50] = 82633039, [51] = 84013237, [52] = 76067258, [53] = 359563, [54] = 91279700, [55] = 91279700 }, [16] = { [1] = 37343995, [2] = 37343995, [3] = 37343995, [4] = 16889337, [5] = 16889337, [6] = 16889337, [7] = 16474916, [8] = 16474916, [9] = 16474916, [10] = 67972302, [11] = 67972302, [12] = 67972302, [13] = 79858629, [14] = 79858629, [15] = 43863925, [16] = 43863925, [17] = 43863925, [18] = 5352328, [19] = 5352328, [20] = 14558127, [21] = 14558127, [22] = 14558127, [23] = 23434538, [24] = 23434538, [25] = 23434538, [26] = 84211599, [27] = 84211599, [28] = 4408198, [29] = 24224830, [30] = 24224830, [31] = 77913594, [32] = 77913594, [33] = 77913594, [34] = 197042, [35] = 197042, [36] = 10045474, [37] = 10045474, [38] = 77891946, [39] = 77891946, [40] = 77891946, [41] = 90448279, [42] = 59242457, [43] = 59242457, [44] = 9272381, [45] = 42741437, [46] = 42741437, [47] = 42741437, [48] = 78135071, [49] = 78135071, [50] = 41524885, [51] = 41524885, [52] = 46772449, [53] = 5530780, [54] = 58858807, [55] = 8728498 }, [17] = { [1] = 71197066, [2] = 15397015, [3] = 15397015, [4] = 15397015, [5] = 4376659, [6] = 4376659, [7] = 31764354, [8] = 31887906, [9] = 40542826, [10] = 40542826, [11] = 68881650, [12] = 68881650, [13] = 14558127, [14] = 14558127, [15] = 36584821, [16] = 36584821, [17] = 23434538, [18] = 23434538, [19] = 18144506, [20] = 35261759, [21] = 35261759, [22] = 49238328, [23] = 49238328, [24] = 73915051, [25] = 73915051, [26] = 62256492, [27] = 62256492, [28] = 25704359, [29] = 25704359, [30] = 30241314, [31] = 30241314, [32] = 36975314, [33] = 36975314, [34] = 59305593, [35] = 59305593, [36] = 61740673, [37] = 82732705, [38] = 82732705, [39] = 40605147, [40] = 40605147, [41] = 41420027, [42] = 41420027, [43] = 84749824, [44] = 84749824, [45] = 12014404, [46] = 31833038, [47] = 85289965, [48] = 65330383, [49] = 38342335, [50] = 2857636, [51] = 9839945, [52] = 30674956, [53] = 48815792, [54] = 73309655, [55] = 97661969, [56] = 75452921, [57] = 98978921, [58] = 41999284, [59] = 41999284 }, [18] = { [1] = 23950192, [2] = 23950192, [3] = 90311614, [4] = 90311614, [5] = 63948258, [6] = 63948258, [7] = 9126351, [8] = 9126351, [9] = 81278754, [10] = 81278754, [11] = 56052205, [12] = 56052205, [13] = 56052205, [14] = 1357146, [15] = 1357146, [16] = 46239604, [17] = 46239604, [18] = 46239604, [19] = 23408872, [20] = 23408872, [21] = 12538374, [22] = 12538374, [23] = 53129443, [24] = 73628505, [25] = 73628505, [26] = 98645731, [27] = 98645731, [28] = 86780027, [29] = 86780027, [30] = 86780027, [31] = 2084239, [32] = 2084239, [33] = 2084239, [34] = 34351849, [35] = 34351849, [36] = 34351849, [37] = 85742772, [38] = 85742772, [39] = 99188141, [40] = 99188141 }, [19] = { [1] = 25524823, [2] = 36521459, [3] = 3825890, [4] = 62473983, [5] = 17393207, [6] = 17393207, [7] = 17393207, [8] = 25262697, [9] = 30213599, [10] = 30213599, [11] = 30213599, [12] = 24317029, [13] = 24317029, [14] = 24317029, [15] = 93023479, [16] = 93023479, [17] = 93023479, [18] = 72405967, [19] = 72405967, [20] = 5318639, [21] = 5318639, [22] = 5318639, [23] = 14087893, [24] = 14087893, [25] = 70000776, [26] = 70000776, [27] = 47355498, [28] = 47355498, [29] = 47355498, [30] = 29401950, [31] = 29401950, [32] = 30450531, [33] = 30450531, [34] = 53582587, [35] = 53582587, [36] = 70342110, [37] = 70342110, [38] = 84749824, [39] = 90434657, [40] = 90434657, [41] = 44508094 }, [20] = { [1] = 20056760, [2] = 20056760, [3] = 20056760, [4] = 29834183, [5] = 29834183, [6] = 29834183, [7] = 93445074, [8] = 93445074, [9] = 93445074, [10] = 66451379, [11] = 66451379, [12] = 66451379, [13] = 23434538, [14] = 23434538, [15] = 23434538, [16] = 97268402, [17] = 97268402, [18] = 97268402, [19] = 18144507, [20] = 33057951, [21] = 33057951, [22] = 33057951, [23] = 53129443, [24] = 83764718, [25] = 98645731, [26] = 98645731, [27] = 98645731, [28] = 2759860, [29] = 2759860, [30] = 2759860, [31] = 58120309, [32] = 75361204, [33] = 75361204, [34] = 49966595, [35] = 49966595, [36] = 49966595, [37] = 82732705, [38] = 82732705, [39] = 82732705, [40] = 41420027, [41] = 52687916, [42] = 80666118, [43] = 39765958, [44] = 52145422, [45] = 52145422, [46] = 70902743, [47] = 76774528, [48] = 44508094, [49] = 83994433, [50] = 95040215, [51] = 98012938, [52] = 88033975, [53] = 26593852, [54] = 98558751, [55] = 78156759 }, [21] = { [1] = 71197066, [2] = 71197066, [3] = 15397015, [4] = 15397015, [5] = 15397015, [6] = 14558127, [7] = 36584821, [8] = 36584821, [9] = 36584821, [10] = 23434538, [11] = 63845230, [12] = 63845230, [13] = 63845230, [14] = 18144506, [15] = 35261759, [16] = 35261759, [17] = 59750328, [18] = 59750328, [19] = 70368879, [20] = 98645731, [21] = 98645731, [22] = 98645731, [23] = 73915051, [24] = 73915051, [25] = 10045474, [26] = 10045474, [27] = 10813327, [28] = 23924608, [29] = 47475363, [30] = 47475363, [31] = 30241314, [32] = 36975314, [33] = 36975314, [34] = 58921041, [35] = 69452756, [36] = 40605147, [37] = 40605147, [38] = 41420027, [39] = 41420027, [40] = 77538567, [41] = 86221741, [42] = 31833038, [43] = 85289965, [44] = 30194529, [45] = 38342335, [46] = 2857636, [47] = 24094258, [48] = 75452921, [49] = 50588353, [50] = 3987233, [51] = 3987233, [52] = 63288573, [53] = 41999284, [54] = 41999284, [55] = 41999284 }, [22] = { [1] = 43096270, [2] = 43096270, [3] = 43096270, [4] = 11091375, [5] = 11091375, [6] = 11091375, [7] = 79473793, [8] = 79473793, [9] = 48229808, [10] = 11224103, [11] = 11224103, [12] = 70095154, [13] = 70095154, [14] = 84914462, [15] = 84914462, [16] = 84914462, [17] = 47013502, [18] = 47013502, [19] = 47013502, [20] = 9666558, [21] = 26412047, [22] = 26412047, [23] = 53129443, [24] = 66788016, [25] = 66788016, [26] = 81385346, [27] = 81385346, [28] = 81439173, [29] = 5318639, [30] = 5318639, [31] = 87025064, [32] = 87025064, [33] = 50913601, [34] = 50913601, [35] = 20638610, [36] = 20638610, [37] = 44095762, [38] = 44095762, [39] = 70342110, [40] = 70342110 }, [23] = { [1] = 27204311, [2] = 68304193, [3] = 68304193, [4] = 68304193, [5] = 32909498, [6] = 32909498, [7] = 32909498, [8] = 4928565, [9] = 78534861, [10] = 78534861, [11] = 91800273, [12] = 91800273, [13] = 72090076, [14] = 31149212, [15] = 31149212, [16] = 31149212, [17] = 14558127, [18] = 14558127, [19] = 14558127, [20] = 23434538, [21] = 23434538, [22] = 31480215, [23] = 34447918, [24] = 34447918, [25] = 34447918, [26] = 73628505, [27] = 84211599, [28] = 84211599, [29] = 24224830, [30] = 24224830, [31] = 65681983, [32] = 69540484, [33] = 69540484, [34] = 69540484, [35] = 71832012, [36] = 71832012, [37] = 71832012, [38] = 10045474, [39] = 10045474, [40] = 33925864, [41] = 15291624, [42] = 27548199, [43] = 21915012, [44] = 48626373, [45] = 48626373, [46] = 95474755, [47] = 95474755, [48] = 95474755, [49] = 10389142, [50] = 73542331, [51] = 73542331, [52] = 21887175, [53] = 44097050, [54] = 22423493, [55] = 65741786 }, [24] = { [1] = 81497285, [2] = 81497285, [3] = 2347656, [4] = 41165831, [5] = 73602965, [6] = 73602965, [7] = 75730490, [8] = 1225009, [9] = 1225009, [10] = 1225009, [11] = 37629703, [12] = 37629703, [13] = 37629703, [14] = 14558127, [15] = 14558127, [16] = 14558127, [17] = 23434538, [18] = 23434538, [19] = 23434538, [20] = 74018812, [21] = 74018812, [22] = 74018812, [23] = 2511, [24] = 2511, [25] = 2511, [26] = 49238328, [27] = 49238328, [28] = 5380979, [29] = 5380979, [30] = 6351147, [31] = 6351147, [32] = 10045474, [33] = 10045474, [34] = 10045474, [35] = 30748475, [36] = 53417695, [37] = 83326048, [38] = 92714517, [39] = 92714517, [40] = 92714517, [41] = 22850702, [42] = 22850702, [43] = 93039339, [44] = 93039339, [45] = 29479265, [46] = 93084621, [47] = 93084621, [48] = 24269961, [49] = 24269961, [50] = 24269961, [51] = 67680512, [52] = 67680512, [53] = 29301450, [54] = 71607202, [55] = 94259633 }, [25] = { [1] = 87979586, [2] = 87979586, [3] = 82012319, [4] = 82012319, [5] = 65367484, [6] = 65367484, [7] = 44928016, [8] = 77558536, [9] = 77558536, [10] = 19139516, [11] = 67696066, [12] = 53573406, [13] = 53573406, [14] = 25259669, [15] = 25259669, [16] = 12213463, [17] = 12213463, [18] = 26118970, [19] = 4334811, [20] = 4334811, [21] = 4334811, [22] = 72291078, [23] = 72291078, [24] = 9742784, [25] = 9742784, [26] = 911883, [27] = 911883, [28] = 911883, [29] = 12580477, [30] = 18144506, [31] = 32807846, [32] = 81439173, [33] = 83764718, [34] = 94886282, [35] = 94886282, [36] = 24224830, [37] = 24224830, [38] = 24224830, [39] = 40605147, [40] = 40605147, [41] = 89907227, [42] = 27548199, [43] = 50954680, [44] = 80666118, [45] = 74586817, [46] = 76774528, [47] = 33698022, [48] = 68431965, [49] = 42566602, [50] = 53325667, [51] = 90590303, [52] = 21887175, [53] = 47363932, [54] = 47363932, [55] = 50588353 }, [26] = { [1] = 99800003 }, [27] = { [1] = 77558536, [2] = 18144506, [3] = 57774843, [4] = 57774843, [5] = 57774843, [6] = 58996430, [7] = 58996430, [8] = 58996430, [9] = 59019082, [10] = 77558536, [11] = 77558536, [12] = 22624373, [13] = 22624373, [14] = 67696066, [15] = 67696066, [16] = 67696066, [17] = 25259669, [18] = 25259669, [19] = 25259669, [20] = 1833916, [21] = 1833916, [22] = 73176465, [23] = 73176465, [24] = 37742478, [25] = 37742478, [26] = 95503687, [27] = 95503687, [28] = 95503687, [29] = 40164421, [30] = 21502796, [31] = 67441435, [32] = 691925, [33] = 691925, [34] = 691925, [35] = 5133471, [36] = 32807846, [37] = 73594093, [38] = 94886282, [39] = 94886282, [40] = 94886282, [41] = 52687916, [42] = 80666118, [43] = 74586817, [44] = 4779823, [45] = 37192109, [46] = 56832966, [47] = 84013237, [48] = 82633039, [49] = 30100551, [50] = 30100551, [51] = 30100551, [52] = 46772449, [53] = 83531441, [54] = 1861629, [55] = 3987233 }, [28] = { [1] = 18940556, [2] = 18940556, [3] = 18940556, [4] = 93332803, [5] = 93332803, [6] = 55063751, [7] = 28674152, [8] = 41782653, [9] = 41782653, [10] = 41782653, [11] = 3717252, [12] = 3717252, [13] = 80280944, [14] = 48048590, [15] = 77723643, [16] = 77723643, [17] = 55623480, [18] = 30328508, [19] = 30328508, [20] = 44335251, [21] = 77558536, [22] = 77558536, [23] = 77558536, [24] = 95503687, [25] = 95503687, [26] = 4939890, [27] = 4939890, [28] = 14558127, [29] = 14558127, [30] = 59438930, [31] = 37445295, [32] = 37445295, [33] = 23434538, [34] = 23434538, [35] = 33420078, [36] = 67441435, [37] = 1475311, [38] = 1475311, [39] = 1475311, [40] = 11110587, [41] = 11110587, [42] = 11110587, [43] = 18144506, [44] = 38179121, [45] = 38179121, [46] = 38179121, [47] = 44394295, [48] = 44394295, [49] = 44394295, [50] = 67169062, [51] = 81439173, [52] = 83764718, [53] = 94886282, [54] = 94886282, [55] = 99330325, [56] = 10045474, [57] = 10045474, [58] = 74003290, [59] = 77505534, [60] = 4904633, [61] = 74822425, [62] = 20366274, [63] = 48424886, [64] = 94977269, [65] = 50954680, [66] = 80666118, [67] = 4779823, [68] = 33698022, [69] = 76547525, [70] = 42566602, [71] = 98558751, [72] = 30100551, [73] = 74997493, [74] = 50588353, [75] = 50588353 }, [29] = { [1] = 8567955, [2] = 8567955, [3] = 8567955, [4] = 89743495, [5] = 89743495, [6] = 27182739, [7] = 27182739, [8] = 27182739, [9] = 53577438, [10] = 53577438, [11] = 53577438, [12] = 16360142, [13] = 16360142, [14] = 16360142, [15] = 80965043, [16] = 80965043, [17] = 80965043, [18] = 52354896, [19] = 52354896, [20] = 12580477, [21] = 14025912, [22] = 14532163, [23] = 14532163, [24] = 35261759, [25] = 35261759, [26] = 35261759, [27] = 57160136, [28] = 57160136, [29] = 57160136, [30] = 70368879, [31] = 70368879, [32] = 70368879, [33] = 81439173, [34] = 93104632, [35] = 93104632, [36] = 8267140, [37] = 41410651, [38] = 36361633, [39] = 36361633, [40] = 36361633, [41] = 42632209, [42] = 42632209, [43] = 42632209, [44] = 15248594, [45] = 15248594, [46] = 15248594, [47] = 61399402, [48] = 61399402, [49] = 61399402, [50] = 85692042, [51] = 85692042, [52] = 85692042, [53] = 88021907, [54] = 88021907, [55] = 88021907 }, [30] = { [1] = 39552864, [2] = 39552864, [3] = 39552864, [4] = 12482652, [5] = 12482652, [6] = 12482652, [7] = 42941100, [8] = 42941100, [9] = 42941100, [10] = 79335209, [11] = 79335209, [12] = 79335209, [13] = 487395, [14] = 487395, [15] = 487395, [16] = 99171160, [17] = 99171160, [18] = 99171160, [19] = 53776525, [20] = 53776525, [21] = 53776525, [22] = 32274490, [23] = 32274490, [24] = 32274490, [25] = 27288416, [26] = 27288416, [27] = 27288416, [28] = 80825553, [29] = 80825553, [30] = 80825553, [31] = 7902349, [32] = 8124921, [33] = 44519536, [34] = 70903634, [35] = 69380702, [36] = 69380702, [37] = 69380702, [38] = 3557275, [39] = 3557275, [40] = 3557275 }, [31] = { [1] = 5464695, [2] = 5464695, [3] = 5464695, [4] = 39256679, [5] = 39256679, [6] = 39256679, [7] = 11549357, [8] = 11549357, [9] = 11549357, [10] = 99785935, [11] = 99785935, [12] = 99785935, [13] = 91152256, [14] = 91152256, [15] = 91152256, [16] = 76812113, [17] = 76812113, [18] = 76812113, [19] = 85639257, [20] = 85639257, [21] = 85639257, [22] = 74093656, [23] = 74093656, [24] = 74093656, [25] = 68505803, [26] = 68505803, [27] = 68505803, [28] = 27288416, [29] = 27288416, [30] = 27288416, [31] = 19384334, [32] = 22702055, [33] = 23424603, [34] = 35956022, [35] = 45778932, [36] = 50913601, [37] = 56594520, [38] = 82999629, [39] = 86318356, [40] = 87430998, [41] = 45815891, [42] = 45815891, [43] = 45815891, [44] = 71594310, [45] = 71594310, [46] = 71594310, [47] = 67598234, [48] = 67598234, [49] = 67598234 }, [32] = { [1] = 52738610, [2] = 52738610, [3] = 52738610, [4] = 23401839, [5] = 23401839, [6] = 23401839, [7] = 95492061, [8] = 95492061, [9] = 95492061, [10] = 30312361, [11] = 90307777, [12] = 88240999, [13] = 88240999, [14] = 52068432, [15] = 52068432, [16] = 52068432, [17] = 74122412, [18] = 74122412, [19] = 26674724, [20] = 89463537, [21] = 99185129, [22] = 99185129, [23] = 99185129, [24] = 32807846, [25] = 53129443, [26] = 96729612, [27] = 96729612, [28] = 14735698, [29] = 14735698, [30] = 14735698, [31] = 51124303, [32] = 51124303, [33] = 51124303, [34] = 97211663, [35] = 5318639, [36] = 5318639, [37] = 5318639, [38] = 51452091, [39] = 51452091, [40] = 51452091, [41] = 35952884, [42] = 35952884, [43] = 41517789, [44] = 41517789, [45] = 24696097, [46] = 24696097, [47] = 52687916, [48] = 74586817, [49] = 37192109, [50] = 42566602, [51] = 90953320, [52] = 79606837, [53] = 79606837, [54] = 79606837, [55] = 46772449 }, [33] = { [1] = 16600024, [2] = 16600024, [3] = 16600024, [4] = 16600023, [5] = 16600023, [6] = 16600023, [7] = 16600011, [8] = 16600012, [9] = 16600025, [10] = 16600025, [11] = 16600025, [12] = 14558127, [13] = 16600021, [14] = 23434538, [15] = 99800003, [16] = 16670040, [17] = 16670040, [18] = 16670040, [19] = 25311006, [20] = 16600055, [21] = 16600005, [22] = 16600006, [23] = 16600006, [24] = 16600006, [25] = 16600007, [26] = 16600007, [27] = 16600007, [28] = 16600008, [29] = 16600008, [30] = 16600008, [31] = 16600009, [32] = 16600009, [33] = 16600009, [34] = 16600050, [35] = 16600060, [36] = 16600060, [37] = 16600060, [38] = 16670013, [39] = 16670013, [40] = 16670013, [41] = 16600001, [42] = 16600035, [43] = 16600035, [44] = 16600032, [45] = 16600032, [46] = 16600034, [47] = 16600040, [48] = 16600040, [49] = 16600040, [50] = 16600040, [51] = 16600040, [52] = 16600040, [53] = 16600040, [54] = 16600040, [55] = 16600040, [56] = 16600040 }, [34] = { [1] = 6631034, [2] = 6631034, [3] = 6631034, [4] = 43096270, [5] = 43096270, [6] = 43096270, [7] = 69247929, [8] = 69247929, [9] = 69247929, [10] = 77542832, [11] = 77542832, [12] = 77542832, [13] = 11091375, [14] = 11091375, [15] = 11091375, [16] = 35052053, [17] = 35052053, [18] = 35052053, [19] = 49881766, [20] = 83104731, [21] = 83104731, [22] = 30190809, [23] = 30190809, [24] = 26412047, [25] = 26412047, [26] = 26412047, [27] = 43422537, [28] = 43422537, [29] = 43422537, [30] = 53129443, [31] = 66788016, [32] = 66788016, [33] = 66788016, [34] = 72302403, [35] = 72302403, [36] = 44095762, [37] = 44095762, [38] = 44095762, [39] = 70342110, [40] = 70342110 }, [35] = { [1] = 93920420, [2] = 5560911, [3] = 4055337, [4] = 4055337, [5] = 98169343, [6] = 61283655, [7] = 57835716, [8] = 57835716, [9] = 57835716, [10] = 28985331, [11] = 21441617, [12] = 4334811, [13] = 90432163, [14] = 36426778, [15] = 14558127, [16] = 14558127, [17] = 73642296, [18] = 73642296, [19] = 23434538, [20] = 23434538, [21] = 23434538, [22] = 9742784, [23] = 32807846, [24] = 63166095, [25] = 63166095, [26] = 73628505, [27] = 81439173, [28] = 24224830, [29] = 24224830, [30] = 24224830, [31] = 25733157, [32] = 52340444, [33] = 35371948, [34] = 35371948, [35] = 35371948, [36] = 90351981, [37] = 98827725, [38] = 25542642, [39] = 25542642, [40] = 703897, [41] = 27548199, [42] = 68431965, [43] = 93854893, [44] = 93854893, [45] = 85289965, [46] = 76145142, [47] = 26692769, [48] = 2857636, [49] = 30741503, [50] = 30741503, [51] = 30741503, [52] = 50588353, [53] = 63288573, [54] = 3679218, [55] = 60303245 }, [36] = { [1] = 81823360, [2] = 81823360, [3] = 81823360, [4] = 14558127, [5] = 14558127, [6] = 63845230, [7] = 18144506, [8] = 35261759, [9] = 35261759, [10] = 47325505, [11] = 47325505, [12] = 59750328, [13] = 59750328, [14] = 59750328, [15] = 73628505, [16] = 98645731, [17] = 98645731, [18] = 98645731, [19] = 73915051, [20] = 73915051, [21] = 2819435, [22] = 2819435, [23] = 2819435, [24] = 10045474, [25] = 34302287, [26] = 34302287, [27] = 34302287, [28] = 47475363, [29] = 58120309, [30] = 61397885, [31] = 61397885, [32] = 89208725, [33] = 89208725, [34] = 19089195, [35] = 19089195, [36] = 19089195, [37] = 53334471, [38] = 53334471, [39] = 82732705, [40] = 99188141, [41] = 44508094, [42] = 5821478, [43] = 31833038, [44] = 85289965, [45] = 65330383, [46] = 72529749, [47] = 61665245, [48] = 38342335, [49] = 2857636, [50] = 75452921, [51] = 50588353, [52] = 3987233, [53] = 98978921, [54] = 41999284, [55] = 41999284 }, [37] = { [1] = 71007216, [2] = 71007216, [3] = 71007216, [4] = 81275020, [5] = 71175527, [6] = 71175527, [7] = 71175527, [8] = 43722862, [9] = 43722862, [10] = 43722862, [11] = 53932291, [12] = 53932291, [13] = 65277087, [14] = 65277087, [15] = 65277087, [16] = 54455435, [17] = 54455435, [18] = 54455435, [19] = 91662792, [20] = 91662792, [21] = 91662792, [22] = 16725505, [23] = 70117860, [24] = 70117860, [25] = 70117860, [26] = 12580477, [27] = 27980138, [28] = 27980138, [29] = 58577036, [30] = 83764718, [31] = 8267140, [32] = 25789292, [33] = 67723438, [34] = 67723438, [35] = 8608979, [36] = 8608979, [37] = 8608979, [38] = 24590232, [39] = 40605147, [40] = 84749824, [41] = 27315304, [42] = 50954680, [43] = 50954680, [44] = 50954680, [45] = 82044279, [46] = 82044279, [47] = 14577226, [48] = 29552709, [49] = 29552709, [50] = 64880894, [51] = 84766279, [52] = 42110604, [53] = 70913714, [54] = 30674956, [55] = 90512490 }, [38] = { [1] = 65518099, [2] = 65518099, [3] = 65518099, [4] = 13073850, [5] = 13073850, [6] = 90885155, [7] = 37991342, [8] = 37991342, [9] = 91907707, [10] = 91907707, [11] = 53129443, [12] = 59750328, [13] = 59750328, [14] = 79816536, [15] = 79816536, [16] = 79816536, [17] = 98645731, [18] = 98645731, [19] = 17639150, [20] = 17639150, [21] = 44095762, [22] = 44095762, [23] = 44095762, [24] = 53582587, [25] = 53582587, [26] = 53582587, [27] = 83326048, [28] = 83326048, [29] = 83326048, [30] = 94192409, [31] = 94192409, [32] = 94192409, [33] = 5851097, [34] = 82732705, [35] = 82732705, [36] = 82732705, [37] = 40605147, [38] = 40605147, [39] = 99188141, [40] = 99188141, [41] = 13331639, [42] = 13331639, [43] = 13331639, [44] = 79229522, [45] = 79229522, [46] = 79229522, [47] = 26268488, [48] = 26268488, [49] = 26268488, [50] = 35952884, [51] = 35952884, [52] = 35952884, [53] = 23187256, [54] = 23187256, [55] = 23187256 }, [39] = { [1] = 18108166, [2] = 18108166, [3] = 18108166, [4] = 74852097, [5] = 74852097, [6] = 74852097, [7] = 81823360, [8] = 81823360, [9] = 81823360, [10] = 75195825, [11] = 75195825, [12] = 75195825, [13] = 87979586, [14] = 87979586, [15] = 87979586, [16] = 33256280, [17] = 33256280, [18] = 33256280, [19] = 85138716, [20] = 85138716, [21] = 85138716, [22] = 911883, [23] = 911883, [24] = 911883, [25] = 18144506, [26] = 35261759, [27] = 35261759, [28] = 35261759, [29] = 97169186, [30] = 97169186, [31] = 97169186, [32] = 5650082, [33] = 20522190, [34] = 29401950, [35] = 29616929, [36] = 40838625, [37] = 44095762, [38] = 47475363, [39] = 58120309, [40] = 75249652, [41] = 80666118, [42] = 18239909, [43] = 44508094, [44] = 56832966, [45] = 37279508, [46] = 84013237, [47] = 74294676, [48] = 82697249, [49] = 82633039, [50] = 61344030, [51] = 22653490, [52] = 46772449, [53] = 12014404, [54] = 359563, [55] = 6511113 }, [40] = { [1] = 28601770, [2] = 28601770, [3] = 28601770, [4] = 70095154, [5] = 70095154, [6] = 70095154, [7] = 29353756, [8] = 29353756, [9] = 33911264, [10] = 33911264, [11] = 33911264, [12] = 20932152, [13] = 20932152, [14] = 20932152, [15] = 12299841, [16] = 12299841, [17] = 12299841, [18] = 24610207, [19] = 24610207, [20] = 24610207, [21] = 88552992, [22] = 88552992, [23] = 88552992, [24] = 1845204, [25] = 1845204, [26] = 1845204, [27] = 43422537, [28] = 43422537, [29] = 43422537, [30] = 5318639, [31] = 5318639, [32] = 14087893, [33] = 13032689, [34] = 26708437, [35] = 26708437, [36] = 44095762, [37] = 44095762, [38] = 53582587, [39] = 96457619, [40] = 96457619, [41] = 72959823, [42] = 72959823, [43] = 72959823, [44] = 91949988, [45] = 91949988, [46] = 10443957, [47] = 10443957, [48] = 10443957, [49] = 31386180, [50] = 29669359, [51] = 29669359, [52] = 50449881, [53] = 58069384, [54] = 58069384, [55] = 58069384 }, [41] = { [1] = 51490121, [2] = 38572779, [3] = 88392300, [4] = 81109178, [5] = 16604000, [6] = 16604000, [7] = 16604000, [8] = 16604005, [9] = 16604010, [10] = 16604010, [11] = 16604010, [12] = 16604015, [13] = 16604015, [14] = 16604025, [15] = 16609030, [16] = 9300018, [17] = 14558127, [18] = 14558127, [19] = 52038441, [20] = 59438930, [21] = 59438930, [22] = 59438930, [23] = 60643553, [24] = 62015408, [25] = 73642296, [26] = 9300011, [27] = 23434538, [28] = 23434538, [29] = 23434538, [30] = 20450925, [31] = 24508238, [32] = 2511, [33] = 18964575, [34] = 18964575, [35] = 18964575, [36] = 97268402, [37] = 97268402, [38] = 97268402, [39] = 18144506, [40] = 8267140, [41] = 99267151, [42] = 99267151, [43] = 99267151, [44] = 84433295, [45] = 84433295, [46] = 84433295, [47] = 80532587, [48] = 80532587, [49] = 80532587, [50] = 16604030, [51] = 16604030, [52] = 16604030, [53] = 81330115, [54] = 81330115, [55] = 81330115 }, [42] = { [1] = 8633261, [2] = 8633261, [3] = 8633261, [4] = 35844557, [5] = 35844557, [6] = 35844557, [7] = 72238166, [8] = 34022970, [9] = 34022970, [10] = 34022970, [11] = 42141493, [12] = 42141493, [13] = 84192580, [14] = 87126721, [15] = 14558127, [16] = 14558127, [17] = 14558127, [18] = 59438930, [19] = 59438930, [20] = 23434538, [21] = 23434538, [22] = 94145021, [23] = 97268402, [24] = 97268402, [25] = 97268402, [26] = 7477101, [27] = 7477101, [28] = 7477101, [29] = 25311006, [30] = 35261759, [31] = 35261759, [32] = 85106525, [33] = 24224830, [34] = 24224830, [35] = 60394026, [36] = 65681983, [37] = 6798031, [38] = 10045474, [39] = 10045474, [40] = 10045474, [41] = 9940036, [42] = 34909328, [43] = 34909328, [44] = 2061963, [45] = 7511613, [46] = 7511613, [47] = 45852939, [48] = 45852939, [49] = 6983839, [50] = 90590303, [51] = 46772449, [52] = 16643334, [53] = 21044178, [54] = 66011101, [55] = 8728498 }, [43] = { [1] = 97268402, [2] = 97268402, [3] = 97268402, [4] = 94620082, [5] = 94620082, [6] = 94620082, [7] = 26889158, [8] = 26889158, [9] = 26889158, [10] = 89662401, [11] = 14558127, [12] = 14558127, [13] = 20618081, [14] = 56003780, [15] = 52277807, [16] = 52277807, [17] = 52277807, [18] = 23434538, [19] = 23434538, [20] = 23434538, [21] = 16188701, [22] = 16188701, [23] = 16188701, [24] = 52155219, [25] = 52155219, [26] = 52155219, [27] = 24224830, [28] = 24224830, [29] = 24224830, [30] = 81439174, [31] = 18144507, [32] = 1295111, [33] = 14934922, [34] = 51339637, [35] = 51339637, [36] = 10045474, [37] = 10045474, [38] = 10045474, [39] = 41420027, [40] = 41420027, [41] = 6983839, [42] = 87327776, [43] = 87327776, [44] = 87871125, [45] = 87871125, [46] = 87871125, [47] = 31833038, [48] = 14812471, [49] = 14812471, [50] = 14812471, [51] = 41463182, [52] = 41463182, [53] = 48815792, [54] = 2857636, [55] = 85289965 }, [44] = { [1] = 26077387, [2] = 26077387, [3] = 26077387, [4] = 14558127, [5] = 14558127, [6] = 59438930, [7] = 23434538, [8] = 23434538, [9] = 23434538, [10] = 9742784, [11] = 97268402, [12] = 97268402, [13] = 25955749, [14] = 32807846, [15] = 35726888, [16] = 35726888, [17] = 35726888, [18] = 63166095, [19] = 63166095, [20] = 63166095, [21] = 70368879, [22] = 70368879, [23] = 70368879, [24] = 73594093, [25] = 99550630, [26] = 43898403, [27] = 43898403, [28] = 43898403, [29] = 52340444, [30] = 52340444, [31] = 52340444, [32] = 98338152, [33] = 98338152, [34] = 98338152, [35] = 24010609, [36] = 97616504, [37] = 50005218, [38] = 41420027, [39] = 84749824, [40] = 84749824, [41] = 42110604, [42] = 5821478, [43] = 61665245, [44] = 38342335, [45] = 2857636, [46] = 50588353, [47] = 8491308, [48] = 8491308, [49] = 63288573, [50] = 63288573, [51] = 63288573, [52] = 90673288, [53] = 90673288, [54] = 90673288, [55] = 41999284 }, [45] = { [1] = 32295838, [2] = 36211150, [3] = 7445307, [4] = 70950698, [5] = 70950698, [6] = 70950698, [7] = 35595518, [8] = 35595518, [9] = 9190563, [10] = 9190563, [11] = 44956694, [12] = 44956694, [13] = 44956694, [14] = 8567955, [15] = 8567955, [16] = 8567955, [17] = 71172240, [18] = 71172240, [19] = 45778242, [20] = 45778242, [21] = 62706865, [22] = 62706865, [23] = 18789533, [24] = 37520316, [25] = 53129443, [26] = 83764718, [27] = 5318639, [28] = 8267140, [29] = 14087893, [30] = 43839002, [31] = 43839002, [32] = 19508728, [33] = 61583217, [34] = 29401950, [35] = 44095762, [36] = 53582587, [37] = 70238111, [38] = 83326048, [39] = 94192409, [40] = 40605147, [41] = 1861629, [42] = 1861629, [43] = 1861629, [44] = 6622715, [45] = 6622715, [46] = 6622715, [47] = 32617464, [48] = 32617464, [49] = 34472920, [50] = 34472920, [51] = 79016563, [52] = 79016563, [53] = 98978921, [54] = 98978921, [55] = 98978921 }, [46] = { [1] = 35891015, [2] = 10045474, [3] = 10045474, [4] = 10045474, [5] = 14558127, [6] = 14558127, [7] = 14558127, [8] = 35261759, [9] = 35261759, [10] = 59438931, [11] = 97268402, [12] = 35891016, [13] = 22819092, [14] = 22819092, [15] = 22819092, [16] = 1033312, [17] = 1033312, [18] = 1033312, [19] = 35891014, [20] = 59438931, [21] = 59438931, [22] = 94145021, [23] = 94145021, [24] = 35891013, [25] = 35891010, [26] = 35891013, [27] = 35891014, [28] = 35891008, [29] = 35891008, [30] = 35890001, [31] = 35890001, [32] = 35890001, [33] = 35891009, [34] = 35891009, [35] = 35891015, [36] = 35891015, [37] = 35891009, [38] = 23434538, [39] = 23434538, [40] = 23434538, [41] = 5041348, [42] = 93039339, [43] = 29301450, [44] = 22850702, [45] = 10705021, [46] = 50954680, [47] = 84815190, [48] = 84815190, [49] = 35891011, [50] = 11900069, [51] = 11900069, [52] = 35891011, [53] = 35891011, [54] = 35891012, [55] = 35891012 }, [47] = { [1] = 83334932, [2] = 83334932, [3] = 83334932, [4] = 82112494, [5] = 82112494, [6] = 82112494, [7] = 19510093, [8] = 19510093, [9] = 34496660, [10] = 34496660, [11] = 34496660, [12] = 90361010, [13] = 90361010, [14] = 90361010, [15] = 78391364, [16] = 78391364, [17] = 56727340, [18] = 56727340, [19] = 14624296, [20] = 95500396, [21] = 10604644, [22] = 23434538, [23] = 23434538, [24] = 23434538, [25] = 14558127, [26] = 14558127, [27] = 14558127, [28] = 49036338, [29] = 38814750, [30] = 38814750, [31] = 97268402, [32] = 97268402, [33] = 73642296, [34] = 73642296, [35] = 59438930, [36] = 59438930, [37] = 59438930, [38] = 94145021, [39] = 94145021, [40] = 94145021, [41] = 64193046, [42] = 84815190, [43] = 30983281, [44] = 44508094, [45] = 27548199, [46] = 76471944, [47] = 74586817, [48] = 28912357, [49] = 38342335, [50] = 27381364, [51] = 22423493, [52] = 65741786, [53] = 33918636, [54] = 33918636, [55] = 33918636 }, [48] = { [1] = 27204311, [2] = 87052196, [3] = 87052196, [4] = 23431858, [5] = 93490856, [6] = 93490856, [7] = 93490856, [8] = 56495147, [9] = 56495147, [10] = 56495147, [11] = 20001443, [12] = 20001443, [13] = 20001443, [14] = 55273560, [15] = 55273560, [16] = 55273560, [17] = 14558127, [18] = 14558127, [19] = 14558127, [20] = 23434538, [21] = 23434538, [22] = 23434538, [23] = 97268402, [24] = 97268402, [25] = 97268402, [26] = 98159737, [27] = 35261759, [28] = 35261759, [29] = 56465981, [30] = 56465981, [31] = 56465981, [32] = 93850690, [33] = 24224830, [34] = 24224830, [35] = 65681983, [36] = 10045474, [37] = 10045474, [38] = 10045474, [39] = 14821890, [40] = 14821890, [41] = 42632209, [42] = 60465049, [43] = 96633955, [44] = 84815190, [45] = 47710198, [46] = 9464441, [47] = 5041348, [48] = 69248256, [49] = 69248256, [50] = 83755611, [51] = 43202238, [52] = 78917791, [53] = 32519092, [54] = 32519092, [55] = 32519092 }, [49] = { [1] = 3717252, [2] = 77723643, [3] = 572850, [4] = 572850, [5] = 572850, [6] = 73956664, [7] = 73956664, [8] = 25926710, [9] = 25926710, [10] = 25926710, [11] = 99937011, [12] = 99937011, [13] = 99937011, [14] = 62320425, [15] = 62320425, [16] = 62320425, [17] = 63542003, [18] = 63542003, [19] = 97518132, [20] = 37961969, [21] = 37961969, [22] = 37961969, [23] = 74078255, [24] = 74078255, [25] = 74078255, [26] = 92919429, [27] = 92919429, [28] = 92919429, [29] = 17266660, [30] = 17266660, [31] = 17266660, [32] = 21074344, [33] = 21074344, [34] = 21074344, [35] = 40177746, [36] = 6767771, [37] = 77103950, [38] = 77103950, [39] = 74920585, [40] = 74920585, [41] = 28226490, [42] = 84330567, [43] = 69946549, [44] = 92731385, [45] = 92731385, [46] = 94977269, [47] = 80532587, [48] = 84815190, [49] = 33158448, [50] = 21044178, [51] = 98127546, [52] = 21887175, [53] = 38342335, [54] = 27381364, [55] = 65741786 }, [50] = { [1] = 89631139 }, [51] = { [1] = 51712652, [2] = 96729612, [3] = 23434538, [4] = 10045474, [5] = 14558128, [6] = 27204311, [7] = 94145021, [8] = 94145021, [9] = 94145021, [10] = 14558128, [11] = 14558128, [12] = 23434538, [13] = 23434538, [14] = 51712660, [15] = 51712660, [16] = 51712660, [17] = 51712627, [18] = 51712626, [19] = 51712664, [20] = 51712664, [21] = 51712663, [22] = 51712662, [23] = 96729612, [24] = 96729612, [25] = 51712615, [26] = 51712615, [27] = 51712650, [28] = 51712652, [29] = 51712652, [30] = 51712653, [31] = 51712653, [32] = 51712653, [33] = 32181268, [34] = 32181268, [35] = 32181268, [36] = 51712651, [37] = 51751750, [38] = 10045474, [39] = 24224830, [40] = 24224830, [41] = 51751799, [42] = 51751799, [43] = 51751799, [44] = 96113307, [45] = 96113307, [46] = 10019086, [47] = 10090351, [48] = 90590303, [49] = 90590303, [50] = 93039339, [51] = 93039339, [52] = 79606837, [53] = 79606837, [54] = 80532587, [55] = 80532587 }, [52] = { [1] = 5206415, [2] = 32731036, [3] = 32731036, [4] = 90488465, [5] = 6637331, [6] = 6637331, [7] = 33854624, [8] = 33854624, [9] = 29596581, [10] = 29596581, [11] = 83107873, [12] = 83107873, [13] = 31786629, [14] = 31786629, [15] = 31786629, [16] = 56713174, [17] = 56713174, [18] = 56713174, [19] = 61901281, [20] = 61901281, [21] = 99234526, [22] = 99234526, [23] = 92998610, [24] = 92998610, [25] = 44586426, [26] = 44586426, [27] = 44586426, [28] = 14558127, [29] = 14558127, [30] = 23434538, [31] = 23434538, [32] = 23434538, [33] = 76218313, [34] = 20318029, [35] = 20318029, [36] = 20318029, [37] = 1475311, [38] = 1475311, [39] = 1475311, [40] = 75500286, [41] = 95238394, [42] = 95238394, [43] = 99266988, [44] = 99266988, [45] = 99266988, [46] = 24224830, [47] = 24224830, [48] = 34090915, [49] = 10045474, [50] = 10045474, [51] = 41685633, [52] = 41685633, [53] = 15291624, [54] = 21044178, [55] = 98127546, [56] = 21887175, [57] = 86066372, [58] = 4280258, [59] = 38342335, [60] = 83152482, [61] = 65741786, [62] = 50277355, [63] = 70369116, [64] = 73539069, [65] = 41999284 }, [53] = { [1] = 35800400, [2] = 35800400, [3] = 35800400, [4] = 35891022, [5] = 35891022, [6] = 35891022, [7] = 51398002, [8] = 51398002, [9] = 51398002, [10] = 51398005, [11] = 51398005, [12] = 51398005, [13] = 51398008, [14] = 51398008, [15] = 51398008, [16] = 22007085, [17] = 22007085, [18] = 22007085, [19] = 55144522, [20] = 55144522, [21] = 55144522, [22] = 79571449, [23] = 79571449, [24] = 79571449, [25] = 24224830, [26] = 24224830, [27] = 99800001, [28] = 10045474, [29] = 10045474, [30] = 13813501, [31] = 13813501, [32] = 16670006, [33] = 16670006, [34] = 16670006, [35] = 90846359, [36] = 90846359, [37] = 90846359, [38] = 53334471, [39] = 53334471, [40] = 53334471, [41] = 84815190, [42] = 10705021, [43] = 79606837, [44] = 90448279, [45] = 93039339, [46] = 27552504, [47] = 90590303, [48] = 68300121, [49] = 29423048, [50] = 4280258, [51] = 24094258, [52] = 29301450, [53] = 65741786 }, [54] = { [1] = 65367484, [2] = 71564252, [3] = 71564252, [4] = 71564252, [5] = 56308388, [6] = 56308388, [7] = 56308388, [8] = 67696066, [9] = 67696066, [10] = 82496097, [11] = 82496097, [12] = 74578720, [13] = 74578720, [14] = 19891131, [15] = 19891131, [16] = 19891131, [17] = 14558127, [18] = 14558127, [19] = 23434538, [20] = 23434538, [21] = 12580477, [22] = 18144507, [23] = 35261759, [24] = 35261759, [25] = 49238328, [26] = 49238328, [27] = 81439173, [28] = 10877309, [29] = 10877309, [30] = 81670445, [31] = 18678554, [32] = 98827725, [33] = 36975314, [34] = 36975314, [35] = 40605147, [36] = 40605147, [37] = 40605147, [38] = 41420027, [39] = 41420027, [40] = 41420027, [41] = 76587747, [42] = 76587747, [43] = 84749824, [44] = 84749824, [45] = 56832966, [46] = 56832966, [47] = 42421606, [48] = 86532744, [49] = 86532744, [50] = 16195942, [51] = 84013237, [52] = 84013237, [53] = 55285840, [54] = 55285840, [55] = 59208943, [56] = 59208943, [57] = 46772449, [58] = 12014404, [59] = 12014404 }, [55] = { [1] = 23950192, [2] = 23950192, [3] = 90311614, [4] = 90311614, [5] = 90311614, [6] = 9126351, [7] = 9126351, [8] = 9126351, [9] = 50088247, [10] = 50088247, [11] = 50088247, [12] = 1357146, [13] = 1357146, [14] = 1357146, [15] = 46239604, [16] = 46239604, [17] = 46239604, [18] = 80250319, [19] = 80250319, [20] = 80250319, [21] = 5133471, [22] = 5133471, [23] = 5133471, [24] = 18144506, [25] = 33057951, [26] = 33057951, [27] = 33057951, [28] = 53129443, [29] = 72892473, [30] = 81439173, [31] = 83764718, [32] = 84206435, [33] = 84206435, [34] = 84206435, [35] = 96947648, [36] = 96947648, [37] = 96947648, [38] = 29047353, [39] = 29047353, [40] = 29047353, [41] = 79606837, [42] = 79606837, [43] = 79606837, [44] = 90809975, [45] = 90809975, [46] = 90809975, [47] = 36776089, [48] = 36776089, [49] = 36776089, [50] = 2766877, [51] = 2766877, [52] = 2766877, [53] = 84224627, [54] = 84224627, [55] = 84224627 }, [56] = { [1] = 98169343, [2] = 98169343, [3] = 61283655, [4] = 61283655, [5] = 61283655, [6] = 35199656, [7] = 35199656, [8] = 35199656, [9] = 14558127, [10] = 14558127, [11] = 59438930, [12] = 98700941, [13] = 23434538, [14] = 23434538, [15] = 23434538, [16] = 94145021, [17] = 63845230, [18] = 63845230, [19] = 63845230, [20] = 18144506, [21] = 35261759, [22] = 35261759, [23] = 53129443, [24] = 53129443, [25] = 53129443, [26] = 73628505, [27] = 73915051, [28] = 73915051, [29] = 22159429, [30] = 35371948, [31] = 35371948, [32] = 35371948, [33] = 10813327, [34] = 10813327, [35] = 21076084, [36] = 83555666, [37] = 40605147, [38] = 40605147, [39] = 84749824, [40] = 84749824, [41] = 41999284, [42] = 41999284, [43] = 3987233, [44] = 2857636, [45] = 50588353, [46] = 98558751, [47] = 86221741, [48] = 31833038, [49] = 3987233, [50] = 99111753, [51] = 38342335, [52] = 50588353, [53] = 9753964, [54] = 41999284, [55] = 34408491 }, [57] = { [1] = 49036338, [2] = 71074418, [3] = 21522601, [4] = 84523092, [5] = 84523092, [6] = 21744288, [7] = 21744288, [8] = 21744288, [9] = 95245544, [10] = 95245544, [11] = 95245544, [12] = 14558127, [13] = 38814750, [14] = 38814750, [15] = 38814750, [16] = 23434538, [17] = 59851535, [18] = 64756282, [19] = 64756282, [20] = 10805153, [21] = 11110587, [22] = 11110587, [23] = 14532163, [24] = 14532163, [25] = 49238328, [26] = 49238328, [27] = 49238328, [28] = 54693926, [29] = 54693926, [30] = 57916305, [31] = 57916305, [32] = 57916305, [33] = 58577036, [34] = 58577036, [35] = 58577036, [36] = 73594093, [37] = 83301414, [38] = 83301414, [39] = 83301414, [40] = 24224830, [41] = 24224830, [42] = 24224830, [43] = 56894757, [44] = 65681983, [45] = 65681983, [46] = 70226289, [47] = 13758665, [48] = 19673561, [49] = 40252269, [50] = 40252269, [51] = 83289866, [52] = 83289866, [53] = 83289866, [54] = 87769556, [55] = 10045474, [56] = 10045474, [57] = 10045474, [58] = 55072170, [59] = 94553671, [60] = 94553671, [61] = 27548199, [62] = 5041348, [63] = 5041348, [64] = 74586817, [65] = 98558751, [66] = 85289965, [67] = 38342335, [68] = 2857636, [69] = 2857636, [70] = 8802510, [71] = 50588353, [72] = 60303245, [73] = 94259633, [74] = 94259633, [75] = 94259633 }, [58] = { [1] = 92246806, [2] = 92246806, [3] = 92246806, [4] = 65247798, [5] = 65247798, [6] = 65247798, [7] = 28630501, [8] = 28630501, [9] = 28630501, [10] = 25244515, [11] = 25244515, [12] = 18144507, [13] = 53129443, [14] = 59750328, [15] = 59750328, [16] = 98645731, [17] = 98645731, [18] = 98645731, [19] = 8267140, [20] = 8267140, [21] = 8267140, [22] = 40838625, [23] = 40838625, [24] = 47475363, [25] = 47475363, [26] = 47475363, [27] = 58120309, [28] = 58120309, [29] = 58120309, [30] = 5851097, [31] = 30241314, [32] = 30241314, [33] = 30241314, [34] = 40605147, [35] = 40605147, [36] = 41420027, [37] = 59344077, [38] = 59344077, [39] = 59344077, [40] = 84749824, [41] = 44508094, [42] = 56832966, [43] = 86532744, [44] = 16195942, [45] = 84013237, [46] = 94380860, [47] = 96381979, [48] = 63746411, [49] = 82633039, [50] = 95169481, [51] = 22653490, [52] = 46772449, [53] = 21044178, [54] = 12014404, [55] = 12014404 }, [59] = { [1] = 49036338, [2] = 29432356, [3] = 29432356, [4] = 29432356, [5] = 3611830, [6] = 76794549, [7] = 5560911, [8] = 96227613, [9] = 96227613, [10] = 27354732, [11] = 58990362, [12] = 58990362, [13] = 58990362, [14] = 20773176, [15] = 22617205, [16] = 69610326, [17] = 14785765, [18] = 95401059, [19] = 31314549, [20] = 96223501, [21] = 52159691, [22] = 21495657, [23] = 21495657, [24] = 57777714, [25] = 92559258, [26] = 92559258, [27] = 92559258, [28] = 38814750, [29] = 38814750, [30] = 38814750, [31] = 72291078, [32] = 23434538, [33] = 23434538, [34] = 23434538, [35] = 94693857, [36] = 9742784, [37] = 19580308, [38] = 11609969, [39] = 61488417, [40] = 2295440, [41] = 23581825, [42] = 38943357, [43] = 38943357, [44] = 38943357, [45] = 41620959, [46] = 41620959, [47] = 41620959, [48] = 73628505, [49] = 74580251, [50] = 74580251, [51] = 74580251, [52] = 81439173, [53] = 24224830, [54] = 24224830, [55] = 46372010, [56] = 32354768, [57] = 32354768, [58] = 32354768, [59] = 35561352, [60] = 57831349, [61] = 27548199, [62] = 74586817, [63] = 80696379, [64] = 33158448, [65] = 65536818, [66] = 79606837, [67] = 88581108, [68] = 96157835, [69] = 73347079, [70] = 74997493, [71] = 44097050, [72] = 24094258, [73] = 50588353, [74] = 36429703, [75] = 41999284 }, [60] = { [1] = 70095155, [2] = 81471108, [3] = 81471108, [4] = 45082499, [5] = 45082499, [6] = 33911264, [7] = 33911264, [8] = 65367484, [9] = 65367484, [10] = 24610207, [11] = 24610207, [12] = 24610207, [13] = 30914564, [14] = 30914564, [15] = 30914564, [16] = 25259669, [17] = 25259669, [18] = 25259669, [19] = 37742478, [20] = 37742478, [21] = 94656263, [22] = 94656263, [23] = 94656263, [24] = 40941889, [25] = 18063928, [26] = 18063928, [27] = 18063928, [28] = 423585, [29] = 1845204, [30] = 1845204, [31] = 1845204, [32] = 32807846, [33] = 53129443, [34] = 5318639, [35] = 5318639, [36] = 11705261, [37] = 11705261, [38] = 11705261, [39] = 40605147, [40] = 84749824, [41] = 45231177, [42] = 17881964, [43] = 17881964, [44] = 91949988, [45] = 60992364, [46] = 56832966, [47] = 56832966, [48] = 56832966, [49] = 29669359, [50] = 86532744, [51] = 86532744, [52] = 86532744, [53] = 84013237, [54] = 84013237, [55] = 84013237 }, [61] = { [1] = 63941210, [2] = 36956512, [3] = 55063751, [4] = 28674152, [5] = 29726552, [6] = 65367484, [7] = 65367484, [8] = 65367484, [9] = 77150143, [10] = 77150143, [11] = 77150143, [12] = 31755044, [13] = 31755044, [14] = 31755044, [15] = 86120751, [16] = 86120751, [17] = 86120751, [18] = 78872731, [19] = 78872731, [20] = 78872731, [21] = 18144506, [22] = 53129443, [23] = 73628505, [24] = 73628505, [25] = 73628505, [26] = 74063034, [27] = 74063034, [28] = 74063034, [29] = 83764718, [30] = 99330325, [31] = 99330325, [32] = 99330325, [33] = 46060017, [34] = 46060017, [35] = 46060017, [36] = 57103969, [37] = 47679935, [38] = 47679935, [39] = 47679935, [40] = 73881652, [41] = 75286621, [42] = 75286621, [43] = 48791583, [44] = 48791583, [45] = 581014, [46] = 581014, [47] = 11510448, [48] = 11510448, [49] = 41375811, [50] = 41375811, [51] = 48905153, [52] = 48905153, [53] = 85115440, [54] = 85115440, [55] = 85115440 } },
	["name"] = { [1] = "AI_Albaz.ydk", [2] = "AI_Altergeist.ydk", [3] = "AI_best-friend.ydk", [4] = "AI_Blackwing.ydk", [5] = "AI_BlueEyes.ydk", [6] = "AI_BlueEyesMaxDragon.ydk", [7] = "AI_Brave.ydk", [8] = "AI_Burn.ydk", [9] = "AI_ChainBurn.ydk", [10] = "AI_CyberDragon.ydk", [11] = "AI_DarkMagician.ydk", [12] = "AI_Dogmatika.ydk", [13] = "AI_Dragun.ydk", [14] = "AI_Dragunity.ydk", [15] = "AI_Evilswarm.ydk", [16] = "AI_Exosister.ydk", [17] = "AI_FamiliarPossessed.ydk", [18] = "AI_Frog.ydk", [19] = "AI_Gravekeeper.ydk", [20] = "AI_Graydle.ydk", [21] = "AI_GrenMajuThunderBoarder.ydk", [22] = "AI_Horus.ydk", [23] = "AI_Kashtira.ydk", [24] = "AI_Labrynth.ydk", [25] = "AI_Level8.ydk", [26] = "AI_LienChan.ydk", [27] = "AI_Lightsworn.ydk", [28] = "AI_LightswornShaddoldinosour.ydk", [29] = "AI_Mathmech.ydk", [30] = "AI_MokeyMokey.ydk", [31] = "AI_MokeyMokeyKing.ydk", [32] = "AI_Nekroz.ydk", [33] = "AI_Nf.ydk", [34] = "AI_OldSchool.ydk", [35] = "AI_Orcust.ydk", [36] = "AI_Phantasm.ydk", [37] = "AI_PureWinds.ydk", [38] = "AI_Qliphort.ydk", [39] = "AI_Rainbow.ydk", [40] = "AI_Rank5.ydk", [41] = "AI_RecurringNightmare.ydk", [42] = "AI_Ryzeal.ydk", [43] = "AI_Salamangreat.ydk", [44] = "AI_SkyStriker.ydk", [45] = "AI_ST1732.ydk", [46] = "AI_stars.ydk", [47] = "AI_SuperheavySamurai.ydk", [48] = "AI_Swordsoul.ydk", [49] = "AI_Tearlaments.ydk", [50] = "AI_Test.ydk", [51] = "AI_TheDreamLand.ydk", [52] = "AI_ThunderDragon.ydk", [53] = "AI_Tianjuelong.ydk", [54] = "AI_Timethief.ydk", [55] = "AI_ToadallyAwesome.ydk", [56] = "AI_Trickstar.ydk", [57] = "AI_Witchcraft.ydk", [58] = "AI_Yosenju.ydk", [59] = "AI_Zefra.ydk", [60] = "AI_ZexalWeapons.ydk", [61] = "AI_Zoodiac.ydk" }
}

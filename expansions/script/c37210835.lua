-- 占位符 ID，请将 cxxxxxxxxx 替换为你分配的实际卡号（例如 c10000001）
local s, id = GetID()
function s.initial_effect(c)
	-- 超量召唤规则：6星怪兽×2
	-- 替换召唤规则：也能在自己场上没有超量素材的天使族超量怪兽上面重叠，1回合1次
	aux.AddXyzProcedure(c, nil, 6, 2, s.ovfilter, aux.Stringid(id, 0), 2, s.xyzop)
	c:EnableReviveLimit()
	
	-- ①：这张卡超量召唤的场合，支付500倍数的基本分才能发动。
	local e1 = Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id, 1))
	e1:SetCategory(CATEGORY_ATKCHANGE + CATEGORY_DEFCHANGE)
	e1:SetType(EFFECT_TYPE_SINGLE + EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1, id)
	e1:SetCondition(s.atkcon)
	e1:SetCost(s.atkcost)
	e1:SetOperation(s.atkop)
	c:RegisterEffect(e1)
	
	-- ②：自己·对方回合，把这张卡的1个超量取除才能发动。从卡组把1张装备魔法卡加入手卡或给场上的1只怪兽装备。
	local e2 = Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id, 2))
	e2:SetCategory(CATEGORY_SEARCH + CATEGORY_TOHAND + CATEGORY_EQUIP)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetHintTiming(0, TIMINGS_CHECK_MONSTER + TIMING_END_PHASE)
	e2:SetCountLimit(1, id + 1) -- 使用 id+100 区分同名卡的不同效果限制
	e2:SetCost(s.eqcost)		  -- 【修正处】：使用标准的取除素材判定
	e2:SetTarget(s.eqtg)
	e2:SetOperation(s.eqop)
	c:RegisterEffect(e2)
end

-- 替换超量召唤的滤镜与操作（控制同名卡1回合1次）
function s.ovfilter(c, tp, lc)
	return c:IsFaceup() and c:IsRace(RACE_FAIRY, lc, SUMMON_TYPE_XYZ, tp) and c:IsType(TYPE_XYZ, lc, SUMMON_TYPE_XYZ, tp) and c:GetOverlayCount() == 0
end
function s.xyzop(e, tp, chk)
	if chk == 0 then return Duel.GetFlagEffect(tp, id) == 0 end
	Duel.RegisterFlagEffect(tp, id, RESET_PHASE + PHASE_END, 0, 1)
	return true
end

-- ①效果相关函数
function s.atkcon(e, tp, eg, ep, ev, re, r, rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_XYZ)
end
function s.atkcost(e, tp, eg, ep, ev, re, r, rp, chk)
	-- 计算最多能支付的500的倍数（必须保证支付后至少剩余1点基本分）
	local max_pay = math.floor((Duel.GetLP(tp) - 1) / 500)
	if chk == 0 then return max_pay > 0 end
	local t = {}
	for i = 1, max_pay do
		t[i] = i * 500
	end
	local val = Duel.AnnounceNumber(tp, table.unpack(t))
	Duel.PayLPCost(tp, val)
	e:SetLabel(val)
end
function s.atkop(e, tp, eg, ep, ev, re, r, rp)
	local c = e:GetHandler()
	local val = e:GetLabel()
	local tg = Duel.GetMatchingGroup(Card.IsFaceup, tp, LOCATION_MZONE, LOCATION_MZONE, nil)
	for tc in aux.Next(tg) do
		-- 判定敌我，自己上升，对方下降
		local atk_val = tc:IsControler(tp) and val or -val
		local e1 = Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(atk_val)
		e1:SetReset(RESET_EVENT + RESETS_STANDARD + RESET_PHASE + PHASE_END)
		tc:RegisterEffect(e1)
		local e2 = e1:Clone()
		e2:SetCode(EFFECT_UPDATE_DEFENSE)
		tc:RegisterEffect(e2)
	end
end

-- ②效果相关函数

-- 【修正处】：标准的手动取除超量素材作为 Cost 的函数
function s.eqcost(e, tp, eg, ep, ev, re, r, rp, chk)
	if chk == 0 then return e:GetHandler():CheckRemoveOverlayCard(tp, 1, REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp, 1, 1, REASON_COST)
end

function s.eqfilter(c, tp)
	if not c:IsType(TYPE_EQUIP) then return false end
	return c:IsAbleToHand() or Duel.IsExistingMatchingCard(s.eqtgfilter, tp, LOCATION_MZONE, LOCATION_MZONE, 1, nil, c, tp)
end
function s.eqtgfilter(c, ec, tp)
	return c:IsFaceup() and ec:CheckEquipTarget(c)
end
function s.eqtg(e, tp, eg, ep, ev, re, r, rp, chk)
	if chk == 0 then return Duel.IsExistingMatchingCard(s.eqfilter, tp, LOCATION_DECK, 0, 1, nil, tp) end
	Duel.SetOperationInfo(0, CATEGORY_TOHAND, nil, 1, tp, LOCATION_DECK)
	Duel.SetOperationInfo(0, CATEGORY_EQUIP, nil, 1, tp, LOCATION_DECK)
end
function s.eqop(e, tp, eg, ep, ev, re, r, rp)
	Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_OPERATECARD)
	local g = Duel.SelectMatchingCard(tp, s.eqfilter, tp, LOCATION_DECK, 0, 1, 1, nil, tp)
	local tc = g:GetFirst()
	if tc then
		local b1 = tc:IsAbleToHand()
		local b2 = Duel.IsExistingMatchingCard(s.eqtgfilter, tp, LOCATION_MZONE, LOCATION_MZONE, 1, nil, tc, tp)
		local op = 0
		if b1 and b2 then
			op = Duel.SelectOption(tp, 1190, 1068)
		elseif b1 then
			op = 0
		else
			op = 1
		end
		
		if op == 0 then
			Duel.SendtoHand(tc, nil, REASON_EFFECT)
			Duel.ConfirmCards(1 - tp, tc)
		else
			Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_EQUIP)
			local sg = Duel.SelectMatchingCard(tp, s.eqtgfilter, tp, LOCATION_MZONE, LOCATION_MZONE, 1, 1, nil, tc, tp)
			local ec = sg:GetFirst()
			if ec then
				Duel.Equip(tp, tc, ec)
			end
		end
	end
end
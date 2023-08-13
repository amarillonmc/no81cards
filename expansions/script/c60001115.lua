local m = 60001115
local cm = _G["c" .. m]
cm.name = "圣兽装骑·鲨-重剑"

function cm.initial_effect(c)
	--negate
	local e1 = Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP + EFFECT_FLAG_DAMAGE_CAL)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1)
	e1:SetTarget(cm.tg1)
	e1:SetOperation(cm.op1)
	c:RegisterEffect(e1)
	local e2 = e1:Clone()
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1, m)
	e2:SetTarget(cm.tg2)
	e2:SetOperation(cm.op2)
	c:RegisterEffect(e2)
end

function cm.tg1(e, tp, eg, ep, ev, re, r, rp, chk)
	if chk == 0 then return Duel.GetLocationCount(tp, LOCATION_MZONE) > 0 end
end

function cm.op1(e, tp, eg, ep, ev, re, r, rp)
	local c = e:GetHandler()
	if Duel.GetLocationCount(tp, LOCATION_MZONE) < 0 then return end
	Duel.SpecialSummon(c, 0, tp, tp, nil, nil, POS_FACEUP)
	local e1 = Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetTargetRange(LOCATION_MZONE, 0)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTarget(cm.filter1)
	e1:SetValue(cm.filter2)
	e1:SetReset(RESET_PHASE + PHASE_END)
	Duel.RegisterEffect(e1,tp)
	local e2 = Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET + EFFECT_FLAG_CLIENT_HINT)
	e2:SetTargetRange(1, 0)
	e2:SetTarget(cm.splimit)
	e2:SetReset(RESET_PHASE + PHASE_END)
	Duel.RegisterEffect(e2, tp)
end

function cm.tg2(e, tp, eg, ep, ev, re, r, rp, chk)
	local c = e:GetHandler()
	if chk == 0 then return Duel.GetLocationCount(tp, LOCATION_MZONE) > 0
			and not Duel.IsPlayerAffectedByEffect(tp, m)
	end
	local e2 = Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(m)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET + EFFECT_CANNOT_DISABLE)
	e2:SetTargetRange(1, 0)
	Duel.RegisterEffect(e2, tp)
end

function cm.op2(e, tp, eg, ep, ev, re, r, rp)
	local c = e:GetHandler()
	if Duel.GetLocationCount(tp, LOCATION_MZONE) < 0 then return end
	Duel.SpecialSummon(c, 0, tp, tp, nil, nil, POS_FACEUP)
	local e1 = Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetTargetRange(LOCATION_MZONE, 0)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTarget(cm.filter1)
	e1:SetValue(cm.filter2)
	e1:SetReset(RESET_PHASE + PHASE_END)
	Duel.RegisterEffect(e1,tp)
	local e2 = Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET + EFFECT_FLAG_CLIENT_HINT)
	e2:SetTargetRange(1, 0)
	e2:SetTarget(cm.splimit)
	e2:SetReset(RESET_PHASE + PHASE_END)
	Duel.RegisterEffect(e2,tp)
end

function cm.filter1(e, c)
	return c:IsSetCard(0x62e) and c:IsType(TYPE_MONSTER)
end

function cm.filter2(e, te)
	return te:GetHandler():GetControler() ~= e:GetHandlerPlayer()
end

function cm.splimit(e, c)
	return not c:IsAttribute(ATTRIBUTE_WATER)
end

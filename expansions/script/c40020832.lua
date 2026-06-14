--兵虫 电锯锹甲虫
local s, id = GetID()

s.named_with_WeaponInsect = 1
function s.WeaponInsect(c)
	local m = _G["c"..c:GetCode()]
	return m and m.named_with_WeaponInsect
end

s.RAHERAKHTY_CODE = 40020713
s.WEAPON_INSECT_PLACE_EVENT = EVENT_CUSTOM + 40020713

function s.initial_effect(c)
		aux.AddCodeList(c,40020713)
	local e1 = Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id, 0))
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_HAND)
	e1:SetHintTiming(0, TIMINGS_CHECK_MONSTER + TIMING_END_PHASE)
	e1:SetCountLimit(1, id)
	e1:SetCondition(s.setcon)
	e1:SetTarget(s.settg)
	e1:SetOperation(s.setop)
	c:RegisterEffect(e1)
	
	local e2 = Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id, 1))
	e2:SetCategory(CATEGORY_TODECK)
	e2:SetType(EFFECT_TYPE_SINGLE + EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_MOVE)
	e2:SetProperty(EFFECT_FLAG_DELAY + EFFECT_FLAG_CARD_TARGET)
	e2:SetTarget(s.tdtg)
	e2:SetOperation(s.tdop)
	c:RegisterEffect(e2)
	
	local e3 = Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE + EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_BE_MATERIAL)
	e3:SetCondition(s.efcon)
	e3:SetOperation(s.efop)
	c:RegisterEffect(e3)
end

function s.fieldfilter(c)
	return c:IsFaceup() and (c:IsCode(s.RAHERAKHTY_CODE) or s.WeaponInsect(c))
end

function s.setcon(e, tp, eg, ep, ev, re, r, rp)
	return Duel.IsExistingMatchingCard(s.fieldfilter, tp, LOCATION_ONFIELD, 0, 1, nil)
end

function s.settg(e, tp, eg, ep, ev, re, r, rp, chk)
	if chk == 0 then return Duel.GetLocationCount(tp, LOCATION_SZONE) > 0 end
end

function s.setop(e, tp, eg, ep, ev, re, r, rp)
	local c = e:GetHandler()
	if not c:IsRelateToEffect(e) or Duel.GetLocationCount(tp, LOCATION_SZONE) <= 0 then return end
	
	Duel.MoveToField(c, tp, tp, LOCATION_SZONE, POS_FACEUP, true)
	
	local ot = c:GetOriginalType()
	local e1 = Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CHANGE_TYPE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetValue(TYPE_TRAP + TYPE_CONTINUOUS)
	e1:SetReset(RESET_EVENT + RESETS_STANDARD - RESET_TURN_SET)
	c:RegisterEffect(e1, true)
	
	Duel.RaiseSingleEvent(c, s.WEAPON_INSECT_PLACE_EVENT, e, REASON_EFFECT, tp, tp, 0)
end

function s.tdtg(e, tp, eg, ep, ev, re, r, rp, chk, chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1 - tp) end
	if chk == 0 then return Duel.IsExistingTarget(aux.TRUE, tp, 0, LOCATION_MZONE, 1, nil) end
	Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_TODECK)
	local g = Duel.SelectTarget(tp, aux.TRUE, tp, 0, LOCATION_MZONE, 1, 1, nil)
	Duel.SetOperationInfo(0, CATEGORY_TODECK, g, 1, 0, 0)
end

function s.tdop(e, tp, eg, ep, ev, re, r, rp)
	local tc = Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then
		Duel.SendtoDeck(tc, nil, SEQ_DECKBOTTOM, REASON_EFFECT)
	end
end

function s.efcon(e, tp, eg, ep, ev, re, r, rp)
	local rc = e:GetHandler():GetReasonCard()
	return rc:IsType(TYPE_XYZ) and s.WeaponInsect(rc)
end

function s.efop(e, tp, eg, ep, ev, re, r, rp)
	local c = e:GetHandler()
	local rc = c:GetReasonCard()
	
	local e1 = Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id, 2))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET + EFFECT_FLAG_CLIENT_HINT)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(0, 1)
	e1:SetCondition(s.actcon)
	e1:SetValue(s.actlimit)
	e1:SetReset(RESET_EVENT + RESETS_STANDARD)
	rc:RegisterEffect(e1, true)
end

function s.actcon(e)
	local tp = e:GetHandlerPlayer()
	local a = Duel.GetAttacker()
	local d = Duel.GetAttackTarget()
	return (a and a == e:GetHandler() and a:IsControler(tp))
		or (d and d == e:GetHandler() and d:IsControler(tp))
end

function s.actlimit(e, re, tp)
	return true 
end

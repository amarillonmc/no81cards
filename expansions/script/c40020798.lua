--皇兽·Z·瑙曼象
local s, id = GetID()

s.named_with_EmperorBeast = 1
function s.EmperorBeast(c)
	local m = _G["c"..c:GetCode()]
	return m and m.named_with_EmperorBeast
end

s.ZEUS_CODE = 40020683

function s.initial_effect(c)
	aux.AddCodeList(c,40020683)
	local e1 = Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id, 0))
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_HAND)
	e1:SetHintTiming(0, TIMING_END_PHASE)
	e1:SetCountLimit(1, id)
	e1:SetCondition(s.pzcon)
	e1:SetCost(s.pzcost)
	e1:SetTarget(s.pztg)
	e1:SetOperation(s.pzop)
	c:RegisterEffect(e1)
  
	local e2 = Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id, 1))
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_SINGLE + EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY + EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1, id + 1)
	e2:SetTarget(s.destg)
	e2:SetOperation(s.desop)
	c:RegisterEffect(e2)
	local e3 = e2:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
end
function s.pzfilter(c)
	return c:IsCode(s.ZEUS_CODE)
end
function s.pzcon(e, tp, eg, ep, ev, re, r, rp)
	return not Duel.IsExistingMatchingCard(s.pzfilter, tp, LOCATION_PZONE, 0, 1, nil)
end
function s.pzcost(e, tp, eg, ep, ev, re, r, rp, chk)
	if chk == 0 then return e:GetHandler():IsDiscardable() end
	Duel.SendtoGrave(e:GetHandler(), REASON_COST + REASON_DISCARD)
end
function s.zeusfilter(c)
	return c:IsCode(s.ZEUS_CODE) and not c:IsForbidden()
end
function s.pztg(e, tp, eg, ep, ev, re, r, rp, chk)
	if chk == 0 then
		local hasZone = Duel.CheckLocation(tp, LOCATION_PZONE, 0) or Duel.CheckLocation(tp, LOCATION_PZONE, 1)
		return hasZone and Duel.IsExistingMatchingCard(s.zeusfilter, tp, LOCATION_DECK, 0, 1, nil)
	end
end
function s.pzop(e, tp, eg, ep, ev, re, r, rp)
	local c = e:GetHandler()
	local hasZone = Duel.CheckLocation(tp, LOCATION_PZONE, 0) or Duel.CheckLocation(tp, LOCATION_PZONE, 1)
	if hasZone then
		Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_TOFIELD)
		local g = Duel.SelectMatchingCard(tp, s.zeusfilter, tp, LOCATION_DECK, 0, 1, 1, nil)
		if #g > 0 then
			Duel.MoveToField(g:GetFirst(), tp, tp, LOCATION_PZONE, POS_FACEUP, true)
		end
	end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetTarget(s.splimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function s.splimit(e,c)
	return not c:IsRace(RACE_THUNDER)
end
function s.destg(e, tp, eg, ep, ev, re, r, rp, chk, chkc)
	if chkc then return chkc:IsLocation(LOCATION_ONFIELD) and chkc:IsControler(1 - tp) end
	if chk == 0 then return Duel.IsExistingTarget(aux.TRUE, tp, 0, LOCATION_ONFIELD, 1, nil) end
	Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_DESTROY)
	local g = Duel.SelectTarget(tp, aux.TRUE, tp, 0, LOCATION_ONFIELD, 1, 1, nil)
	Duel.SetOperationInfo(0, CATEGORY_DESTROY, g, 1, 0, 0)
end
function s.desop(e, tp, ev, re, r, rp)
	local tc = Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then
		Duel.Destroy(tc, REASON_EFFECT)
	end
end

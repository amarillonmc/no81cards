--宙斯的仪式神殿
local s, id = GetID()

function s.EmperorBeast(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_EmperorBeast
end
s.ZEUS_CODE = 40020683
function s.initial_effect(c)

	local e1 = Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1, id, EFFECT_COUNT_CODE_OATH)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
	

	local e2=aux.AddRitualProcGreater2(c,s.ritfilter,LOCATION_HAND,nil,nil,true)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_FZONE)
	c:RegisterEffect(e2)
	
	local e3 = Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id, 2))
	e3:SetCategory(CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_FIELD + EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_PHASE + PHASE_END)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCountLimit(1, id+1)
	e3:SetCondition(s.thcon)
	e3:SetTarget(s.thtg)
	e3:SetOperation(s.thop)
	c:RegisterEffect(e3)
end
function s.zeusfilter(c)
	return c:GetCode() == s.ZEUS_CODE
end
function s.ritfilter(c)
	return s.EmperorBeast(c)
end

function s.activate(e,tp,eg,ep,ev,re,r,rp)

	if Duel.IsExistingMatchingCard(s.zeusfilter,tp,LOCATION_DECK,0,1,nil)
		and (Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1)) 
		and Duel.SelectYesNo(tp,aux.Stringid(id,3)) then
		
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
		local g=Duel.SelectMatchingCard(tp,s.zeusfilter,tp,LOCATION_DECK,0,1,1,nil)
		if g:GetCount()>0 then
			Duel.MoveToField(g:GetFirst(),tp,tp,LOCATION_PZONE,POS_FACEUP,true)
		end
	end
end

function s.thcon(e, tp, eg, ep, ev, re, r, rp)
	return Duel.GetTurnPlayer() == tp
end

function s.thtg(e, tp, eg, ep, ev, re, r, rp, chk, chkc)
	if chkc then 
		return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and s.recfilter(chkc) 
	end
	if chk == 0 then 
		return Duel.IsExistingTarget(s.recfilter, tp, LOCATION_GRAVE, 0, 1, nil) 
	end
	Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_ATOHAND)
	local g = Duel.SelectTarget(tp, s.recfilter, tp, LOCATION_GRAVE, 0, 1, 1, nil)
	Duel.SetOperationInfo(0, CATEGORY_TOHAND, g, 1, 0, 0)
end

function s.thop(e, tp, eg, ep, ev, re, r, rp)
	local tc = Duel.GetFirstTarget()
	if not tc or not tc:IsRelateToEffect(e) then return end
	
	local hasPendulumZone = Duel.CheckLocation(tp, LOCATION_PZONE, 0) or Duel.CheckLocation(tp, LOCATION_PZONE, 1)
	
	local isPendulum = tc:IsType(TYPE_PENDULUM)
	
	if hasPendulumZone and isPendulum then
		local op = Duel.SelectOption(tp, aux.Stringid(id, 4), aux.Stringid(id, 5))
		if op == 0 then

			Duel.MoveToField(tc, tp, tp, LOCATION_PZONE, POS_FACEUP, true)
			return
		end
	end
	
	Duel.SendtoHand(tc, nil, REASON_EFFECT)
	Duel.ConfirmCards(1 - tp, tc)
end
--『破交』AIII
function c9911763.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedureLevelFree(c,c9911763.mfilter,nil,3,99)
	c:EnableReviveLimit()
	--remove
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_TO_GRAVE_REDIRECT)
	e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_IGNORE_RANGE+EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(0,LOCATION_DECK)
	e1:SetTarget(c9911763.rmtg)
	e1:SetValue(LOCATION_REMOVED)
	c:RegisterEffect(e1)
	--destroy or to hand
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e2:SetCost(c9911763.descost)
	e2:SetTarget(c9911763.destg)
	e2:SetOperation(c9911763.desop)
	c:RegisterEffect(e2)
end
function c9911763.mfilter(c,xyzc)
	return c:IsXyzLevel(xyzc,4) or c:IsXyzLevel(xyzc,6) or c:IsXyzLevel(xyzc,11)
end
function c9911763.rmtg(e,c)
	return c:GetOwner()~=e:GetHandlerPlayer()
end
function c9911763.descost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c9911763.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return chkc:IsOnField() and chkc:IsFaceup() and chkc~=c end
	if chk==0 then return c:GetFlagEffect(9911763)==0
		and Duel.IsExistingTarget(Card.IsFaceup,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,c) end
	local ph=Duel.GetCurrentPhase()
	if ph>PHASE_MAIN1 and ph<PHASE_MAIN2 then ph=PHASE_BATTLE end
	c:RegisterFlagEffect(9911763,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+ph,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(9911763,0))
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,Card.IsFaceup,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,2,e:GetHandler())
end
function c9911763.xmfilter(c,ph)
	local b1=ph<=PHASE_STANDBY and c:IsLocation(LOCATION_MZONE)
	local b2=ph>=PHASE_MAIN2 and c:IsFaceup() and c:IsType(TYPE_TRAP)
	local b3=ph>PHASE_STANDBY and ph<PHASE_MAIN2 and c:IsFaceup() and c:IsType(TYPE_SPELL)
	return c:IsCanOverlay() and (b1 or b2 or b3)
end
function c9911763.desop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToChain,nil)
	if #g==0 then return end
	local c=e:GetHandler()
	local ph=Duel.GetCurrentPhase()
	if g:IsExists(c9911763.xmfilter,1,nil,ph) and c:IsRelateToChain() and c:IsType(TYPE_XYZ)
		and Duel.SelectYesNo(tp,aux.Stringid(9911763,1)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
		local sg=g:FilterSelect(tp,c9911763.xmfilter,1,1,nil,ph)
		local tc=sg:GetFirst()
		Duel.HintSelection(sg)
		if tc and not tc:IsImmuneToEffect(e) then
			local og=tc:GetOverlayGroup()
			if #og>0 then Duel.SendtoGrave(og,REASON_RULE) end
			tc:CancelToGrave()
			Duel.Overlay(c,sg)
		end
		g:RemoveCard(tc)
	end
	if #g==0 then return end
	if g:FilterCount(Card.IsAbleToHand,nil)==#g and Duel.SelectOption(tp,aux.Stringid(9911763,2),aux.Stringid(9911763,3))==1 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
	else
		Duel.Destroy(g,REASON_EFFECT)
	end
end

--巨型台风
local m=93600300
local cm=_G["c"..m]
function cm.initial_effect(c)
--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_END_PHASE)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
	--act in hand
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e2:SetCondition(cm.handcon)
	c:RegisterEffect(e2)
	--
end
function cm.cfilter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function cm.handcon(e)
	local tp=e:GetHandlerPlayer()
	return not Duel.IsExistingMatchingCard(cm.cfilter,tp,LOCATION_ONFIELD,0,1,nil)
		and Duel.IsExistingMatchingCard(cm.cfilter,tp,0,LOCATION_ONFIELD,2,nil)
		and Duel.GetCurrentPhase()==PHASE_END
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsType(TYPE_SPELL+TYPE_TRAP) and chkc~=e:GetHandler() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsType,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,2,e:GetHandler(),TYPE_SPELL+TYPE_TRAP) end
	if e:GetActivateLocation()==LOCATION_HAND then
		e:SetLabel(1)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectTarget(tp,Card.IsType,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,2,2,e:GetHandler(),TYPE_SPELL+TYPE_TRAP)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function cm.setfilter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToHand() 
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	Duel.SendtoGrave(g,REASON_EFFECT)
	Duel.BreakEffect()
	local sg=Duel.GetMatchingGroup(cm.setfilter,tp,0,LOCATION_GRAVE+LOCATION_REMOVED,nil) 
	if sg:GetCount()>0 and e:GetLabel()==1 and Duel.GetLocationCount(1-tp,LOCATION_SZONE)>0 and Duel.SelectYesNo(1-tp,aux.Stringid(m,0)) then
		local bg=sg:Select(1-tp,1,1,nil)
		Duel.SendtoHand(bg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,bg)
   end
end


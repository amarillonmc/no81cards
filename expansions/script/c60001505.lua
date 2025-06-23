--过往核心
local cm,m,o=GetID()
function cm.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(cm.fcon)
	e1:SetTarget(cm.ftg)
	e1:SetOperation(cm.fop)
	c:RegisterEffect(e1)
end
function cm.ffil1(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToGrave()
end
function cm.ffil2(c)
	return c:IsCode(60001507) and c:IsFacedown() and c:IsAbleToHand()
end
function cm.fcon(e,tp)
	return (Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2) and Duel.GetTurnPlayer()==tp and Duel.GetCurrentChain()<1
end
function cm.ftg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	return Duel.IsExistingMatchingCard(cm.ffil1,tp,LOCATION_HAND,0,1,c) and Duel.IsExistingMatchingCard(cm.ffil2,tp,LOCATION_REMOVED,0,1,nil)
end
function cm.fop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g1=Duel.SelectMatchingCard(tp, cm.ffil1,tp,LOCATION_HAND,0,1,1,c)
	g1:AddCard(c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g2=Duel.SelectMatchingCard(tp, cm.ffil2,tp,LOCATION_REMOVED,0,1,1,nil)
	if Duel.SendtoGrave(g1,REASON_EFFECT)>1 then Duel.SendtoHand(g2,nil,REASON_EFFECT) end
end
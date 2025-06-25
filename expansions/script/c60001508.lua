--毁灭创造物α
Duel.LoadScript("c60001511.lua")
local cm,m,o=GetID()
function cm.initial_effect(c)
	byd.GArtifact(c)
	
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(cm.fcon)
	e1:SetTarget(cm.ftg)
	e1:SetOperation(cm.fop)
	c:RegisterEffect(e1)
	--to hand
	local ce1=Effect.CreateEffect(c)
	ce1:SetCategory(CATEGORY_RECOVER)
	ce1:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	ce1:SetProperty(EFFECT_FLAG_DELAY)
	ce1:SetCode(EVENT_SPSUMMON_SUCCESS)
	--ce1:SetTarget(cm.tg)
	ce1:SetOperation(cm.op)
	c:RegisterEffect(ce1)
	local ce2=ce1:Clone()
	ce2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	ce2:SetRange(LOCATION_MZONE)
	ce2:SetCode(EVENT_PHASE+PHASE_END)
	ce2:SetCountLimit(1)
	c:RegisterEffect(ce2)
end
function cm.ffil1(c,code)
	return c:IsCode(code) and c:IsAbleToGrave()
end
function cm.ffil2(c)
	return c:IsCode(60001511) and c:IsFacedown() and c:IsAbleToHand()
end
function cm.fcon(e,tp)
	return (Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2) and Duel.GetTurnPlayer()==tp and Duel.GetCurrentChain()<1
end
function cm.ftg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	return Duel.IsExistingMatchingCard(cm.ffil1,tp,LOCATION_HAND,0,1,c,m+1) and Duel.IsExistingMatchingCard(cm.ffil1,tp,LOCATION_HAND,0,1,c,m+2) and Duel.IsExistingMatchingCard(cm.ffil2,tp,LOCATION_REMOVED,0,1,nil)
end
function cm.fop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g1=Duel.SelectMatchingCard(tp,cm.ffil1,tp,LOCATION_HAND,0,1,1,c,m+1)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g2=Duel.SelectMatchingCard(tp,cm.ffil1,tp,LOCATION_HAND,0,1,1,c,m+2)
	g1:Merge(g2)
	g1:AddCard(c)
	if Duel.SendtoGrave(g1,REASON_EFFECT)>2 then
		Duel.AdjustAll()
		local g3=Duel.GetMatchingGroup(cm.ffil2,tp,LOCATION_REMOVED,0,nil):GetFirst()
		Duel.SendtoHand(g3,nil,REASON_EFFECT)
	end
end
function cm.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(aux.TRUE,tp,0,LOCATION_MZONE,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,1,1-tp,LOCATION_MZONE)
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	Duel.Recover(tp,1200,REASON_EFFECT)
end
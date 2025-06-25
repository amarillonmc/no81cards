--城堡创造物
Duel.LoadScript("c60001511.lua")

local cm,m,o=GetID()
function cm.initial_effect(c)
	byd.GArtifact(c)
	--to hand
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_RECOVER)
	e1:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetOperation(cm.op)
	c:RegisterEffect(e1)
	--
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_HAND)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCondition(cm.con)
	e2:SetOperation(cm.op2)
	c:RegisterEffect(e2)
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	Duel.Recover(tp,500,REASON_EFFECT)
end
function cm.tgcheck(c)
	return c:IsAbleToGrave()
end
function cm.thcheck(c)
	return c:IsAbleToHand() and c:IsCode(60001508,60001509,60001510) and c:IsFacedown()
end
function cm.getlv(c)
	if c:IsLevelAbove(1) then
		return c:GetLevel()
	else
		return 1
	end
end
function cm.gcheck(g,sg)
	local lvsum=g:GetSum(cm.getlv)
	if lvsum==1 then
		return sg:IsExists(Card.IsCode,1,nil,60001508)
	elseif lvsum==2 then
		return sg:IsExists(Card.IsCode,1,nil,60001509)
	else
		return sg:IsExists(Card.IsCode,1,nil,60001510)
	end
end 
function cm.con(e,tp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(cm.tgcheck,tp,LOCATION_HAND,0,c)
	local sg=Duel.GetMatchingGroup(cm.thcheck,tp,LOCATION_REMOVED,0,nil)
	return (Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2) and Duel.GetTurnPlayer()==tp and Duel.GetCurrentChain()<1 and sg:CheckSubGroup(cm.gcheck,1,#g,sg)
end
function cm.op2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(cm.tgcheck,tp,LOCATION_HAND,0,c)
	local sg=Duel.GetMatchingGroup(cm.thcheck,tp,LOCATION_REMOVED,0,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local sug=g:SelectSubGroup(tp,cm.gcheck,false,1,#g,sg)
	sug:AddCard(c)
	if Duel.SendtoGrave(sug,REASON_EFFECT)>0 then
		local og=Duel.GetOperatedGroup()
		Duel.AdjustAll()
		og:RemoveCard(c)
		local ag=Group.CreateGroup()
		local lvsum=og:GetSum(cm.getlv)
		if lvsum==1 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			ag=sg:FilterSelect(tp,Card.IsCode,1,1,nil,60001508)
		elseif lvsum==2 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			ag=sg:FilterSelect(tp,Card.IsCode,1,1,nil,60001509)
		else
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			ag=sg:FilterSelect(tp,Card.IsCode,1,1,nil,60001510)
		end
		Duel.SendtoHand(ag,tp,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,ag)
	end
end
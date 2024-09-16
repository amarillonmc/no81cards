--心相隙
local cm,m,o=GetID()
function cm.initial_effect(c)
	--draw
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,m)
	e1:SetCondition(cm.con)
	e1:SetCost(cm.cost)
	e1:SetTarget(cm.tg)
	e1:SetOperation(cm.operation)
	c:RegisterEffect(e1)
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToGraveAsCost() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST)
end
function cm.con(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(nil,tp,LOCATION_ONFIELD,0,nil)
	return #g==0
end
function cm.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(nil,tp,LOCATION_HAND,0,1,e:GetHandler()) and Duel.IsExistingMatchingCard(nil,tp,0,LOCATION_HAND,1,nil) end
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	local tp=e:GetHandlerPlayer()
	
	local g1=Duel.GetMatchingGroup(nil,tp,LOCATION_HAND,0,nil)
	local g2=Duel.GetMatchingGroup(nil,tp,0,LOCATION_HAND,nil)
	
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local g3=g1:Select(tp,0,99,nil)
	if #g3>0 then
		for c in aux.Next(g3) do
			g1:RemoveCard(c)
		end
	end
	
	Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_CONFIRM)
	local g4=g2:Select(1-tp,0,99,nil)
	if #g4>0 then
		for c in aux.Next(g4) do
			g2:RemoveCard(c)
		end
	end

	Duel.ConfirmCards(tp,g4)
	Duel.ConfirmCards(1-tp,g3)

	local op1=aux.SelectFromOptions(tp,
		{#g4>0,aux.Stringid(m,1)},
		{#g2>0,aux.Stringid(m,2)})
	local op2=aux.SelectFromOptions(1-tp,
		{#g3>0,aux.Stringid(m,1)},
		{#g1>0,aux.Stringid(m,2)})

	if op1==1 then
		Duel.SendtoHand(g4,tp,REASON_EFFECT)
	elseif op1==2 then
		Duel.SendtoHand(g2,tp,REASON_EFFECT)
	end
	if op2==1 then
		Duel.SendtoHand(g3,1-tp,REASON_EFFECT)
	elseif op2==2 then
		Duel.SendtoHand(g1,1-tp,REASON_EFFECT)
	end
end



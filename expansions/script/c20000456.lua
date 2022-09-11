--深渊异龙的导引
local cm,m,o=GetID()
function cm.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,m)
	e1:SetCost(cm.cos1)
	e1:SetTarget(cm.tg1)
	e1:SetOperation(cm.op1)
	c:RegisterEffect(e1)
	local e2=aux.AddRitualProcGreater2(c,aux.FilterBoolFunction(Card.IsRace,RACE_DRAGON),LOCATION_DECK,nil,cm.val2,1)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,m)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(cm.tg2(e2:GetTarget()))
	c:RegisterEffect(e2)
end
--e1
function cm.cosf1(c)
	return c:IsSetCard(0x9fd5) and c:IsPublic()
end
function cm.tgf1(c)
	return c:IsSetCard(0x9fd5) and c:IsAbleToHand() and not c:IsType(TYPE_RITUAL)
end
function cm.cos1(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetReleaseGroup(tp,true):Filter(cm.cosf1,nil)
	if chk==0 then return #g>0 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	g=g:Select(tp,1,1,nil)
	Auxiliary.UseExtraReleaseCount(g,tp)
	Duel.Release(g,REASON_COST)
end
function cm.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.tgf1,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(cm.tgf2,tp,LOCATION_DECK,0,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,cm.tgf1,tp,LOCATION_DECK,0,1,1,nil)
	if #g>0 and Duel.SendtoHand(g,nil,REASON_EFFECT)>0 then
		Duel.ConfirmCards(1-tp,g)
	end
end
--e2
function cm.val2(c)
	return c:IsPublic() and c:IsLocation(LOCATION_HAND)
end
function cm.tg2(pre_tg)
	return function(e,tp,eg,ep,ev,re,r,rp,chk)
		if chk==0 then return pre_tg(e,tp,eg,ep,ev,re,r,rp,0) end
		pre_tg(e,tp,eg,ep,ev,re,r,rp,1)
		Duel.Hint(24,0,aux.Stringid(m,0))
	end
end
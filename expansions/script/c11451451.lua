--革命再起
local m=11451451
local cm=_G["c"..m]
function cm.initial_effect(c)
	aux.AddCodeList(c,99518961)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,m+EFFECT_COUNT_CODE_OATH)
	e1:SetCost(cm.cost)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
end
function cm.filter1(c)
	return c:IsType(TYPE_NORMAL) and c:IsAbleToDeckAsCost()
end
function cm.filter2(c)
	return aux.IsCodeListed(c,99518961) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function cm.filter3(c)
	return ((aux.IsCodeListed(c,99518961) and c:IsType(TYPE_SPELL)) or c:IsCode(99518961)) and c:IsAbleToHand()
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.filter1,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,cm.filter1,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SendtoDeck(g,nil,2,REASON_COST)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.filter2,tp,LOCATION_DECK,0,1,nil) and Duel.IsExistingMatchingCard(cm.filter3,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,2,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local g1=Duel.GetMatchingGroup(cm.filter2,tp,LOCATION_DECK,0,nil)
	local g2=Duel.GetMatchingGroup(aux.NecroValleyFilter(cm.filter3),tp,LOCATION_GRAVE,0,nil)
	if g1:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg1=g1:Select(tp,1,1,nil)
		if Duel.SendtoHand(sg1,nil,REASON_EFFECT)>0 then
			Duel.ConfirmCards(1-tp,sg1)
			if g2:GetCount()>0 then
				Duel.BreakEffect()
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
				local sg2=g2:Select(tp,1,1,nil)
				if Duel.SendtoHand(sg2,nil,REASON_EFFECT)>0 then
					Duel.ConfirmCards(1-tp,sg2)
				end
			end
		end
	end
end
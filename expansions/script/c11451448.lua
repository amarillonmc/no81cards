--革命的准备
local m=11451448
local cm=_G["c"..m]
function cm.initial_effect(c)
	aux.AddCodeList(c,99518961)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,m+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
end
function cm.filter1(c)
	return aux.IsCodeListed(c,99518961) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function cm.filter2(c)
	return c:IsCode(99518961,65396880) and c:IsAbleToHand()
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.filter1,tp,LOCATION_DECK,0,1,nil) and Duel.IsExistingMatchingCard(cm.filter2,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,2,tp,LOCATION_DECK)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local g1=Duel.GetMatchingGroup(cm.filter1,tp,LOCATION_DECK,0,nil)
	local g2=Duel.GetMatchingGroup(cm.filter2,tp,LOCATION_DECK,0,nil)
	if g1:GetCount()>0 and g2:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg1=g1:Select(tp,1,1,nil)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg2=g2:Select(tp,1,1,nil)
		sg1:Merge(sg2)
		if Duel.SendtoHand(sg1,nil,REASON_EFFECT)>0 then
			Duel.ConfirmCards(1-tp,sg1)
			local ct=Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)-Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)
			if ct>0 and Duel.IsPlayerCanDraw(1-tp,ct) then
				Duel.Draw(1-tp,ct,REASON_EFFECT)
			end
		end
	end
end
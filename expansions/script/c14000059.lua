--源始魔术再诞
local m=14000059
local cm=_G["c"..m]
cm.named_with_Origic=1
function cm.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
end
function cm.filter(c,tp)
	return c:IsAbleToHand() and c:IsCode(14000056) and Duel.IsExistingMatchingCard(cm.filter_1,tp,LOCATION_DECK,0,1,nil)
end
function cm.filter_1(c)
	return c:IsAbleToGrave() and c:IsCode(14000055)
end
function cm.filter1(c,tp)
	return c:IsAbleToHand() and c:IsCode(14000055) and Duel.IsExistingMatchingCard(cm.filter1_1,tp,LOCATION_DECK,0,1,nil)
end
function cm.filter1_1(c)
	return c:IsAbleToGrave() and c:IsCode(14000056)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_DECK,0,1,nil,tp) or Duel.IsExistingMatchingCard(cm.filter1,tp,LOCATION_DECK,0,1,nil,tp) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(cm.filter,tp,LOCATION_DECK,0,nil,tp)
	local g1=Duel.GetMatchingGroup(cm.filter1,tp,LOCATION_DECK,0,nil,tp)
	if #g<=0 or #g1<=0 then return end
	g2=Group.__add(g,g1)
	if #g2>1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local tg=g2:FilterSelect(tp,Card.IsAbleToHand,1,1,nil)
		local tc=tg:GetFirst()
		if g:IsContains(tc) then
			g2:Sub(g)
		else
			g2:Sub(g1)
		end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local tg1=g2:FilterSelect(tp,Card.IsAbleToGrave,1,1,nil)
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc)
		Duel.SendtoGrave(tg1,REASON_EFFECT)
	end
end
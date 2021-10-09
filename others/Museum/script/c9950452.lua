--fate·夏天之力
function c9950452.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,9950452+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c9950452.target)
	e1:SetOperation(c9950452.activate)
	c:RegisterEffect(e1)
end
function c9950452.filter1(c)
	return c:IsSetCard(0xba5) and bit.band(c:GetType(),0x82)==0x82 and c:IsAbleToHand()
end
function c9950452.filter2(c)
	return c:IsSetCard(0xba5) and bit.band(c:GetType(),0x81)==0x81 and c:IsAbleToHand()
end
function c9950452.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9950452.filter1,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil)
		and Duel.IsExistingMatchingCard(c9950452.filter2,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,2,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function c9950452.activate(e,tp,eg,ep,ev,re,r,rp)
	local g1=Duel.GetMatchingGroup(c9950452.filter1,tp,LOCATION_DECK+LOCATION_GRAVE,0,nil)
	local g2=Duel.GetMatchingGroup(c9950452.filter2,tp,LOCATION_DECK+LOCATION_GRAVE,0,nil)
	if g1:GetCount()>0 and g2:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg1=g1:Select(tp,1,1,nil)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg2=g2:Select(tp,1,1,nil)
		sg1:Merge(sg2)
		Duel.SendtoHand(sg1,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg1)
	end
end



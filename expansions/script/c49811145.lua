--侵略の再生
function c49811145.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_MAIN_END+TIMING_END_PHASE)
	e1:SetTarget(c49811145.target)
	e1:SetOperation(c49811145.activate)
	c:RegisterEffect(e1)
end
function c49811145.filter(c)
	return c:IsSetCard(0x100a) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand() and c:IsFaceup()
end
function c49811145.life(tp)
	return Duel.GetLP(tp) < Duel.GetLP(1-tp)
end
function c49811145.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local zone=LOCATION_GRAVE+LOCATION_REMOVED
	if c49811145.life(tp) then zone=LOCATION_GRAVE+LOCATION_REMOVED+LOCATION_ONFIELD end
	if chkc then return chkc:IsLocation(zone) and chkc:IsControler(tp) and c49811145.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c49811145.filter,tp,zone,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,c49811145.filter,tp,zone,0,1,2,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,g:GetCount(),tp,0)
end
function c49811145.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local sg=g:Filter(Card.IsRelateToEffect,nil,e)
	if sg:GetCount()>0 then
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
	end
end
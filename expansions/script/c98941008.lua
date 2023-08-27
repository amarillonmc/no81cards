--多元春化精与花蕾
function c98941008.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,98941008+EFFECT_COUNT_CODE_OATH)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetTarget(c98941008.target)
	e1:SetOperation(c98941008.activate)
	c:RegisterEffect(e1)
	--act in hand
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e3:SetCondition(c98941008.handcon)
	c:RegisterEffect(e3)
end
function c98941008.cfilter(c)
	return c:IsSummonLocation(LOCATION_GRAVE) and c:IsAttribute(ATTRIBUTE_EARTH) and c:IsFaceup()
end
function c98941008.thfilter(c)
	return c:IsFaceup() and c:IsAbleToHand()
end
function c98941008.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsControler(1-tp) and c98941008.thfilter(chkc) end
	local g=Duel.GetMatchingGroup(c98941008.cfilter,tp,LOCATION_MZONE,0,nil)
	if chk==0 then return #g>0 and Duel.IsExistingTarget(c98941008.thfilter,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local ct=g:GetClassCount(Card.GetCode)
	local sg=Duel.SelectTarget(tp,c98941008.thfilter,tp,0,LOCATION_ONFIELD,1,ct,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,sg,sg:GetCount()*2,0,0)
end
function c98941008.sfilter(c)
	return c:IsAttribute(ATTRIBUTE_EARTH) and c:IsFaceup() and c:IsAbleToHand()
end
function c98941008.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local tg=g:Filter(Card.IsRelateToEffect,nil,e)
	local ct=g:GetCount()
	local g2=Duel.GetMatchingGroup(c98941008.sfilter,tp,LOCATION_MZONE,0,nil)
	if g2:GetCount()<ct then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local sg=g2:Select(tp,ct,ct,nil)
	if Duel.SendtoHand(sg,nil,REASON_EFFECT)>0 and sg:IsExists(Card.IsLocation,1,nil,LOCATION_HAND) then
		Duel.SendtoHand(tg,nil,REASON_EFFECT)
	end
end
function c98941008.hfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xa182)
end
function c98941008.handcon(e)
	return Duel.IsExistingMatchingCard(c98941008.hfilter,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil)
end
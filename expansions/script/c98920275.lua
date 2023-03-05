--鹰身守护者
function c98920275.initial_effect(c)
	--change name
	aux.EnableChangeCode(c,76812113,LOCATION_MZONE+LOCATION_GRAVE)
	--link summon
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkRace,RACE_WINDBEAST),2,3)
--tohand
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,98920275)
	e2:SetTarget(c98920275.thtg)
	e2:SetOperation(c98920275.thop)
	c:RegisterEffect(e2)
--search
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(98920275,1))
	e4:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_TO_GRAVE)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetCountLimit(1,98930275)
	e4:SetCondition(c98920275.thcon1)
	e4:SetTarget(c98920275.thtg1)
	e4:SetOperation(c98920275.thop1)
	c:RegisterEffect(e4)
end
function c98920275.filter(c)
	return c:IsSetCard(0x64) and c:IsAbleToHand() and c:IsType(TYPE_MONSTER)
end
function c98920275.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then return Duel.IsExistingTarget(c98920275.filter,tp,LOCATION_GRAVE,0,1,nil)
		and Duel.IsExistingTarget(Card.IsAbleToHand,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g1=Duel.SelectTarget(tp,c98920275.filter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g2=Duel.SelectTarget(tp,Card.IsAbleToHand,tp,0,LOCATION_MZONE,1,1,nil)
	g1:Merge(g2)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g1,2,0,0)
end
function c98920275.thop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
	end
end
function c98920275.thcon1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousLocation(LOCATION_MZONE) and c:IsSummonType(SUMMON_TYPE_LINK)
end
function c98920275.filter1(c)
	return c:IsSetCard(0x64) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c98920275.filter2(c)
	return c:IsCode(19337371,21297224,77778835) and c:IsAbleToHand()
end
function c98920275.thtg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c98920275.filter1,tp,LOCATION_DECK,0,1,nil)
		and Duel.IsExistingMatchingCard(c98920275.filter2,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,2,tp,LOCATION_DECK)
end
function c98920275.thop1(e,tp,eg,ep,ev,re,r,rp)
	local g1=Duel.GetMatchingGroup(c98920275.filter1,tp,LOCATION_DECK,0,nil)
	local g2=Duel.GetMatchingGroup(c98920275.filter2,tp,LOCATION_DECK,0,nil)
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
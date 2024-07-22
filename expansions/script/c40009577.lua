--瓦尔里纳
function c40009577.initial_effect(c)
	aux.AddCodeList(c,40009571)
	--link summon
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkCode,40009571),1,1)
	--search
	local e1=Effect.CreateEffect(c) 
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O) 
	e1:SetCode(EVENT_SPSUMMON_SUCCESS) 
	e1:SetProperty(EFFECT_FLAG_DELAY) 
	e1:SetCountLimit(1,40009577) 
	e1:SetCondition(function(e) 
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK) end)
	e1:SetCost(c40009577.thcost)
	e1:SetTarget(c40009577.thtg)
	e1:SetOperation(c40009577.thop)
	c:RegisterEffect(e1)
end
function c40009577.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)
end
function c40009577.thfilter1(c,tp)
	return c:IsSetCard(0x3f1b) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand() and Duel.IsExistingMatchingCard(c40009577.thfilter2,tp,LOCATION_DECK,0,1,c)
end
function c40009577.thfilter2(c)
	return c:IsCode(40009569) and c:IsAbleToHand()
end
function c40009577.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c40009577.thfilter1,tp,LOCATION_DECK,0,1,nil,tp) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c40009577.thop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local tc=Duel.SelectMatchingCard(tp,c40009577.thfilter1,tp,LOCATION_DECK,0,1,1,nil,tp) 
	if tc then 
		local sg=Duel.SelectMatchingCard(tp,c40009577.thfilter2,tp,LOCATION_DECK,0,1,1,tc) 
		sg:AddCard(tc)
		Duel.SendtoHand(sg,tp,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg)
	end
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e2:SetTargetRange(1,0)
	e2:SetTarget(function(e,c)
	return not c:IsAttribute(ATTRIBUTE_FIRE) end)
	e2:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e2,tp)
end









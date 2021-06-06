--桃绯交锋
function c9910532.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetCondition(c9910532.condition)
	e1:SetTarget(c9910532.target)
	e1:SetOperation(c9910532.activate)
	c:RegisterEffect(e1)
end
function c9910532.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFieldGroupCount(tp,0,LOCATION_MZONE)>Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)
end
function c9910532.thfilter(c)
	return c:IsSetCard(0xa950) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c9910532.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9910532.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function c9910532.cpfilter(c)
	return c:IsSetCard(0xa950) and c:GetType()==0x82 and c:IsAbleToGrave()
		and c:CheckActivateEffect(true,true,false)~=nil
end
function c9910532.activate(e,tp,eg,ep,ev,re,r,rp)
	local ct=Duel.GetFieldGroupCount(tp,0,LOCATION_MZONE)-Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)
	local g=Duel.GetMatchingGroup(aux.NecroValleyFilter(c9910532.thfilter),tp,LOCATION_DECK+LOCATION_GRAVE,0,nil)
	if ct<1 or g:GetCount()==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local sg=g:SelectSubGroup(tp,aux.dncheck,false,1,ct)
	local res=sg:IsExists(Card.IsLocation,1,nil,LOCATION_DECK)
	Duel.SendtoHand(sg,nil,REASON_EFFECT)
	Duel.ConfirmCards(1-tp,sg)
	if not sg:IsExists(Card.IsLocation,1,nil,LOCATION_HAND) then return end
	local loc=LOCATION_HAND+LOCATION_DECK 
	if res then loc=LOCATION_HAND end
	local g2=Duel.GetMatchingGroup(c9910532.cpfilter,tp,loc,0,nil)
	if g2:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(9910532,0)) then
		Duel.BreakEffect()
		local tc=g2:Select(tp,1,1,nil):GetFirst()
		if not tc or Duel.SendtoGrave(tc,REASON_EFFECT)==0 or not tc:IsLocation(LOCATION_GRAVE) then return end
		local te=tc:GetActivateEffect()
		local op=te:GetOperation()
		if op then op(e,tp,eg,ep,ev,re,r,rp) end
	end
end

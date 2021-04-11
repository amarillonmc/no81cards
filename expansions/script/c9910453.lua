--约定的韶光 希尔维娅
function c9910453.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c9910453.hspcon)
	e1:SetValue(c9910453.hspval)
	c:RegisterEffect(e1)
	--to hand
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_TOGRAVE+CATEGORY_REMOVE)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,9910453)
	e2:SetTarget(c9910453.thtg)
	e2:SetOperation(c9910453.thop)
	c:RegisterEffect(e2)
end
function c9910453.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x9950)
end
function c9910453.hspcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local zone=0
	local lg=Duel.GetMatchingGroup(c9910453.cfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	for tc in aux.Next(lg) do
		zone=bit.bor(zone,tc:GetColumnZone(LOCATION_MZONE,tp))
	end
	return Duel.GetLocationCount(tp,LOCATION_MZONE,tp,LOCATION_REASON_TOFIELD,zone)>0
end
function c9910453.hspval(e,c)
	local tp=c:GetControler()
	local zone=0
	local lg=Duel.GetMatchingGroup(c9910453.cfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	for tc in aux.Next(lg) do
		zone=bit.bor(zone,tc:GetColumnZone(LOCATION_MZONE,tp))
	end
	return 0,zone
end
function c9910453.thfilter(c)
	return c:GetCounter(0x1950)>0 and c:IsAbleToHand()
end
function c9910453.filter1(c)
	return c:IsSetCard(0x9950) and (c:IsAbleToGrave() or c:IsAbleToRemove())
end
function c9910453.filter2(c)
	return (c:IsLocation(LOCATION_GRAVE) or c:IsFaceup()) and c:IsSetCard(0x9950) and c:IsAbleToHand()
end
function c9910453.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and c9910453.thfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c9910453.thfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) and (Duel.IsExistingMatchingCard(c9910453.filter1,tp,LOCATION_DECK,0,1,nil) or Duel.IsExistingMatchingCard(c9910453.filter2,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil)) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=Duel.SelectTarget(tp,c9910453.thfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c9910453.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if not tc:IsRelateToEffect(e) or Duel.SendtoHand(tc,nil,REASON_EFFECT)==0
		or not tc:IsLocation(LOCATION_HAND) then return end
	local g1=Duel.GetMatchingGroup(c9910453.filter1,tp,LOCATION_DECK,0,nil)
	local g2=Duel.GetMatchingGroup(aux.NecroValleyFilter(c9910453.filter2),tp,LOCATION_GRAVE+LOCATION_REMOVED,0,nil)
	local op=0
	if #g1>0 and #g2>0 then op=Duel.SelectOption(tp,aux.Stringid(9910453,0),aux.Stringid(9910453,1))
	elseif #g1>0 then op=Duel.SelectOption(tp,aux.Stringid(9910453,0))
	elseif #g2>0 then op=Duel.SelectOption(tp,aux.Stringid(9910453,1))+1
	else return end
	if op==0 then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
		local tc=g1:Select(tp,1,1,nil):GetFirst()
		if tc then
			if tc:IsAbleToGrave() and (not tc:IsAbleToRemove() or Duel.SelectOption(tp,1191,1192)==0) then
				Duel.SendtoGrave(tc,REASON_EFFECT)
			else
				Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)
			end
		end
	else
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=g2:Select(tp,1,1,nil)
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg)
	end
end

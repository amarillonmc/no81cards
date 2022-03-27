--治安战警队 追缉者
function c9794970.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(9794970,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,9794970)
	e1:SetCondition(c9794970.spcon)
	e1:SetTarget(c9794970.sptg)
	e1:SetOperation(c9794970.spop)
	c:RegisterEffect(e1)
	--search
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(9794970,1))
	e2:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetCountLimit(1,9794971)
	e2:SetTarget(c9794970.thtg)
	e2:SetOperation(c9794970.thop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_REMOVE)
	c:RegisterEffect(e3)
end
function c9794970.spfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x156)
end
function c9794970.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c9794970.spfilter,tp,LOCATION_ONFIELD+LOCATION_GRAVE,0,1,nil)
end
function c9794970.getzone(tp)
	local zone=0
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_MZONE,nil)
	for tc in aux.Next(g) do
		local seq=aux.MZoneSequence(tc:GetSequence())
		zone=zone|(1<<(4-seq))
	end
	return zone
end
function c9794970.linkfilter(c)
	return c:IsLinkSummonable(nil)
end
function c9794970.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local zone=0
	local lg=Duel.GetFieldGroup(tp,0,LOCATION_MZONE)
	for lc in aux.Next(lg) do
		zone=bit.bor(zone,lc:GetColumnZone(LOCATION_MZONE,tp))
	end
	zone=zone&0x1f
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE,tp,LOCATION_REASON_TOFIELD,zone)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false,zone) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c9794970.spop(e,tp,eg,ep,ev,re,r,rp)
	local zone=0
	local lg=Duel.GetFieldGroup(tp,0,LOCATION_MZONE)
	for lc in aux.Next(lg) do
		zone=bit.bor(zone,lc:GetColumnZone(LOCATION_MZONE,tp))
	end
	zone=zone&0x1f
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP,zone)>0 and Duel.IsExistingMatchingCard(c9794970.linkfilter,tp,LOCATION_EXTRA,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(9794970,2)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,c9794970.linkfilter,tp,LOCATION_EXTRA,0,1,1,nil)
		local tc=g:GetFirst()
		if tc then
			Duel.LinkSummon(tp,tc,nil)
		end
	end
end
function c9794970.thfilter(c)
	return c:IsSetCard(0x156) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToHand()
end
function c9794970.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9794970.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c9794970.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c9794970.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end

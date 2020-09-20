--理念的冲突
function c9950560.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(c9950560.condition)
	e1:SetTarget(c9950560.target)
	e1:SetOperation(c9950560.activate)
	c:RegisterEffect(e1)
 --search
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_DESTROYED)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,9950560)
	e2:SetCondition(c9950560.thcon)
	e2:SetTarget(c9950560.thtg)
	e2:SetOperation(c9950560.thop)
	c:RegisterEffect(e2)
end
function c9950560.cfilter(c)
	return c:IsFaceup() and c:IsCode(9950556)
end
function c9950560.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c9950560.cfilter,tp,LOCATION_ONFIELD,0,1,nil)
end
function c9950560.desfilter(c)
	return not c9950560.cfilter(c)
end
function c9950560.spfilter(c,e,tp)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x6ba6) and c:IsCanBeSpecialSummoned(e,0,tp,true,false)
end
function c9950560.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(c9950560.desfilter,tp,LOCATION_MZONE,0,nil)
	if chk==0 then
		local loc=0
		if Duel.GetMZoneCount(tp,g)>0 then loc=loc+LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE end
		if Duel.GetLocationCountFromEx(tp,tp,g)>0 then loc=loc+LOCATION_EXTRA end
		return g:GetCount()>0 and loc~=0
			and Duel.IsExistingMatchingCard(c9950560.spfilter,tp,loc,0,1,nil,e,tp)
	end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE+LOCATION_EXTRA)
end
function c9950560.gcheck(g,ft1,ft2,ft)
	return aux.dncheck(g) and #g<=ft
		and g:FilterCount(Card.IsLocation,nil,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE)<=ft1
		and g:FilterCount(Card.IsLocation,nil,LOCATION_EXTRA)<=ft2
end
function c9950560.activate(e,tp,eg,ep,ev,re,r,rp)
	local dg=Duel.GetMatchingGroup(c9950560.desfilter,tp,LOCATION_MZONE,0,nil)
	if Duel.Destroy(dg,REASON_EFFECT)==0 then return end
	local ft1=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local ft2=Duel.GetLocationCountFromEx(tp)
	local ft=Duel.GetUsableMZoneCount(tp)
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then
		if ft1>0 then ft1=1 end
		if ft2>0 then ft2=1 end
		ft=1
	end
	local loc=0
	if ft1>0 then loc=loc+LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE end
	if ft2>0 then loc=loc+LOCATION_EXTRA end
	if loc==0 then return end
	local ect=c29724053 and Duel.IsPlayerAffectedByEffect(tp,29724053) and c29724053[tp]
	if ect and ect<ft2 then ft2=ect end
	local sg=Duel.GetMatchingGroup(aux.NecroValleyFilter(c9950560.spfilter),tp,loc,0,nil,e,tp)
	if sg:GetCount()==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local rg=sg:SelectSubGroup(tp,c9950560.gcheck,false,1,2,ft1,ft2,ft)
	Duel.SpecialSummon(rg,0,tp,tp,true,false,POS_FACEUP)
end
function c9950560.thcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousLocation(LOCATION_ONFIELD) and bit.band(r,REASON_EFFECT)~=0
end
function c9950560.thfilter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsSetCard(0x6ba6) and c:IsAbleToHand()
end
function c9950560.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9950560.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c9950560.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c9950560.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
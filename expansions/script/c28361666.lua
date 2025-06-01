--放课后花开彩祭！
function c28361666.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c28361666.target)
	e1:SetOperation(c28361666.activate)
	c:RegisterEffect(e1)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(28361666,1))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_TOGRAVE+CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCondition(c28361666.spcon)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c28361666.sptg)
	e2:SetOperation(c28361666.spop)
	c:RegisterEffect(e2)
end
function c28361666.spfilter(c,e,tp)
	return c:IsSetCard(0x286) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
	and Duel.IsExistingMatchingCard(c28361666.cfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,c:GetAttribute())
end
function c28361666.cfilter(c,attr)
	return c:IsNonAttribute(attr) and c:IsFaceup()
end
function c28361666.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetMZoneCount(tp)>0
		and Duel.IsExistingMatchingCard(c28361666.spfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil,e,tp)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function c28361666.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetMZoneCount(tp)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sc=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c28361666.spfilter),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,e,tp):GetFirst()
	local g=Duel.GetMatchingGroup(Card.IsFaceup,0,LOCATION_MZONE,LOCATION_MZONE,nil)
	g:AddCard(sc)
	if sc and Duel.SpecialSummonStep(sc,0,tp,tp,false,false,POS_FACEUP) and aux.GetAttributeCount(g)<=3 and sc:IsSummonLocation(LOCATION_DECK) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetDescription(aux.Stringid(28361666,0))
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CANNOT_TRIGGER)
		e1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
		--e1:SetCondition(c28361666.accon)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		sc:RegisterEffect(e1)
	end
	Duel.SpecialSummonComplete()
end
function c28361666.accon(e)
	local g=Duel.GetMatchingGroup(Card.IsFaceup,0,LOCATION_MZONE,LOCATION_MZONE,nil)
	return aux.GetAttributeCount(g)<3
end
function c28361666.spcon(e,tp,eg,ep,ev,re,r,rp)
	return re:IsActiveType(TYPE_MONSTER) and re:GetActivateLocation()==LOCATION_MZONE
end
function c28361666.tgfilter(c,e,tp,chk)
	return (chk~=0 or Duel.GetMZoneCount(tp,c)>0) and (c:IsAbleToHand() and (chk~=0 or Duel.IsExistingMatchingCard(c28361666.gspfilter,tp,LOCATION_HAND,0,1,nil,e,tp)) or c:IsAbleToGrave() and (chk~=0 or Duel.IsExistingMatchingCard(c28361666.gspfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp)))
end
function c28361666.gspfilter(c,e,tp)
	return c:IsSetCard(0x286) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
	and Duel.IsExistingMatchingCard(c28361666.chkfilter,0,LOCATION_MZONE,LOCATION_MZONE,1,nil,c:GetAttribute())
end
function c28361666.chkfilter(c,attr)
	return c:IsAttribute(attr) and c:IsFaceup()
end
function c28361666.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c28361666.tgfilter,tp,LOCATION_MZONE,0,1,nil,e,tp,0) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_GRAVE)
end
function c28361666.spop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
	local tc=Duel.SelectMatchingCard(tp,c28361666.tgfilter,tp,LOCATION_MZONE,0,1,1,nil,e,tp,1):GetFirst()
	if not tc then return end
	Duel.HintSelection(Group.FromCards(tc))
	local loc=0
	if tc:IsAbleToHand() and (not tc:IsAbleToGrave() or Duel.SelectOption(tp,1190,1191)==0) then
		if Duel.SendtoHand(tc,nil,REASON_EFFECT)~=0 and tc:IsLocation(LOCATION_HAND) then loc=LOCATION_HAND end
		--Duel.ConfirmCards(1-tp,tc)
	else
		if Duel.SendtoGrave(tc,REASON_EFFECT)~=0 and tc:IsLocation(LOCATION_GRAVE) then loc=LOCATION_GRAVE end
	end
	if loc==0 or Duel.GetMZoneCount(tp)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sc=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c28361666.gspfilter),tp,loc,0,1,1,nil,e,tp):GetFirst()
	if sc then
		Duel.SpecialSummon(sc,0,tp,tp,false,false,POS_FACEUP)
	end
end

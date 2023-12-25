--卢纳人偶师
function c74546765.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,c74546765.matfilter,1,1)
	c:EnableReviveLimit()
	--to hand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(74546765,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1,74546765)
	e1:SetCondition(c74546765.thcon)
	e1:SetTarget(c74546765.thtg)
	e1:SetOperation(c74546765.thop)
	c:RegisterEffect(e1)
	--Special Summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(74546765,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c74546765.spcon)
	e2:SetTarget(c74546765.sptg)
	e2:SetOperation(c74546765.spop)
	c:RegisterEffect(e2)
end
function c74546765.matfilter(c)
	return c:IsLinkSetCard(0x745) and not c:IsLinkType(TYPE_LINK)
end
function c74546765.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end
function c74546765.thfilter(c)
	return c:IsSetCard(0x745) and c:IsAbleToHand()
end
function c74546765.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c74546765.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c74546765.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c74546765.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c74546765.cfilter(c,ec)
	if c:IsFaceup() and c:IsType(TYPE_RITUAL) and c:IsSummonType(SUMMON_TYPE_RITUAL) then
		if c:IsLocation(LOCATION_MZONE) then
			return ec:GetLinkedGroup():IsContains(c)
		else
			return bit.band(ec:GetLinkedZone(c:GetPreviousControler()),bit.lshift(0x1,c:GetPreviousSequence()))~=0
		end
	end
end
function c74546765.spcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c74546765.cfilter,1,nil,e:GetHandler())
end
function c74546765.spfilter(c,e,tp)
	return c:IsType(TYPE_DUAL) and c:IsSetCard(0x745) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c74546765.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(c74546765.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end
function c74546765.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tc=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c74546765.spfilter),tp,LOCATION_GRAVE,0,1,1,nil,e,tp):GetFirst()
	if tc and Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP) then
		if tc:IsSummonable(true,nil) and Duel.SelectYesNo(tp,aux.Stringid(74546765,2)) then Duel.Summon(tp,tc,true,nil) end
	end
end

--闪耀的放课后 西城树里
function c28316048.initial_effect(c)
	--hokura spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(28316048,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,28316048)
	e1:SetCost(c28316048.spcost)
	e1:SetTarget(c28316048.sptg)
	e1:SetOperation(c28316048.spop)
	c:RegisterEffect(e1)
	--recover
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(28316048,1))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_LEAVE_FIELD)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,38316048)
	e2:SetCondition(c28316048.reccon)
	e2:SetTarget(c28316048.rectg)
	e2:SetOperation(c28316048.recop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_LEAVE_GRAVE)
	c:RegisterEffect(e3)
end
function c28316048.chkfilter(c)
	return c:IsSetCard(0x283) and c:IsNonAttribute(ATTRIBUTE_LIGHT) and c:IsType(TYPE_MONSTER) and not c:IsPublic()
end
function c28316048.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c28316048.chkfilter,tp,LOCATION_HAND,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local g=Duel.SelectMatchingCard(tp,c28316048.chkfilter,tp,LOCATION_HAND,0,1,1,nil)
	Duel.ConfirmCards(1-tp,g)
	Duel.ShuffleHand(tp)
end
function c28316048.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c28316048.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c28316048.cfilter(c)
	return c:IsPreviousLocation(LOCATION_GRAVE) and c:IsType(TYPE_MONSTER) or c:IsPreviousLocation(LOCATION_MZONE)
end
function c28316048.reccon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c28316048.cfilter,1,nil)
end
function c28316048.thfilter(c)
	return c:IsSetCard(0x283) and c:IsAbleToHand()
end
function c28316048.rectg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c28316048.thfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE)
end
function c28316048.spfilter(c,e,tp)
	for _,sumtype in pairs({0,SUMMON_TYPE_FUSION,SUMMON_TYPE_SYNCHRO,SUMMON_TYPE_XYZ,SUMMON_TYPE_LINK,SUMMON_TYPE_SPECIAL,SUMMON_VALUE_SELF}) do
		if c:IsSpecialSummonable(sumtype) and aux.NecroValleyFilter()(c) then return true end
	end
	return false
end
function c28316048.recop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local tc=Duel.SelectMatchingCard(tp,c28316048.thfilter,tp,LOCATION_GRAVE,0,1,1,nil):GetFirst()
	if tc then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc)
	end
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	if aux.GetAttributeCount(g)>=3 and Duel.IsExistingMatchingCard(c28316048.spfilter,tp,0xff,0,1,nil,e,tp) and Duel.SelectYesNo(tp,aux.Stringid(28316048,2)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sc=Duel.SelectMatchingCard(tp,c28316048.spfilter,tp,0xff,0,1,1,nil,e,tp):GetFirst()
		for _,sumtype in pairs({0,SUMMON_TYPE_FUSION,SUMMON_TYPE_SYNCHRO,SUMMON_TYPE_XYZ,SUMMON_TYPE_LINK,SUMMON_TYPE_SPECIAL,SUMMON_VALUE_SELF}) do
			if sc:IsSpecialSummonable(sumtype) then
				Duel.SpecialSummonRule(tp,sc,sumtype)
				break
			end
		end
	end
end

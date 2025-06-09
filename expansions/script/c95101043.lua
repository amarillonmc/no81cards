--找寻真相的背叛者 格林
function c95101043.initial_effect(c)
	aux.AddCodeList(c,95101001)
	--link summon
	aux.AddLinkProcedure(c,c95101043.matfilter,1,1)
	c:EnableReviveLimit()
	--change code
	aux.EnableChangeCode(c,95101001,LOCATION_MZONE+LOCATION_GRAVE)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(95101043,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,95101043)
	e1:SetCondition(c95101043.spcon)
	e1:SetTarget(c95101043.sptg)
	e1:SetOperation(c95101043.spop)
	c:RegisterEffect(e1)
	--set
	local e2=Effect.CreateEffect(c)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
	e2:SetDescription(aux.Stringid(95101043,1))
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,95101043+1)
	e2:SetCondition(c95101043.setcon)
	e2:SetCost(c95101043.setcost)
	e2:SetTarget(c95101043.seteg)
	e2:SetOperation(c95101043.setop)
	c:RegisterEffect(e2)
end
function c95101043.matfilter(c)
	return c:IsLinkCode(95101001) and not c:IsLinkAttribute(ATTRIBUTE_LIGHT)
end
function c95101043.spcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end
function c95101043.spfilter(c,e,tp,zone)
	return c:IsCode(95101001) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP,1-tp,zone)
end
function c95101043.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local zone=e:GetHandler():GetLinkedZone(1-tp)
	if chk==0 then return Duel.IsExistingMatchingCard(c95101043.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp,zone) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c95101043.spop(e,tp,eg,ep,ev,re,r,rp)
	local zone=e:GetHandler():GetLinkedZone(1-tp)
	if Duel.GetLocationCount(1-tp,LOCATION_MZONE,tp,LOCATION_REASON_TOFIELD,zone)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c95101043.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp,zone)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,1-tp,false,false,POS_FACEUP,zone)
	end
end
function c95101043.setcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsMainPhase()
end
function c95101043.costfilter(c,tp)
	return c:IsAbleToHandAsCost()
		and Duel.IsExistingMatchingCard(c95101043.setfilter,tp,LOCATION_MZONE+0x10,LOCATION_MZONE,1,c)
end
function c95101043.setcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c95101043.costfilter,tp,LOCATION_ONFIELD,0,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=Duel.SelectMatchingCard(tp,c95101043.costfilter,tp,LOCATION_ONFIELD,0,1,1,nil,tp)
	Duel.SendtoHand(g,nil,REASON_COST)
end
function c95101043.setfilter(c)
	local p=c:GetOwner()
	return c:IsType(TYPE_MONSTER) and not c:IsForbidden() and Duel.GetLocationCount(p,LOCATION_SZONE)>0 and c:IsFaceupEx() and aux.IsCodeListed(c,95101001)
end
function c95101043.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c95101043.setfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,LOCATION_MZONE,1,nil) end
end
function c95101043.setop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local tc=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c95101043.setfilter),tp,LOCATION_MZONE+LOCATION_GRAVE,LOCATION_MZONE,1,1,nil):GetFirst()
	if tc then
		Duel.HintSelection(Group.FromCards(tc))
		if tc:IsImmuneToEffect(e) then return end
		Duel.MoveToField(tc,tp,tc:GetOwner(),LOCATION_SZONE,POS_FACEUP,true)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_TYPE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET)
		e1:SetValue(TYPE_SPELL+TYPE_CONTINUOUS)
		tc:RegisterEffect(e1)
	end
end

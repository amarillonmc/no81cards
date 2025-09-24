--人偶爱丽丝
function c95101176.initial_effect(c)
	--alice spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(95101176,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,95101176)
	e1:SetCondition(c95101176.spcon)
	e1:SetCost(c95101176.cost)
	e1:SetTarget(c95101176.sptg)
	e1:SetOperation(c95101176.spop)
	c:RegisterEffect(e1)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,95101176+1)
	e2:SetCost(c95101176.cost)
	e2:SetTarget(c95101176.spotg)
	e2:SetOperation(c95101176.spoop)
	c:RegisterEffect(e2)
	--
	Duel.AddCustomActivityCounter(95101176,ACTIVITY_SPSUMMON,c95101176.counterfilter)
end
function c95101176.spcon(e,tp,eg,ep,ev,re,r,rp)
	return bit.band(Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION),LOCATION_ONFIELD)~=0 and rp==1-tp
end
function c95101176.counterfilter(c)
	return not c:IsSummonLocation(LOCATION_EXTRA) or (c:IsAttribute(ATTRIBUTE_DARK) and c:IsType(TYPE_FUSION))
end
function c95101176.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetCustomActivityCount(95101176,tp,ACTIVITY_SPSUMMON)==0 end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c95101176.splimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c95101176.splimit(e,c,sump,sumtype,sumpos,targetp)
	return c:IsLocation(LOCATION_EXTRA) and not (c:IsAttribute(ATTRIBUTE_DARK) and c:IsType(TYPE_FUSION))
end
function c95101176.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetMZoneCount(tp)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c95101176.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c95101176.spfilter(c,e,tp,chk)
	return c:IsSetCard(0xbbe) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and (chk==0 or aux.NecroValleyFilter()(c))
end
function c95101176.spotg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetMZoneCount(tp)>0
		and Duel.IsExistingMatchingCard(c95101176.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp,0)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c95101176.spoop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetMZoneCount(tp)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sc=Duel.SelectMatchingCard(tp,c95101176.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp,1):GetFirst()
	if sc then
		Duel.SpecialSummon(sc,0,tp,tp,false,false,POS_FACEUP)
	end
end

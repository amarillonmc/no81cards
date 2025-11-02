--化龙祖师 政
function c95101234.initial_effect(c)
	--spsummon
	local se1=Effect.CreateEffect(c)
	se1:SetType(EFFECT_TYPE_FIELD)
	se1:SetCode(EFFECT_SPSUMMON_PROC)
	se1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	se1:SetRange(LOCATION_HAND)
	se1:SetCountLimit(1,95101234+EFFECT_COUNT_CODE_OATH)
	se1:SetCondition(c95101234.sprcon)
	se1:SetOperation(c95101234.sprop)
	c:RegisterEffect(se1)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,95101234)
	e1:SetCost(c95101234.spcost)
	e1:SetTarget(c95101234.sptg)
	e1:SetOperation(c95101234.spop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
	--spsummon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(95101234,1))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCountLimit(1,95101234+1)
	e3:SetCondition(c95101234.spscon)
	e3:SetTarget(c95101234.spstg)
	e3:SetOperation(c95101234.spsop)
	c:RegisterEffect(e3)
	--counter
	Duel.AddCustomActivityCounter(95101234,ACTIVITY_SPSUMMON,c95101234.counterfilter)
end
function c95101234.counterfilter(c)
	return c:IsSetCard(0x5bb0)
end
function c95101234.sprfilter(c)
	return c:IsSetCard(0x5bb0) and c:IsAbleToGraveAsCost()
end
function c95101234.sprcon(e,c)
	if c==nil then return true end
	return Duel.GetMZoneCount(c:GetControler())>0
		and Duel.IsExistingMatchingCard(c95101234.sprfilter,c:GetControler(),LOCATION_EXTRA,0,1,nil)
end
function c95101234.sprop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c95101234.sprfilter,tp,LOCATION_EXTRA,0,1,1,nil)
	Duel.SendtoGrave(g,REASON_COST)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_COUNT_CODE_OATH)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c95101234.splimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c95101234.splimit(e,c)
	return not c:IsType(TYPE_SYNCHRO) and c:IsLocation(LOCATION_EXTRA)
end
function c95101234.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetCustomActivityCount(95101234,tp,ACTIVITY_SPSUMMON)==0 end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c95101234.csplimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c95101234.csplimit(e,c,sump,sumtype,sumpos,targetp,se)
	return not c:IsSetCard(0x5bb0)
end
function c95101234.spfilter(c,e,tp,chk)
	return c:IsSetCard(0x5bb0) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and (chk==0 or aux.NecroValleyFilter()(c))
end
function c95101234.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetMZoneCount(tp)>0
		and Duel.IsExistingMatchingCard(c95101234.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp,0)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c95101234.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetMZoneCount(tp)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sc=Duel.SelectMatchingCard(tp,c95101234.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp,1):GetFirst()
	if sc then
		Duel.SpecialSummon(sc,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c95101234.chkfilter(c,tp)
	return c:IsSummonPlayer(tp) and c:IsSetCard(0x5bb0) and c:IsFaceup() and c:IsType(TYPE_SYNCHRO) and c:IsSummonType(SUMMON_TYPE_SYNCHRO)
end
function c95101234.spscon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c95101234.chkfilter,1,nil,tp)
end
function c95101234.spstg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetMZoneCount(tp)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c95101234.spsop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end

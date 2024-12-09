--核成源超荷束士
function c49811279.initial_effect(c)
	--link summon
	c:SetUniqueOnField(1,0,49811279)
	aux.AddLinkProcedure(c,c49811279.mfilter,1)
	c:EnableReviveLimit()
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(49811279,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_LEAVE_FIELD)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(c49811279.spcon)
	e1:SetTarget(c49811279.sptg)
	e1:SetOperation(c49811279.spop)
	c:RegisterEffect(e1)
end
function c49811279.mfilter(c)
	return c:IsLevelAbove(3) and c:IsLinkSetCard(0x1d)
end
function c49811279.checkfilter(c,tp)
	return c:IsPreviousControler(tp) and c:IsPreviousLocation(LOCATION_MZONE)
end
function c49811279.gfilter(c)
	return c:IsType(TYPE_MONSTER) and not c:IsSetCard(0x1d)
end
function c49811279.spcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c49811279.checkfilter,1,nil,tp) and not Duel.IsExistingMatchingCard(c49811279.gfilter,tp,LOCATION_GRAVE,0,1,nil)
end
function c49811279.cfilter(c,race)
	return c:IsRace(race) and c:IsFaceupEx()
end
function c49811279.spfilter(c,e,tp,zone)
	return c:IsSetCard(0x1d) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP,tp,zone) and
	not Duel.IsExistingMatchingCard(c49811279.cfilter,tp,LOCATION_ONFIELD+LOCATION_GRAVE,0,1,nil,c:GetRace())
end
function c49811279.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local zone=Duel.GetLinkedZone(tp)
	if chk==0 then return zone~=0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c49811279.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp,zone) end
	Duel.PayLPCost(tp,math.floor(Duel.GetLP(tp)/2))
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c49811279.spop(e,tp,eg,ep,ev,re,r,rp)
	--limlt
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c49811279.splimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	--spsummon
	local zone=Duel.GetLinkedZone(tp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 or zone==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c49811279.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp,zone)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP,zone)
	end
end
function c49811279.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return not c:IsSetCard(0x1d) and c:IsLocation(LOCATION_EXTRA)
end

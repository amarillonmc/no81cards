--熔岩谷龙王
function c98920808.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(Card.IsAttribute,ATTRIBUTE_FIRE),1)
	c:EnableReviveLimit()
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(98920808,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCountLimit(1,98930808)
	e2:SetCondition(c98920808.condition)
	e2:SetTarget(c98920808.target)
	e2:SetOperation(c98920808.operation)
	c:RegisterEffect(e2)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(98920808,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_TO_GRAVE)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,98920808)
	e1:SetCondition(c98920808.spcon)
	e1:SetCost(c98920808.spcost)
	e1:SetTarget(c98920808.sptg)
	e1:SetOperation(c98920808.spop)
	c:RegisterEffect(e1)
end
function c98920808.condition(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_SYNCHRO)
end
function c98920808.filter(c,e,sp)
	return c:IsSetCard(0x39) and not c:IsType(TYPE_SYNCHRO) and c:IsCanBeSpecialSummoned(e,0,sp,false,false)
end
function c98920808.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c98920808.filter,tp,LOCATION_GRAVE,0,1,nil,e,tp)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end
	local ct=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then ct=1 end
	local gct=Duel.GetMatchingGroupCount(c98920808.filter,tp,LOCATION_GRAVE,0,nil,e,tp)
	if ct>gct then
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,gct,tp,LOCATION_GRAVE)
	else
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,ct,tp,LOCATION_GRAVE)
	end
end
function c98920808.operation(e,tp,eg,ep,ev,re,r,rp)
	local ct=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if ct<=0 then return end
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then ct=1 end
	local g=Duel.GetMatchingGroup(c98920808.filter,tp,LOCATION_GRAVE,0,nil,e,tp)
	local gc=g:GetCount()
	if gc==0 then return end
	if gc<=ct then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=g:Select(tp,ct,ct,nil)
		Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
	end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c98920808.splimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c98920808.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return not c:IsAttribute(ATTRIBUTE_FIRE)
end
function c98920808.spcfilter(c)
	return c:IsDefense(200) and c:IsAttribute(ATTRIBUTE_FIRE)
end
function c98920808.spcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousLocation(LOCATION_MZONE) and c:IsSummonType(SUMMON_TYPE_SYNCHRO)
end
function c98920808.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c98920808.spcfilter,tp,LOCATION_GRAVE,0,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c98920808.spcfilter,tp,LOCATION_GRAVE,0,1,1,e:GetHandler())
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c98920808.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c98920808.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<1 or not c:IsRelateToEffect(e) then return end
	if Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)>0 then
		local cg=c:GetColumnGroup():Filter(Card.IsControler,nil,1-tp)
		if #cg==0 then return end
		Duel.BreakEffect()
		Duel.Destroy(cg,REASON_EFFECT)
	end
end
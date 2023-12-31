local s,id,o=GetID()
function s.initial_effect(c)
	local e_sp=Effect.CreateEffect(c)
	e_sp:SetDescription(aux.Stringid(id,0))
	e_sp:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e_sp:SetType(EFFECT_TYPE_IGNITION)
	e_sp:SetRange(LOCATION_GRAVE)
	e_sp:SetCountLimit(1,id)
	e_sp:SetCondition(s.spcon)
	e_sp:SetCost(s.spcost)
	e_sp:SetTarget(s.sptg)
	e_sp:SetOperation(s.spop)
	c:RegisterEffect(e_sp)
	Duel.AddCustomActivityCounter(id,ACTIVITY_SPSUMMON,s.counterfilter)
	if not s.global_check then
		s.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD)
		ge1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_IGNORE_RANGE)
		ge1:SetCode(EFFECT_MATERIAL_CHECK)
		ge1:SetValue(s.valcheck)
		Duel.RegisterEffect(ge1,0)
	end
end
function s.valcheck(e,c)
	local g=c:GetMaterial()
	if g:IsExists(Card.IsLinkCode,1,nil,c:GetCode()) then
		c:RegisterFlagEffect(id,RESET_EVENT+0x4fe0000,0,1)
	end
end
function s.counterfilter(c)
	return c:IsAttribute(ATTRIBUTE_FIRE)
end
function s.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsEnvironment(1295111)
end
function s.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetCustomActivityCount(id,tp,ACTIVITY_SPSUMMON)==0 end
	local e_lmt=Effect.CreateEffect(e:GetHandler())
	e_lmt:SetType(EFFECT_TYPE_FIELD)
	e_lmt:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e_lmt:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e_lmt:SetTarget(s.splimit)
	e_lmt:SetTargetRange(1,0)
	e_lmt:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e_lmt,tp)
end
function s.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return not c:IsAttribute(ATTRIBUTE_FIRE)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function s.lfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x119) and c:IsSummonType(SUMMON_TYPE_LINK) and c:GetFlagEffect(id)~=0
end
function s.filter(c,e,tp)
	return c:IsRace(RACE_CYBERSE) and c:IsAttribute(ATTRIBUTE_FIRE) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_DEFENSE)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0 and Duel.IsExistingMatchingCard(s.lfilter,tp,LOCATION_MZONE,0,1,nil) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(aux.NecroValleyFilter(s.filter),tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil,e,tp) and Duel.SelectYesNo(tp,aux.Stringid(id,1)) then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(s.filter),tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil,e,tp)
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP_DEFENSE)
	end
end

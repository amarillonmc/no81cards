--维多利亚·术士干员-薄绿
function c79029333.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkType,TYPE_EFFECT),2,99,c79029333.lcheck)
	c:EnableReviveLimit()
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,79029333)
	e1:SetCost(c79029333.spcost)
	e1:SetCondition(c79029333.spcon)
	e1:SetTarget(c79029333.sptg)
	e1:SetOperation(c79029333.spop)
	c:RegisterEffect(e1)	
	--atk
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(c79029333.atkval)
	c:RegisterEffect(e1)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(79029333,0))
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetCountLimit(1,09029333)
	e1:SetCost(c79029333.cost)
	e1:SetTarget(c79029333.target)
	e1:SetOperation(c79029333.activate)
	c:RegisterEffect(e1) 
end
function c79029333.atkfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xa900) and c:GetBaseAttack()>=0
end
function c79029333.atkval(e,c)
	local lg=c:GetLinkedGroup():Filter(c79029333.atkfilter,nil)
	return lg:GetSum(Card.GetBaseAttack)
end
function c79029333.lcheck(g,lc)
	return g:IsExists(Card.IsLinkSetCard,1,nil,0x4902)
end
function c79029333.spcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end
function c79029333.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.PayLPCost(tp,math.floor(Duel.GetLP(tp)/2))
end
function c79029333.spfilter(c,e,tp,zone)
	return c:IsSetCard(0xa900) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_DEFENSE,tp,zone)
end
function c79029333.spcheck(sg,e,tp,mg)
	return sg:GetClassCount(Card.GetLocation)==#sg
end
function c79029333.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local zone=e:GetHandler():GetLinkedZone(tp)&0x1f
	local ct=Duel.GetLocationCount(tp,LOCATION_MZONE,tp,LOCATION_REASON_TOFIELD,zone)
	if chk==0 then return ct>0 and Duel.IsExistingMatchingCard(c79029333.spfilter,tp,LOCATION_HAND+LOCATION_GRAVE+LOCATION_DECK,0,1,nil,e,tp,zone)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,0,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE)
end
function c79029333.spop(e,tp,eg,ep,ev,re,r,rp)
	Debug.Message("出发了哦。")
	Duel.Hint(HINT_SOUND,0,aux.Stringid(79029333,1))
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and not Duel.IsPlayerAffectedByEffect(tp,59822133) then
	local zone=c:GetLinkedZone(tp)&0x1f
	local ct=Duel.GetLocationCount(tp,LOCATION_MZONE,tp,LOCATION_REASON_TOFIELD,zone)
	local g1=Duel.GetMatchingGroup(c79029333.spfilter,tp,LOCATION_HAND+LOCATION_GRAVE+LOCATION_DECK,0,nil,e,tp,zone)
	local sg1=0
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then
	sg1=g1:Select(tp,1,1,nil)
	Duel.SpecialSummon(sg1,0,tp,tp,false,false,POS_FACEUP_DEFENSE,zone)
	else
	sg1=g1:Select(tp,1,ct,nil)
	Duel.SpecialSummon(sg1,0,tp,tp,false,false,POS_FACEUP_DEFENSE,zone)
	end
	end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c79029333.splimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c79029333.splimit(e,c)
	return not c:IsSetCard(0xa900) and c:IsLocation(LOCATION_EXTRA)
end
function c79029333.cofil(c,e,tp)
	return e:GetHandler():GetLinkedGroup():IsContains(c) and c:IsReleasable() and Duel.IsExistingMatchingCard(aux.TRUE,tp,LOCATION_MZONE,0,1,c)
end
function c79029333.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c79029333.cofil,tp,LOCATION_MZONE,0,1,nil,e,tp) end
	local g=Duel.SelectMatchingCard(tp,c79029333.cofil,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
	Duel.Release(g,REASON_COST)
end
function c79029333.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(aux.TRUE,tp,LOCATION_MZONE,0,1,nil,e,tp) end
	local sg=Duel.SelectMatchingCard(tp,aux.TRUE,tp,LOCATION_MZONE,0,1,1,nil,e,tp):GetFirst()
	Duel.SetTargetCard(sg)
end
function c79029333.activate(e,tp,eg,ep,ev,re,r,rp)
	Debug.Message("要不要看我变魔术？")
	Duel.Hint(HINT_SOUND,0,aux.Stringid(79029333,2))
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	--immune
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(79029333,0))
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CLIENT_HINT)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
	e1:SetValue(c79029333.efilter)
	tc:RegisterEffect(e1)
end
function c79029333.efilter(e,te)
	return te:GetOwner():GetControler()~=e:GetOwner():GetControler()
end





--幻奏の音女タムタム
function c79759984.initial_effect(c)
	--immuse
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(79759984,0))
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e2:SetCondition(c79759984.imcon)
	e2:SetCost(c79759984.imcost)
	e2:SetTarget(c79759984.imtg)
	e2:SetOperation(c79759984.imop)
	c:RegisterEffect(e2)
	--spsummon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(79759984,1))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetTarget(c79759984.sptg)
	e3:SetOperation(c79759984.spop)
	c:RegisterEffect(e3)
end
function c79759984.spfilter(c,e,tp)
	return c:IsSetCard(0x9b) and c:IsLevelBelow(4) and not c:IsCode(79759984) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) 
end
function c79759984.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c79759984.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c79759984.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c79759984.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c79759984.splimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c79759984.splimit(e,c)
	return not c:IsSetCard(0x9b)
end
function c79759984.imcon(e,tp,eg,ep,ev,re,r,rp)
	return rp~=tp 
end
function c79759984.imcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToDeckAsCost() end
	Duel.SendtoDeck(e:GetHandler(),nil,SEQ_DECKSHUFFLE,REASON_COST)
end
function c79759984.imfilter(c)
	return c:IsSetCard(0x9b) and c:IsFaceup()
end
function c79759984.imtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c79759984.imfilter,tp,LOCATION_MZONE,0,1,nil) end
end
function c79759984.imop(e,tp,eg,ep,ev,re,r,rp)
	local g1=Duel.GetMatchingGroup(c79759984.imfilter,tp,LOCATION_MZONE,0,nil)
	local nc=g1:GetFirst()
	while nc do
		local e3=Effect.CreateEffect(e:GetHandler())
		e3:SetType(EFFECT_TYPE_SINGLE)
		e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e3:SetRange(LOCATION_MZONE)
		e3:SetCode(EFFECT_IMMUNE_EFFECT)
		e3:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END+RESET_CHAIN)
		e3:SetValue(c79759984.efilter)
		e3:SetOwnerPlayer(tp)
		nc:RegisterEffect(e3)
		nc=g1:GetNext()
	end
end
function c79759984.efilter(e,re)
	return e:GetOwnerPlayer()~=re:GetOwnerPlayer()
end

--インヴェルズの密偵
function c49811147.initial_effect(c)
	--link summon
	c:SetSPSummonOnce(49811147)
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,c49811147.matfilter,1,1)
	--trap set
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(49811147,0))
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_RELEASE)
	e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e1:SetCountLimit(1,49811147)
	e1:SetTarget(c49811147.target)
	e1:SetOperation(c49811147.operation)
	c:RegisterEffect(e1)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(49811147,1))
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetCode(EVENT_PAY_LPCOST)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCondition(c49811147.condition)
	e2:SetTarget(c49811147.sptg)
	e2:SetOperation(c49811147.spop)
	c:RegisterEffect(e2)
end
function c49811147.matfilter(c)
	return c:IsLinkSetCard(0x100a) and c:IsLevelBelow(4)
end
function c49811147.filter(c)
	return c:IsSetCard(0x65) and c:IsType(TYPE_TRAP) and c:IsSSetable()
end
function c49811147.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c49811147.filter,tp,LOCATION_DECK,0,1,nil) end
end
function c49811147.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g=Duel.SelectMatchingCard(tp,c49811147.filter,tp,LOCATION_DECK,0,1,1,nil)
	local sc=g:GetFirst()
	if sc and Duel.SSet(tp,sc)~=0 then
		if sc:IsType(TYPE_CONTINUOUS) and sc:IsType(TYPE_TRAP) then
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_TRAP_ACT_IN_SET_TURN)
			e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			sc:RegisterEffect(e1)
		end
	end
end
function c49811147.condition(e)
	return not Duel.IsExistingMatchingCard(Card.IsFacedown,e:GetHandlerPlayer(),LOCATION_SZONE,0,1,nil)
end
function c49811147.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c49811147.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
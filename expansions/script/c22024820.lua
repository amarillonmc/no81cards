--人理彼面 阿昙矶良
function c22024820.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcCode2FunRep(c,22024811,22024812,aux.FilterBoolFunction(Card.IsFusionType,TYPE_EFFECT),1,1,false,false)
	--remove
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(22024820,0))
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,22024820)
	e1:SetCondition(c22024820.rmcon)
	e1:SetTarget(c22024820.rmtg)
	e1:SetOperation(c22024820.rmop)
	c:RegisterEffect(e1)
	--destroy1
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(22024820,0))
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCode(EVENT_PHASE+PHASE_END)
	e2:SetTarget(c22024820.target1)
	e2:SetOperation(c22024820.operation1)
	c:RegisterEffect(e2)
	--token
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(22024820,2))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCountLimit(1,22024820)
	e3:SetCost(c22024820.cost)
	e3:SetTarget(c22024820.sptg)
	e3:SetOperation(c22024820.spop)
	c:RegisterEffect(e3)
	--remove ere
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(22024820,0))
	e3:SetCategory(CATEGORY_REMOVE)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetCountLimit(1,22024820)
	e3:SetCondition(c22024820.rmcon1)
	e3:SetCost(c22024820.erecost)
	e3:SetTarget(c22024820.rmtg)
	e3:SetOperation(c22024820.rmop)
	c:RegisterEffect(e3)
	--destroy ere
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(22024820,0))
	e4:SetCategory(CATEGORY_DESTROY)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e4:SetRange(LOCATION_GRAVE)
	e4:SetCountLimit(1)
	e4:SetCode(EVENT_PHASE+PHASE_END)
	e4:SetCondition(c22024820.erecon)
	e4:SetCost(c22024820.erecost)
	e4:SetTarget(c22024820.target1)
	e4:SetOperation(c22024820.operation1)
	c:RegisterEffect(e4)
end
function c22024820.cfilter(c)
	return c:IsFaceup() and c:IsAttribute(ATTRIBUTE_WATER)
end
function c22024820.rmcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c22024820.cfilter,tp,LOCATION_MZONE,LOCATION_MZONE,3,nil)
end
function c22024820.rmfilter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToRemove()
end
function c22024820.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c22024820.rmfilter,tp,0,LOCATION_ONFIELD,1,nil) end
	local g=Duel.GetMatchingGroup(c22024820.rmfilter,tp,0,LOCATION_ONFIELD,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,g:GetCount(),0,0)
end
function c22024820.rmop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c22024820.rmfilter,tp,0,LOCATION_ONFIELD,nil)
	if g:GetCount()>0 then
		Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
	end
end
function c22024820.target1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c22024820.cfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,e:GetHandler()) end
	local g=Duel.GetMatchingGroup(c22024820.cfilter,tp,LOCATION_MZONE,LOCATION_MZONE,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c22024820.operation1(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c22024820.cfilter,tp,LOCATION_MZONE,LOCATION_MZONE,aux.ExceptThisCard(e))
	Duel.Destroy(g,REASON_EFFECT)
end
function c22024820.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)
end
function c22024820.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not Duel.IsPlayerAffectedByEffect(tp,59822133)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>1
		and Duel.IsPlayerCanSpecialSummonMonster(tp,22024811,0,TYPES_TOKEN_MONSTER,1500,1500,4,RACE_SEASERPENT,ATTRIBUTE_LIGHT) and Duel.IsPlayerCanSpecialSummonMonster(tp,22024812,0,TYPES_TOKEN_MONSTER,1500,1500,4,RACE_SEASERPENT,ATTRIBUTE_EARTH) end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,2,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,2,0,0)
end
function c22024820.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then return end
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<2 then return end
	if not Duel.IsPlayerCanSpecialSummonMonster(tp,22024811,0,TYPES_TOKEN_MONSTER,1500,1500,4,RACE_SEASERPENT,ATTRIBUTE_LIGHT)
		or not Duel.IsPlayerCanSpecialSummonMonster(tp,22024812,0,TYPES_TOKEN_MONSTER,1500,1500,4,RACE_SEASERPENT,ATTRIBUTE_EARTH) then return end
	local token=Duel.CreateToken(tp,22024811)
	Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP)
	local token2=Duel.CreateToken(tp,22024812)
	Duel.SpecialSummonStep(token2,0,tp,tp,false,false,POS_FACEUP)
	Duel.SpecialSummonComplete()
end
function c22024820.rmcon1(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c22024820.cfilter,tp,LOCATION_MZONE,LOCATION_MZONE,3,nil) and Duel.IsPlayerAffectedByEffect(tp,22020980)
end
function c22024820.erecost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.Hint(HINT_CARD,0,22020980)
	Duel.PayLPCost(tp,math.floor(Duel.GetLP(tp)/2))
end
function c22024820.erecon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsPlayerAffectedByEffect(tp,22020980)
end
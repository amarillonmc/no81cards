--元界书画家
function c99700312.initial_effect(c)
	c:SetSPSummonOnce(99700312)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFunRep(c,aux.FilterBoolFunction(Card.IsSetCard,0xfd03),2,true)
	--spsummon condition
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	e0:SetValue(c99700312.splimit)
	c:RegisterEffect(e0)
	--todeck
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(99700312,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCondition(c99700312.tdcon)
	e1:SetOperation(c99700312.tdop)
	c:RegisterEffect(e1)
	--indes
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_INDESTRUCTABLE_COUNT)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetTarget(c99700312.indtg)
	e2:SetValue(c99700312.indct)
	c:RegisterEffect(e2)
	--negate
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(99700312,1))
	e3:SetCategory(CATEGORY_NEGATE)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e3:SetCode(EVENT_CHAINING)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetCondition(c99700312.negcon)
	e3:SetCost(c99700312.negcost)
	e3:SetTarget(c99700312.negtg)
	e3:SetOperation(c99700312.negop)
	c:RegisterEffect(e3)
end
function c99700312.splimit(e,se,sp,st)
	return (se:GetHandler():IsSetCard(0xfd03) and se:GetHandler():IsType(TYPE_MONSTER))
end
function c99700312.tdfilter(c)
	return c:IsSetCard(0xfd03) and c:IsType(TYPE_MONSTER) and c:IsAbleToDeck()
end
function c99700312.tdcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_FUSION) and Duel.IsExistingMatchingCard(c99700312.tdfilter,tp,LOCATION_REMOVED,0,2,nil)
end
function c99700312.tdop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=Duel.GetMatchingGroup(Card.IsAbleToDeck,tp,LOCATION_REMOVED,LOCATION_REMOVED,nil,TYPE_MONSTER+TYPE_SPELL+TYPE_TRAP)
	Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
end
function c99700312.indtg(e,c)
	return (c:IsFaceup() and c:IsSetCard(0xfd03)) and e:GetHandler():IsSummonType(SUMMON_TYPE_FUSION)
end
function c99700312.indct(e,re,r,rp)
	if bit.band(r,REASON_EFFECT)~=0 then
		return 1
	else return 0 end
end
function c99700312.negcon(e,tp,eg,ep,ev,re,r,rp)
	return not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED)
		and (re:IsActiveType(TYPE_MONSTER+TYPE_SPELL+TYPE_TRAP) or re:IsHasType(EFFECT_TYPE_ACTIVATE)) and Duel.IsChainNegatable(ev)
end
function c99700312.cfilter(c,rtype)
	return c:IsSetCard(0xfd03) and c:IsType(TYPE_MONSTER) and c:IsAbleToGraveAsCost()
end
function c99700312.negcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c99700312.cfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c99700312.cfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,1,nil)
	Duel.SendtoGrave(g,REASON_COST)
end
function c99700312.negtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
end
function c99700312.negop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateActivation(ev)
end
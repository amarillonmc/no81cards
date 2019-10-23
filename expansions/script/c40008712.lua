--闪光英雄 刚火
function c40008712.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddFusionProcFunRep(c,aux.FilterBoolFunction(Card.IsFusionSetCard,0xa008),2,true)
	--cannot special summon
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	c:RegisterEffect(e0)
	--special summon rule
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetCondition(c40008712.sprcon)
	e1:SetOperation(c40008712.sprop)
	c:RegisterEffect(e1)  
	--negate
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(40008712,0))
	e2:SetCategory(CATEGORY_NEGATE+CATEGORY_REMOVE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCondition(c40008712.negcon)
	e2:SetCost(c40008712.negcost)
	e2:SetTarget(c40008712.negtg)
	e2:SetOperation(c40008712.negop)
	c:RegisterEffect(e2)
	--atkup
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetValue(c40008712.atkup)
	c:RegisterEffect(e3)  
end
function c40008712.sprfilter1(c)
	return c:IsCode(84536654) and c:IsAbleToDeckAsCost()
end
function c40008712.sprfilter2(c,tp,sc)
	return c:IsFaceup() and c:IsCode(58147549) and c:IsAbleToExtraAsCost() and Duel.GetLocationCountFromEx(tp,tp,c,sc)>0
end
function c40008712.sprcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.IsExistingMatchingCard(c40008712.sprfilter1,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil)
		and Duel.IsExistingMatchingCard(c40008712.sprfilter2,tp,LOCATION_MZONE,0,1,nil,tp,c)
end
function c40008712.sprop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g1=Duel.SelectMatchingCard(tp,c40008712.sprfilter1,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g2=Duel.SelectMatchingCard(tp,c40008712.sprfilter2,tp,LOCATION_MZONE,0,1,1,nil,tp,c)
	g1:Merge(g2)
	Duel.SendtoDeck(g1,nil,2,REASON_COST)
end
function c40008712.atkup(e,c)
	return Duel.GetMatchingGroupCount(Card.IsSetCard,c:GetControler(),LOCATION_GRAVE,0,nil,0x8)*300
end
function c40008712.negcon(e,tp,eg,ep,ev,re,r,rp)
	return not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED)
		and (re:IsActiveType(TYPE_MONSTER) or re:IsHasType(EFFECT_TYPE_ACTIVATE)) and Duel.IsChainNegatable(ev)
end
function c40008712.cfilter(c,rtype)
	return c:IsType(rtype) and c:IsAbleToRemoveAsCost()
end
function c40008712.negcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local rtype=bit.band(re:GetActiveType(),0x7)
	if chk==0 then return Duel.IsExistingMatchingCard(c40008712.cfilter,tp,LOCATION_GRAVE,0,1,nil,rtype) end
	local g=Duel.SelectMatchingCard(tp,c40008712.cfilter,tp,LOCATION_GRAVE,0,1,1,nil,rtype)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c40008712.negtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return aux.nbcon(tp,re) end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_REMOVE,eg,1,0,0)
	end
end
function c40008712.negop(e,tp,eg,ep,ev,re,r,rp)
	local ec=re:GetHandler()
	if Duel.NegateActivation(ev) and ec:IsRelateToEffect(re) then
		ec:CancelToGrave()
		Duel.SendtoDeck(ec,nil,2,REASON_EFFECT)
	end
end

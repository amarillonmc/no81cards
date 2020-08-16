--合约行动-代号·荒芜
function c79029252.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,79029252+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c79029252.target)
	e1:SetOperation(c79029252.activate)
	c:RegisterEffect(e1)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCountLimit(1,790252)
	e1:SetCost(aux.bfgcost)
	e1:SetCondition(c79029252.condition1)
	e1:SetTarget(c79029252.target1)
	e1:SetOperation(c79029252.activate1)
	c:RegisterEffect(e1)
end
function c79029252.filter(c)
	return c:IsLinkSummonable(nil) and c:IsSetCard(0xa900)
end
function c79029252.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c79029252.filter,tp,LOCATION_EXTRA,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
function c79029252.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c79029252.filter,tp,LOCATION_EXTRA,0,1,1,nil)
	local tc=g:GetFirst()
	if tc then
		Duel.LinkSummon(tp,tc,nil)
	end
end
function c79029252.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xa900) and c:IsType(TYPE_LINK)
end
function c79029252.condition1(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.IsExistingMatchingCard(c79029252.cfilter,tp,LOCATION_MZONE,0,1,nil) then return false end
	if not Duel.IsChainNegatable(ev) then return false end
	return re:IsActiveType(TYPE_MONSTER) or re:IsHasType(EFFECT_TYPE_ACTIVATE)
end
function c79029252.target1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function c79029252.activate1(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
		Duel.Destroy(eg,REASON_EFFECT)
	end
end




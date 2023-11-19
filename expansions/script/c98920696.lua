--点火骑士·爱国者
function c98920696.initial_effect(c)
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(c98920696.splimit)
	c:RegisterEffect(e1)
	 --special summon
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_HAND)
	e2:SetCountLimit(1,98920696)
	e2:SetCondition(c98920696.spcon)
	c:RegisterEffect(e2)
	--negate
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(98920696,0))
	e3:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_CHAINING)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,98930696)
	e3:SetCondition(c98920696.condition)
	e3:SetTarget(c98920696.target)
	e3:SetOperation(c98920696.operation)
	c:RegisterEffect(e3)
end
function c98920696.splimit(e,se,sp,st)
	return se:GetHandler():IsSetCard(0xc8)
end
function c98920696.spcon(e,c)
	if c==nil then return true end
	if Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)<=0 then return false end
	return Duel.GetMatchingGroup(c98920696.spfilter,c:GetControler(),LOCATION_EXTRA,0,nil):GetClassCount(Card.GetCode)>=3
end
function c98920696.spfilter(c)
	return c:IsSetCard(0xc8) and c:IsFaceup()
end
function c98920696.condition(e,tp,eg,ep,ev,re,r,rp)
	return rp==1-tp and re:IsActiveType(TYPE_MONSTER) and not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) and Duel.IsChainNegatable(ev)
end
function c98920696.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c98920696.filter,tp,LOCATION_EXTRA,0,3,nil) end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_EXTRA)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function c98920696.operation(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
		if Duel.Destroy(eg,REASON_EFFECT) then
		   Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(98920696,0))
		   local g=Duel.SelectMatchingCard(tp,c98920696.filter,tp,LOCATION_EXTRA,0,3,3,nil)
		   if g:GetCount()<3 then return end
		   Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		   local sg=g:Select(tp,1,1,nil)
		   Duel.SendtoHand(sg,nil,REASON_EFFECT)
		   g:Sub(sg)
		   Duel.SendtoDeck(g,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
	   end
	end
end
function c98920696.filter(c)
	return c:IsSetCard(0xc8) and c:IsAbleToHand() and c:IsFaceup()
end
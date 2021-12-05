--花镜月
function c72412350.initial_effect(c)
		--activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(72412350,0))
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,72412350)
	e1:SetCost(c72412350.cost)
	e1:SetTarget(c72412350.target)
	e1:SetOperation(c72412350.operation)
	c:RegisterEffect(e1)
end
function c72412350.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsDiscardable() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST+REASON_DISCARD)
end
function c72412350.filter(c)
	return c:IsFaceup() and c:IsPosition(POS_ATTACK) 
end
function c72412350.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then return  Duel.IsExistingTarget(c72412350.filter,tp,0,LOCATION_MZONE,2,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPPO)
	local g=Duel.SelectTarget(tp,c72412350.filter,tp,0,LOCATION_MZONE,2,2,nil)
end

function c72412350.tfilter(c,e)
	return c:IsRelateToEffect(e) and c:IsFaceup()
end
function c72412350.operation(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(c72412350.tfilter,nil,e)
	if g:GetCount()<2 then return end
	local ac=g:Filter(Card.IsAttackable,nil):GetFirst()
	local bc=g:Filter(aux.TRUE,ac):GetFirst()
	if not ( ac:IsPosition(POS_ATTACK) and bc:IsPosition(POS_ATTACK))then return end
	Duel.CalculateDamage(ac,bc)
end

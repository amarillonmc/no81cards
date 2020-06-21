--魔玩具衍生物
function c79029200.initial_effect(c)
	--atk def
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetRange(LOCATION_SZONE)
	e3:SetTargetRange(LOCATION_MZONE,0)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetValue(c79029200.val)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e4)
	--remove
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetCountLimit(1)
	e1:SetProperty(EFFECT_FLAG_BOTH_SIDE)
	e1:SetRange(LOCATION_SZONE)
	e1:SetCost(c79029200.cost)
	e1:SetOperation(c79029200.op)
	c:RegisterEffect(e1)
end
function c79029200.val(e,c,Counter)  
	return Duel.GetFieldGroupCount(tp,LOCATION_REMOVED+LOCATION_GRAVE,LOCATION_REMOVED+LOCATION_GRAVE)*-200
end
function c79029200.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local p=e:GetHandler():GetControler()
	local p1=e:GetHandler():GetOwner()
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsReleasable,p,LOCATION_MZONE,0,1,e:GetHandler()) and Duel.GetTurnPlayer()~=p end
	local g=Duel.SelectMatchingCard(p1,Card.IsReleasable,p,LOCATION_ONFIELD,0,1,1,e:GetHandler())
	Duel.Release(g,REASON_COST)
end
function c79029200.op(e,tp,eg,ep,ev,re,r,rp)
	local p=e:GetHandler():GetControler()
	local g=Duel.GetDecktopGroup(p,5)
	Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
end






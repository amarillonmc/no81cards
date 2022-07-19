--缇雅·雅莉珂希德 静心
local m=60002053
local cm=_G["c"..m]
cm.name="缇雅·雅莉珂希德 静心"
function cm.initial_effect(c)
	--disable
	local e5=Effect.CreateEffect(c)
	e5:SetCategory(CATEGORY_DISABLE)
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCode(EVENT_FREE_CHAIN)
	e5:SetCost(cm.dscost)
	e5:SetOperation(cm.dsop)
	e5:SetCountLimit(1,m)
	c:RegisterEffect(e5)
	--disable
	local e6=Effect.CreateEffect(c)
	e6:SetCategory(CATEGORY_DISABLE)
	e6:SetType(EFFECT_TYPE_QUICK_O)
	e6:SetRange(LOCATION_MZONE)
	e6:SetCode(EVENT_CHAINING)
	e6:SetTarget(cm.target)
	e6:SetCondition(cm.condition)
	e6:SetOperation(cm.activate)
	e6:SetCountLimit(1,m+10000000)
	c:RegisterEffect(e6)
end
function cm.dscost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil) and Duel.IsExistingMatchingCard(Card.IsOnField,tp,0,LOCATION_MZONE,1,nil) end
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST,nil)
end
function cm.dsop(e,tp,eg,ep,ev,re,r,rp)
	--disable
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_DISABLE)
	e2:SetTargetRange(0,LOCATION_MZONE)
	e2:SetReset(RESET_PHASE+PHASE_END,2)
	e2:SetTarget(cm.distarget)
	Duel.RegisterEffect(e2,tp)
end
function cm.distarget(e,c)
	return c~=e:GetHandler() and c:IsType(TYPE_MONSTER)
end
function cm.condition(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	return rc:IsLocation(LOCATION_HAND+LOCATION_EXTRA+LOCATION_REMOVED+LOCATION_GRAVE+LOCATION_DECK) and Duel.IsChainNegatable(ev) and rc:GetControler()~=tp
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
		Duel.Destroy(eg,REASON_EFFECT)
		Duel.Damage(1-tp,1000,REASON_EFFECT)
	end
end




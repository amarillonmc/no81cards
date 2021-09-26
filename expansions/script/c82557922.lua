--神融钢战-EVANGELION-13
function c82557922.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFun2(c,aux.FilterBoolFunction(Card.IsFusionCode,82557921),aux.FilterBoolFunction(Card.IsFusionSetCard,0x829),false)
	aux.AddContactFusionProcedure(c,Card.IsReleasable,LOCATION_MZONE,0,Duel.Release,REASON_COST+REASON_MATERIAL)
	--ATK
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(82557922,0))
	e1:SetCategory(CATEGORY_ATKCHANGE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_BATTLE_START)
	e1:SetTarget(c82557922.target)
	e1:SetOperation(c82557922.operation)
	c:RegisterEffect(e1)
	--negate
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(82557922,0))
	e2:SetCategory(CATEGORY_NEGATE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(2)
	e2:SetCondition(c82557922.negcon)
	e2:SetCost(c82557922.cost)
	e2:SetTarget(c82557922.negtg)
	e2:SetOperation(c82557922.negop)
	c:RegisterEffect(e2)
end
function c82557922.filter(c,g)
	return c:IsFaceup()
end 
function c82557922.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local sg=Duel.GetMatchingGroup(c82557922.filter,tp,0,LOCATION_MZONE,e:GetHandler())
	local nsg=sg:GetCount()
	if chk==0 then return Duel.IsExistingMatchingCard(c82557922.filter,tp,0,LOCATION_MZONE,1,e:GetHandler()) end
	Duel.SetOperationInfo(0,CATEGORY_ATKCHANGE,sg,nsg,tp,0)
end
function c82557922.operation(e,tp,eg,ep,ev,re,r,rp)
	local sg=Duel.GetMatchingGroup(c82557922.filter,tp,0,LOCATION_MZONE,e:GetHandler())
	local c=e:GetHandler()
	local tc=sg:GetFirst()
	if not c:IsRelateToEffect(e) then return false end
	while tc do
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_ATTACK_FINAL)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_DAMAGE_CAL)
		e1:SetValue(0)
		tc:RegisterEffect(e1)
		tc=sg:GetNext()
	end
end
function c82557922.negcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if ep==tp or c:IsStatus(STATUS_BATTLE_DESTROYED) then return false end
	return not c:IsStatus(STATUS_CHAINING) and Duel.IsChainNegatable(ev) 
				  and Duel.GetTurnPlayer()==e:GetHandler():GetControler()
end
function c82557922.cfilter(c)
	return c:IsSetCard(0x829) and c:IsType(TYPE_MONSTER) and c:IsAbleToGraveAsCost()
end
function c82557922.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c82557922.cfilter,tp,LOCATION_DECK,0,1,nil) end
	local g=Duel.SelectMatchingCard(tp,c82557922.cfilter,tp,LOCATION_DECK,0,1,1,nil)
	Duel.SendtoGrave(g,REASON_COST)
end
function c82557922.negtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
end
function c82557922.negop(e,tp,eg,ep,ev,re,r,rp)
	 Duel.NegateEffect(ev)
end
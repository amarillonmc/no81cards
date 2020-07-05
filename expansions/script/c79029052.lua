--企鹅物流·辅助干员-空
function c79029052.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFun2(c,aux.FilterBoolFunction(Card.IsFusionSetCard,
	0x1902),aux.FilterBoolFunction(Card.IsFusionSetCard,0xa900),true)  
	--disable
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_DISABLE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(0,LOCATION_MZONE)
	e1:SetTarget(c79029052.distg)
	c:RegisterEffect(e1)
	--cannot attack
	local e2=e1:Clone()
	e2:SetCode(EFFECT_CANNOT_ATTACK)
	c:RegisterEffect(e2) 
	--CANNOT_CHANGE_POSITION
	local e3=e1:Clone()
	e3:SetCode(EFFECT_CANNOT_CHANGE_POSITION)
	c:RegisterEffect(e3)
	--atk up
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(79029021,0))
	e4:SetCategory(CATEGORY_ATKCHANGE)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCost(c79029052.atkcost)
	e4:SetTarget(c79029052.atktg)
	e4:SetOperation(c79029052.atkop)
	c:RegisterEffect(e4)  
end
function c79029052.distg(e,c)
	return c:GetDefense()<=e:GetHandler():GetDefense()
end
function c79029052.filter(c)
	return c:IsFaceup()
end
function c79029052.atkcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsCanRemoveCounter(tp,1,0,0x1099,5,REASON_COST) end
	Duel.RemoveCounter(tp,1,0,0x1099,5,REASON_COST)
end
function c79029052.atktg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c79029052.filter,tp,LOCATION_MZONE,0,1,nil) end
end
function c79029052.atkop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c79029052.filter,tp,LOCATION_MZONE,0,nil)
	local tc=g:GetFirst()
	while tc do
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,2)
		e1:SetValue(tc:GetAttack()*1/2)
		tc:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_UPDATE_DEFENSE)
		e2:SetValue(tc:GetDefense()*1/2)
		tc:RegisterEffect(e2)
		tc=g:GetNext()
	end
end
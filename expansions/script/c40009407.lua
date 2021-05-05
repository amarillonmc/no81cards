--混沌No.12 机甲忍者 无影
function c40009407.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsRace,RACE_WARRIOR),6,3)
	c:EnableReviveLimit()  
	--attack up
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(40009407,0))
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCost(c40009407.cost)
	e1:SetOperation(c40009407.operation)
	c:RegisterEffect(e1) 
	--direct attack
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_DIRECT_ATTACK)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c40009407.indcon)
	c:RegisterEffect(e2) 
end
c40009407.xyz_number=12
function c40009407.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c40009407.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local atk=c:GetAttack()
	local def=c:GetDefense()
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_SET_ATTACK_FINAL)
		e1:SetTargetRange(LOCATION_MZONE,0)
		e1:SetTarget(c40009407.atktg)
		e1:SetValue(atk*2)
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_SET_DEFENSE_FINAL)
		e2:SetValue(def*2)
		Duel.RegisterEffect(e2,tp)
		local e3=e1:Clone()
		e3:SetCode(EFFECT_PIERCE)
		Duel.RegisterEffect(e1,tp)
end
function c40009407.atktg(e,c)
	return c:IsRace(RACE_WARRIOR)
end
function c40009407.indcon(e)
	return e:GetHandler():GetOverlayGroup():IsExists(Card.IsCode,1,nil,19333131)
end
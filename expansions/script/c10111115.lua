function c10111115.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,c10111115.mfilter,5,3,c10111115.ovfilter,aux.Stringid(10111115,0),3,c10111115.xyzop)
	c:EnableReviveLimit()
  --immune
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(c10111115.efilter1)
	c:RegisterEffect(e1)
    	--attack up
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_ATKCHANGE)
	e2:SetDescription(aux.Stringid(10111115,0))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetCountLimit(1)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCost(c10111115.cost)
	e2:SetOperation(c10111115.operation)
	c:RegisterEffect(e2)
end
function c10111115.mfilter(c)
	return c:IsRace(RACE_WARRIOR) 
end
function c10111115.ovfilter(c)
	return c:IsFaceup() and c:IsCode(60645181)
end
function c10111115.efilter1(e,te)
	return te:GetOwnerPlayer()~=e:GetHandlerPlayer() and te:IsActiveType(TYPE_MONSTER)
end
function c10111115.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,3,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,3,3,REASON_COST)
end
function c10111115.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsFaceup() then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_ATTACK_FINAL)
		e1:SetValue(c:GetBaseAttack()*2)
		c:RegisterEffect(e1)
	end
end
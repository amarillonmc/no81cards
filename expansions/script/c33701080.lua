--超自研的慵懒
function c33701080.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_END_PHASE)
	c:RegisterEffect(e1)
	--cannot attack
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_ATTACK)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetTarget(c33701080.atktarget)
	c:RegisterEffect(e2)
	--atk up
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(33701080,1))
	e2:SetCategory(CATEGORY_ATKCHANGE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_SZONE)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e2:SetHintTiming(TIMING_DAMAGE_STEP)
	e2:SetCondition(c33701080.atkcon)
	e2:SetCost(c33701080.atkcost)
	e2:SetOperation(c33701080.atkop)
	c:RegisterEffect(e2)
end
function c33701080.atktarget(e,c)
	return not (c:IsLevel(5) or c:IsRank(5))and c:IsAttribute(ATTRIBUTE_EARTH)
end
function c33701080.atkcon(e,tp,eg,ep,ev,re,r,rp)
	local phase=Duel.GetCurrentPhase()
	if phase~=PHASE_DAMAGE or Duel.IsDamageCalculated() then return false end
	local tc=Duel.GetAttackTarget()
	if not tc then return false end
	if tc:IsControler(1-tp) then tc=Duel.GetAttacker() end
	e:SetLabelObject(tc)
	return tc:IsFaceup() and (tc:IsLevel(5) or tc:IsRank(5)) and tc:IsAttribute(ATTRIBUTE_EARTH) and tc:IsRelateToBattle()
end
function c33701080.atkcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToHandAsCost() end
	Duel.SendtoHand(e:GetHandler(),nil,2,REASON_COST)
end
function c33701080.atkop(e,tp,eg,ep,ev,re,r,rp)
	 local c=Duel.GetAttacker()
	local tc=Duel.GetAttackTarget()
	if not c:IsRelateToBattle() or not tc:IsRelateToBattle() then return end
	if tc:IsRelateToBattle() then Duel.SendtoGrave(tc,REASON_EFFECT) end
end
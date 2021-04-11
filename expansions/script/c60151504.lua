--Yang Xiao Long
function c60151504.initial_effect(c)
	c:SetUniqueOnField(1,0,60151504)
	--battle indestructable
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e1:SetValue(1)
	c:RegisterEffect(e1)
	--return
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_ATKCHANGE)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
    e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e2:SetCode(EVENT_DAMAGE_STEP_END)
	e2:SetOperation(c60151504.retop)
	c:RegisterEffect(e2)
	--return
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_DAMAGE_STEP_END)
    e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e3:SetCountLimit(1)
	e3:SetOperation(c60151504.retop2)
	c:RegisterEffect(e3)
end
function c60151504.retop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():GetBattleTarget()==nil then return end
	local bc=e:GetHandler():GetBattleTarget()
	if not bc:IsRelateToBattle() and not e:GetHandler():IsFaceup() and not e:GetHandler():IsRelateToBattle() then return end
	if bc:IsFaceup() then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		e1:SetValue((bc:GetAttack())/2)
		e:GetHandler():RegisterEffect(e1)
	else
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		e1:SetValue((bc:GetBaseAttack())/2)
		e:GetHandler():RegisterEffect(e1)
	end
end
function c60151504.retop2(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():GetBattleTarget()==nil then return end
	local bc=e:GetHandler():GetBattleTarget()
	if bc:IsRelateToBattle() and e:GetHandler():IsFaceup() and e:GetHandler():IsRelateToBattle()
		and bc:IsLocation(LOCATION_MZONE) and e:GetHandler():IsChainAttackable() then
		Duel.ChainAttack()
	end
end
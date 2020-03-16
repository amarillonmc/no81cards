--伏魔忍鬼 白萩野
function c40009052.initial_effect(c)
	c:EnableReviveLimit()
	--atk
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(40009052,0))
	e1:SetCategory(CATEGORY_ATKCHANGE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e1:SetRange(LOCATION_HAND)
	e1:SetHintTiming(TIMING_DAMAGE_STEP)
	e1:SetCondition(c40009052.atkcon)
	e1:SetCost(c40009052.atkcost)
	e1:SetOperation(c40009052.atkop)
	c:RegisterEffect(e1)  
	--flip
	--indes
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(LOCATION_MZONE,0)
	e3:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x2b))
	e3:SetCondition(c40009052.indcon)
	e3:SetValue(1)
	c:RegisterEffect(e3)
end
function c40009052.atkcon(e,tp,eg,ep,ev,re,r,rp)
	local phase=Duel.GetCurrentPhase()
	if phase~=PHASE_DAMAGE or Duel.IsDamageCalculated() then return false end
	local a=Duel.GetAttacker()
	local d=Duel.GetAttackTarget()
	if not a:IsControler(tp) then a,d=d,a end
	e:SetLabelObject(a)
	return a and a:IsFaceup() and a:IsControler(tp) and a:IsSetCard(0x2b) and a:IsRelateToBattle()
		and d and d:IsControler(1-tp)
end
function c40009052.atkcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToGraveAsCost() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST)
end
function c40009052.atkop(e,tp,eg,ep,ev,re,r,rp,chk)
	local a=e:GetLabelObject()
	if not a or not a:IsRelateToBattle() then return end
	if a:IsFaceup() then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_DEFENSE)
		e1:SetValue(3000)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		a:RegisterEffect(e1)
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_IMMUNE_EFFECT)
		e2:SetValue(c40009052.efilter)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		e2:SetOwnerPlayer(tp)
		a:RegisterEffect(e2)
	end
	if a:IsFaceup() and not a:IsDefensePos() and Duel.SelectYesNo(tp,aux.Stringid(40009052,1)) then
		Duel.BreakEffect()
		Duel.ChangePosition(a,POS_FACEUP_DEFENSE)
	end
end
function c40009052.efilter(e,re)
	return e:GetOwnerPlayer()~=re:GetOwnerPlayer()
end
function c40009052.indcon(e)
	return e:GetHandler():IsDefensePos()
end
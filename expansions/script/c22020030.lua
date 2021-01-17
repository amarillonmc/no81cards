--人理之基 玛修·基列莱特
function c22020030.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(nil),1)
	c:EnableReviveLimit()
	--summon success
	local e100=Effect.CreateEffect(c)
	e100:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e100:SetCode(EVENT_SPSUMMON_SUCCESS)
	e100:SetOperation(c22020030.sumsuc)
	e100:SetCountLimit(1,22020030+EFFECT_COUNT_CODE_DUEL)
	c:RegisterEffect(e100)
	--indes
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetCondition(c22020030.cona)
	e1:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0xff1))
	e1:SetValue(1)
	c:RegisterEffect(e1)
	--indes
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetCondition(c22020030.cond)
	e2:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0xff1))
	e2:SetValue(1)
	c:RegisterEffect(e2)
	--search
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_POSITION)
	e3:SetDescription(aux.Stringid(22020030,0))
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetCountLimit(1)
	e3:SetHintTiming(0,TIMING_END_PHASE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(c22020030.condition)
	e3:SetOperation(c22020030.operation)
	c:RegisterEffect(e3)
end
function c22020020.sumsuc(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	Debug.Message("开始战斗。Matster，请下指示")
	Duel.RegisterEffect(e1,tp)
end
function c22020030.cona(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsAttackPos()
end
function c22020030.cond(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsDefensePos()
end
function c22020030.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=tp
end
function c22020030.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsFaceup() and c:IsRelateToEffect(e) then
		Duel.ChangePosition(c,POS_FACEUP_DEFENSE,0,POS_FACEUP_ATTACK,0)
	end
end
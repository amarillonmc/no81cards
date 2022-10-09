--人理之基 溶解莉莉丝
function c22021600.initial_effect(c)
	c:SetUniqueOnField(1,0,22021600)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcCodeFun(c,22020310,aux.FilterBoolFunction(Card.IsFusionSetCard,0x2ff1),1,true,true)
	--attack cost
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_ATTACK_COST)
	e1:SetCost(c22021600.atcost)
	e1:SetOperation(c22021600.atop)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(0,LOCATION_MZONE)
	e2:SetTarget(c22021600.eftg)
	e2:SetLabelObject(e1)
	c:RegisterEffect(e2)
	--attribute
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(0,LOCATION_MZONE)
	e3:SetCode(EFFECT_ADD_TYPE)
	e3:SetTarget(c22021600.eftg1)
	e3:SetValue(TYPE_EFFECT)
	c:RegisterEffect(e3)
	--protect battle
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(22021600,0))
	e4:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetRange(LOCATION_MZONE)
	e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e4:SetHintTiming(TIMING_DAMAGE_STEP,TIMING_DAMAGE_STEP+TIMINGS_CHECK_MONSTER)
	e4:SetCountLimit(1)
	e4:SetCondition(aux.dscon)
	e4:SetTarget(c22021600.pttg)
	e4:SetOperation(c22021600.ptop)
	c:RegisterEffect(e4)
end
function c22021600.atcost(e,c,tp)
	return Duel.CheckReleaseGroup(tp,nil,1,e:GetHandler())
end
function c22021600.atop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.SelectReleaseGroup(tp,nil,1,1,e:GetHandler())
	Duel.Release(g,REASON_COST)
end
function c22021600.eftg(e,c)
	return c:IsType(TYPE_MONSTER)
end
function c22021600.eftg1(e,c)
	return c:IsFaceup() and not c:IsType(TYPE_EFFECT)
end
function c22021600.pttg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,1,e:GetHandler()) end
end
function c22021600.ptop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsFaceup() then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE+RESET_PHASE+PHASE_END)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(1000)
		c:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_FIELD)
		e2:SetCode(EFFECT_UPDATE_ATTACK)
		e2:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		e2:SetTarget(c22021600.ptfilter)
		e2:SetValue(-1000)
		Duel.RegisterEffect(e2,tp)
	end
end
function c22021600.ptfilter(e,c)
	return c:IsFaceup() and c:IsAttackAbove(1) and c~=e:GetHandler()
end

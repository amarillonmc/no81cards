--龙界将军 北极星·圣龙
function c99700295.initial_effect(c)
	c:SetSPSummonOnce(99700295)
	--xyz summon
	aux.AddXyzProcedureLevelFree(c,c99700295.mfilter,c99700295.xyzcheck,2,2,c99700295.ovfilter,aux.Stringid(99700295,0))
	c:EnableReviveLimit()
	--spsummon condition
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	e0:SetValue(c99700295.splimit1)
	c:RegisterEffect(e0)
	--indes
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(LOCATION_MZONE+LOCATION_FZONE+LOCATION_SZONE,0)
	e1:SetCondition(c99700295.indcon)
	e1:SetTarget(c99700295.indtg)
	e1:SetValue(1)
	c:RegisterEffect(e1)
	--act qp/trap in hand
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_QP_ACT_IN_NTPHAND)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(LOCATION_HAND,0)
	e2:SetCondition(c99700295.handcon)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	c:RegisterEffect(e3)
	local e4=e2:Clone()
	e4:SetCode(99700295)
	c:RegisterEffect(e4)
	--activate cost
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetCode(EFFECT_ACTIVATE_COST)
	e5:SetRange(LOCATION_MZONE)
	e5:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e5:SetTargetRange(1,0)
	e5:SetCost(c99700295.costchk)
	e5:SetTarget(c99700295.costtg)
	e5:SetOperation(c99700295.costop)
	c:RegisterEffect(e5)
	--atk up
	local e6=Effect.CreateEffect(c)
	e6:SetCategory(CATEGORY_ATKCHANGE)
	e6:SetType(EFFECT_TYPE_QUICK_O)
	e6:SetRange(LOCATION_MZONE)
	e6:SetCode(EVENT_PRE_DAMAGE_CALCULATE)
	e6:SetCondition(c99700295.atkcon)
	e6:SetCost(c99700295.atkcost)
	e6:SetOperation(c99700295.atkop)
	c:RegisterEffect(e6)
	--cannot be Destroy
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_FIELD)
	e7:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e7:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e7:SetRange(LOCATION_MZONE)
	e7:SetTargetRange(LOCATION_ONFIELD,0)
	e7:SetCondition(c99700295.indcon)
	e7:SetTarget(aux.TargetBoolFunction(Card.IsType,TYPE_SPELL+TYPE_TRAP))
	e7:SetValue(aux.indoval)
	c:RegisterEffect(e7)
end
function c99700295.splimit1(e,se,sp,st)
	return (se:GetHandler():IsSetCard(0xfb00) or se:GetHandler():IsSetCard(0xfb01) or se:GetHandler():IsSetCard(0xfb02) or se:GetHandler():IsSetCard(0xfb03) or se:GetHandler():IsSetCard(0xfb04))
end
function c99700295.mfilter(c,xyzc)
	return c:IsType(TYPE_MONSTER) and c:IsLevel(10)
end
function c99700295.ovfilter(c)
	return c:IsFaceup() and c:IsXyzType(TYPE_XYZ) and (c:IsSetCard(0xfb00) or c:IsSetCard(0xfb04))
end
function c99700295.indcon(e)
	return Duel.IsEnvironment(99700121) or Duel.IsEnvironment(99700281)
end
function c99700295.indtg(e,c)
	return c==e:GetHandler() or (c:IsLocation(LOCATION_FZONE) and (c:IsFaceup() or c:IsFacedown()))
end
function c99700295.handcon(e)
	return Duel.GetTurnPlayer()~=e:GetHandlerPlayer() and e:GetHandler():GetOverlayCount()~=0
end
function c99700295.costtg(e,te,tp)
	local tc=te:GetHandler()
	return Duel.GetTurnPlayer()~=e:GetHandlerPlayer()
		and tc:IsLocation(LOCATION_HAND) and tc:GetEffectCount(99700295)>0
		and ((tc:GetEffectCount(EFFECT_QP_ACT_IN_NTPHAND)<=tc:GetEffectCount(99700295) and tc:IsType(TYPE_QUICKPLAY+TYPE_SPELL))
			or (tc:GetEffectCount(EFFECT_TRAP_ACT_IN_HAND)<=tc:GetEffectCount(99700295) and tc:IsType(TYPE_COUNTER+TYPE_TRAP)))
end
function c99700295.costchk(e,te_or_c,tp)
	return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_EFFECT)
end
function c99700295.costop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,99700295)
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_EFFECT)
end
function c99700295.atkcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local bc=c:GetBattleTarget()
	return bc and bc:IsSummonType(SUMMON_TYPE_SPECIAL) and bc:GetAttack()>0
end
function c99700295.atkcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:GetFlagEffect(99700295)==0 end
	c:RegisterFlagEffect(99700295,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_DAMAGE_CAL,0,1)
end
function c99700295.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local bc=c:GetBattleTarget()
	if c:IsRelateToBattle() and c:IsFaceup() and bc:IsRelateToBattle() and bc:IsFaceup() then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_DAMAGE_CAL)
		e1:SetValue(bc:GetAttack())
		c:RegisterEffect(e1)
	end
end
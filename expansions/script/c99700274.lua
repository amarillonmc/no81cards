--龙界原始龙种后裔 圣白龙
function c99700274.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFunFunRep(c,aux.FilterBoolFunction(Card.IsFusionSetCard,0xfd00),aux.FilterBoolFunction(Card.IsFusionSetCard,0xfd04,0xfd07),4,99,true)
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(c99700274.splimit)
	c:RegisterEffect(e1)
	--multi attack
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCondition(c99700274.mtcon)
	e2:SetOperation(c99700274.mtop)
	c:RegisterEffect(e2)
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetCode(EFFECT_MATERIAL_CHECK)
	e5:SetValue(c99700274.valcheck1)
	e5:SetLabelObject(e2)
	c:RegisterEffect(e5)
	--disable
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_ATTACK_ANNOUNCE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e3:SetCondition(c99700274.discon)
	e3:SetOperation(c99700274.disop)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EVENT_BE_BATTLE_TARGET)
	c:RegisterEffect(e4)
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_FIELD)
	e6:SetCode(EFFECT_DISABLE)
	e6:SetRange(LOCATION_MZONE)
	e6:SetTargetRange(0,LOCATION_MZONE)
	e6:SetTarget(c99700274.distg)
	c:RegisterEffect(e6)
	local e7=e6:Clone()
	e7:SetCode(EFFECT_DISABLE_EFFECT)
	c:RegisterEffect(e7)
	--spsummon()
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_SINGLE)
	e8:SetCode(EFFECT_CANNOT_DISABLE_SPSUMMON)
	e8:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e8:SetCondition(c99700274.effcon)
	c:RegisterEffect(e8)
	--summon success
	local e9=Effect.CreateEffect(c)
	e9:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e9:SetCode(EVENT_SPSUMMON_SUCCESS)
	e9:SetOperation(c99700274.sumsuc)
	c:RegisterEffect(e9)
	--Disable
	local e10=Effect.CreateEffect(c)
	e10:SetDescription(aux.Stringid(99700274,0))
	e10:SetCategory(CATEGORY_DISABLE)
	e10:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e10:SetType(EFFECT_TYPE_QUICK_O)
	e10:SetCode(EVENT_FREE_CHAIN)
	e10:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e10:SetHintTiming(TIMING_DAMAGE_STEP+TIMING_MAIN_END)
	e10:SetCountLimit(1,99700274)
	e10:SetRange(LOCATION_MZONE)
	e10:SetCondition(c99700274.Dcon)
	e10:SetTarget(c99700274.tg)
	e10:SetOperation(c99700274.op)
	c:RegisterEffect(e10)
	--activate limit
	local e11=Effect.CreateEffect(c)
	e11:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e11:SetCode(EVENT_CHAINING)
	e11:SetRange(LOCATION_MZONE)
	e11:SetOperation(c99700274.alop)
	c:RegisterEffect(e11)
	--negate
	local e12=Effect.CreateEffect(c)
	e12:SetDescription(aux.Stringid(99700274,1))
	e12:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e12:SetType(EFFECT_TYPE_QUICK_O)
	e12:SetCode(EVENT_CHAINING)
	e12:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e12:SetCountLimit(5)
	e12:SetRange(LOCATION_MZONE)
	e12:SetCondition(c99700274.negcon)
	e12:SetCost(c99700274.cost)
	e12:SetTarget(c99700274.negtg)
	e12:SetOperation(c99700274.negop)
	c:RegisterEffect(e12)
	--cannot release
	local e14=Effect.CreateEffect(c)
	e14:SetType(EFFECT_TYPE_SINGLE)
	e14:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e14:SetRange(LOCATION_MZONE)
	e14:SetCode(EFFECT_UNRELEASABLE_SUM)
	e14:SetValue(1)
	c:RegisterEffect(e14)
	local e15=e14:Clone()
	e15:SetCode(EFFECT_UNRELEASABLE_NONSUM)
	c:RegisterEffect(e15)
	local e16=Effect.CreateEffect(c)
	e16:SetType(EFFECT_TYPE_SINGLE)
	e16:SetCode(EFFECT_MATERIAL_CHECK)
	e16:SetValue(c99700274.valcheck)
	e16:SetLabelObject(e14,e15,e17,e19)
	c:RegisterEffect(e16)
	--immune
	local e17=Effect.CreateEffect(c)
	e17:SetType(EFFECT_TYPE_SINGLE)
	e17:SetCode(EFFECT_IMMUNE_EFFECT)
	e17:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e17:SetRange(LOCATION_MZONE)
	e17:SetCondition(c99700274.valcheck)
	e17:SetValue(c99700274.efilter)
	c:RegisterEffect(e17)
	--cannot be fusion material
	local e18=Effect.CreateEffect(c)
	e18:SetType(EFFECT_TYPE_SINGLE)
	e18:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e18:SetCode(EFFECT_CANNOT_BE_FUSION_MATERIAL)
	e18:SetValue(1)
	c:RegisterEffect(e18)
	local e19=e17:Clone()
	e19:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	c:RegisterEffect(e19)
end
c99700274.material_type=TYPE_FUSION 
function c99700274.valcheck1(e,c)
	e:GetLabelObject():SetLabel(c:GetMaterial():FilterCount(Card.GetOriginalType,nil,TYPE_SPELL+TYPE_TRAP))
end
function c99700274.mtcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_FUSION)
end
function c99700274.mtop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ct=e:GetLabel()
	if ct>=2 then
		local e1=Effect.CreateEffect(c)
		e1:SetDescription(aux.Stringid(99700274,2))
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
		e1:SetCode(EFFECT_EXTRA_ATTACK)
		e1:SetValue(ct-1)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		c:RegisterEffect(e1)
	end
end
function c99700274.splimit(e,se,sp,st)
	return not e:GetHandler():IsLocation(LOCATION_EXTRA+LOCATION_GRAVE+LOCATION_REMOVED) or bit.band(st,SUMMON_TYPE_FUSION)==SUMMON_TYPE_FUSION and se:GetHandler():IsCode(99700273)
end
function c99700274.cfilter(c,tp)
	return c:IsFaceup() and (c:IsSetCard(0xfd00) or c:IsSetCard(0xfd04)) and c:IsControler(tp)
end
function c99700274.discon(e,tp,eg,ep,ev,re,r,rp)
	local c=Duel.GetAttackTarget()
	if not c then return false end
	if c:IsControler(1-tp) then c=Duel.GetAttacker() end
	return c and c99700274.cfilter(c,tp)
end
function c99700274.disop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetAttackTarget()
	if tc:IsControler(tp) then tc=Duel.GetAttacker() end
	tc:RegisterFlagEffect(99700274,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_BATTLE,0,1)
	Duel.AdjustInstantly(c)
end
function c99700274.distg(e,c)
	return c:GetFlagEffect(99700274)~=0
end
function c99700274.effcon(e)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_FUSION)
end
function c99700274.sumsuc(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsSummonType(SUMMON_TYPE_FUSION) then return end
	Duel.SetChainLimitTillChainEnd(aux.FALSE)
end
function c99700274.Dcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2 or Duel.GetCurrentPhase()==PHASE_BATTLE_START or Duel.GetCurrentPhase()==PHASE_BATTLE_STEP or Duel.GetCurrentPhase()==PHASE_BATTLE 
end
function c99700274.disfilter(c)
	return c:IsFaceup() and not c:IsDisabled() and c:GetOriginalType(TYPE_EFFECT)
end
function c99700274.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c99700274.disfilter,tp,0,LOCATION_MZONE,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,nil,1,0,0)
	Duel.SetChainLimit(c99700274.chainlm)
end
function c99700274.op(e,tp,eg,ep,ev,re,r,rp)
	local cc=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g2=Duel.SelectMatchingCard(tp,c99700274.disfilter,tp,0,LOCATION_MZONE,1,1,nil)
	if g2:GetCount()>0 then
		local tc=g2:GetFirst()
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetValue(RESET_TURN_SET)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e2)
		Duel.AdjustInstantly()
		Duel.NegateRelatedChain(tc,RESET_TURN_SET)
		Duel.MajesticCopy(cc,tc)
	end
end
function c99700274.alop(e,tp,eg,ep,ev,re,r,rp)
	if re:GetOwner()==e:GetOwner() and not re:IsHasProperty(EFFECT_FLAG_INITIAL) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetCode(EFFECT_CANNOT_ACTIVATE)
		e1:SetRange(LOCATION_MZONE)
		e1:SetTargetRange(1,1)
		e1:SetValue(c99700274.aclimit1)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		e:GetHandler():RegisterEffect(e1)
	end
end
function c99700274.aclimit1(e,re,tp)
	return re:GetOwner()==e:GetOwner() and not re:IsHasProperty(EFFECT_FLAG_INITIAL)
end
function c99700274.negcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if ep==tp or c:IsStatus(STATUS_BATTLE_DESTROYED) then return false end
	return (re:IsActiveType(TYPE_MONSTER) or re:IsHasType(EFFECT_TYPE_ACTIVATE)) and Duel.IsChainNegatable(ev)
end
function c99700274.cfilter1(c)
	return (c:IsSetCard(0xfd00) or c:IsSetCard(0xfd04)) and c:IsType(TYPE_SPELL+TYPE_TRAP+TYPE_MONSTER) and c:IsAbleToGraveAsCost()
end
function c99700274.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c99700274.cfilter1,tp,LOCATION_HAND,0,1,nil) end
	Duel.SendtoGrave(tp,c99700274.cfilter1,1,1,REASON_COST)
end
function c99700274.negtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
	Duel.SetChainLimit(c99700274.chainlm)
end
function c99700274.negop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
		Duel.Destroy(eg,REASON_EFFECT)
	end
end
function c99700274.valcheck(e,c)
	return (e:GetHandler():GetMaterial():FilterCount(Card.IsSetCard,nil,0xfd00) or e:GetHandler():GetMaterial():FilterCount(Card.IsSetCard,nil,0xfd07)) and e:GetHandler():GetMaterial():FilterCount(Card.IsType,nil,TYPE_SPELL+TYPE_TRAP)
end
function c99700274.efilter(e,re)
	return e:GetOwnerPlayer()~=re:GetOwnerPlayer()
end
function c99700274.chainlm(e,ep,tp)
	return tp==ep
end
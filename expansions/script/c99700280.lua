--龙界守护者 聂尔·圣龙
function c99700280.initial_effect(c)
	c:SetSPSummonOnce(99700280)
	c:SetUniqueOnField(1,0,99700280)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFun2(c,aux.AND(aux.FilterBoolFunction(Card.IsFusionType,TYPE_SPELL+TYPE_TRAP),aux.FilterBoolFunction(Card.IsFusionSetCard,0xfd04)),aux.AND(aux.FilterBoolFunction(Card.IsFusionType,TYPE_MONSTER),aux.FilterBoolFunction(Card.IsFusionSetCard,0xfd00)),false)
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(c99700280.splimit)
	c:RegisterEffect(e1)
	--indes
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetCondition(c99700280.spcon)
	e2:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0xfd04))
	e2:SetValue(1)
	c:RegisterEffect(e2)
	--damage 0
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_CHANGE_DAMAGE)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetRange(LOCATION_MZONE)
	e4:SetTargetRange(1,1)
	e4:SetValue(c99700280.damval)
	c:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetCode(EFFECT_NO_EFFECT_DAMAGE)
	c:RegisterEffect(e5)
	--negate
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e6:SetCode(EVENT_CHAINING)
	e6:SetRange(LOCATION_MZONE)
	e6:SetCountLimit(1,99700280)
	e6:SetCondition(c99700280.condition)
	e6:SetTarget(c99700280.target)
	e6:SetOperation(c99700280.activate)
	c:RegisterEffect(e6)
end
function c99700280.spcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_FUSION)
end
function c99700280.splimit(e,se,sp,st)
	return not e:GetHandler():IsLocation(LOCATION_EXTRA+LOCATION_GRAVE+LOCATION_REMOVED) or bit.band(st,SUMMON_TYPE_FUSION)==SUMMON_TYPE_FUSION 
end
function c99700280.damval(e,re,val,r,rp,rc)
	if bit.band(r,REASON_EFFECT)~=0 then return 0 end
	return val
end
function c99700280.condition(e,tp,eg,ep,ev,re,r,rp,c)
	return Duel.IsChainNegatable(ev) and not (re:GetHandler():IsSetCard(0xfd00) or  re:GetHandler():IsSetCard(0xfd04)) and re:IsHasType(EFFECT_TYPE_ACTIVATE)
end
function c99700280.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return aux.nbcon(tp,re) end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsAbleToGrave() and re:GetHandler():IsRelateToEffect(re) then
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,eg,1,0,0)
	end
end
function c99700280.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
	Duel.Hint(HINT_CARD,0,99700280)
	local code=re:GetCode()
		Duel.SendtoGrave(re:GetHandler(),nil,REASON_EFFECT)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetCode(EFFECT_CANNOT_ACTIVATE)
		e1:SetTargetRange(0,1)
		e1:SetValue(c99700280.aclimit)
		e1:SetLabel(code)
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
	end
end
function c99700280.aclimit(e,re,tp)
	return re:IsHasType(EFFECT_TYPE_ACTIVATE) and re:GetHandler():IsCode(e:GetLabel())
end

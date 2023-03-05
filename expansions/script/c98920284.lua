--魔轰神 阿斯塔罗
function c98920284.initial_effect(c)
   --atkdown
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(98920284,1))
	e2:SetCategory(CATEGORY_ATKCHANGE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e2:SetRange(LOCATION_HAND)
	e2:SetHintTiming(TIMING_DAMAGE_STEP)
	e2:SetCondition(c98920284.condition2)
	e2:SetCost(c98920284.cost2)
	e2:SetTarget(c98920284.target2)
	e2:SetOperation(c98920284.operation2)
	c:RegisterEffect(e2)
--to hand
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,98920284)
	e2:SetCondition(c98920284.thcon)
	e2:SetTarget(c98920284.thtg)
	e2:SetOperation(c98920284.thop)
	c:RegisterEffect(e2)
end
function c98920284.condition2(e,tp,eg,ep,ev,re,r,rp)
	local phase=Duel.GetCurrentPhase()
	if phase~=PHASE_DAMAGE or Duel.IsDamageCalculated() then return false end
	local a=Duel.GetAttacker()
	local d=Duel.GetAttackTarget()
	if not d then return false end
	if not a:IsControler(tp) then a,d=d,a end
	e:SetLabelObject(d)
	return a:IsControler(tp) and a:IsFaceup() and a:IsRace(RACE_FIEND) and d:IsControler(1-tp) and d:IsFaceup() and d:IsRelateToBattle()
end
function c98920284.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToGraveAsCost() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST)
end
function c98920284.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	local d=e:GetLabelObject()
	if chk==0 then return d end
	Duel.SetTargetCard(d)
end
function c98920284.operation2(e,tp,eg,ep,ev,re,r,rp)
	local d=Duel.GetFirstTarget()
	if not (d:IsRelateToBattle() and d:IsFaceup() and d:IsControler(1-tp)) then return end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SET_ATTACK_FINAL)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
	e1:SetValue(0)
	d:RegisterEffect(e1)
end
function c98920284.thcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c98920284.thfilter,1,nil) and not eg:IsContains(e:GetHandler())
end
function c98920284.thfilter(c)
	return c:IsSetCard(0x35) and c:IsPreviousLocation(LOCATION_HAND)
end
function c98920284.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
end
function c98920284.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SendtoHand(c,nil,REASON_EFFECT)
	end
end
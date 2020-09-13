--姬绊连结 春咲日和莉
function c10700235.initial_effect(c)
	aux.EnableDualAttribute(c)   
	--atkup
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(10700235,0))
	e1:SetCategory(CATEGORY_ATKCHANGE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_HAND)
	e1:SetHintTiming(TIMING_DAMAGE_STEP)
	e1:SetCountLimit(1,10700235)
	e1:SetCondition(aux.dscon)
	e1:SetCost(c10700235.atkcost1)
	e1:SetTarget(c10700235.atktg)
	e1:SetOperation(c10700235.atkop1)
	c:RegisterEffect(e1) 
	--atk up
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(10700235,1))
	e2:SetCategory(CATEGORY_ATKCHANGE)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetCountLimit(1)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(aux.IsDualState)
	e2:SetCost(c10700235.thcost)
	e2:SetOperation(c10700235.operation)
	c:RegisterEffect(e2) 
end
function c10700235.atkcost1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsDiscardable() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST+REASON_DISCARD)
end
function c10700235.atkfilter(c)
	return c:IsFaceup() and (c:IsSetCard(0x3a01) or c:IsType(TYPE_DUAL))
end
function c10700235.atktg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c10700235.atkfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c10700235.atkfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c10700235.atkfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
end
function c10700235.atkop1(e,tp,eg,ep,ev,re,r,rp,chk)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(1900)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
	end
end
function c10700235.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)
end
function c10700235.atkfilter2(c)
	return c:IsFaceup()
end
function c10700235.operation(e,tp,eg,ep,ev,re,r,rp)
   local tg=Duel.GetMatchingGroup(c10700235.atkfilter2,tp,LOCATION_MZONE,0,nil)
   if tg:GetCount()<=0 then return end
   local tc=tg:GetFirst()
   while tc do
	   local e1=Effect.CreateEffect(e:GetHandler())
	   e1:SetType(EFFECT_TYPE_SINGLE)
	   e1:SetCode(EFFECT_UPDATE_ATTACK)
	   e1:SetValue(600)
	   e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	   e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
	   tc:RegisterEffect(e1)
	   tc=tg:GetNext()
   end
end
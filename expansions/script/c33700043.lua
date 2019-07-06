--GUARDIAN 静流
function c33700043.initial_effect(c)
 c:EnableCounterPermit(0x1021)	 
  --spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetRange(LOCATION_HAND)
	e1:SetCode(EVENT_SSET)
	e1:SetCondition(c33700043.spcon)
	e1:SetTarget(c33700043.sptg)
	e1:SetOperation(c33700043.spop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_MSET)
	c:RegisterEffect(e2)
	--counter
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(33700043,0))
	e3:SetCategory(CATEGORY_COUNTER)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e3:SetCountLimit(1)
	e3:SetCondition(c33700043.addcon)
	e3:SetOperation(c33700043.addc)
	c:RegisterEffect(e3)
	--atk
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(33700043,1))
	e4:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e4:SetRange(LOCATION_MZONE)
	e4:SetHintTiming(TIMING_DAMAGE_STEP)
	e4:SetCountLimit(1,EFFECT_COUNT_CODE_SINGLE)
	e4:SetCondition(c33700043.atkcon)
	e4:SetCost(c33700043.atkcost)
	e4:SetOperation(c33700043.atkop)
	c:RegisterEffect(e4)
	--destroy
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(33700043,2))
	e5:SetCategory(CATEGORY_DESTROY+CATEGORY_TODECK)
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetRange(LOCATION_MZONE)
	e5:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e5:SetCountLimit(1,EFFECT_COUNT_CODE_SINGLE)
	e5:SetCost(c33700043.cost)
	e5:SetTarget(c33700043.destg)
	e5:SetOperation(c33700043.desop)
	c:RegisterEffect(e5)
end
function c33700043.spcon(e,tp,eg,ep,ev,re,r,rp)
	 local ct1=Duel.GetFieldGroup(tp,LOCATION_ONFIELD,0):FilterCount(Card.IsFacedown,nil)
	local ct2=Duel.GetFieldGroup(tp,0,LOCATION_ONFIELD):FilterCount(Card.IsFacedown,nil)
	return Duel.GetTurnPlayer()==1-tp and rp==1-tp and ct1<ct2
end
function c33700043.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetMZoneCount(tp)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c33700043.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and  Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)>0 then
	c:AddCounter(0x1021,2)
	end
end
function c33700043.addcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp 
end
function c33700043.addc(e,tp,eg,ep,ev,re,r,rp)
		e:GetHandler():AddCounter(0x1021,1)
end
function c33700043.atkcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()~=PHASE_DAMAGE or not Duel.IsDamageCalculated()
end
function c33700043.atkcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():GetCounter(0x1021)>0 end
  e:GetHandler():RemoveCounter(tp,0x1021,1,REASON_COST)
end
function c33700043.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if   c:IsFaceup() and c:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		e1:SetValue(1000)
		c:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_UPDATE_DEFENSE)
		e2:SetValue(-1000)
		c:RegisterEffect(e2)
	end
end
function c33700043.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():GetCounter(0x1021)>1 end
  e:GetHandler():RemoveCounter(tp,0x1021,2,REASON_COST)
end
function c33700043.filter(c)
	return c:IsDestructable() or c:IsAbleToDeck()
end
function c33700043.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() end
	if chk==0 then return Duel.IsExistingTarget(c33700043.filter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,c33700043.filter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c33700043.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e)  then
	  if not tc:IsAbleToDeck() or Duel.SelectYesNo(tp,aux.Stringid(33700043,3)) then
		Duel.Destroy(tc,REASON_EFFECT)
else
	Duel.SendtoDeck(tc,nil,2,REASON_EFFECT)
	end
end
end
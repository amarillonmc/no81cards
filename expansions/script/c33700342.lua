--阻抗之卵 ~后路~
function c33700342.initial_effect(c)
	c:SetUniqueOnField(1,1,33700342)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--con
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetDescription(aux.Stringid(33700342,1))
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCost(c33700342.cost)
	e2:SetCondition(c33700342.con)
	e2:SetTarget(c33700342.tg)
	e2:SetOperation(c33700342.op)
	c:RegisterEffect(e2)	  
	--to hand
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(33700342,0))
	e3:SetCategory(CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetHintTiming(0,0x1e0)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCountLimit(1)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetCondition(c33700342.thcon)
	e3:SetTarget(c33700342.thtg)
	e3:SetOperation(c33700342.thop)
	c:RegisterEffect(e3)	
end
function c33700342.filter(c,p)
	local tp=c:GetControler()
	if c:IsType(TYPE_FIELD) then return false end
	if c:IsLocation(LOCATION_PZONE) and c:IsType(TYPE_PENDULUM) then return Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1) end
	for i=0,4 do
		if c:IsLocation(LOCATION_SZONE) and not c:IsType(TYPE_PENDULUM) and Duel.CheckLocation(tp,LOCATION_SZONE,i) then return true end
		if c:IsLocation(LOCATION_MZONE) and Duel.CheckLocation(tp,LOCATION_MZONE,i) then return true end
	end
	return false
end
function c33700342.tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and c33700342.filter(chkc,tp) end
	if chk==0 then return Duel.IsExistingTarget(c33700342.filter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local g=Duel.SelectTarget(tp,c33700342.filter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil,tp)
end
function c33700342.op(e,p,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local tc=Duel.GetFirstTarget()
	local tp=tc:GetControler()
	local nseq=0
	if not tc:IsRelateToEffect(e) then return end
	local seq=tc:GetSequence()
	if tc:IsLocation(LOCATION_PZONE) and tc:IsType(TYPE_PENDULUM) and 
	   (Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1)) then
	   if seq==0 then nseq=4
	   else nseq=0
	   end  
	end
	if tc:IsLocation(LOCATION_SZONE) and not tc:IsType(TYPE_PENDULUM) then
	   if tc:IsControler(p) then
		  local s=Duel.SelectDisableField(p,1,LOCATION_SZONE,0,0)
		  nseq=math.log(s,2)-8
	   else
		  local s=Duel.SelectDisableField(p,1,0,LOCATION_SZONE,0)/0x10000
		  nseq=math.log(s,2)-8
	   end
	end
	if tc:IsLocation(LOCATION_MZONE) then
	   if tc:IsControler(p) then
		  local s=Duel.SelectDisableField(p,1,LOCATION_MZONE,0,0)
		  nseq=math.log(s,2)
	   else
		  local s=Duel.SelectDisableField(p,1,0,LOCATION_MZONE,0)/0x10000
		  nseq=math.log(s,2)
	   end
	end
	Duel.MoveSequence(tc,nseq)
end
function c33700342.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x5449)
end
function c33700342.con(e,tp,eg,ep,ev,re,r,rp,chk)
	local ct=Duel.GetMatchingGroupCount(c33700342.cfilter,tp,LOCATION_ONFIELD,0,nil)
	local ct2=Duel.GetFlagEffect(tp,33700342)
	return ct>ct2
end
function c33700342.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.RegisterFlagEffect(tp,33700342,RESET_PHASE+PHASE_END,0,1)
end
function c33700342.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToHand() end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,tp,LOCATION_SZONE)
end
function c33700342.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then Duel.SendtoHand(c,nil,REASON_EFFECT)
	end
end
function c33700342.thcon(e,tp,eg,ep,ev,re,r,rp)
	return (Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2) and Duel.GetTurnPlayer()==tp
end

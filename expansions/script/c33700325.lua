--阻抗之脑 黑吉尔
function c33700325.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--con
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCountLimit(2,33700325)
	e1:SetTarget(c33700325.tg)
	e1:SetOperation(c33700325.op)
	c:RegisterEffect(e1)	
end
function c33700325.filter(c,p)
	local tp=c:GetControler()
	if c:IsType(TYPE_FIELD) then return false end
	if c:IsLocation(LOCATION_PZONE) and c:IsType(TYPE_PENDULUM) then return Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1) end
	for i=0,4 do
		if c:IsLocation(LOCATION_SZONE) and not c:IsType(TYPE_PENDULUM) and Duel.CheckLocation(tp,LOCATION_SZONE,i) then return true end
		if c:IsLocation(LOCATION_MZONE) and Duel.CheckLocation(tp,LOCATION_MZONE,i) then return true end
	end
	return false
end
function c33700325.tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and c33700325.filter(chkc,tp) end
	if chk==0 then return Duel.IsExistingTarget(c33700325.filter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local g=Duel.SelectTarget(tp,c33700325.filter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil,tp)
end
function c33700325.op(e,p,eg,ep,ev,re,r,rp)
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

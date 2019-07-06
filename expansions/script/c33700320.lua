--革新者的奇点 佐亚
function c33700320.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--con
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCountLimit(1)
	e1:SetTarget(c33700320.tg)
	e1:SetOperation(c33700320.op)
	c:RegisterEffect(e1) 
	--Atk
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetRange(LOCATION_PZONE)
	e2:SetTargetRange(0,LOCATION_MZONE)
	e2:SetValue(c33700320.adval)
	c:RegisterEffect(e2)
	--Def
	local e3=e2:Clone()
	e3:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e3)  
	--battle indestructable
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e4:SetValue(1)
	c:RegisterEffect(e4)
	--tof
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_QUICK_O)
	e5:SetCode(EVENT_DAMAGE)
	e5:SetRange(LOCATION_HAND)
	e5:SetCountLimit(1,33700320)
	e5:SetCost(c33700320.tfcost)
	e5:SetTarget(c33700320.tftg)
	e5:SetOperation(c33700320.tfop)
	c:RegisterEffect(e5)
end
function c33700320.tfcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsDiscardable() end
	Duel.SendtoGrave(e:GetHandler(),REASON_DISCARD+REASON_COST)
end
function c33700320.tftg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c33700320.cfilter,tp,LOCATION_GRAVE+LOCATION_DECK,0,1,nil) and Duel.GetLocationCount(tp,LOCATION_SZONE)>=1 end
end
function c33700320.tfop(e,tp,eg,ep,ev,re,r,rp)
	local ft=Duel.GetLocationCount(tp,LOCATION_SZONE)
	if ft<=0 then return end
	local ct=math.min(2,ft)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local tg=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c33700320.cfilter),tp,LOCATION_GRAVE+LOCATION_DECK,0,ct,ct,nil)
	if tg:GetCount()<=0 then return end
	for tc in aux.Next(tg) do
	   if Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true) then
		  local e1=Effect.CreateEffect(e:GetHandler())
		  e1:SetCode(EFFECT_CHANGE_TYPE)
		  e1:SetType(EFFECT_TYPE_SINGLE)
		  e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		  e1:SetReset(RESET_EVENT+0x1fc0000)
		  e1:SetValue(TYPE_SPELL+TYPE_CONTINUOUS)
		  tc:RegisterEffect(e1)
	   end
	end
end
function c33700320.cfilter(c)
	return c:IsSetCard(0x1449) and c:IsType(TYPE_MONSTER) and not c:IsForbidden()
end
function c33700320.adval(e,c)
	return -1*(Duel.GetMatchingGroupCount(Card.IsType,tp,LOCATION_ONFIELD,0,nil,TYPE_SPELL+TYPE_TRAP)*200)
end
function c33700320.filter(c)
	return c:IsSetCard(0x1449) and c:IsType(TYPE_SPELL) and c:IsSSetable(false)
end
function c33700320.tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and c33700320.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c33700320.filter,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,nil) and Duel.GetLocationCount(tp,LOCATION_SZONE)>=1 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g=Duel.SelectTarget(tp,c33700320.filter,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,1,nil)
end
function c33700320.op(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 then
	   Duel.SSet(tp,tc,tp) 
	   Duel.ConfirmCards(1-tp,tc)
	   local e1=Effect.CreateEffect(e:GetHandler())
	   e1:SetType(EFFECT_TYPE_SINGLE)
	   e1:SetCode(EFFECT_CANNOT_TRIGGER)
	   e1:SetReset(RESET_EVENT+0x17a0000+RESET_PHASE+PHASE_END)
	   tc:RegisterEffect(e1)
	end
end
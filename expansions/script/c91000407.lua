--机械装甲柒
local m=91000407
local cm=c91000407
function c91000407.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddFusionProcFunRep(c,(function(c) return c:IsLevel(10) end),2,false) 
	aux.AddContactFusionProcedure(c,Card.IsAbleToGraveAsCost,LOCATION_MZONE,0,Duel.SendtoGrave,REASON_COST)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_EQUIP)
	e1:SetCode(EFFECT_SET_CONTROL)
	e1:SetValue(cm.cval)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_EQUIP)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,m)
	e2:SetCondition(cm.con2)
	e2:SetTarget(cm.tg2)
	e2:SetOperation(cm.op2)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_EQUIP)
	e3:SetCode(EFFECT_CANNOT_DISABLE)
	c:RegisterEffect(e3)	
	local e5=Effect.CreateEffect(c)
	e5:SetCategory(CATEGORY_EQUIP)
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetRange(LOCATION_SZONE)
	e5:SetCountLimit(1,m*5)
	e5:SetCondition(cm.condition)
	e5:SetTarget(cm.tg5)
	e5:SetOperation(cm.op5)
	c:RegisterEffect(e5)
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e6:SetCode(EVENT_LEAVE_FIELD)
	e6:SetProperty(EFFECT_FLAG_DELAY)
	e6:SetCountLimit(1,m*6)
	e6:SetOperation(cm.op6)
	c:RegisterEffect(e6)
	Duel.AddCustomActivityCounter(91000407,ACTIVITY_SPSUMMON,cm.counterfilter)
end
function cm.counterfilter(c)
	return  c:IsLevel(10)
end
function cm.con2(e,tp,eg,ep,ev,re,r,rp,chk)
return Duel.GetCustomActivityCount(91000407,tp,ACTIVITY_SPSUMMON)==0 
end
function cm.tg2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsFaceup() end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingTarget(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	Duel.SelectTarget(tp,Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,e:GetHandler(),1,0,0)
end
function cm.op2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and tc:IsFaceup()  and tc:IsRelateToEffect(e) then
		if not Duel.Equip(tp,c,tc) then return end
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_SINGLE)
		e3:SetCode(EFFECT_EQUIP_LIMIT)
		e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e3:SetValue(1)
		c:RegisterEffect(e3)
	end
end
function cm.cval(e,c)
	return e:GetHandlerPlayer()
end
function cm.fit(c)
	return c:IsSetCard(0x9d2)and not c:IsForbidden() and c:IsFaceup()
end
function cm.condition(e,tp,eg,ep,ev,re,r,rp)
	return  e:GetHandler():GetEquipTarget()
end
function cm.tg5(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.fit,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil) and Duel.IsExistingMatchingCard(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,1,e:GetHandler())end  
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,nil,1,0,LOCATION_GRAVE+LOCATION_REMOVED)
end
function cm.op5(e,tp,eg,ep,ev,re,r,rp)
	local ft=Duel.GetLocationCount(tp,LOCATION_SZONE)
	local te=e:GetHandler():GetFirstCardTarget()
	local c=e:GetHandler()
	if ft<=0 or not c:IsRelateToEffect(e) or not te then return end
	if  Duel.IsExistingMatchingCard(aux.NecroValleyFilter(cm.fit),tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil) and Duel.IsExistingMatchingCard(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,1,e:GetHandler()) then
		local sg=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(cm.fit),tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,2,nil)
		local sc=sg:GetFirst()
		while sc do
		local tc=Duel.SelectMatchingCard(tp,Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil):GetFirst()
		Duel.Equip(tp,sc,tc,true,true)   
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_EQUIP_LIMIT)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetValue(cm.eqlimit)
		e1:SetLabelObject(tc)
		sc:RegisterEffect(e1)
			sc=sg:GetNext()
		end
		Duel.EquipComplete()
	end
end
function cm.eqlimit(e,c)
	return e:GetLabelObject()==c
end
function cm.op6(e,tp,eg,ep,ev,re,r,rp)
	local e11=Effect.CreateEffect(e:GetHandler())
		e11:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e11:SetCode(EVENT_PHASE+PHASE_END)
		e11:SetCountLimit(1)
		e11:SetCondition(cm.spcon)
		e11:SetOperation(cm.spop)
		 if Duel.GetCurrentPhase()<=PHASE_END then
		e11:SetReset(RESET_PHASE+PHASE_END)
	else
		e11:SetReset(RESET_PHASE+PHASE_END)
	end
	Duel.RegisterEffect(e11,tp)
end
function cm.spcon(e,tp,eg,ep,ev,re,r,rp)
	return  Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and Duel.IsExistingMatchingCard(aux.NecroValleyFilter(cm.fit),tp,LOCATION_GRAVE,0,1,nil,e) and Duel.IsExistingMatchingCard(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
  if  Duel.IsExistingMatchingCard(aux.NecroValleyFilter(cm.fit),tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil) and Duel.IsExistingMatchingCard(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,1,e:GetHandler()) then
		local tc=Duel.SelectMatchingCard(tp,Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil):GetFirst()
		local sc=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(cm.fit),tp,LOCATION_GRAVE,0,1,1,nil):GetFirst()
		Duel.Equip(tp,sc,tc)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_EQUIP_LIMIT)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetValue(cm.eqlimit)
		e1:SetLabelObject(tc)
		sc:RegisterEffect(e1)
	end
end
function cm.eqlimit(e,c)
	return e:GetLabelObject()==c
end
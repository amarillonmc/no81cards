--破坏剑-心灵破坏之剑
--21.08.26
local m=11451603
local cm=_G["c"..m]
function cm.initial_effect(c)
	--equip
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetRange(LOCATION_HAND+LOCATION_MZONE)
	e1:SetTarget(cm.eqtg)
	e1:SetOperation(cm.eqop)
	c:RegisterEffect(e1)
	--cannot activate
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCode(EFFECT_CANNOT_ACTIVATE)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTargetRange(0,1)
	e2:SetCondition(function(e) return e:GetHandler():GetEquipTarget() end)
	e2:SetValue(cm.aclimit)
	c:RegisterEffect(e2)
	local e4=e2:Clone()
	e4:SetCode(EFFECT_ACTIVATE_COST)
	e4:SetCost(cm.costchk)
	e4:SetTarget(cm.costtg)
	e4:SetOperation(cm.costop)
	--c:RegisterEffect(e4)
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e5:SetCode(EVENT_ADJUST)
	e5:SetRange(LOCATION_SZONE)
	e5:SetCondition(function(e) return e:GetHandler():GetEquipTarget() end)
	e5:SetOperation(cm.regop)
	--c:RegisterEffect(e5)
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_SINGLE)
	e6:SetCode(m)
	e6:SetRange(LOCATION_SZONE)
	e6:SetCondition(function(e) return e:GetHandler():GetEquipTarget() end)
	--c:RegisterEffect(e6)
	--tohand
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_TOHAND)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCost(cm.thcost)
	e3:SetTarget(cm.thtg)
	e3:SetOperation(cm.thop)
	c:RegisterEffect(e3)
end
function cm.filter(c)
	return c:IsFaceup() and c:IsCode(78193831)
end
function cm.eqtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and cm.filter(chkc) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingTarget(cm.filter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	Duel.SelectTarget(tp,cm.filter,tp,LOCATION_MZONE,0,1,1,nil)
end
function cm.eqop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	if c:IsLocation(LOCATION_MZONE) and c:IsFacedown() then return end
	local tc=Duel.GetFirstTarget()
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 or tc:GetControler()~=tp or tc:IsFacedown() or not tc:IsRelateToEffect(e) then
		Duel.SendtoGrave(c,REASON_EFFECT)
		return
	end
	Duel.Equip(tp,c,tc)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_EQUIP_LIMIT)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	e1:SetValue(cm.eqlimit)
	e1:SetLabelObject(tc)
	c:RegisterEffect(e1)
end
function cm.eqlimit(e,c)
	return c==e:GetLabelObject()
end
function cm.desfilter(c,tp,seq)
	return aux.GetColumn(c,tp)==seq
end
function cm.aclimit(e,re,tp)
	local rc,loc,seq=re:GetHandler(),re:GetActivateLocation(),re:GetActivateSequence()
	return loc&LOCATION_ONFIELD>0 and not Duel.IsExistingMatchingCard(cm.desfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,rc,tp,seq)
end
function cm.costchk(e,te,tp)
	if te:GetType()&EFFECT_TYPE_ACTIVATE==0 or te:GetHandler():IsLocation(LOCATION_SZONE) then return true end
	local zone=0
	if te:GetHandler():IsType(TYPE_PENDULUM) then
		for x=0,1 do
			if Duel.IsExistingMatchingCard(cm.desfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil,tp,5*x) and Duel.CheckLocation(tp,LOCATION_PZONE,x) then zone=zone|(1<<(5*x)) end
		end
	else
		for x=0,4 do
			if Duel.IsExistingMatchingCard(cm.desfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil,tp,x) and Duel.CheckLocation(tp,LOCATION_SZONE,x) then zone=zone|(1<<x) end
		end
	end
	return zone>0
end
function cm.costtg(e,te,tp)
	e:SetLabelObject(te)
	return te:GetType()&EFFECT_TYPE_ACTIVATE>0 and not te:GetHandler():IsLocation(LOCATION_SZONE)
end
function cm.costop(e,tp,eg,ep,ev,re,r,rp)
	local te=e:GetLabelObject()
	local zone=0
	if te:GetHandler():IsType(TYPE_PENDULUM) then
		for x=0,1 do
			if Duel.IsExistingMatchingCard(cm.desfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil,tp,5*x) and Duel.CheckLocation(tp,LOCATION_PZONE,x) then zone=zone|(1<<(5*x)) end
		end
		Duel.MoveToField(te:GetHandler(),tp,tp,LOCATION_PZONE,POS_FACEUP,false,zone)
	else
		for x=0,4 do
			if Duel.IsExistingMatchingCard(cm.desfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil,tp,x) and Duel.CheckLocation(tp,LOCATION_SZONE,x) then zone=zone|(1<<x) end
		end
		Duel.MoveToField(te:GetHandler(),tp,tp,LOCATION_SZONE,POS_FACEUP,false,zone)
	end
end
function cm.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():GetEquipTarget() and e:GetHandler():IsAbleToGraveAsCost() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST)
end
function cm.thfilter(c)
	return c:IsSetCard(0xd6) and c:IsAbleToHand() and c:IsFaceup()
end
function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_REMOVED) and cm.thfilter(chkc,e,tp) end
	if chk==0 then return Duel.IsExistingTarget(cm.thfilter,tp,LOCATION_REMOVED,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=Duel.SelectTarget(tp,cm.thfilter,tp,LOCATION_REMOVED,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function cm.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc)
	end
end
function cm.zones(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsLocation(LOCATION_SZONE) or not Duel.IsExistingMatchingCard(Card.IsHasEffect,tp,0,LOCATION_SZONE,1,nil,m) then return 0xff end
	local zone=0
	if te:GetHandler():IsType(TYPE_PENDULUM) then
		for x=0,1 do
			if Duel.IsExistingMatchingCard(cm.desfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil,tp,5*x) and Duel.CheckLocation(tp,LOCATION_PZONE,x) then zone=zone|(1<<(5*x)) end
		end
	else
		for x=0,4 do
			if Duel.IsExistingMatchingCard(cm.desfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil,tp,x) and Duel.CheckLocation(tp,LOCATION_SZONE,x) then zone=zone|(1<<x) end
		end
	end
	return zone
end
function cm.regop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetFieldGroup(tp,0xff,0xff)
	for tc in aux.Next(g) do
		local eset={tc:GetActivateEffect()}
		for _,te in pairs(eset) do
			local prop1,prop2=te:GetProperty()
			prop1=prop1|EFFECT_FLAG_LIMIT_ZONE
			te:SetProperty(prop1,prop2)
			local val=te:GetValue()
			if not val or val==0 then
				te:SetValue(cm.zones)
			else
				local f=function(e,tp,eg,ep,ev,re,r,rp)
							local zones1=0
							if aux.GetValueType(val)=="Number" then
								zones1=val
							else
								zones1=val(e,tp,eg,ep,ev,re,r,rp)
							end
							local zones2=cm.zones(e,tp,eg,ep,ev,re,r,rp)
							return zones1&zones2
						end
				te:SetValue(f)
			end
		end
	end
end
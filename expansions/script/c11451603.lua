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
	e2:SetTargetRange(1,1)
	e2:SetCondition(function(e) return e:GetHandler():GetEquipTarget() end)
	e2:SetValue(cm.aclimit)
	c:RegisterEffect(e2)
	local e4=e2:Clone()
	e4:SetCode(EFFECT_ACTIVATE_COST)
	e4:SetCost(cm.costchk)
	e4:SetTarget(cm.costtg)
	e4:SetOperation(cm.costop)
	--c:RegisterEffect(e4)
	--spsummon
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCost(cm.spcost)
	e3:SetTarget(cm.sptg)
	e3:SetOperation(cm.spop)
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
function cm.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():GetEquipTarget() and e:GetHandler():IsAbleToGraveAsCost() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST)
end
function cm.spfilter(c,e,tp)
	return c:IsSetCard(0xd7) and c:IsType(TYPE_MONSTER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_REMOVED) and cm.spfilter(chkc,e,tp) end
	if chk==0 then return Duel.IsExistingTarget(cm.spfilter,tp,LOCATION_REMOVED,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,cm.spfilter,tp,LOCATION_REMOVED,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP) end
end
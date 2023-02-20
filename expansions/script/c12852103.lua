--转天魔具-彩虹
function c12852103.initial_effect(c)
	aux.AddCodeList(c,12852102)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_CONTINUOUS_TARGET)
	e1:SetTarget(c12852103.target)
	e1:SetOperation(c12852103.operation)
	c:RegisterEffect(e1)
	--Atk up
	local e21=Effect.CreateEffect(c)
	e21:SetType(EFFECT_TYPE_EQUIP)
	e21:SetCode(EFFECT_UPDATE_ATTACK)
	e21:SetCondition(c12852103.atkcon)
	e21:SetValue(2500)
	c:RegisterEffect(e21)
	--Equip limit
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_EQUIP_LIMIT)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e3:SetValue(c12852103.eqlimit)
	c:RegisterEffect(e3)	
	--att change
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(72819261,1))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTarget(c12852103.atttg)
	e2:SetOperation(c12852103.attop)
	c:RegisterEffect(e2)
	--Activate
	local e12=Effect.CreateEffect(c)
	e12:SetCategory(CATEGORY_DISABLE+CATEGORY_DESTROY)
	e12:SetType(EFFECT_TYPE_QUICK_O)
	e12:SetCode(EVENT_CHAINING)
	e12:SetRange(LOCATION_SZONE)
	e12:SetCountLimit(1,12852105)
	e12:SetCondition(c12852103.condition)
	e12:SetTarget(c12852103.target1)
	e12:SetOperation(c12852103.activate1)
	c:RegisterEffect(e12)
end
function c12852103.atkcon(e)
	return Duel.IsExistingMatchingCard(Card.IsCode,e:GetHandlerPlayer(),LOCATION_ONFIELD,0,1,nil,12852102)
end
function c12852103.eqlimit(e,c)
	return c:IsRace(RACE_SPELLCASTER)
end
function c12852103.filter(c)
	return c:IsFaceup() and c:IsRace(RACE_SPELLCASTER)
end
function c12852103.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c12852103.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c12852103.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	Duel.SelectTarget(tp,c12852103.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,e:GetHandler(),1,0,0)
end
function c12852103.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if e:GetHandler():IsRelateToEffect(e) and tc:IsRelateToEffect(e) and tc:IsFaceup() then
		Duel.Equip(tp,e:GetHandler(),tc)
	end
end
function c12852103.atttg(e,tp,eg,ep,ev,re,r,rp,chk)
	local attribute=ATTRIBUTE_ALL
	local c=e:GetHandler()
	local tc=c:GetEquipTarget()
	local att=tc:GetAttribute()
	if Duel.GetFlagEffect(tp,12852100)~=0 and not tc:IsAttribute(ATTRIBUTE_DARK)  then
		attribute=attribute-ATTRIBUTE_DARK
	end
	if Duel.GetFlagEffect(tp,12852101)~=0 and not tc:IsAttribute(ATTRIBUTE_DIVINE)  then
		attribute=attribute-ATTRIBUTE_DIVINE
	end
	if Duel.GetFlagEffect(tp,12852102)~=0 and not tc:IsAttribute(ATTRIBUTE_EARTH)  then
		attribute=attribute-ATTRIBUTE_EARTH
	end
	if Duel.GetFlagEffect(tp,12852103)~=0 and not tc:IsAttribute(ATTRIBUTE_FIRE)  then
		attribute=attribute-ATTRIBUTE_FIRE
	end
	if Duel.GetFlagEffect(tp,12852104)~=0 and not tc:IsAttribute(ATTRIBUTE_LIGHT)  then
		attribute=attribute-ATTRIBUTE_LIGHT
	end
	if Duel.GetFlagEffect(tp,12852105)~=0 and not tc:IsAttribute(ATTRIBUTE_WATER)  then
		attribute=attribute-ATTRIBUTE_WATER
	end
	if Duel.GetFlagEffect(tp,12852106)~=0 and not tc:IsAttribute(ATTRIBUTE_WIND)  then
		attribute=attribute-ATTRIBUTE_WIND
	end
	if chk==0 then return attribute-att~=0 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATTRIBUTE)
	local att1=Duel.AnnounceAttribute(tp,1,attribute-att)
	e:SetLabel(att1)
end
function c12852103.attop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetLabel()==ATTRIBUTE_DARK then
		Duel.RegisterFlagEffect(tp,12852100,RESET_PHASE+PHASE_END,0,1)
	elseif e:GetLabel()==ATTRIBUTE_DIVINE then
		Duel.RegisterFlagEffect(tp,12852101,RESET_PHASE+PHASE_END,0,1)
	elseif e:GetLabel()==ATTRIBUTE_EARTH then
		Duel.RegisterFlagEffect(tp,12852102,RESET_PHASE+PHASE_END,0,1)
	elseif e:GetLabel()==ATTRIBUTE_FIRE then
		Duel.RegisterFlagEffect(tp,12852103,RESET_PHASE+PHASE_END,0,1)
	elseif e:GetLabel()==ATTRIBUTE_LIGHT then
		Duel.RegisterFlagEffect(tp,12852104,RESET_PHASE+PHASE_END,0,1)
	elseif e:GetLabel()==ATTRIBUTE_WATER then
		Duel.RegisterFlagEffect(tp,12852105,RESET_PHASE+PHASE_END,0,1)
	else
		Duel.RegisterFlagEffect(tp,12852106,RESET_PHASE+PHASE_END,0,1)
	end
	local c=e:GetHandler()
	local tc=c:GetEquipTarget()
	if c:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_ATTRIBUTE)
		e1:SetValue(e:GetLabel())
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
	end
end
function c12852103.condition(e,tp,eg,ep,ev,re,r,rp)
	local tgp,loc=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_CONTROLER,CHAININFO_TRIGGERING_LOCATION)
	local tc=re:GetHandler()
	local ta=e:GetHandler():GetEquipTarget():GetAttribute()
	return loc==LOCATION_MZONE and Duel.IsChainDisablable(ev) and tc:IsAttribute(ta)
end
function c12852103.target1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function c12852103.activate1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Destroy(e:GetHandler(),REASON_EFFECT)
	if Duel.NegateEffect(ev) and re:GetHandler():IsRelateToEffect(re) then
		Duel.Destroy(eg,REASON_EFFECT)
	end
end
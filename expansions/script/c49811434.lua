--龟蟹流拳-强击霸王拳
function c49811434.initial_effect(c)
	--equip limit
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_EQUIP_LIMIT)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e0:SetValue(c49811434.eqlimit)
	c:RegisterEffect(e0)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_CONTINUOUS_TARGET)
	e1:SetTarget(c49811434.target)
	e1:SetOperation(c49811434.activate)
	c:RegisterEffect(e1)
	--Equip from extra
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_EQUIP)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1,49811434)
	e2:SetCost(c49811434.eqcost)
	e2:SetTarget(c49811434.eqtg)
	e2:SetOperation(c49811434.eqop)
	c:RegisterEffect(e2)
	--Equip from deck
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(49811434,1))
	e3:SetCategory(CATEGORY_EQUIP+CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_DESTROYED)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCountLimit(1,49811434)
	e3:SetCondition(c49811434.eqcon2)
	e3:SetTarget(c49811434.eqtg2)
	e3:SetOperation(c49811434.eqop2)
	c:RegisterEffect(e3)
end
function c49811434.eqlimit(e,c)
	return c:IsAttribute(ATTRIBUTE_WATER)
end
function c49811434.filter(c)
	return c:IsAttribute(ATTRIBUTE_WATER) and c:IsFaceup()
end
function c49811434.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c49811434.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c49811434.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	Duel.SelectTarget(tp,c49811434.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,e:GetHandler(),1,0,0)
end
function c49811434.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if e:GetHandler():IsRelateToEffect(e) and tc:IsRelateToEffect(e) and tc:IsFaceup() then
		Duel.Equip(tp,e:GetHandler(),tc)
	end
end
function c49811434.eqcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToGraveAsCost() end
	e:SetLabelObject(c:GetEquipTarget())
	Duel.SetTargetCard(c:GetEquipTarget())
	Duel.SendtoGrave(c,REASON_COST)
end
function c49811434.eqfilter(c,tp)
	return c:IsAttribute(ATTRIBUTE_WATER) and c:CheckUniqueOnField(tp,LOCATION_SZONE) and not c:IsForbidden()
end
function c49811434.eqtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>=1
		and Duel.IsExistingMatchingCard(c49811434.eqfilter,tp,LOCATION_EXTRA,0,2,nil,tp) end
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,e:GetLabelObject(),1,0,0)
end
function c49811434.eqop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<2 or tc:IsFacedown() or not tc:IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local g=Duel.SelectMatchingCard(tp,c49811434.eqfilter,tp,LOCATION_EXTRA,0,2,2,nil,tp)
	if #g~=2 then return end
	for ec in aux.Next(g) do
		Duel.Equip(tp,ec,tc,true,true)
		--equip limit
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_EQUIP_LIMIT)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetLabelObject(tc)
		e1:SetValue(c49811434.eqlimit2)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		ec:RegisterEffect(e1)
		--atk up
		local e2=Effect.CreateEffect(ec)
		e2:SetType(EFFECT_TYPE_EQUIP)
		e2:SetCode(EFFECT_UPDATE_ATTACK)
		e2:SetValue(400)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		ec:RegisterEffect(e2)
		--def down
		local e3=e2:Clone()
		e3:SetCode(EFFECT_UPDATE_DEFENSE)
		e3:SetValue(-200)
		ec:RegisterEffect(e3)
	end
	Duel.EquipComplete()
end
function c49811434.eqlimit2(e,c)
	return c==e:GetLabelObject()
end
function c49811434.eqcon2(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(Card.IsPreviousLocation,1,nil,LOCATION_ONFIELD) and not eg:IsContains(e:GetHandler())
end
function c49811434.eqfilter2(c,tp)
	return c:IsCode(2370081) and c:CheckUniqueOnField(tp) and not c:IsForbidden()
		and Duel.IsExistingMatchingCard(c49811434.eqtgfilter,tp,LOCATION_MZONE,0,1,nil,c)
end
function c49811434.eqtgfilter(c,ec)
	return c:IsAttribute(ATTRIBUTE_WATER) and c:IsType(TYPE_RITUAL) and c:IsFaceup() and ec:CheckEquipTarget(c)
end
function c49811434.eqtg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)>0
		and Duel.IsExistingMatchingCard(c49811434.eqfilter2,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil,tp) end
end
function c49811434.eqop2(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_SZONE)>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
		local ec=Duel.SelectMatchingCard(tp,c49811434.eqfilter2,tp,LOCATION_HAND+LOCATION_DECK,0,1,1,nil,tp):GetFirst()
		if ec then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
			local tc=Duel.SelectMatchingCard(tp,c49811434.eqtgfilter,tp,LOCATION_MZONE,0,1,1,nil,ec):GetFirst()
			Duel.Equip(tp,ec,tc)
			local g=Duel.GetFieldGroup(tp,0,LOCATION_HAND,nil)
			if g:GetCount()==0 then return end
			Duel.BreakEffect()
			local sg=g:RandomSelect(1-tp,1)
			Duel.Destroy(sg,REASON_EFFECT)
		end
	end
end

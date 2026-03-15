--未被遗忘的约定×天星
function c43480065.initial_effect(c)
	--pl 
	local e1=Effect.CreateEffect(c) 
	e1:SetType(EFFECT_TYPE_ACTIVATE) 
	e1:SetCode(EVENT_FREE_CHAIN) 
	e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_LIMIT_ZONE) 
	e1:SetCountLimit(1,43480065) 
	e1:SetCost(c43480065.plcost)
	e1:SetTarget(c43480065.pltg)
	e1:SetOperation(c43480065.plop) 
	e1:SetValue(c43480065.zones)
	c:RegisterEffect(e1)
	--equip 
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_EQUIP)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_GRAVE) 
	e2:SetCountLimit(1,43480066)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c43480065.eqtg)
	e2:SetOperation(c43480065.eqop)
	c:RegisterEffect(e2)
end
function c43480065.zones(e,tp,eg,ep,ev,re,r,rp)
	local zone=0xff
	local p0=Duel.CheckLocation(tp,LOCATION_PZONE,0)
	local p1=Duel.CheckLocation(tp,LOCATION_PZONE,1)
	if not p0 or not p1 then zone=zone-0x11 end
	return zone
end
function c43480065.pctfil(c,e,tp) 
	return c:IsAbleToGraveAsCost() and c:IsSetCard(0x3f13) and c:IsType(TYPE_MONSTER) and Duel.IsExistingMatchingCard(c43480065.plfilter,tp,LOCATION_DECK,0,1,nil)
end 
function c43480065.plcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c43480065.pctfil,tp,LOCATION_DECK,0,1,nil,e,tp) end 
	local g=Duel.SelectMatchingCard(tp,c43480065.pctfil,tp,LOCATION_DECK,0,1,1,nil,e,tp) 
	Duel.SendtoGrave(g,REASON_COST)
end 
function c43480065.plfilter(c)
	return c:IsSetCard(0x3f13) and c:IsType(TYPE_PENDULUM) and not c:IsForbidden()
end
function c43480065.pltg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c43480065.plfilter,tp,LOCATION_DECK,0,1,nil) and (Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1)) end
end
function c43480065.plop(e,tp,eg,ep,ev,re,r,rp) 
	if not (Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1)) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local g=Duel.SelectMatchingCard(tp,c43480065.plfilter,tp,LOCATION_DECK,0,1,1,nil)
	local tc=g:GetFirst()
	if tc then
		Duel.MoveToField(tc,tp,tp,LOCATION_PZONE,POS_FACEUP,true) 
	end
end
function c43480065.eqfilter(c,tp)
	return c:IsFaceup() and c:IsCode(4348030) and Duel.IsExistingMatchingCard(c43480065.eqeqfilter,tp,LOCATION_DECK,0,1,nil,c,tp)
end
function c43480065.eqeqfilter(c,tc,tp)
	return c:IsType(TYPE_PENDULUM) and c:IsSetCard(0x3f13) and c:CheckUniqueOnField(tp) and not c:IsForbidden()
end
function c43480065.eqtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c43480065.eqfilter(chkc,tp) end 
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and Duel.IsExistingTarget(c43480065.eqfilter,tp,LOCATION_MZONE,0,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c43480065.eqfilter,tp,LOCATION_MZONE,0,1,1,nil,tp)
end
function c43480065.eqop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() and tc:IsControler(tp) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
		local ec=Duel.SelectMatchingCard(tp,c43480065.eqeqfilter,tp,LOCATION_DECK,0,1,1,nil,tc,tp):GetFirst()
		if ec then
			Duel.Equip(tp,ec,tc) 
			--equip limit
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_EQUIP_LIMIT)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE) 
			e1:SetLabelObject(tc)
			e1:SetValue(function(e,c)
			return c==e:GetLabelObject() end)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			ec:RegisterEffect(e1) 
		end
	end
end







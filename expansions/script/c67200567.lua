--巧壳精 艾露法蒂西亚
function c67200567.initial_effect(c)
	--set pendulum
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(67200567,0))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,67200567)
	e1:SetCost(c67200567.setcost)
	e1:SetTarget(c67200567.settg)
	e1:SetOperation(c67200567.setop)
	c:RegisterEffect(e1)
	--equip 
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(67200567,1))
	e4:SetCategory(CATEGORY_EQUIP)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetRange(LOCATION_GRAVE)
	e4:SetCountLimit(1,67200567)
	e4:SetCost(aux.bfgcost)
	e4:SetTarget(c67200567.eqtg)
	e4:SetOperation(c67200567.eqop)
	c:RegisterEffect(e4)	
end
function c67200567.costfilter(c)
	return c:IsRace(RACE_MACHINE) and c:IsAbleToGraveAsCost()
end
function c67200567.setcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToGraveAsCost() and
		Duel.IsExistingMatchingCard(c67200567.costfilter,tp,LOCATION_HAND,0,1,c) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c67200567.costfilter,tp,LOCATION_HAND,0,1,1,c)
	g:AddCard(c)
	Duel.SendtoGrave(g,REASON_COST)
end
function c67200567.setfilter1(c,tp)
	return c:IsSetCard(0x676) and c:IsType(TYPE_PENDULUM) and not c:IsForbidden()
		and Duel.IsExistingMatchingCard(c67200567.setfilter2,tp,LOCATION_DECK,0,1,nil,c:GetCode(),c:GetLeftScale(),c:GetRightScale())
end
function c67200567.setfilter2(c,code,lse,rse)
	return c:IsSetCard(0x676) and not c:IsCode(code) and c:IsType(TYPE_PENDULUM) and c:GetLeftScale()==lse and c:GetRightScale()==rse and not c:IsForbidden()
end
function c67200567.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLocation(tp,LOCATION_PZONE,0) and Duel.CheckLocation(tp,LOCATION_PZONE,1)
		and Duel.IsExistingMatchingCard(c67200567.setfilter1,tp,LOCATION_DECK,0,1,nil,tp) end
end
function c67200567.setop(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.CheckLocation(tp,LOCATION_PZONE,0) or not Duel.CheckLocation(tp,LOCATION_PZONE,1) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local g1=Duel.SelectMatchingCard(tp,c67200567.setfilter1,tp,LOCATION_DECK,0,1,1,nil,tp)
	local tc1=g1:GetFirst()
	if not tc1 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local g2=Duel.SelectMatchingCard(tp,c67200567.setfilter2,tp,LOCATION_DECK,0,1,1,nil,tc1:GetCode(),tc1:GetLeftScale(),tc1:GetRightScale())
	local tc2=g2:GetFirst()
	if Duel.MoveToField(tc1,tp,tp,LOCATION_PZONE,POS_FACEUP,true) then
		Duel.MoveToField(tc2,tp,tp,LOCATION_PZONE,POS_FACEUP,true) 
	end
end
--
function c67200567.tgfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x676)
end
function c67200567.eqfilter(c)
	return c:IsSetCard(0x676) and c:IsType(TYPE_PENDULUM) and not c:IsForbidden()
end
function c67200567.eqtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c67200567.tgfilter(chkc) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingTarget(c67200567.tgfilter,tp,LOCATION_MZONE,0,1,nil)
		and Duel.IsExistingMatchingCard(c67200567.eqfilter,tp,LOCATION_EXTRA+LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
	Duel.SelectTarget(tp,c67200567.tgfilter,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,nil,1,tp,LOCATION_EXTRA+LOCATION_GRAVE)
end
function c67200567.eqop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
		local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c67200567.eqfilter),tp,LOCATION_EXTRA+LOCATION_GRAVE,0,1,1,nil)
		local ec=g:GetFirst()
		if ec then
			if not Duel.Equip(tp,ec,tc) then return end
			--equip limit
			local e4=Effect.CreateEffect(e:GetHandler())
			e4:SetType(EFFECT_TYPE_SINGLE)
			e4:SetCode(EFFECT_EQUIP_LIMIT)
			e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e4:SetLabelObject(tc)
			e4:SetValue(c67200567.eqlimit)
			e4:SetReset(RESET_EVENT+RESETS_STANDARD)
			ec:RegisterEffect(e4)
		end
	end
end
function c67200567.eqlimit(e,c)
	return c==e:GetLabelObject()
end


--海造贼-强敌
function c44227728.initial_effect(c)
	aux.AddRitualProcGreater2(c,c44227728.ritual_filter)
	--equip
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(44227728,1))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_GRAVE)
	e1:SetCountLimit(1,44227728)
	e1:SetCost(aux.bfgcost)
	e1:SetTarget(c44227728.eqtg)
	e1:SetOperation(c44227728.eqop)
	c:RegisterEffect(e1)
end
function c44227728.ritual_filter(c)
	return c:IsType(TYPE_RITUAL) and c:IsRace(RACE_FIEND)
end
function c44227728.eqfilter(c,ec,tp)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x13f) and not c:IsForbidden() and c:CheckUniqueOnField(tp,LOCATION_SZONE)
end
function c44227728.cfilter(c,tp)
	return c:IsFaceup() and c:IsSetCard(0x13f) and Duel.IsExistingMatchingCard(c44227728.eqfilter,tp,LOCATION_DECK+LOCATION_EXTRA,0,1,nil,c,tp)
end
function c44227728.eqtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c44227728.cfilter(chkc,tp) end
	if chk==0 then return Duel.IsExistingTarget(c44227728.cfilter,tp,LOCATION_MZONE,0,1,nil,tp)
		and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c44227728.cfilter,tp,LOCATION_MZONE,0,1,1,nil,tp)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function c44227728.eqop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<1 then return end
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
		local g=Duel.SelectMatchingCard(tp,c44227728.eqfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,tc,tp)
		local sc=g:GetFirst()
		if not sc then return end
		if not Duel.Equip(tp,sc,tc) then return end
		--equip limit
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCode(EFFECT_EQUIP_LIMIT)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetLabelObject(tc)
		e1:SetValue(c44227728.eqlimit)
		sc:RegisterEffect(e1)
	end
end
function c44227728.eqlimit(e,c)
	return c==e:GetLabelObject()
end
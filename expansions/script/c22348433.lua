--拉特金修女
function c22348433.initial_effect(c)
	--equip
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(22348433,0))
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,22349433)
	e1:SetTarget(c22348433.eqtg)
	e1:SetOperation(c22348433.eqop)
	c:RegisterEffect(e1)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(22348433,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,22349433)
	e2:SetTarget(c22348433.sptg)
	e2:SetOperation(c22348433.spop)
	c:RegisterEffect(e2)
	--equip 2
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(22348433,2))
	e3:SetCategory(CATEGORY_EQUIP)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,22348433)
	e3:SetCost(c22348433.cost)
	e3:SetTarget(c22348433.eqtg2)
	e3:SetOperation(c22348433.eqop2)
	c:RegisterEffect(e3)
end
c22348433.has_text_type=TYPE_UNION
function c22348433.eqfilter(c)
	return c:IsSetCard(0x970b) and c:IsType(TYPE_MONSTER) and not c:IsForbidden()
end
function c22348433.eqtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and Duel.IsExistingMatchingCard(c22348433.eqfilter,tp,LOCATION_HAND+LOCATION_MZONE+LOCATION_GRAVE,0,1,c) end
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,nil,1,tp,LOCATION_HAND+LOCATION_MZONE+LOCATION_GRAVE)
end
function c22348433.eqop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsFaceup() and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
		local ec=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c22348433.eqfilter),tp,LOCATION_HAND+LOCATION_MZONE+LOCATION_GRAVE,0,1,1,c):GetFirst()
		if ec and Duel.Equip(tp,ec,c) then
		--equip limit
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_EQUIP_LIMIT)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetLabelObject(c)
		e1:SetValue(c22348433.eeqlimit)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		ec:RegisterEffect(e1)
		end
	end
end
function c22348433.eeqlimit(e,c)
	return c==e:GetLabelObject()
end
function c22348433.spfilter(c,e,tp,ec)
	return c:IsSetCard(0x970b) and c:GetEquipTarget()==ec and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c22348433.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetMZoneCount(tp)>0
		and Duel.IsExistingMatchingCard(c22348433.spfilter,tp,LOCATION_SZONE,0,1,nil,e,tp,e:GetHandler()) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_SZONE)
end
function c22348433.spop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c22348433.spfilter,tp,LOCATION_SZONE,0,1,1,nil,e,tp,e:GetHandler())
	if #g>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c22348433.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(1)
	if chk==0 then return true end
end
function c22348433.costfilter(c,tp)
	return c:IsAbleToGraveAsCost() and c:IsType(TYPE_EQUIP) and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and Duel.IsExistingTarget(c22348433.tgfilter,tp,LOCATION_MZONE,0,1,nil,tp,c:GetCode())
end
function c22348433.tgfilter(c,tp,code)
	return Duel.IsExistingMatchingCard(c22348433.cfilter,tp,LOCATION_DECK,0,1,nil,c,tp,code) and c:IsFaceup() and c:IsRace(RACE_BEAST+RACE_BEASTWARRIOR)
end
function c22348433.cfilter(c,ec,tp,code)
	return c:IsType(TYPE_UNION) and c:IsSetCard(0x970b) and c:CheckUniqueOnField(tp) and not c:IsForbidden() and c:CheckUnionTarget(ec) and aux.CheckUnionEquip(c,ec) and not c:IsCode(code)
end
function c22348433.eqtg2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then
		if e:GetLabel()==0 then return false end
		e:SetLabel(0)
		return Duel.IsExistingMatchingCard(c22348433.costfilter,tp,LOCATION_SZONE,0,1,nil,tp) end
	e:SetLabel(0)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local cc=Duel.SelectMatchingCard(tp,c22348433.costfilter,tp,LOCATION_SZONE,0,1,1,nil,tp):GetFirst()
	Duel.SendtoGrave(cc,REASON_COST)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local g=Duel.SelectTarget(tp,c22348433.tgfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil,tp,cc:GetCode())
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,g,1,0,0)
	e:SetLabelObject(cc)
end
function c22348433.eqop2(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	local cc=e:GetLabelObject()
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 or tc:IsFacedown() or not tc:IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local ec=Duel.SelectMatchingCard(tp,c22348433.cfilter,tp,LOCATION_DECK,0,1,1,nil,tc,tp,cc:GetCode()):GetFirst()
	if ec and Duel.Equip(tp,ec,tc) then
		aux.SetUnionState(ec)
	end
end

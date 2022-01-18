--同盟探索者
function c188811.initial_effect(c)
	aux.EnableUnionAttribute(c,c188811.eqlimit)
	--equip
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(188811,0))
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTarget(c188811.eqtg)
	e1:SetOperation(c188811.eqop)
	c:RegisterEffect(e1)
	--unequip
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(188811,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTarget(c188811.sptg)
	e2:SetOperation(c188811.spop)
	c:RegisterEffect(e2)  
	--negate
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_DISABLE)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_CHAIN_SOLVING)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCondition(c188811.negcon)
	e3:SetOperation(c188811.negop)
	c:RegisterEffect(e3)  
	--
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_EQUIP)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O) 
	e4:SetCode(EVENT_TO_GRAVE)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetCountLimit(1,188811)
	e4:SetTarget(c188811.xeqtg)
	e4:SetOperation(c188811.xeqop)
	c:RegisterEffect(e4)
end
function c188811.eqlimit(e,c)
	return (c:IsRace(RACE_MACHINE) and c:IsAttribute(ATTRIBUTE_LIGHT)) or e:GetHandler():GetEquipTarget()==c
end
function c188811.filter(c)
	local ct1,ct2=c:GetUnionCount()
	return c:IsFaceup() and c:IsRace(RACE_MACHINE) and c:IsAttribute(ATTRIBUTE_WATER) and ct2==0
end
function c188811.eqtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c188811.filter(chkc) end
	if chk==0 then return e:GetHandler():GetFlagEffect(188811)==0 and Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingTarget(c188811.filter,tp,LOCATION_MZONE,0,1,c) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local g=Duel.SelectTarget(tp,c188811.filter,tp,LOCATION_MZONE,0,1,1,c)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,g,1,0,0)
	c:RegisterFlagEffect(188811,RESET_EVENT+0x7e0000+RESET_PHASE+PHASE_END,0,1)
end
function c188811.eqop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if not c:IsRelateToEffect(e) or c:IsFacedown() then return end
	if not tc:IsRelateToEffect(e) or not c188811.filter(tc) then
		Duel.SendtoGrave(c,REASON_EFFECT)
		return
	end
	if not Duel.Equip(tp,c,tc,false) then return end
	aux.SetUnionState(c)
end
function c188811.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:GetFlagEffect(188811)==0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,true,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
	c:RegisterFlagEffect(188811,RESET_EVENT+0x7e0000+RESET_PHASE+PHASE_END,0,1)
end
function c188811.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	Duel.SpecialSummon(c,0,tp,tp,true,false,POS_FACEUP)
end
function c188811.tfilter(c,e,tp)
	return c==e:GetHandler():GetEquipTarget()
end
function c188811.negcon(e,tp,eg,ep,ev,re,r,rp)
	if not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return false end
	local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	return g and g:IsExists(c188811.tfilter,1,nil,e,tp) and Duel.IsChainDisablable(ev) and e:GetHandler():IsDestructable()
end
function c188811.negop(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	if Duel.SelectYesNo(tp,aux.Stringid(188811,0)) then
		Duel.Hint(HINT_CARD,0,188811)
		if Duel.Destroy(e:GetHandler(),REASON_EFFECT) then
		Duel.NegateEffect(ev)
		end
	end
end
function c188811.unfil1(c,tp)
	return c:IsType(TYPE_UNION) and Duel.IsExistingMatchingCard(c188811.unfil2,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil,tp,c)
end
function c188811.unfil2(c,tp,tc)
	return aux.CheckUnionEquip(c,tc) and c:CheckUnionTarget(tc) and c:IsType(TYPE_UNION) and c:CheckUniqueOnField(tp) and not c:IsForbidden()
end
function c188811.xeqtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingTarget(c188811.unfil1,tp,LOCATION_MZONE,0,1,nil,tp) end
	local tc=Duel.SelectTarget(tp,c188811.unfil1,tp,LOCATION_MZONE,0,1,1,nil,tp)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,tc,1,0,0)	 
end
function c188811.xeqop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
		local g=Duel.SelectMatchingCard(tp,c188811.unfil2,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil,tp,tc)
		local ec=g:GetFirst()
		if ec and aux.CheckUnionEquip(ec,tc) and Duel.Equip(tp,ec,tc) then
			aux.SetUnionState(ec)
		end
	end
end






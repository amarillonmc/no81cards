--甲虫装机 吉咖沙螽
function c98920357.initial_effect(c)
	--equip
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(98920357,0))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetRange(LOCATION_HAND)
	e1:SetTarget(c98920357.eqtg)
	e1:SetOperation(c98920357.eqop)
	c:RegisterEffect(e1)
	--equip effect
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_EQUIP)
	e2:SetCode(EFFECT_SET_BASE_ATTACK)
	e2:SetValue(2200)
	c:RegisterEffect(e2)
	--special summon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(98920357,1))
	e3:SetCategory(CATEGORY_EQUIP)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetCountLimit(1,98920357)
	e3:SetCondition(c98920357.spcon)
	e3:SetTarget(c98920357.sptg)
	e3:SetOperation(c98920357.spop)
	c:RegisterEffect(e3)
end
function c98920357.filter(c)
	return c:IsFaceup() and c:IsSetCard(0x56)
end
function c98920357.eqtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c98920357.filter(chkc) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingTarget(c98920357.filter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	Duel.SelectTarget(tp,c98920357.filter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c98920357.eqop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local tc=Duel.GetFirstTarget()
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 or tc:IsFacedown() or not tc:IsRelateToEffect(e) or not tc:IsControler(tp) then
		Duel.SendtoGrave(c,REASON_EFFECT)
		return
	end
	Duel.Equip(tp,c,tc)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_EQUIP_LIMIT)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	e1:SetValue(c98920357.eqlimit)
	e1:SetLabelObject(tc)
	c:RegisterEffect(e1)
end
function c98920357.eqlimit(e,c)
	return c==e:GetLabelObject()
end
function c98920357.spcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousLocation(LOCATION_SZONE) and c:GetPreviousEquipTarget() and not c:IsReason(REASON_LOST_TARGET)
end
function c98920357.spfilter(c,e,tp)
	return c:IsSetCard(0x56) and not c:IsCode(98920357) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c98920357.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and c98920357.filter(chkc) and chkc~=c end
	if chk==0 then return Duel.IsExistingTarget(c98920357.filter,tp,LOCATION_MZONE,0,1,c)
		and Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingMatchingCard(c98920357.eqfilter,tp,LOCATION_DECK,0,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c98920357.filter,tp,LOCATION_MZONE,0,1,1,c)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,nil,1,tp,LOCATION_DECK)
end
function c98920357.filter(c)
	return c:IsFaceup() and c:IsSetCard(0x56) and c:IsType(TYPE_MONSTER)
end
function c98920357.eqfilter(c,tp)
	return c:IsSetCard(0x56) and c:CheckUniqueOnField(tp) and c:IsType(TYPE_MONSTER) and not c:IsForbidden()
end
function c98920357.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsFacedown() or not tc:IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local ec=Duel.SelectMatchingCard(tp,c98920357.eqfilter,tp,LOCATION_DECK,0,1,1,nil,tp):GetFirst()
	if ec then
		Duel.Equip(tp,ec,tc)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_EQUIP_LIMIT)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetValue(c98920357.eqlimit)
		e1:SetLabelObject(tc)
		ec:RegisterEffect(e1)
	end
end
function c98920357.eqlimit(e,c)
	return c==e:GetLabelObject()
end
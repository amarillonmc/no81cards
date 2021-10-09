--英灵剑豪七番胜负·二盖笠
function c9950367.initial_effect(c)
	   --Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(9950367,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(c9950367.condition)
	e1:SetTarget(c9950367.target)
	e1:SetOperation(c9950367.operation)
	c:RegisterEffect(e1)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(9950367,1))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c9950367.target2)
	e1:SetOperation(c9950367.operation2)
	c:RegisterEffect(e1)
--destroy
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(9950367,0))
	e4:SetCategory(CATEGORY_DESTROY)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCountLimit(1)
	e4:SetTarget(c9950367.destg)
	e4:SetOperation(c9950367.desop)
	c:RegisterEffect(e4)
   --Equip limit
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_EQUIP_LIMIT)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e3:SetValue(c9950367.eqlimit)
	c:RegisterEffect(e3)
	--Equip limit
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_EQUIP_LIMIT)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e3:SetValue(1)
	c:RegisterEffect(e3)
	--equip
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(9950367,1))
	e5:SetCategory(CATEGORY_EQUIP)
	e5:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e5:SetCode(EVENT_TO_GRAVE)
	e5:SetCountLimit(1,9950367)
	e5:SetCondition(c9950367.eqcon)
	e5:SetTarget(c9950367.eqtg)
	e5:SetOperation(c9950367.eqop)
	c:RegisterEffect(e5)
end
function c9950367.condition(e,tp,eg,ep,ev,re,r,rp)
   return not Duel.IsExistingMatchingCard(Card.IsType,tp,LOCATION_GRAVE,0,1,nil,TYPE_MONSTER)
end
function c9950367.spfilter(c,e,tp)
	return c:IsCode(9950366) and c:IsCanBeSpecialSummoned(e,0,tp,true,false)
end
function c9950367.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c9950367.spfilter,tp,LOCATION_DECK+LOCATION_HAND,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK+LOCATION_HAND)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,e:GetHandler(),1,0,0)
end
function c9950367.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCountFromEx(tp)<=0 then return end
	local g=Duel.SelectMatchingCard(tp,c9950367.spfilter,tp,LOCATION_DECK+LOCATION_HAND,0,1,1,nil,e,tp)
	local tc=g:GetFirst()
	if c:IsRelateToEffect(e) and g:GetCount()>0 then
		if not Duel.SpecialSummonStep(tc,0,tp,tp,true,false,POS_FACEUP) then return end
		Duel.Equip(tp,c,tc)
		--Add Equip limit
		local e1=Effect.CreateEffect(tc)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_EQUIP_LIMIT)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetValue(c9950367.eqlimit)
		c:RegisterEffect(e1)
		Duel.SpecialSummonComplete()
	end
end
function c9950367.filter(c,e,tp)
	return c:IsLevelBelow(4) and c:IsSetCard(0xba5) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c9950367.target2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_REMOVED+LOCATION_GRAVE) and chkc:IsControler(tp) and c9950367.filter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c9950367.filter,tp,LOCATION_REMOVED+LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c9950367.filter,tp,LOCATION_REMOVED+LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,e:GetHandler(),1,0,0)
end
function c9950367.operation2(e,tp,eg,ep,ev,re,r,rp)
	 local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and tc:IsRelateToEffect(e)
		and Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP) then
		Duel.Equip(tp,c,tc)
		local e1=Effect.CreateEffect(tc)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCode(EFFECT_EQUIP_LIMIT)
		e1:SetValue(c9950367.eqlimit)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		c:RegisterEffect(e1)
	end
	Duel.SpecialSummonComplete()
end
function c9950367.eqlimit(e,c)
	return e:GetOwner()==c
end
function c9950367.desfilter(c)
	return c:IsFaceup()
end
function c9950367.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(1-tp) and chkc:IsOnField() and c9950367.desfilter(chkc) end
	local eq=e:GetHandler():GetEquipTarget()
	if chk==0 then return Duel.IsExistingTarget(c9950367.desfilter,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,c9950367.desfilter,tp,0,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c9950367.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	local eq=c:GetEquipTarget()
	if not c:IsRelateToEffect(e) or eq:IsImmuneToEffect(e) then return end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetValue(500)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	eq:RegisterEffect(e1)
	if tc:IsRelateToEffect(e) and tc:IsControler(1-tp) and tc:IsFacedown() then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end
function c9950367.eqcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousLocation(LOCATION_ONFIELD) and c:IsPreviousPosition(POS_FACEUP) and c:IsReason(REASON_DESTROY) and c:CheckUniqueOnField(tp)
end
function c9950367.eqfilter2(c)
	return c:IsFaceup() and c:IsSetCard(0xba5) 
end
function c9950367.eqtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c9950367.eqfilter2(chkc) end
	if chk==0 then return e:GetHandler():IsRelateToEffect(e) and Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingTarget(c9950367.eqfilter2,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	Duel.SelectTarget(tp,c9950367.eqfilter2,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,e:GetHandler(),1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,e:GetHandler(),1,0,0)
end
function c9950367.eqop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) and tc:IsFaceup() and c:CheckUniqueOnField(tp) then
		Duel.Equip(tp,c,tc)
	end
end
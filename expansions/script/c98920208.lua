--临时圣剑 丹内尔
function c98920208.initial_effect(c)
	aux.AddCodeList(c,3285552) 
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(c98920208.condition)
	e1:SetTarget(c98920208.target)
	e1:SetOperation(c98920208.operation)
	c:RegisterEffect(e1)
	--Equip limit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_EQUIP_LIMIT)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetValue(c98920208.eqlimit)
	c:RegisterEffect(e2)
	--negate
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_DISABLE+CATEGORY_POSITION)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_CHAIN_SOLVING)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCondition(c98920208.negcon)
	e3:SetOperation(c98920208.negop)
	c:RegisterEffect(e3)
	--grave to equip
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_EQUIP)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_TO_GRAVE)
	e4:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e4:SetTarget(c98920208.eqtg)
	e4:SetOperation(c98920208.eqop)
	c:RegisterEffect(e4)
end
function c98920208.eqlimit(e,c)
	return c:IsCode(3285552)
end
function c98920208.cfilter0(c)
	return c:IsCode(3285552) and c:IsFaceup()
end
function c98920208.condition(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsExistingMatchingCard(c98920208.cfilter0,tp,LOCATION_ONFIELD,0,1,nil)
end
function c98920208.aclimit(e,re,tp)
	local rc=re:GetHandler()
	return re:IsActiveType(TYPE_MONSTER) and not (rc:IsSummonType(SUMMON_TYPE_SPECIAL) and rc:IsSummonLocation(LOCATION_HAND+LOCATION_GRAVE)) and rc:IsLocation(LOCATION_MZONE)
end
function c98920208.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and
		Duel.IsPlayerCanSpecialSummonMonster(tp,3285552,0,TYPES_TOKEN_MONSTER,2000,2000,4,RACE_FAIRY,ATTRIBUTE_EARTH) end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,0)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,e:GetHandler(),1,0,0)
end
function c98920208.operation(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0
		or not Duel.IsPlayerCanSpecialSummonMonster(tp,3285552,0,TYPES_TOKEN_MONSTER,2000,2000,4,RACE_FAIRY,ATTRIBUTE_EARTH) then return end
	local token=Duel.CreateToken(tp,3285552)
	Duel.SpecialSummon(token,0,tp,tp,false,false,POS_FACEUP)
	Duel.Equip(tp,e:GetHandler(),token)
end
function c98920208.negcon(e,tp,eg,ep,ev,re,r,rp)
	return rp==1-tp and re:IsActiveType(TYPE_SPELL+TYPE_TRAP)
		and Duel.IsChainDisablable(ev) and not Duel.IsChainDisabled(ev)
		and e:GetHandler():GetFlagEffect(98920208)<=0
end
function c98920208.negop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rc=re:GetHandler()
	if Duel.SelectEffectYesNo(tp,c) then
		Duel.Hint(HINT_CARD,0,98920208)
		if Duel.NegateEffect(ev) and Duel.IsExistingMatchingCard(c98920208.cfilter,tp,LOCATION_MZONE,0,1,nil) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_POSCHANGE)
			Duel.Destroy(e:GetHandler(),REASON_EFFECT)  
		end
		c:RegisterFlagEffect(98920208,RESET_EVENT+RESETS_STANDARD,0,1) 
	end
end
function c98920208.filter(c)
	return c:IsCode(3285552) and c:IsFaceup()
end
function c98920208.eqfilter(c,tc,tp)
	return c:IsType(TYPE_EQUIP) and c:IsCode(65952776) and c:CheckEquipTarget(tc) and c:CheckUniqueOnField(tp) and not c:IsForbidden()
end
function c98920208.eqtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c98920208.filter(chkc,tp) end
	local ft=0
	if e:GetHandler():IsLocation(LOCATION_HAND) then ft=1 end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>ft
		and Duel.IsExistingTarget(c98920208.filter,tp,LOCATION_MZONE,0,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c98920208.filter,tp,LOCATION_MZONE,0,1,1,nil,tp)
end
function c98920208.eqop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() and tc:IsControler(tp) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
		local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c98920208.eqfilter),tp,LOCATION_DECK+LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil,tc,tp)
		if g:GetCount()>0 then
			Duel.Equip(tp,g:GetFirst(),tc)
		end
	end
end
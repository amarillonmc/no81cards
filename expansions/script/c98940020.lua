--元素灵剑士·夜暮
function c98940020.initial_effect(c)
 --special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(98940020,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,98940020)
	e1:SetCost(c98940020.spcost)
	e1:SetTarget(c98940020.sptg)
	e1:SetOperation(c98940020.spop)
	c:RegisterEffect(e1)
	--summon success
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCondition(c98940020.regcon)
	e2:SetOperation(c98940020.regop)
	c:RegisterEffect(e2)
	e2:SetLabelObject(e1)
end
function c98940020.costfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsAbleToGraveAsCost()
		and (c:IsSetCard(0x400d) or c:IsLocation(LOCATION_HAND))
end
function c98940020.regfilter(c,attr)
	return c:IsSetCard(0x400d) and bit.band(c:GetOriginalAttribute(),attr)~=0
end
function c98940020.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local fe=Duel.IsPlayerAffectedByEffect(tp,61557074)
	local loc=LOCATION_HAND
	if fe then loc=LOCATION_HAND+LOCATION_DECK end
	if chk==0 then return Duel.IsExistingMatchingCard(c98940020.costfilter,tp,loc,0,2,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c98940020.costfilter,tp,loc,0,2,2,e:GetHandler())
	if g:IsExists(Card.IsLocation,1,nil,LOCATION_DECK) then
		Duel.Hint(HINT_CARD,0,61557074)
		fe:UseCountLimit(tp)
	end
	local flag=0
	if g:IsExists(c98940020.regfilter,1,nil,ATTRIBUTE_EARTH+ATTRIBUTE_WIND) then flag=bit.bor(flag,0x1) end
	if g:IsExists(c98940020.regfilter,1,nil,ATTRIBUTE_WATER+ATTRIBUTE_FIRE) then flag=bit.bor(flag,0x2) end
	if g:IsExists(c98940020.regfilter,1,nil,ATTRIBUTE_LIGHT+ATTRIBUTE_DARK) then flag=bit.bor(flag,0x4) end
	Duel.SendtoGrave(g,REASON_COST)
	e:SetLabel(flag)
end
function c98940020.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c98940020.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,SUMMON_VALUE_SELF,tp,tp,false,false,POS_FACEUP)
	end
end
function c98940020.regcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_SPECIAL+SUMMON_VALUE_SELF and e:GetLabelObject():GetLabel()~=0
end
function c98940020.regop(e,tp,eg,ep,ev,re,r,rp)
	local flag=e:GetLabelObject():GetLabel()
	local c=e:GetHandler()
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetProperty(EFFECT_FLAG_CLIENT_HINT)
	e0:SetRange(LOCATION_MZONE)
	e0:SetTargetRange(0,LOCATION_MZONE)
	e0:SetTarget(c98940020.immtg)
	e0:SetReset(RESET_EVENT+RESETS_STANDARD)
	if bit.band(flag,0x1)~=0 then
		local e1=e0:Clone()
		e1:SetDescription(aux.Stringid(98940020,1))
		e1:SetCode(EFFECT_SET_ATTACK_FINAL)
		e1:SetValue(c98940020.atkval)
		c:RegisterEffect(e1)
		local e5=e1:Clone()
		e5:SetCode(EFFECT_SET_DEFENSE_FINAL)
		e5:SetValue(c98940020.defval)
		c:RegisterEffect(e5)
	end
	if bit.band(flag,0x2)~=0 then
		local e2=e0:Clone()
		e2:SetDescription(aux.Stringid(98940020,2))
		e2:SetCode(EFFECT_CANNOT_ATTACK_ANNOUNCE)
		e2:SetValue(1)
		c:RegisterEffect(e2)
	end
	if bit.band(flag,0x4)~=0 then
		local e3=e0:Clone()
		e3:SetDescription(aux.Stringid(98940020,3))
		e3:SetCode(EFFECT_CANNOT_TRIGGER)
		c:RegisterEffect(e3)
	end
end
function c98940020.immtg(e,c)
	return c:IsFaceup()
end
function c98940020.atkval(e,c)
	return math.ceil(c:GetAttack()/2)
end
function c98940020.defval(e,c)
	return math.ceil(c:GetDefense()/2)
end
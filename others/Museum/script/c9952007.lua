--ZZ-金属履带2
function c9952007.initial_effect(c)
	 --link summon
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkRace,RACE_MACHINE),2,2)
	--Equip
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCategory(CATEGORY_EQUIP)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetHintTiming(0,TIMING_END_PHASE)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetCountLimit(1,9952007)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTarget(c9952007.target)
	e3:SetOperation(c9952007.operation)
	c:RegisterEffect(e3)
 --special summon
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EVENT_BATTLE_DESTROYED)
   e2:SetCountLimit(1,99520070)
	e2:SetCondition(c9952007.regcon)
	e2:SetOperation(c9952007.regop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetCondition(c9952007.regcon2)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(9952007,1))
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e4:SetCode(EVENT_CUSTOM+9952007)
	e4:SetCountLimit(1,99520070)
	e4:SetRange(LOCATION_MZONE)
	e4:SetTarget(c9952007.sptg)
	e4:SetOperation(c9952007.spop)
	c:RegisterEffect(e4)
end
function c9952007.cfilter2(c)
	return c:IsFaceup() and c:IsRace(RACE_MACHINE)
end
function c9952007.filter2(c)
	return c:IsRace(RACE_MACHINE) and c:IsType(TYPE_MONSTER) and not c:IsForbidden()
end
function c9952007.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and c9952007.cfilter2(chkc) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingTarget(c9952007.cfilter2,tp,LOCATION_MZONE,0,1,nil)
		and Duel.IsExistingMatchingCard(c9952007.filter2,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c9952007.cfilter2,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,nil,1,tp,LOCATION_GRAVE)
end
function c9952007.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	if not tc:IsFaceup() or not tc:IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local sg=Duel.SelectMatchingCard(tp,c9952007.filter2,tp,LOCATION_GRAVE,0,1,1,nil)
	local sc=sg:GetFirst()
	if sc then
		if not Duel.Equip(tp,sc,tc) then return end
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_EQUIP_LIMIT)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetValue(c9952007.eqlimit)
		e1:SetLabelObject(tc)
		sc:RegisterEffect(e1)
	end
end
function c9952007.eqlimit(e,c)
	return e:GetLabelObject()==c
end
function c9952007.cfilter(c,tp,zone)
	local seq=c:GetPreviousSequence()
	if c:GetPreviousControler()~=tp then seq=seq+16 end
	return c:IsPreviousLocation(LOCATION_MZONE) and bit.extract(zone,seq)~=0
end
function c9952007.regcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c9952007.cfilter,1,nil,tp,e:GetHandler():GetLinkedZone())
end
function c9952007.cfilter2(c,tp,zone)
	return not c:IsReason(REASON_BATTLE) and c9952007.cfilter(c,tp,zone)
end
function c9952007.regcon2(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c9952007.cfilter2,1,nil,tp,e:GetHandler():GetLinkedZone())
end
function c9952007.regop(e,tp,eg,ep,ev,re,r,rp)
	Duel.RaiseSingleEvent(e:GetHandler(),EVENT_CUSTOM+9952007,e,0,tp,0,0)
end
function c9952007.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(Card.IsCanBeSpecialSummoned,tp,LOCATION_HAND,0,1,nil,e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function c9952007.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,Card.IsCanBeSpecialSummoned,tp,LOCATION_HAND,0,1,1,nil,e,0,tp,false,false)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end

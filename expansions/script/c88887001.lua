--数理罪论 福尔摩斯
function c88887001.initial_effect(c)
	--special summon itself
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,88887001)
	e1:SetCondition(c88887001.spcon)
	e1:SetTarget(c88887001.sptg)
	e1:SetOperation(c88887001.spop)
	c:RegisterEffect(e1)
	--set
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,18887001)
	e2:SetTarget(c88887001.setg)
	e2:SetOperation(c88887001.seop)
	c:RegisterEffect(e2)
	--special summon
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_REMOVE)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e3:SetCountLimit(1,28887001)
	e3:SetCondition(c88887001.sprcon)
	e3:SetTarget(c88887001.sprtg)
	e3:SetOperation(c88887001.sprop)
	c:RegisterEffect(e3)
end
function c88887001.cfilter(c)
	return c:IsFacedown() or not c:IsRace(RACE_SPELLCASTER)
end
function c88887001.spcon(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsExistingMatchingCard(c88887001.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c88887001.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c88887001.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c88887001.desfilter(c,tp)
	return (c:IsLocation(LOCATION_MZONE) and c:IsFaceup() and c:IsRace(RACE_SPELLCASTER)) or (c:IsLocation(LOCATION_SZONE) and c:IsFacedown() and c:GetSequence()<5)
		and Duel.GetMZoneCount(tp,c)>0
end
function c88887001.sefilter(c)
	return c:IsSetCard(0x881) and c:IsSSetable() and not c:IsType(TYPE_FIELD+TYPE_MONSTER)
end
function c88887001.setg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return chkc:IsOnField() and chkc:IsControler(tp) and c88887001.desfilter(chkc,tp) end
	if chk==0 then return Duel.IsExistingMatchingCard(c88887001.sefilter,tp,LOCATION_DECK,0,1,nil)
		and Duel.IsExistingTarget(c88887001.desfilter,tp,LOCATION_ONFIELD,0,1,c) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,c88887001.desfilter,tp,LOCATION_ONFIELD,0,1,1,c)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c88887001.seop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.Destroy(tc,REASON_EFFECT)~=0 and Duel.IsExistingMatchingCard(c88887001.sefilter,tp,LOCATION_DECK,0,1,nil) then
		local g=Duel.GetMatchingGroup(c88887001.sefilter,tp,LOCATION_DECK,0,nil)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
		local sg=g:Select(tp,1,1,nil)
		Duel.SSet(tp,sg,tp,true)
	end
end
function c88887001.sprfilter(c,e,tp)
	return c:IsRace(RACE_SPELLCASTER) and c:IsAttribute(ATTRIBUTE_LIGHT+ATTRIBUTE_DARK) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
		and not c:IsCode(88887001) and c:IsLevelBelow(6) and (c:IsLocation(LOCATION_GRAVE) or c:IsFaceup())
end
function c88887001.sprcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_GRAVE+LOCATION_ONFIELD)
end
function c88887001.sprtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return chkc:IsLocation(LOCATION_GRAVE+LOCATION_REMOVED) and chkc:IsControler(tp) and c88887001.sprfilter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c88887001.sprfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c88887001.sprfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c88887001.sprop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
end
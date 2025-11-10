--CAN:D 珂蒂娅
function c88888212.initial_effect(c)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(88888212,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e1:SetCountLimit(1,88888212)
	e1:SetCost(c88888212.spcost)
	e1:SetTarget(c88888212.sptg)
	e1:SetOperation(c88888212.spop)
	c:RegisterEffect(e1)
	--szone
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(88888212,0))
	e3:SetCategory(CATEGORY_DISABLE)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetCountLimit(1,18888212)
	e3:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e3:SetCondition(c88888212.xcon)
	e3:SetTarget(c88888212.xtg)
	e3:SetOperation(c88888212.xop)
	c:RegisterEffect(e3)
end
function c88888212.cifilter(c,tp)
	return c:IsAbleToGraveAsCost() and c:GetOriginalType()&TYPE_MONSTER~=0 and Duel.GetMZoneCount(tp,c)>0
end
function c88888212.chfilter(c)
	return c:IsFacedown() or not c:IsSetCard(0x8908)
end
function c88888212.spfilter(c,e,tp)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x8908) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c88888212.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c88888212.cifilter,tp,LOCATION_ONFIELD+LOCATION_HAND,0,1,e:GetHandler(),tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c88888212.cifilter,tp,LOCATION_ONFIELD+LOCATION_HAND,0,1,1,e:GetHandler(),tp)
	Duel.SendtoGrave(g,REASON_COST)
end
function c88888212.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c88888212.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)==0 then return end
	if Duel.GetMatchingGroupCount(c88888212.chfilter,tp,LOCATION_MZONE,0,nil)==0 
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(aux.NecroValleyFilter(c88888212.spfilter),tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil,e,tp) 
		and Duel.SelectYesNo(tp,aux.Stringid(88888212,1)) then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c88888212.spfilter),tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil,e,tp)
		if g:GetCount()>0 then
			Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end
function c88888212.xcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetType()==TYPE_TRAP+TYPE_CONTINUOUS
end
function c88888212.xfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_XYZ) and c:IsSetCard(0x8908)
end
function c88888212.xtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c88888212.xfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c88888212.xfilter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c88888212.xfilter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c88888212.xop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or not c:IsLocation(LOCATION_ONFIELD) then return end
	local tc=Duel.GetFirstTarget()
	if not tc:IsRelateToEffect(e) or tc:IsImmuneToEffect(e) then return end
	Duel.Overlay(tc,Group.FromCards(c))
	local ct=Duel.GetMatchingGroupCount(c88888212.filter,tp,LOCATION_ONFIELD,0,nil)
	if ct>0 and Duel.IsExistingMatchingCard(aux.NegateAnyFilter,tp,0,LOCATION_ONFIELD,1,nil)
		and Duel.SelectYesNo(tp,aux.Stringid(88888212,2)) then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISABLE)
		local g=Duel.SelectMatchingCard(tp,aux.NegateAnyFilter,tp,0,LOCATION_ONFIELD,1,1,nil)
		local ac=g:GetFirst()
		Duel.NegateRelatedChain(ac,RESET_TURN_SET)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		ac:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetValue(RESET_TURN_SET)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		ac:RegisterEffect(e2)
		if ac:IsType(TYPE_TRAPMONSTER) then
			local e3=Effect.CreateEffect(c)
			e3:SetType(EFFECT_TYPE_SINGLE)
			e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e3:SetCode(EFFECT_DISABLE_TRAPMONSTER)
			e3:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			ac:RegisterEffect(e3)
		end
	end
end
function c88888212.filter(c)
	return c:IsFaceup() and c:IsType(TYPE_TRAP) and c:IsType(TYPE_CONTINUOUS)
end
function c88888212.cfilter(c)
	return c:IsSetCard(0x8908) and c:IsAbleToDeck() and c:IsFaceupEx()
end
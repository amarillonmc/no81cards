--CAN:D 索尼可
function c88888211.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(88888211,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,88888211)
	e1:SetCost(c88888211.spcost)
	e1:SetTarget(c88888211.sptg)
	e1:SetOperation(c88888211.spop)
	c:RegisterEffect(e1)
	--szone
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(88888211,0))
	e3:SetCategory(CATEGORY_TODECK)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetCountLimit(1,18888211)
	e3:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e3:SetCondition(c88888211.xcon)
	e3:SetTarget(c88888211.xtg)
	e3:SetOperation(c88888211.xop)
	c:RegisterEffect(e3)
end
function c88888211.chfilter(c)
	return c:IsSetCard(0x8908) and not c:IsPublic()
end
function c88888211.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c88888211.chfilter,tp,LOCATION_EXTRA,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local g=Duel.SelectMatchingCard(tp,c88888211.chfilter,tp,LOCATION_EXTRA,0,1,1,nil)
	Duel.ConfirmCards(1-tp,g)
	e:SetLabel(g:GetFirst():GetAttribute())
end
function c88888211.tgfilter(c,attr)
	return c:IsSetCard(0x8908) and c:IsAttribute(attr) and c:IsAbleToGrave()
end
function c88888211.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c88888211.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local attr=e:GetLabel()
	if not c:IsRelateToChain() then return end
	if Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)==0 then return end
	if Duel.IsExistingMatchingCard(c88888211.tgfilter,tp,LOCATION_DECK,0,1,nil,attr)
		and Duel.SelectYesNo(tp,aux.Stringid(88888211,1)) then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local g=Duel.SelectMatchingCard(tp,c88888211.tgfilter,tp,LOCATION_DECK,0,1,1,nil,attr)
		if g:GetCount()>0 then
			Duel.SendtoGrave(g,REASON_EFFECT)
		end
	end
end
function c88888211.xcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetType()==TYPE_TRAP+TYPE_CONTINUOUS
end
function c88888211.xfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_XYZ) and c:IsSetCard(0x8908)
end
function c88888211.xtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c88888211.xfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c88888211.xfilter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c88888211.xfilter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c88888211.xop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or not c:IsLocation(LOCATION_ONFIELD) then return end
	local tc=Duel.GetFirstTarget()
	if not tc:IsRelateToEffect(e) or tc:IsImmuneToEffect(e) then return end
	Duel.Overlay(tc,Group.FromCards(c))
	local ct=Duel.GetMatchingGroupCount(c88888211.filter,tp,LOCATION_ONFIELD,0,nil)
	local g=Duel.GetMatchingGroup(aux.NecroValleyFilter(c88888211.cfilter),tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil)
	if ct>0 and g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(88888211,2)) then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		local sg=g:Select(tp,1,ct,nil)
		Duel.HintSelection(sg)
		Duel.SendtoDeck(sg,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
	end
end
function c88888211.filter(c)
	return c:IsFaceup() and c:IsType(TYPE_TRAP) and c:IsType(TYPE_CONTINUOUS)
end
function c88888211.cfilter(c)
	return c:IsSetCard(0x8908) and c:IsAbleToDeck() and c:IsFaceupEx()
end
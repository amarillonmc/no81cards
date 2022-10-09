--结缘的永夏 鸣濑白羽
function c9910964.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(nil),1)
	c:EnableReviveLimit()
	--flag
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e0:SetCode(EVENT_REMOVE)
	e0:SetOperation(c9910964.flag)
	c:RegisterEffect(e0)
	--Special Summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(9910964,0))
	e1:SetCategory(CATEGORY_REMOVE+CATEGORY_SPECIAL_SUMMON+CATEGORY_GRAVE_SPSUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,9910964)
	e1:SetTarget(c9910964.target)
	e1:SetOperation(c9910964.operation)
	c:RegisterEffect(e1)
	--disable
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(9910964,1))
	e2:SetCategory(CATEGORY_REMOVE+CATEGORY_SPECIAL_SUMMON+CATEGORY_GRAVE_SPSUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,9910964)
	e2:SetCost(c9910964.rmcost)
	e2:SetTarget(c9910964.rmtg)
	e2:SetOperation(c9910964.rmop)
	c:RegisterEffect(e2)
end
function c9910964.flag(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsReason(REASON_EFFECT) then
		c:RegisterFlagEffect(9910963,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(9910963,3))
	end
end
function c9910964.filter1(c,tp)
	return c:IsFaceup() and c:IsSetCard(0x5954) and c:IsAbleToRemove(tp,POS_FACEDOWN)
end
function c9910964.filter2(c,e,tp)
	return Duel.IsExistingMatchingCard(c9910964.filter3,tp,LOCATION_EXTRA+LOCATION_GRAVE,0,1,nil,e,tp,c)
end
function c9910964.filter3(c,e,tp,tc)
	if not (c:IsSetCard(0x5954) and c:IsType(TYPE_SYNCHRO) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_DEFENSE)) then return false end
	if c:IsLocation(LOCATION_EXTRA) then
		return Duel.GetLocationCountFromEx(tp,tp,tc,c)>0
	else
		return Duel.GetMZoneCount(tp,tc)>0
	end
end
function c9910964.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(c9910964.filter1,tp,LOCATION_ONFIELD,0,nil,tp)
	if chk==0 then return #g>1 and g:IsExists(c9910964.filter2,1,nil,e,tp) end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA+LOCATION_GRAVE)
end
function c9910964.operation(e,tp,eg,ep,ev,re,r,rp)
	local g1=Duel.GetMatchingGroup(c9910964.filter1,tp,LOCATION_ONFIELD,0,nil,tp)
	local g2=g1:Filter(c9910964.filter2,nil,e,tp)
	if #g1<2 or #g1==0 then return end
	local g=Group.CreateGroup()
	if Duel.IsExistingMatchingCard(c9910964.filter3,tp,LOCATION_EXTRA+LOCATION_GRAVE,0,1,nil,e,tp,nil) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		g=g1:Select(tp,2,2,nil)
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		g=g2:Select(tp,1,1,nil)
		g1:RemoveCard(g:GetFirst())
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local g3=g1:Select(tp,1,1,nil)
		g:Merge(g3)
	end
	Duel.HintSelection(g)
	if #g>0 and Duel.Remove(g,POS_FACEDOWN,REASON_EFFECT)~=0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c9910964.filter3),tp,LOCATION_EXTRA+LOCATION_GRAVE,0,1,1,nil,e,tp,nil)
		if #sg>0 then
			Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP_DEFENSE)
		end
	end
end
function c9910964.tdfilter(c)
	return c:IsFacedown() and c:IsSetCard(0x5954) and c:IsReason(REASON_EFFECT)
		and c:IsAbleToDeckOrExtraAsCost()
end
function c9910964.rmcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9910964.tdfilter,tp,LOCATION_REMOVED,0,3,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,c9910964.tdfilter,tp,LOCATION_REMOVED,0,3,3,nil)
	Duel.SendtoDeck(g,nil,SEQ_DECKSHUFFLE,REASON_COST)
	Duel.ConfirmCards(1-tp,g)
end
function c9910964.rmtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsAbleToRemove() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsAbleToRemove,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,nil) end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectTarget(tp,Card.IsAbleToRemove,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,3,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,g:GetCount(),0,0)
end
function c9910964.spfilter(c,e,tp)
	return c:IsSetCard(0x5954) and not c:IsType(TYPE_TUNER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c9910964.rmop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if g:GetCount()>0 then
		Duel.Remove(g,POS_FACEDOWN,REASON_EFFECT)
	end
end

--天空漫步者-眼镜蛇机动
function c9910597.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetTarget(c9910597.target)
	e1:SetOperation(c9910597.activate)
	c:RegisterEffect(e1)
	--change effect
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TODECK)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,9910597)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c9910597.chtg)
	e2:SetOperation(c9910597.chop)
	c:RegisterEffect(e2)
end
function c9910597.rmfilter1(c,tp)
	return c:IsAbleToRemove() and c:IsFaceupEx() and c:IsRace(RACE_PSYCHO)
		and Duel.IsExistingTarget(c9910597.rmfilter2,tp,LOCATION_MZONE+LOCATION_GRAVE,LOCATION_MZONE+LOCATION_GRAVE,1,c)
end
function c9910597.rmfilter2(c)
	return c:IsAbleToRemove() and (c:IsOnField() or c:IsType(TYPE_MONSTER))
end
function c9910597.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then return Duel.IsExistingTarget(c9910597.rmfilter1,tp,LOCATION_MZONE+LOCATION_GRAVE,LOCATION_MZONE+LOCATION_GRAVE,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectTarget(tp,c9910597.rmfilter1,tp,LOCATION_MZONE+LOCATION_GRAVE,LOCATION_MZONE+LOCATION_GRAVE,1,1,nil,tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g2=Duel.SelectTarget(tp,c9910597.rmfilter2,tp,LOCATION_MZONE+LOCATION_GRAVE,LOCATION_MZONE+LOCATION_GRAVE,1,1,g)
	g:Merge(g2)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,2,0,0)
	if e:IsHasType(EFFECT_TYPE_ACTIVATE) and Duel.GetCurrentChain()>2 then
		e:SetCategory(CATEGORY_REMOVE)
	else
		e:SetCategory(CATEGORY_REMOVE+CATEGORY_SPECIAL_SUMMON)
	end
end
function c9910597.spfilter(c,e,tp)
	return c:IsFaceup() and c:IsType(TYPE_LINK) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c9910597.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if #g>0 and Duel.Remove(g,POS_FACEUP,REASON_EFFECT)~=0 and e:IsHasType(EFFECT_TYPE_ACTIVATE) and Duel.GetCurrentChain()>2 then 
		Duel.AdjustAll()
		if Duel.GetMZoneCount(tp)>0 and Duel.IsExistingMatchingCard(c9910597.spfilter,tp,LOCATION_REMOVED,0,1,nil,e,tp)
			and Duel.SelectYesNo(tp,aux.Stringid(9910597,0)) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local g=Duel.SelectMatchingCard(tp,c9910597.spfilter,tp,LOCATION_REMOVED,0,1,1,nil,e,tp)
			if g:GetCount()>0 then
				Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
			end
		end
	end
end
function c9910597.tdfilter(c,tp)
	return c:IsAbleToDeck() and c:IsFaceupEx() and c:IsSetCard(0x6956) and (c:IsLocation(LOCATION_MZONE) or c:IsType(TYPE_MONSTER))
		and Duel.IsExistingTarget(Card.IsAbleToDeck,tp,LOCATION_ONFIELD+LOCATION_GRAVE,0,1,c)
end
function c9910597.chtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return false end
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,rp,0,LOCATION_HAND,1,nil,REASON_EFFECT)
		and Duel.IsExistingTarget(c9910597.tdfilter,tp,LOCATION_ONFIELD+LOCATION_GRAVE,0,1,c,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,c9910597.tdfilter,tp,LOCATION_ONFIELD+LOCATION_GRAVE,0,1,1,nil,tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g2=Duel.SelectTarget(tp,Card.IsAbleToDeck,tp,LOCATION_ONFIELD+LOCATION_GRAVE,0,1,1,g)
	g:Merge(g2)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,2,0,0)
end
function c9910597.chop(e,tp,eg,ep,ev,re,r,rp)
	local g=Group.CreateGroup()
	Duel.ChangeTargetCard(ev,g)
	Duel.ChangeChainOperation(ev,c9910597.repop)
	local sg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(aux.NecroValleyFilter(Card.IsRelateToChain),nil)
	if sg:GetCount()>0 then
		Duel.BreakEffect()
		Duel.SendtoDeck(sg,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
	end
end
function c9910597.repop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_DISCARD)
	Duel.DiscardHand(1-tp,Card.IsDiscardable,1,1,REASON_EFFECT+REASON_DISCARD)
end

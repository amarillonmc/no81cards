--逆袭之斗兽 鸢泽美咲
function c9910231.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkType,TYPE_LINK),2,99,c9910231.lcheck)
	c:EnableReviveLimit()
	--draw
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DRAW+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetCountLimit(1,9910231)
	e1:SetCost(c9910231.drcost)
	e1:SetTarget(c9910231.drtg)
	e1:SetOperation(c9910231.drop)
	c:RegisterEffect(e1)
	Duel.AddCustomActivityCounter(9910231,ACTIVITY_CHAIN,c9910231.chainfilter)
end
function c9910231.chainfilter(re,tp,cid)
	return not (re:IsHasType(EFFECT_TYPE_ACTIVATE) and re:IsActiveType(TYPE_SPELL) and re:GetHandler():IsSetCard(0x955))
end
function c9910231.lcheck(g)
	return g:IsExists(Card.IsLinkMarker,1,nil,LINK_MARKER_BOTTOM)
		and g:IsExists(Card.IsLinkMarker,1,nil,LINK_MARKER_TOP)
		and g:IsExists(Card.IsLinkMarker,1,nil,LINK_MARKER_TOP_LEFT)
		and g:IsExists(Card.IsLinkMarker,1,nil,LINK_MARKER_TOP_RIGHT)
end
function c9910231.drcost(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCustomActivityCount(9910231,tp,ACTIVITY_CHAIN)~=0
end
function c9910231.costfilter(c,mc,tp)
	local lg=mc:GetLinkedGroup()
	local tg=Group.FromCards(c,mc)
	return lg:IsContains(c) and c:IsAbleToDeckOrExtraAsCost()
end
function c9910231.drcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(c9910231.costfilter,tp,0,LOCATION_MZONE,1,c,c,tp)
		and c:IsAbleToDeckOrExtraAsCost() end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,c9910231.costfilter,tp,0,LOCATION_MZONE,1,1,c,c,tp)
	g:AddCard(c)
	Duel.SendtoDeck(g,nil,SEQ_DECKSHUFFLE,REASON_COST)
end
function c9910231.filter(c,e,tp)
	return c:IsSetCard(0x955) and c:IsCanBeEffectTarget(e) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
		and (c:IsLocation(LOCATION_GRAVE) or c:IsFaceup())
end
function c9910231.lkfilter(c,g)
	return c:IsSetCard(0x955) --and c:IsLinkSummonable(g,nil,g:GetCount(),g:GetCount())
end
function c9910231.fgoal(g,tp)
	return Duel.IsExistingMatchingCard(c9910231.lkfilter,tp,LOCATION_EXTRA,0,1,nil,g)
end
function c9910231.drtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	local mg=Duel.GetMatchingGroup(c9910231.filter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,nil,e,tp)
	local ct=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if chk==0 then return Duel.IsPlayerCanDraw(1-tp,1) and Duel.IsPlayerCanSpecialSummonCount(tp,2)
		and not Duel.IsPlayerAffectedByEffect(tp,59822133) and ct>1 and mg:CheckSubGroup(c9910231.fgoal,2,ct,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sg1=mg:SelectSubGroup(tp,c9910231.fgoal,false,2,ct,tp)
	Duel.SetTargetCard(sg1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,1-tp,1)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,sg1,sg1:GetCount(),0,0)
end
function c9910231.filter2(c,e,tp)
	return c:IsRelateToEffect(e) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c9910231.drop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.Draw(1-tp,1,REASON_EFFECT)==0 then return end
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if ft<=0 then return end
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(c9910231.filter2,nil,e,tp)
	if #g==0 then return end
	if #g>1 and Duel.IsPlayerAffectedByEffect(tp,59822133) then return end
	if #g>ft then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		g=g:Select(tp,ft,ft,nil)
	end
	Duel.BreakEffect()
	Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	local og=Duel.GetOperatedGroup()
	Duel.AdjustAll()
	if og:FilterCount(Card.IsLocation,nil,LOCATION_MZONE)<g:GetCount() then return end
	local tg=Duel.GetMatchingGroup(c9910231.lkfilter,tp,LOCATION_EXTRA,0,nil,og)
	if og:GetCount()==g:GetCount() and tg:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local rg=tg:Select(tp,1,1,nil)
		Duel.LinkSummon(tp,rg:GetFirst(),og,nil,#og,#og)
	end
end

--幻想生物兵器-章型
local m=14010230
local cm=_G["c"..m]
cm.named_with_FantasyArms=1
function cm.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCountLimit(1,m+EFFECT_COUNT_CODE_OATH)
	e1:SetHintTiming(0,0x1e0)
	e1:SetCost(cm.cost)
	e1:SetTarget(cm.tg)
	e1:SetOperation(cm.op)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetRange(LOCATION_DECK)
	e2:SetCost(cm.costchk)
	c:RegisterEffect(e2)
end
function cm.named(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_FantasyArms
end
function cm.tdfilter2(c)
	return cm.named(c) and c:IsType(TYPE_MONSTER) and c:IsAbleToDeckAsCost()
end
function cm.cfilter(c,tp)
	return cm.named(c) and c:IsAbleToGraveAsCost()
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local tg=Duel.GetMatchingGroup(cm.cfilter,tp,LOCATION_HAND+LOCATION_ONFIELD,0,nil,tp)
	local chk1=Duel.IsExistingMatchingCard(Card.IsFacedown,tp,0,LOCATION_REMOVED,1,nil)
	local hg=Duel.GetMatchingGroup(Card.IsAbleToGraveAsCost,tp,0,LOCATION_HAND,nil)
	local g=Duel.GetMatchingGroup(Card.IsAbleToGraveAsCost,tp,0,LOCATION_ONFIELD,nil)
	if chk==0 then 
		return #tg>0 or (chk1 and #hg+#g>0)
	end
	if chk1 then
		tg:Merge(g)
		if #tg>0 and (#hg==0 or not Duel.SelectYesNo(tp,aux.Stringid(m,1))) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
			local g=g:Select(tp,1,1,nil)
			if #g>0 then
				Duel.SendtoGrave(g,REASON_EFFECT)
			end
		else
			sg=hg:RandomSelect(tp,1)
			Duel.SendtoGrave(sg,REASON_EFFECT)
		end
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local g=tg:Select(tp,1,1,nil)
		Duel.SendtoGrave(g,REASON_COST)
	end
end
function cm.costchk(e,tp,eg,ep,ev,re,r,rp,chk)
	local tg=Duel.GetMatchingGroup(cm.cfilter,tp,LOCATION_HAND+LOCATION_ONFIELD,0,nil,tp)
	local chk1=Duel.IsExistingMatchingCard(Card.IsFacedown,tp,0,LOCATION_REMOVED,1,nil)
	local hg=Duel.GetMatchingGroup(Card.IsAbleToGraveAsCost,tp,0,LOCATION_HAND,nil)
	local g=Duel.GetMatchingGroup(Card.IsAbleToGraveAsCost,tp,0,LOCATION_ONFIELD,nil)
	if chk==0 then return (#tg>0 or (chk1 and #hg+#g>0)) and Duel.IsExistingMatchingCard(cm.tdfilter2,tp,LOCATION_GRAVE,0,1,nil) and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,cm.tdfilter2,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SendtoDeck(g,nil,2,REASON_COST)
	Duel.MoveToField(e:GetHandler(),tp,tp,LOCATION_SZONE,POS_FACEUP,true)
	if chk1 then
		tg:Merge(g)
		if #tg>0 and (#hg==0 or not Duel.SelectYesNo(tp,aux.Stringid(m,1))) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
			local g=g:Select(tp,1,1,nil)
			if #g>0 then
				Duel.SendtoGrave(g,REASON_EFFECT)
			end
		else
			sg=hg:RandomSelect(tp,1)
			Duel.SendtoGrave(sg,REASON_EFFECT)
		end
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local g=tg:Select(tp,1,1,nil)
		Duel.SendtoGrave(g,REASON_COST)
	end
end
function cm.spfilter(c,e,tp)
	return cm.named(c) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function cm.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,cm.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	if #g>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
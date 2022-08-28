--恶魔的再归
local m=30005140
local cm=_G["c"..m]
function cm.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TODECK+CATEGORY_DECKDES+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetCondition(cm.condition)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
end
function cm.cfilter(c)
	return c:IsRace(RACE_FIEND) and c:IsFaceup()
end
function cm.condition(e)
	local tsp=e:GetHandler():GetControler()
	return Duel.IsExistingMatchingCard(cm.cfilter,tsp,LOCATION_MZONE,LOCATION_MZONE,1,nil)
end
function cm.fd(c)
	return c:IsRace(RACE_FIEND) and c:IsAbleToDeck() 
		and (c:IsFaceup() or c:IsLocation(LOCATION_GRAVE))
end
function cm.fd3(c,e,tp,code)
	if not c:IsCode(code) then return false end
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	return c:IsAbleToGrave() or (ft>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false))
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chkc then return chkc:IsLocation(LOCATION_MZONE+LOCATION_GRAVE+LOCATION_REMOVED) and cm.fd(chkc) end
	if chk==0 then return Duel.IsExistingTarget(cm.fd,tp,LOCATION_MZONE+LOCATION_GRAVE+LOCATION_REMOVED,LOCATION_MZONE+LOCATION_GRAVE+LOCATION_REMOVED,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,cm.fd,tp,LOCATION_MZONE+LOCATION_GRAVE+LOCATION_REMOVED,LOCATION_MZONE+LOCATION_GRAVE+LOCATION_REMOVED,1,1,e:GetHandler())
	if g:GetFirst():IsLocation(LOCATION_MZONE) then
		Duel.SetTargetParam(1) 
	end 
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,1,0,0)
end
function cm.tgfilter(c)
	return c:IsRace(RACE_FIEND) and c:IsAbleToGrave()
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	local num=Duel.GetChainInfo(0,CHAININFO_TARGET_PARAM)
	if tc:IsRelateToEffect(e) 
		and Duel.SendtoDeck(tc,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)>0 
		and tc:IsLocation(LOCATION_DECK+LOCATION_EXTRA) then
		local code=tc:GetCode()
		local sg=Duel.GetMatchingGroup(cm.fd3,tp,LOCATION_DECK,0,nil,e,tp,code)
		local tg=Duel.GetMatchingGroup(Card.IsAbleToDeck,tp,0,LOCATION_HAND+LOCATION_ONFIELD,nil)
		if #sg>0 and Duel.SelectYesNo(tp,aux.Stringid(m,0)) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
			local g=sg:Select(tp,1,1,nil)
			local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
			local tc=g:GetFirst()
			if tc then
				if tc:IsAbleToGrave() 
					and (not tc:IsCanBeSpecialSummoned(e,0,tp,false,false) or ft<=0 or Duel.SelectOption(tp,1191,1152)==0) then
					Duel.SendtoGrave(tc,REASON_EFFECT)
				else
					Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
				end
			end
			if num>0 and #tg>0 then
				Duel.Hint(HINT_CARD,0,m) 
				local tg1=tg:RandomSelect(tp,1)
				Duel.HintSelection(tg1)
				Duel.SendtoDeck(tg1,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
			end
		end
	end
end


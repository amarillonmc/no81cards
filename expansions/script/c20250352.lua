--禁钉迹观福音
function c20250352.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(20250352,1))
	e2:SetCategory(CATEGORY_COUNTER)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1,20250352)
	e2:SetTarget(c20250352.target1)
	e2:SetOperation(c20250352.activate1)
	c:RegisterEffect(e2)
	--
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(20250352,2))
	e3:SetCategory(CATEGORY_COUNTER)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_SZONE)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetCountLimit(1,20250352)
	e3:SetTarget(c20250352.target2)
	e3:SetOperation(c20250352.activate2)
	c:RegisterEffect(e3)
	--
	local custom_code=aux.RegisterMergedDelayedEvent_ToSingleCard(c,20250352,{EVENT_TO_GRAVE,EVENT_REMOVE})
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(20250352,0))
	e4:SetCategory(CATEGORY_GRAVE_ACTION)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(custom_code)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCountLimit(1,20250353)
	e4:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e4:SetTarget(c20250352.tdtg)
	e4:SetOperation(c20250352.tdop)
	c:RegisterEffect(e4)
end
function c20250352.target1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsCanRemoveCounter(tp,1,0,0x154a,1,REASON_EFFECT) end
end
function c20250352.activate1(e,tp,eg,ep,ev,re,r,rp)
	Duel.RemoveCounter(tp,1,0,0x154a,1,REASON_EFFECT)
end
function c20250352.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingTarget(Card.IsCanAddCounter,tp,LOCATION_MZONE,0,1,nil,0x154a,1) end
end
function c20250352.activate2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectMatchingCard(tp,Card.IsCanAddCounter,tp,LOCATION_MZONE,0,1,1,nil,0x154a,1)
	if #g<1 then return end
	Duel.HintSelection(g)
	local tc=g:GetFirst()
	if tc and tc:AddCounter(0x154a,1) and tc:GetLevel()>1 then
		Duel.SpecialSummonComplete()
	end
end
function c20250352.cfilter(c,e)
	return c:IsFaceup() and c:IsRace(RACE_FAIRY) and c:IsType(TYPE_SYNCHRO) and c:IsAbleToExtra()
		and c:IsCanBeEffectTarget(e) and c:IsPreviousLocation(LOCATION_MZONE) and c:IsPreviousControler(tp)
		and c:IsLocation(LOCATION_GRAVE+LOCATION_REMOVED)
end
function c20250352.filter3(c)
	return c:IsAttribute(ATTRIBUTE_LIGHT) or c:IsRace(RACE_FAIRY) and c:IsAbleToHand()
end
function c20250352.tdtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return eg:IsContains(chkc) end
	if chk==0 then return eg:IsExists(c20250352.cfilter,1,nil,e)
		and Duel.IsPlayerCanDraw(tp,1) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=eg:FilterSelect(tp,c20250352.cfilter,1,1,nil,e)
	Duel.SetTargetCard(g)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,0,tp,1)
end
function c20250352.tdop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.SendtoDeck(tc,nil,SEQ_DECKBOTTOM,REASON_EFFECT)>0 then
		Duel.BreakEffect()
		local tg=Duel.GetMatchingGroup(aux.NecroValleyFilter(c20250352.filter3),tp,LOCATION_GRAVE,0,nil)
		if tg:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(20250352,3)) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			local sg=tg:Select(tp,1,1,nil)
			Duel.SendtoHand(sg,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,sg)
		end
	end
end

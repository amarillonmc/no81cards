--囚徒的死斗
function c71280048.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_TODECK+CATEGORY_GRAVE_ACTION)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetTarget(c71280048.target)
	e1:SetOperation(c71280048.activate)
	c:RegisterEffect(e1)
	--
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(71280048,0))
	e3:SetCategory(CATEGORY_REMOVE)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_DESTROYED)
	e3:SetCountLimit(1,71280048)
	e3:SetTarget(c71280048.rmtg)
	e3:SetOperation(c71280048.rmop)
	c:RegisterEffect(e3)
end
function c71280048.cfilter(c)
	return c:IsSetCard(0x8911) and c:IsAbleToDeck()
end
function c71280048.tgfilter(c)
	return c:IsFaceup() and c:IsAbleToHand()
end
function c71280048.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and c71280048.tgfilter(chkc) end
	local ct=math.floor(Duel.GetMatchingGroupCount(c71280048.cfilter,tp,LOCATION_GRAVE,0,nil)/3)
	if chk==0 then return ct>0 and Duel.IsExistingTarget(c71280048.tgfilter,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=Duel.SelectTarget(tp,c71280048.tgfilter,tp,0,LOCATION_ONFIELD,1,ct,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,g:GetCount(),0,0)
end
function c71280048.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if g:GetCount()>0 then
		local tg=Duel.GetMatchingGroup(aux.NecroValleyFilter(c71280048.cfilter),tp,LOCATION_GRAVE,0,nil)
		local ct=tg:GetCount()/3
		if ct>=g:GetCount() then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
			local sg=tg:Select(tp,g:GetCount()*3,g:GetCount()*3,nil)
			if sg:GetCount()>0 then Duel.SendtoDeck(sg,nil,SEQ_DECKSHUFFLE,REASON_EFFECT) end
			local dg=Duel.GetOperatedGroup()
			if dg:IsExists(Card.IsLocation,1,nil,LOCATION_DECK) then Duel.ShuffleDeck(tp) end
			local ctd=dg:FilterCount(Card.IsLocation,nil,LOCATION_DECK+LOCATION_EXTRA)
			if ctd>0 then
				Duel.BreakEffect()
				Duel.SendtoHand(g,nil,REASON_EFFECT)
			end
		end
	end
end
function c71280048.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetDecktopGroup(1-tp,1):FilterCount(Card.IsAbleToRemove,nil)>0 end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,1-tp,LOCATION_DECK)
end
function c71280048.rmop(e,tp,eg,ep,ev,re,r,rp)
	local ct1=3
	local ct2=Duel.GetDecktopGroup(1-tp,ct1):FilterCount(Card.IsAbleToRemove,nil)
	if ct1>0 and ct2>0 then
		local num={}
		local i=1
		while i<=ct1 and i<=ct2 do
			num[i]=i
			i=i+1
		end
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(71280048,2))
		local ct=Duel.AnnounceNumber(tp,table.unpack(num))
		local g=Duel.GetDecktopGroup(1-tp,ct)
		Duel.DisableShuffleCheck()
		Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
	end
end
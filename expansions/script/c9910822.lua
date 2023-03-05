--曙龙重演之星辰
function c9910822.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TODECK)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetTarget(c9910822.target)
	e1:SetOperation(c9910822.activate)
	c:RegisterEffect(e1)
end
function c9910822.tdfilter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToDeck()
end
function c9910822.filter(c)
	return c:IsFaceup() and c:IsSetCard(0x5954)
end
function c9910822.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then return Duel.IsExistingTarget(c9910822.tdfilter,tp,LOCATION_ONFIELD,0,1,e:GetHandler())
		and Duel.IsExistingTarget(c9910822.tdfilter,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g1=Duel.SelectTarget(tp,c9910822.tdfilter,tp,LOCATION_ONFIELD,0,1,1,e:GetHandler())
	local tc=g1:GetFirst()
	local res=tc:IsFaceup() and bit.band(tc:GetOriginalType(),0x81)==0x81
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g2=Duel.SelectTarget(tp,c9910822.tdfilter,tp,0,LOCATION_ONFIELD,1,2,nil)
	g1:Merge(g2)
	local tep=nil
	if Duel.GetCurrentChain()>1 then tep=Duel.GetChainInfo(Duel.GetCurrentChain()-1,CHAININFO_TRIGGERING_PLAYER) end
	if e:IsHasType(EFFECT_TYPE_ACTIVATE) and res and tep and tep==1-tp then
		e:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW+CATEGORY_DESTROY)
		e:SetLabel(1)
	else
		e:SetCategory(CATEGORY_TODECK)
		e:SetLabel(0)
	end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g1,g1:GetCount(),0,0)
end
function c9910822.activate(e,tp,eg,ep,ev,re,r,rp)
	local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local g=tg:Filter(Card.IsRelateToEffect,nil,e)
	if #g>0 and Duel.SendtoDeck(g,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)~=0 and e:GetLabel()==1 then
		local ct=Duel.GetCurrentChain()
		if ct<2 then return end
		local te,tep=Duel.GetChainInfo(ct-1,CHAININFO_TRIGGERING_EFFECT,CHAININFO_TRIGGERING_PLAYER)
		if tep==1-tp and Duel.IsPlayerCanDraw(tp,1) and Duel.IsPlayerCanDraw(1-tp,1)
			and Duel.SelectYesNo(tp,aux.Stringid(9910822,0)) then
			Duel.BreakEffect()
			local sg=Group.CreateGroup()
			Duel.ChangeTargetCard(ct-1,sg)
			Duel.ChangeChainOperation(ct-1,c9910822.repop)
		end
	end
end
function c9910822.repop(e,tp,eg,ep,ev,re,r,rp)
	local h1=Duel.Draw(tp,1,REASON_EFFECT)
	local h2=Duel.Draw(1-tp,1,REASON_EFFECT)
	if h1>0 or h2>0 then Duel.BreakEffect() end
	if h1>0 then
		Duel.ShuffleHand(tp)
		local g1=Duel.SelectMatchingCard(tp,aux.TRUE,tp,LOCATION_HAND,0,1,1,nil)
		Duel.Destroy(g1,REASON_EFFECT)
	end
	if h2>0 then
		Duel.ShuffleHand(1-tp)
		local g2=Duel.SelectMatchingCard(1-tp,aux.TRUE,1-tp,LOCATION_HAND,0,1,1,nil)
		Duel.Destroy(g2,REASON_EFFECT)
	end
end

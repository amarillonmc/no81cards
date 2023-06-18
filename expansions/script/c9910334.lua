--神树勇者的交心
function c9910334.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_HANDES+CATEGORY_TODECK)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c9910334.target)
	e1:SetOperation(c9910334.activate)
	c:RegisterEffect(e1)
	--to deck
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_SZONE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1)
	e2:SetTarget(c9910334.tdtg)
	e2:SetOperation(c9910334.tdop)
	c:RegisterEffect(e2)
end
function c9910334.cfilter(c)
	return c:IsSetCard(0x3956) and c:IsType(TYPE_MONSTER) and c:IsDiscardable(REASON_EFFECT)
end
function c9910334.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9910334.cfilter,tp,LOCATION_HAND,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_HANDES,nil,0,tp,1)
end
function c9910334.setfilter(c)
	return c:IsSetCard(0x3956) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsSSetable() and not c:IsCode(9910334)
end
function c9910334.activate(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local hg=Duel.GetMatchingGroup(c9910334.cfilter,tp,LOCATION_HAND,0,nil)
	if hg:GetCount()==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
	aux.GCheckAdditional=aux.dncheck
	local dg=hg:SelectSubGroup(tp,aux.TRUE,false,1,2)
	aux.GCheckAdditional=nil
	local ct=Duel.SendtoGrave(dg,REASON_EFFECT+REASON_DISCARD)
	if ct==0 then return end
	local g1=Duel.GetMatchingGroup(c9910334.setfilter,tp,LOCATION_DECK,0,nil)
	local g2=Duel.GetMatchingGroup(Card.IsAbleToDeck,tp,0,LOCATION_ONFIELD,nil)
	if ct==1 and #g1+#g2>0 and Duel.SelectYesNo(tp,aux.Stringid(9910334,0)) then
		Duel.BreakEffect()
		if #g1>0 and (#g2==0 or Duel.SelectOption(tp,aux.Stringid(9910334,1),aux.Stringid(9910334,2))==0) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
			local sg1=g1:Select(tp,1,1,nil)
			Duel.SSet(tp,sg1)
		else
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
			local sg2=g2:Select(tp,1,1,nil)
			Duel.HintSelection(sg2)
			Duel.SendtoDeck(sg2,nil,2,REASON_EFFECT)
		end
	end
	if ct==2 and #g1*#g2>0 and Duel.SelectYesNo(tp,aux.Stringid(9910334,0)) then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
		local sg1=g1:Select(tp,1,1,nil)
		Duel.SSet(tp,sg1)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		local sg2=g2:Select(tp,1,1,nil)
		Duel.HintSelection(sg2)
		Duel.SendtoDeck(sg2,nil,2,REASON_EFFECT)
	end
end
function c9910334.tdfilter(c)
	return c:IsSetCard(0x3956) and c:IsAbleToDeck()
end
function c9910334.tdtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c9910334.tdfilter(chkc) end
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1)
		and Duel.IsExistingTarget(c9910334.tdfilter,tp,LOCATION_GRAVE,0,3,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,c9910334.tdfilter,tp,LOCATION_GRAVE,0,3,3,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,g:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c9910334.tdop(e,tp,eg,ep,ev,re,r,rp)
	local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if #tg==0 then return end
	Duel.SendtoDeck(tg,nil,0,REASON_EFFECT)
	local g=Duel.GetOperatedGroup()
	if g:IsExists(Card.IsLocation,1,nil,LOCATION_DECK) then Duel.ShuffleDeck(tp) end
	local ct=g:FilterCount(Card.IsLocation,nil,LOCATION_DECK+LOCATION_EXTRA)
	if ct>0 then
		Duel.BreakEffect()
		Duel.Draw(tp,1,REASON_EFFECT)
	end
end

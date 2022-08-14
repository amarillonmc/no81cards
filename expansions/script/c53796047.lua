local m=53796047
local cm=_G["c"..m]
cm.name="演剧黑市"
function cm.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
end
function cm.cfilter(c,type)
	return c:IsFaceup() and c:IsType(type)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local ct1,ct2=0,0
	for i,type in ipairs({TYPE_FUSION,TYPE_RITUAL,TYPE_SYNCHRO,TYPE_XYZ,TYPE_LINK}) do
		if Duel.IsExistingMatchingCard(cm.cfilter,tp,LOCATION_MZONE,0,1,nil,type) then ct1=ct1+1 end
		if Duel.IsExistingMatchingCard(cm.cfilter,tp,0,LOCATION_MZONE,1,nil,type) then ct2=ct2+1 end
	end
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToDeck,tp,LOCATION_HAND,0,ct1,nil) and Duel.IsPlayerCanDraw(tp,ct2) end
	Duel.SetTargetPlayer(tp)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,ct1,tp,LOCATION_HAND)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,ct2)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	local ct1,ct2=0,0
	for i,type in ipairs({TYPE_FUSION,TYPE_RITUAL,TYPE_SYNCHRO,TYPE_XYZ,TYPE_LINK}) do
		if Duel.IsExistingMatchingCard(cm.cfilter,p,LOCATION_MZONE,0,1,nil,type) then ct1=ct1+1 end
		if Duel.IsExistingMatchingCard(cm.cfilter,p,0,LOCATION_MZONE,1,nil,type) then ct2=ct2+1 end
	end
	Duel.Hint(HINT_SELECTMSG,p,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(p,Card.IsAbleToDeck,p,LOCATION_HAND,0,ct1,ct1,nil)
	if #g>0 then
		Duel.SendtoDeck(g,nil,0,REASON_EFFECT)
		local og=Duel.GetOperatedGroup()
		local ct=og:FilterCount(Card.IsLocation,nil,LOCATION_DECK)
		if ct==0 then return end
		Duel.SortDecktop(p,p,ct)
		for i=1,ct do
			local mg=Duel.GetDecktopGroup(p,1)
			Duel.MoveSequence(mg:GetFirst(),1)
		end
		Duel.BreakEffect()
		Duel.Draw(p,ct2,REASON_EFFECT)
	end
end

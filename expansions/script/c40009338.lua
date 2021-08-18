--自者封龙
local m=40009338
local cm=_G["c"..m]
cm.named_with_SealDragon=1
function cm.initial_effect(c)
	--search
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(cm.tdtg1)
	e1:SetOperation(cm.tdop1)
	c:RegisterEffect(e1)
	--search
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,1))
	e2:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(cm.tdtg2)
	e2:SetOperation(cm.tdop2)
	c:RegisterEffect(e2)	
end
function cm.SealDragon(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_SealDragon
end
function cm.tdfilter1(c)
	return cm.SealDragon(c) and c:IsType(TYPE_MONSTER) and c:IsAbleToDeck()
end
function cm.tdtg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp)
		and Duel.IsExistingMatchingCard(cm.tdfilter1,tp,LOCATION_GRAVE,0,1,e:GetHandler()) end
	local g=Duel.GetMatchingGroup(cm.tdfilter1,tp,LOCATION_GRAVE,0,e:GetHandler())
	Duel.SetTargetPlayer(tp)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,g:GetCount(),0,0)
end
function cm.tdop1(e,tp,eg,ep,ev,re,r,rp)
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	local g=Duel.GetMatchingGroup(cm.tdfilter1,p,LOCATION_GRAVE,0,nil)
	if g:GetCount()>0 then
		local ct=Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
		Duel.ShuffleDeck(p)
		Duel.BreakEffect()
		local d=math.floor(ct/3)
		Duel.Draw(p,d,REASON_EFFECT)
	end
end
function cm.tdfilter2(c)
	return c:IsFaceup() and cm.SealDragon(c) and c:IsType(TYPE_MONSTER) and c:IsAbleToDeck()
end
function cm.tdtg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp)
		and Duel.IsExistingMatchingCard(cm.tdfilter2,tp,LOCATION_REMOVED,0,1,e:GetHandler()) end
	local g=Duel.GetMatchingGroup(cm.tdfilter2,tp,LOCATION_REMOVED,0,e:GetHandler())
	Duel.SetTargetPlayer(tp)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,g:GetCount(),0,0)
end
function cm.tdop2(e,tp,eg,ep,ev,re,r,rp)
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	local g=Duel.GetMatchingGroup(cm.tdfilter2,p,LOCATION_REMOVED,0,nil)
	if g:GetCount()>0 then
		local ct=Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
		Duel.ShuffleDeck(p)
		Duel.BreakEffect()
		local d=math.floor(ct/3)
		Duel.Draw(p,d,REASON_EFFECT)
	end
end
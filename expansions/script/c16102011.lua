--SCP-2000 机械降神
if not pcall(function() require("expansions/script/c16101100") end) then require("script/c16101100") end
local m,cm=rscf.DefineCard(16102011,"SCP")
c16102011.dfc_front_side=16102011
c16102011.dfc_back_side=16102012
function c16102011.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,16102011+EFFECT_COUNT_CODE_DUEL+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(cm.target1)
	c:RegisterEffect(e1)
	--Activate
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(16102011,1))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1)
	e2:SetCondition(cm.condition)
	e2:SetTarget(cm.target)
	e2:SetOperation(cm.operation)
	c:RegisterEffect(e2)
end
function cm.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetLP(tp)<=1000 or Duel.GetLP(1-tp)<=1000
end
function cm.tdfilter(c)
	return (c:IsLocation(0x1e) or c:IsLocation(LOCATION_REMOVED) or (c:IsFaceup() and c:IsType(TYPE_PENDULUM))) and c:IsAbleToDeck()
end
function cm.target1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetChainLimit(aux.FALSE)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(cm.tdfilter,tp,0x7e,0x7e,e:GetHandler())
	if chk==0 then return g:GetCount()>0 and Duel.IsPlayerCanDraw(tp) and Duel.IsPlayerCanDraw(1-tp) end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,g:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,5,0,0)
	Duel.SetChainLimit(aux.FALSE)
end
function cm.sfilter(c,tp)
	return c:IsLocation(LOCATION_DECK) and c:IsControler(tp)
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tg=Duel.GetMatchingGroup(aux.NecroValleyFilter(cm.tdfilter),tp,0x7e,0x7e,e:GetHandler())
	Duel.SendtoDeck(tg,nil,0,REASON_EFFECT)
	local g=Duel.GetOperatedGroup()
	if g:IsExists(cm.sfilter,1,nil,tp) then Duel.ShuffleDeck(tp) end
	if g:IsExists(cm.sfilter,1,nil,1-tp) then Duel.ShuffleDeck(1-tp) end
	local ct=g:FilterCount(Card.IsLocation,nil,LOCATION_DECK+LOCATION_EXTRA)
	if ct>0 and Duel.Draw(tp,5,REASON_EFFECT)==5 and Duel.Draw(1-tp,5,REASON_EFFECT)==5 then
		Duel.SetLP(tp,8000)
		Duel.SetLP(1-tp,8000)
		if not Duel.SelectYesNo(tp,aux.Stringid(m,0))  then return end
		local tcode=c.dfc_back_side
		c:SetEntityCode(tcode,true)
		c:ReplaceEffect(tcode,0,0)
		Duel.Hint(HINT_CARD,1,m+1)
	end
end
--强欲与强欲与强欲之壶
local m=33712019
local cm=_G["c"..m]
function cm.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetCost(cm.cost)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local num=Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)
	if chk==0 then  return Duel.IsPlayerCanDraw(tp,num) end
	Duel.Draw(tp,num,REASON_COST)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local a=Duel.IsPlayerCanDraw(tp,2) and Duel.IsExistingMatchingCard(aux.TRUE,tp,0,LOCATION_DECK,1,nil)
	local b=Duel.IsPlayerCanDraw(tp,202) and not Duel.IsExistingMatchingCard(aux.TRUE,tp,0,LOCATION_DECK,1,nil)
	if chk==0 then return a or b end
	local num=2
	if not Duel.IsExistingMatchingCard(aux.TRUE,tp,0,LOCATION_DECK,1,nil) then
		num=202
	end
	Duel.SetTargetParam(num)
	Duel.SetTargetPlayer(tp)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,num,tp,0)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end
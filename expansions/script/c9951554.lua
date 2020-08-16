--等离子火花燃烧
function c9951554.initial_effect(c)
	  --Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(c9951554.cost)
	e1:SetTarget(c9951554.target)
	e1:SetOperation(c9951554.operation)
	c:RegisterEffect(e1)
end
function c9951554.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(nil,tp,LOCATION_HAND+LOCATION_ONFIELD,LOCATION_HAND+LOCATION_ONFIELD,e:GetHandler())
	if chk==0 then return g:GetCount()>0 and g:GetCount()==g:FilterCount(Card.IsAbleToRemoveAsCost,nil) end
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c9951554.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp) end
	local ht=Duel.GetFieldGroupCount(tp,LOCATION_HAND,LOCATION_HAND)
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(2-ht)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,PLAYER_ALL,2-ht)
end
function c9951554.operation(e,tp,eg,ep,ev,re,r,rp)
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	local ht=Duel.GetFieldGroupCount(p,LOCATION_HAND,LOCATION_HAND)
	if ht<2 then
		Duel.Draw(p,2-ht,REASON_EFFECT)
		Duel.Draw(1-p,2-ht,REASON_EFFECT)
	end
end


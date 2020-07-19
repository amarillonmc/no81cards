--平行公设
function c31400006.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,31400006+EFFECT_COUNT_CODE_OATH)
	e1:SetCost(c31400006.cost)
	e1:SetTarget(c31400006.target)
	e1:SetOperation(c31400006.activate)
	c:RegisterEffect(e1)
end
function c31400006.filter(c)
	return (c:IsLocation(LOCATION_HAND) or c:IsFaceup()) and c:IsLevel(5)
end
function c31400006.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c31400006.filter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,nil) end
end
function c31400006.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,2) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(2)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,2)
end
function c31400006.activate(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
	local g=Duel.SelectMatchingCard(tp,c31400006.filter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,1,nil)
	Duel.Destroy(g,REASON_EFFECT)
end

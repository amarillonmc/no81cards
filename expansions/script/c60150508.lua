--幻想的代价
function c60150508.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(c60150508.cost)
	e1:SetTarget(c60150508.target)
	e1:SetOperation(c60150508.activate)
	c:RegisterEffect(e1)
end
function c60150508.filter(c)
	return c:GetLevel()==10 and c:IsDiscardable()
end
function c60150508.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c60150508.filter,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,c60150508.filter,1,1,REASON_COST+REASON_DISCARD)
end
function c60150508.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,2) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(2)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,2)
end
function c60150508.activate(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c60150508.splimit)
	Duel.RegisterEffect(e1,tp)
end
function c60150508.splimit(e,c)
	return c:IsLocation(LOCATION_HAND+LOCATION_GRAVE+LOCATION_DECK)
end
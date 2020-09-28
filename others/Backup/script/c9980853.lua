--撒 ，show time!
function c9980853.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCountLimit(1,9980853+EFFECT_COUNT_CODE_OATH)
	e1:SetCost(c9980853.cost)
	e1:SetTarget(c9980853.target)
	e1:SetOperation(c9980853.activate)
	c:RegisterEffect(e1)
end
function c9980853.cfilter(c)
	return c:IsSetCard(0x5bc2) and c:IsType(TYPE_RITUAL) and c:IsAbleToGraveAsCost()
end
function c9980853.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9980853.cfilter,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,c9980853.cfilter,1,1,REASON_COST,nil)
end
function c9980853.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,2) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(2)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,2)
end
function c9980853.tgfilter(c)
	return c:IsSetCard(0x5bc2) and c:IsType(TYPE_RITUAL) and c:IsAbleToGrave()
end
function c9980853.activate(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	local dr=Duel.Draw(p,d,REASON_EFFECT)
	local g=Duel.GetMatchingGroup(c9980853.tgfilter,p,LOCATION_DECK,0,nil)
	if dr~=0 and g:GetCount()>0 and Duel.SelectYesNo(p,aux.Stringid(9980853,0)) then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,p,HINTMSG_TOGRAVE)
		local sg=g:Select(p,1,1,nil)
		Duel.SendtoGrave(sg,REASON_EFFECT)
	end
	Duel.Hint(HINT_MUSIC,0,aux.Stringid(9980853,1))
end

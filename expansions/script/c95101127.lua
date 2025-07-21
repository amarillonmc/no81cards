--休酣的黑之魂
function c95101127.initial_effect(c)
	aux.AddCodeList(c,95101001)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCountLimit(1,95101127+EFFECT_COUNT_CODE_OATH)
	e1:SetCost(c95101127.cost)
	e1:SetTarget(c95101127.target)
	e1:SetOperation(c95101127.activate)
	c:RegisterEffect(e1)
end
function c95101127.costfilter(c)
	return aux.IsCodeListed(c,95101001) and c:IsAbleToHandAsCost()
end
function c95101127.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c95101127.costfilter,tp,LOCATION_PZONE,0,1,nil) end
	local g=Duel.SelectMatchingCard(tp,c95101127.costfilter,tp,LOCATION_PZONE,0,1,1,nil)
	Duel.SendtoHand(g,nil,REASON_COST)
end
function c95101127.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,tp,400)
end
function c95101127.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,2) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(2)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,2)
	Duel.SetOperationInfo(0,CATEGORY_HANDES,nil,0,tp,1)
end
function c95101127.activate(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	if Duel.Draw(p,d,REASON_EFFECT)==2 then
		Duel.ShuffleHand(p)
		Duel.BreakEffect()
		Duel.DiscardHand(p,nil,1,1,REASON_EFFECT+REASON_DISCARD)
	end
end

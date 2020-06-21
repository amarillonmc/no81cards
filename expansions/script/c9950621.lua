--咕噜灵波？
function c9950621.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,9950621+EFFECT_COUNT_CODE_OATH)
	e1:SetCost(c9950621.cost)
	e1:SetTarget(c9950621.target)
	e1:SetOperation(c9950621.activate)
	c:RegisterEffect(e1)
end
function c9950621.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.PayLPCost(tp,math.floor(Duel.GetLP(tp)/2))
end
function c9950621.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,2) and Duel.IsPlayerCanDraw(1-tp,2) end
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,PLAYER_ALL,2)
	if e:IsHasType(EFFECT_TYPE_ACTIVATE) then
		Duel.SetChainLimit(c9950621.chlimit)
	end
end
function c9950621.chlimit(e,ep,tp)
	return tp==ep
end
function c9950621.activate(e,tp,eg,ep,ev,re,r,rp)
	local d1=Duel.Draw(tp,2,REASON_EFFECT)
	local d2=Duel.Draw(1-tp,2,REASON_EFFECT)
end


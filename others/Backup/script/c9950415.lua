--至高神的蔑视
function c9950415.initial_effect(c)
	 --Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,9950415+EFFECT_COUNT_CODE_OATH)
	e1:SetCost(c9950415.cost)
	e1:SetOperation(c9950415.activate)
	c:RegisterEffect(e1)
end
function c9950415.costfilter(c)
	return c:IsSetCard(0xba5) and c:IsType(TYPE_MONSTER) and c:IsDiscardable()
end
function c9950415.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9950415.costfilter,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,c9950415.costfilter,1,1,REASON_COST+REASON_DISCARD,nil)
end
function c9950415.activate(e,tp,eg,ep,ev,re,r,rp)
		local c=e:GetHandler()
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetTargetRange(0,1)
		e1:SetCode(EFFECT_SKIP_BP)
		e1:SetReset(RESET_PHASE+PHASE_BATTLE+RESET_OPPO_TURN)
		Duel.RegisterEffect(e1,tp)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetTargetRange(0,1)
		e1:SetCode(EFFECT_SKIP_DP)
		e1:SetReset(RESET_PHASE+PHASE_DRAW+RESET_OPPO_TURN)
		Duel.RegisterEffect(e1,tp)
end



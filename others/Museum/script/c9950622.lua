--咕噜灵波！
function c9950622.initial_effect(c)
	--damage
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCategory(CATEGORY_DAMAGE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_PLAYER_TARGET)
	e1:SetHintTiming(TIMING_DAMAGE_STEP)
	e1:SetCountLimit(1,9950622+EFFECT_COUNT_CODE_OATH)
	e1:SetCost(c9950622.cost)
	e1:SetTarget(c9950622.damtg)
	e1:SetOperation(c9950622.damop)
	c:RegisterEffect(e1)
end
function c9950622.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.PayLPCost(tp,math.floor(Duel.GetLP(tp)/2))
end
function c9950622.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(1-tp)
	Duel.SetTargetParam(3000)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,3000)
	if e:IsHasType(EFFECT_TYPE_ACTIVATE) then
		Duel.SetChainLimit(c9950622.chlimit)
	end
end
function c9950622.chlimit(e,ep,tp)
	return tp==ep
end
function c9950622.damop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Damage(p,d,REASON_EFFECT)
end

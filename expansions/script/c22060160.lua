--异天枝-米迦勒
function c22060160.initial_effect(c)
	--draw
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(22060160,0))
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,22060160)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
	e1:SetCondition(c22060160.spcon2)
	e1:SetCost(c22060160.cost)
	e1:SetTarget(c22060160.target)
	e1:SetOperation(c22060160.operation)
	c:RegisterEffect(e1)
end
function c22060160.spcon2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=tp and (Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2)
end
function c22060160.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsDiscardable() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST+REASON_DISCARD)
end
function c22060160.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(1-tp,6) end
	Duel.SetTargetPlayer(1-tp)
	Duel.SetTargetParam(6)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,1-tp,6)
end
function c22060160.operation(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
	local e3=Effect.CreateEffect(e:GetHandler())
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_PHASE+PHASE_END)
	e3:SetCountLimit(1)
	e3:SetReset(RESET_PHASE+PHASE_END)
	e3:SetOperation(c22060160.tgop)
	Duel.RegisterEffect(e3,tp)
end
function c22060160.tgop(e,tp,eg,ep,ev,re,r,rp)
	local g2=Duel.GetFieldGroup(1-tp,LOCATION_HAND,0)
	Duel.SendtoGrave(g2,REASON_EFFECT)
end

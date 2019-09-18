--救星的决意
function c33701075.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(c33701075.cost)
	e1:SetTarget(c33701075.target)
	e1:SetOperation(c33701075.activate)
	c:RegisterEffect(e1)
end
function c33701075.filter(c)
	return c:IsFaceup() and c:IsSetCard(0x6440)
end
function c33701075.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroup(tp,c33701075.filter,1,nil) or Duel.IsCanRemoveCounter(tp,1,1,0x1021,2,REASON_COST) end
	local g=Duel.SelectReleaseGroup(tp,c33701075.filter,1,1,nil)
	Duel.Release(g,REASON_COST)
	Duel.RemoveCounter(tp,1,1,0x1021,2,REASON_COST)
end
function c33701075.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,2) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(2)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,2)
end
function c33701075.activate(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
	local cph = Duel.GetCurrentPhase()
	local turn = {PHASE_STANDBY,PHASE_MAIN1,PHASE_BATTLE,PHASE_MAIN2,PHASE_END}
	for _,ph in pairs(turn) do
		if cph <= ph then
			Duel.SkipPhase(Duel.GetTurnPlayer(),ph,RESET_PHASE+PHASE_END,1)
		end
	end
	Duel.Hint(HINT_MUSIC,0,aux.Stringid(33701075,0))
end
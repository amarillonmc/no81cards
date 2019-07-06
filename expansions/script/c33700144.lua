--多面手的祝福
function c33700144.initial_effect(c)
	 --Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,33700144+EFFECT_COUNT_CODE_OATH)
	e1:SetCost(c33700144.cost)
	e1:SetTarget(c33700144.target)
	e1:SetOperation(c33700144.activate)
	c:RegisterEffect(e1)
end
function c33700144.filter(c)
	return c:IsType(TYPE_TOKEN)
end
function c33700144.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroup(tp,c33700144.filter,2,nil) end
	 local g=Duel.SelectReleaseGroup(tp,c33700144.filter,2,2,nil)
	Duel.Release(g,REASON_COST)
end
function c33700144.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,2) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(2)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,2)
end
function c33700144.activate(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end

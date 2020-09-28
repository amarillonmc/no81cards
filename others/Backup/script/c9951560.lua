--力量贷款
function c9951560.initial_effect(c)
	 --Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,9951560+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c9951560.condition)
	e1:SetTarget(c9951560.target)
	e1:SetOperation(c9951560.activate)
	c:RegisterEffect(e1)
end
function c9951560.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetLP(tp)<=2000
end
function c9951560.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,2) end
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,2)
end
function c9951560.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLP(tp)==8000 then return end
	Duel.SetLP(tp,8000)
	Duel.Draw(tp,2,REASON_EFFECT)
end


--生命值变成8000 测试卡
function c40009243.initial_effect(c)
	--lp
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(40009243,1))
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCondition(c40009243.lpcon)
	e2:SetOperation(c40009243.lpop)
	c:RegisterEffect(e2)	
end
function c40009243.lpcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetLP(tp)~=80 
end
function c40009243.lpop(e,tp,eg,ep,ev,re,r,rp)
	Duel.SetLP(tp,80)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CHANGE_DAMAGE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetValue(0)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
--咕噜灵波
function c9950618.initial_effect(c)
	--recover
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetOperation(c9950618.recop)
	c:RegisterEffect(e1)
end
function c9950618.recop(e,tp,eg,ep,ev,re,r,rp)
		local lp=Duel.GetLP(tp)
		Duel.SetLP(tp,math.ceil(lp*2))
end

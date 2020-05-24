--咕噜灵波（物理）
function c9950619.initial_effect(c)
	--recover
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetOperation(c9950619.recop)
	c:RegisterEffect(e1)
end
function c9950619.recop(e,tp,eg,ep,ev,re,r,rp)
		local lp=Duel.GetLP(1-tp)
		Duel.SetLP(1-tp,math.ceil(lp/2))
end

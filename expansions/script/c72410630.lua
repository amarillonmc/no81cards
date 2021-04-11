--坠入天空
function c72410630.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,72410630+EFFECT_COUNT_CODE_DUEL+EFFECT_COUNT_CODE_OATH)
	e1:SetOperation(c72410630.activate)
	c:RegisterEffect(e1)
end
function c72410630.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.SetLP(tp,4000)
	--damage conversion
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_REVERSE_DAMAGE)
	e1:SetTargetRange(1,0)
	e1:SetValue(1)
	Duel.RegisterEffect(e1,tp)
	local e2=Effect.CreateEffect(e:GetHandler())
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_ADJUST)
	e2:SetOperation(c72410630.winop)
	Duel.RegisterEffect(e2,tp)
end
function c72410630.winop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLP(tp)>=8000 then
	Duel.Win(1-tp,nil)
	end
end

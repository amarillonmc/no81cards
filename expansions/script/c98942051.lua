--加速世代2
function c98942051.initial_effect(c)
	--show
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_NO_TURN_RESET+EFFECT_FLAG_INITIAL)
	e1:SetCode(EVENT_PREDRAW)
	e1:SetRange(0xff)
	e1:SetCountLimit(1,98942051+EFFECT_COUNT_CODE_DUEL)
	e1:SetOperation(c98942051.op)
	c:RegisterEffect(e1)
end
function c98942051.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_CARD,0,98942051)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_QP_ACT_IN_NTPHAND)
	e1:SetTargetRange(LOCATION_HAND,0)
	Duel.RegisterEffect(e1,tp)
end
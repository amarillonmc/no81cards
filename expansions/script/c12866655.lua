--早川家
local s,id,o=GetID()
function s.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e1:SetCode(EVENT_PREDRAW)
	e1:SetCountLimit(1,id+EFFECT_COUNT_CODE_DUEL)
	e1:SetRange(0xff)
	e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e1:SetOperation(s.op)
	c:RegisterEffect(e1)
end
function s.op(e,tp)
	Debug.Message("这张卡的lua还没有完成")
end

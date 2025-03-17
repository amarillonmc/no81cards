--龙主玉玺
local s,id,o=GetID()
function s.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e1:SetCode(EVENT_PREDRAW)
	e1:SetCountLimit(1,id+EFFECT_COUNT_CODE_DUEL)
	e1:SetRange(0xff)
	e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e1:SetOperation(function(e) Debug.Message("这张卡的lua还没有完成喵~") end)
	c:RegisterEffect(e1)
end

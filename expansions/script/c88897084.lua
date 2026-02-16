--辞旧迎新 渔人
local s,id,o=GetID()
function s.initial_effect(c)
	--normal summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,id)
	e1:SetOperation(s.op)
	c:RegisterEffect(e1)
end
function s.op(e,tp,eg,ep,ev,re,r,rp) 
	Debug.Message("新年快乐！！")
	Debug.Message("新年快乐！！")
end

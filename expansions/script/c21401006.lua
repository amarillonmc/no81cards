--大模型
local cid = c21401006
local id = 21401006
function cid.initial_effect(c)
	--level
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_MZONE+LOCATION_GRAVE+LOCATION_HAND)
	e1:SetCode(EFFECT_UPDATE_LEVEL)
	e1:SetValue(cid.lvval)
	c:RegisterEffect(e1)
end

function cid.lvval(e,c)
	local tp=c:GetControler()
	return - Duel.GetMatchingGroupCount(aux.TRUE,tp,0,LOCATION_ONFIELD+LOCATION_GRAVE,nil)
end
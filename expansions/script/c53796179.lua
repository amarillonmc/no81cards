if not require and dofile then function require(str) return dofile(str..".lua") end end
if not pcall(function() require("expansions/script/c53702500") end) then require("script/c53702500") end
local s,id,o=GetID()
function s.initial_effect(c)
	SNNM.ATTSeries(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_REMOVE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(1,0)
	e1:SetCondition(SNNM.ATTSerieslockcon(0,ATTRIBUTE_LIGHT))
	c:RegisterEffect(e1)
	local e1_1=e1:Clone()
	e1_1:SetTargetRange(0,1)
	e1_1:SetCondition(SNNM.ATTSerieslockcon(1,ATTRIBUTE_LIGHT))
	c:RegisterEffect(e1_1)
end

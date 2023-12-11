if not require and dofile then function require(str) return dofile(str..".lua") end end
if not pcall(function() require("expansions/script/c53702500") end) then require("script/c53702500") end
local s,id,o=GetID()
function s.initial_effect(c)
	SNNM.ATTSeries(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_IGNORE_RANGE+EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_TO_HAND_REDIRECT)
	e1:SetTargetRange(0xff,0xff)
	e1:SetTarget(s.rmtg)
	e1:SetValue(LOCATION_GRAVE)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_TO_DECK_REDIRECT)
	c:RegisterEffect(e2)
end
function s.rmtg(e,c)
	return Duel.IsExistingMatchingCard(function(c)return c:IsFaceup() and c:IsAttribute(ATTRIBUTE_WIND)end,c:GetReasonPlayer(),LOCATION_MZONE,0,1,nil)
end

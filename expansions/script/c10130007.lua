--幻层驱动 导流层
if not pcall(function() require("expansions/script/c10130001") end) then require("script/c10130001") end
local m=10130007
local cm=_G["c"..m]
function cm.initial_effect(c)
	local e1=rsef.ACT(c)
	local e2=rsef.FV_UPDATE(c,"def",800,aux.TargetBoolFunction(Card.IsSetCard,0xa336),{LOCATION_MZONE,0})
	local e3=rsqd.ContinuousFun(c)
	--Extra summon
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(m,0))
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetRange(LOCATION_SZONE)
	e4:SetTargetRange(LOCATION_HAND,0)
	e4:SetCode(EFFECT_EXTRA_SET_COUNT)
	c:RegisterEffect(e4)
	--Pos Change
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetCode(EFFECT_SET_POSITION)
	e5:SetRange(LOCATION_SZONE)
	e5:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0xa336))
	e5:SetTargetRange(LOCATION_MZONE,0)
	e5:SetValue(POS_FACEUP_DEFENSE)
	c:RegisterEffect(e5)
end
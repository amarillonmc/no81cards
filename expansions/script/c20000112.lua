--神裁煌印·辉煌家园
local cm,m,o=GetID()
if not pcall(function() require("expansions/script/c20000101") end) then require("script/c20000101") end
function cm.initial_effect(c)
	local e1={fu_judg.F(c,m)}
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,1))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_FZONE)
	e2:SetCountLimit(1)
	e2:SetCost(fu_judg.Fcos2)
	e2:SetTarget(fu_judg.Ftg2)
	e2:SetOperation(fu_judg.Fop2)
	c:RegisterEffect(e2)
end
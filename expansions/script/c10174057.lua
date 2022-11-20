--不死鹤
if not pcall(function() require("expansions/script/c10199990") end) then require("script/c10199990") end
local m,cm=rscf.DefineCard(10174057)
function cm.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_EXTRA_SUMMON_COUNT)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(LOCATION_HAND+LOCATION_MZONE,0)
	e1:SetTarget(aux.TargetBoolFunction(Card.IsLevel,3))
	c:RegisterEffect(e1)
	local e4=rsef.I(c,{m,1},{1,m},"sp",nil,LOCATION_GRAVE,nil,rscost.cost(cm.cfilter,"rm",LOCATION_GRAVE,0,2,2,c),rsop.target(rscf.spfilter2(),"sp"),cm.spop)   
end
function cm.cfilter(c)
	return c:IsLevel(3) and c:IsAbleToRemoveAsCost()
end
function cm.spop(e,tp)
	local c=aux.ExceptThisCard(e)
	if not c or rssf.SpecialSummon(c)<=0 then return end
	local e1=rscf.QuickBuff(c,"leave",LOCATION_REMOVED)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
end

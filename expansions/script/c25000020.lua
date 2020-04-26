--斯菲亚合成兽 吉尔伽诺伊德
if not pcall(function() require("expansions/script/c25000011") end) then require("script/c25000011") end
local m,cm=rscf.DefineCard(25000020)
function cm.initial_effect(c)
	local e1,e2,e3,e4=rsgs.FusProcFun(c,m,TYPE_SYNCHRO,"ga,th",nil,rsop.target(cm.thfilter,"th",LOCATION_GRAVE),cm.thop)
	local e5=rsef.SV_IMMUNE_EFFECT(c,cm.imval)
	local e6=rsef.SV_INDESTRUCTABLE(c,"battle",cm.indval)
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_SINGLE)
	e7:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e7:SetRange(LOCATION_MZONE)
	e7:SetCode(EFFECT_AVOID_BATTLE_DAMAGE)
	e7:SetValue(1)
	c:RegisterEffect(e7)
end
function cm.thfilter(c)
	return c:IsSetCard(0xaf2) and c:IsAbleToHand()
end
function cm.thop(e,tp)
	rsop.SelectToHand(tp,aux.NecroValleyFilter(cm.thfilter),tp,LOCATION_GRAVE,0,1,1,nil,{})
end
function cm.imval(e,re)
	return rsval.imoe(e,re) and re:IsActiveType(TYPE_MONSTER)
end
function cm.indval(e,c)
	return c:GetSummonLocation()&LOCATION_EXTRA ~=0 and c:IsSummonType(SUMMON_TYPE_SPECIAL)
end

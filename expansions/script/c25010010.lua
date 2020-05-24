--海洋之光 阿古茹
if not pcall(function() require("expansions/script/c25010001") end) then require("script/c25010001") end
local m,cm=rscf.DefineCard(25010010)
function cm.initial_effect(c)
	rsgol.GaiaSummonFun(c,m,4,cm.ovfilter,m+1,rscost.cost(Card.IsDiscardable,"dish",LOCATION_HAND))
	local e1,e2=rsef.SV_INDESTRUCTABLE(c,"battle,effect")
	local e3=rsef.QO_NEGATE(c,"neg",{1,m},nil,LOCATION_MZONE,rscon.negcon(cm.negfilter),rscost.rmxyz(1))
end
function cm.ovfilter(c)
	return c:IsFaceup() and c:IsXyzType(TYPE_NORMAL) and c:IsAttribute(ATTRIBUTE_WATER) and c:IsLevelBelow(4)
end
function cm.negfilter(e,tp,re,rp,tg,loc)
	return rp~=tp and loc&LOCATION_ONFIELD ==0 and re:IsActiveType(TYPE_SPELL+TYPE_TRAP)
end
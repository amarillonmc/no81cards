--大地之光 盖亚
if not pcall(function() require("expansions/script/c25010001") end) then require("script/c25010001") end
local m,cm=rscf.DefineCard(25010007)
function cm.initial_effect(c)
	rsgol.GaiaSummonFun(c,m,4,cm.ovfilter,m+1,rscost.cost(cm.cfilter,"tg",LOCATION_EXTRA))
	local e1=rsef.FV_LIMIT_PLAYER(c,"rm",nil,cm.rmtg,{0,1})
	local e2=rsef.QO_NEGATE(c,"neg",{1,m},nil,LOCATION_MZONE,rscon.negcon(cm.negfilter),rscost.rmxyz(1))
end
function cm.ovfilter(c)
	return c:IsFaceup() and c:IsXyzType(TYPE_NORMAL) and c:IsAttribute(ATTRIBUTE_EARTH) and c:IsLevelBelow(4)
end
function cm.cfilter(c)
	return c:IsAbleToGraveAsCost() and c:IsCode(25010010)
end
function cm.rmtg(e,c)
	return c:GetControler()==e:GetHandlerPlayer()
end
function cm.negfilter(e,tp,re,rp,tg,loc)
	return rp~=tp and loc&LOCATION_ONFIELD ==0 and re:IsActiveType(TYPE_MONSTER)
end
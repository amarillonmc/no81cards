--行星驱逐舰 风雪游隼号
if not pcall(function() require("expansions/script/c10199990") end) then require("script/c10199990") end
local m,cm=rscf.DefineCard(65020212)
function cm.initial_effect(c)
	local e1=rscf.SetSpecialSummonProduce(c,LOCATION_HAND,cm.sprcon,nil,nil,{1,m})
	local e2=rsef.QO(c,nil,{m,0},1,"tg",nil,LOCATION_MZONE,nil,nil,rsop.target2(cm.fun,cm.tgfilter,"tg",LOCATION_ONFIELD,LOCATION_ONFIELD,true),cm.tgop)
end
function cm.cfilter(c)
	return c:IsFaceup() and c:IsRace(RACE_MACHINE)
end
function cm.sprcon(e,c,tp)
	return Duel.GetFieldGroupCount(tp,0,LOCATION_MZONE)>0 and not Duel.IsExistingMatchingCard(cm.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function cm.tgfilter(c,e)
	return e:GetHandler():GetColumnGroup():IsContains(c)
end
function cm.fun(g,e,tp)
	Duel.SetChainLimit(cm.limit(e:GetHandler()))
end
function cm.limit(c)
	return function(e)
		return not c:GetColumnGroup():IsContains(e:GetHandler())
	end
end
function cm.tgop(e,tp)
	local c=aux.ExceptThisCard(e)
	if not c then return end
	local g=c:GetColumnGroup()
	Duel.SendtoGrave(g,REASON_RULE)
end
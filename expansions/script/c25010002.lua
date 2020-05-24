--光之巨人 空中迪迦
if not pcall(function() require("expansions/script/c25010001") end) then require("script/c25010001") end
local m,cm=rscf.DefineCard(25010002)
function cm.initial_effect(c)
	rsgol.TigaSummonFun(c,m,m+1,m-1,rscon.turns)
	local e1=rsef.QO(c,nil,{m,0},{1,m},"des","tg",LOCATION_MZONE,nil,nil,rstg.target(aux.FilterBoolFunction(Card.IsType,TYPE_SPELL+TYPE_TRAP),"des",0,LOCATION_ONFIELD,1,2),cm.desop)
end
function cm.desop(e,tp)
	local dg=rsgf.GetTargetGroup()
	if #dg>0 then
		Duel.Destroy(dg,REASON_EFFECT)
	end
end

--圆盘生物 阿布索巴
if not pcall(function() require("expansions/script/c25000119") end) then require("script/c25000119") end
local m,cm=rscf.DefineCard(25000127)
function cm.initial_effect(c)
	local e1=rsufo.ShowFun(c,m,nil,"td,rm",nil,nil,nil,rsop.target(cm.rmfilter,"rm",rsloc.de),cm.op,true) 
end
function cm.rmfilter(c)
	return c:IsAbleToRemove() and c:IsType(TYPE_MONSTER)
end
function cm.op(e,tp)
	local ct,ot,tc=rsop.SelectRemove(tp,cm.rmfilter,tp,rsloc.de,0,1,1,nil,{})
	if tc and tc:IsLocation(LOCATION_REMOVED) then
		local e1,e2,e3=rsef.FV_LIMIT_PLAYER({e:GetHandler(),tp},"sum,sp,fp",nil,cm.sumlimit(tc),{1,1},nil,rsreset.pend)
		rsufo.ToDeck(e,true)
	end
end
function cm.sumlimit(tc)
	return function(e,c)
		return tc:IsCode(c:GetCode())
	end
end
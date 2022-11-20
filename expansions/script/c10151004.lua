--领空飞越
if not pcall(function() require("expansions/script/c10199990") end) then require("script/c10199990") end
local m,cm=rscf.DefineCard(10151004)
function cm.initial_effect(c)
	local e1=rsef.ACT(c,nil,nil,{1,m,1},"des","tg",nil,nil,rstg.target2(cm.fun,{cm.cfilter,cm.gcheck},nil,LOCATION_MZONE,LOCATION_MZONE,2),cm.act)
end
function cm.cfilter(c)
	return c:IsPosition(POS_FACEUP_ATTACK)
end
function cm.gcheck(g)
	return rsgf.dnpcheck(g) and g:GetClassCount(aux.GetColumn)==1
end
function cm.fun(g,e,tp)
	local dg=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_MZONE,LOCATION_MZONE,g)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,dg,#dg,0,0)
end
function cm.act(e,tp)
	local c=e:GetHandler()
	local tg=rsgf.GetTargetGroup()
	if #tg~=2 then return end
	local dg=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_MZONE,LOCATION_MZONE,tg)
	if #dg>0 then
		Duel.Destroy(dg,REASON_EFFECT)
	end
	for tc in aux.Next(tg) do
		local e1=rsef.SV_IMMUNE_EFFECT({c,tc},rsval.imes,nil,rsreset.est_pend,"ch",{m,0})
		local e2=rsef.SV_INDESTRUCTABLE({c,tc},"battle",nil,nil,rsreset.est_pend,"ch",{m,1})
	end
end
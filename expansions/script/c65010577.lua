--粉彩调色板大革命☆
if not pcall(function() require("expansions/script/c10199990") end) then require("script/c10199990") end
local m,cm=rscf.DefineCard(65010577,"TianZhi")
function cm.initial_effect(c)
	local e1=rsef.ACT(c,nil,nil,nil,"sp",nil,cm.con,nil,rsop.target(cm.spfilter,"sp",LOCATION_GRAVE,LOCATION_GRAVE),cm.act)
end
function cm.gettype(c)
	return c:GetType() & (rscf.extype_r)
end
function cm.con(e,tp)
	local g=Duel.GetMatchingGroup(Card.IsType,tp,LOCATION_GRAVE,LOCATION_GRAVE,nil,rscf.extype_r)
	return g:GetClassCount(cm.gettype)>=5
end
function cm.spfilter(c,e,tp)
	return c:IsType(rscf.extype_r) and c:IsCanBeSpecialSummoned(e,0,tp,true,false,POS_FACEUP) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
end
function cm.gcheck(g)
	for tc in aux.Next(g) do
		for _,ctype in ipairs(rscf.exlist_r) do 
			if tc:IsType(ctype) and g:IsExists(Card.IsType,1,tc,ctype) then return false end
		end
	end
	return true
end
function cm.act(e,tp)
	local sg=Duel.GetMatchingGroup(aux.NecroValleyFilter(cm.spfilter),tp,LOCATION_GRAVE,LOCATION_GRAVE,nil,e,tp)
	if #sg<=0 then return end
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if ft==0 then return end
	if rscon.bsdcheck(tp) then ft=1 end
	rshint.Select(tp,"sp")
	local sg2=sg:SelectSubGroup(tp,cm.gcheck,false,1,math.min(ft,5))
	Duel.SpecialSummon(sg2,0,tp,tp,true,false,POS_FACEUP)
end
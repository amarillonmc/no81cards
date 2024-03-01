--火之终结
if not pcall(function() dofile("expansions/script/c10171001.lua") end) then dofile("script/c10171001.lua") end
local m,cm=rscf.DefineCard(10171019)
function cm.initial_effect(c)
	local e1=rsef.ACT(c,nil,nil,{1,m},"td",nil,nil,nil,rsop.target(cm.tdfilter,"td",rsloc.de),cm.act)
	local e2=rsef.QO(c,nil,{m,0},{1,m},"sp,dam",nil,LOCATION_GRAVE,nil,aux.bfgcost,rsop.target2(cm.fun,cm.rmfilter,"rm",rsloc.mg,0,true),cm.damop)
end
function cm.tdfilter(c)
	return c:IsCode(m-18) or (c:IsType(TYPE_MONSTER) and c:IsSetCard(0xc335)) and c:IsAbleToGrave()
end
function cm.act(e,tp)
	rsop.SelectToGrave(tp,cm.tdfilter,tp,rsloc.de,0,1,3,nil,{})
end
function cm.rmfilter(c)
	return c:IsFaceup() and (c:IsCode(m-18) or c:IsSetCard(0xc335)) and c:IsType(TYPE_MONSTER) and c:IsAbleToRemove()
end
function cm.fun(g,e,tp)
	local g=Duel.GetMatchingGroup(cm.rmfilter,tp,rsloc.mg,0,nil)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,tp,#g*400)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,0,tp,LOCATION_EXTRA)
end
function cm.spfilter(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsCode(m-2) and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0
end
function cm.damop(e,tp)
	local g=Duel.GetMatchingGroup(cm.rmfilter,tp,rsloc.mg,0,nil)
	if #g<=0 then return end
	local ct=Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
	if ct>0 and Duel.Damage(1-tp,ct*400,REASON_EFFECT)>0 and ct>=3 and Duel.IsExistingMatchingCard(cm.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp) and Duel.SelectYesNo(tp,aux.Stringid(m,1)) then
		rsop.SelectSpecialSummon(tp,cm.spfilter,tp,LOCATION_EXTRA,0,1,1,nil,{},e,tp)
	end
end

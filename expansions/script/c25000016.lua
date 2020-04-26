--寄生斯菲亚
if not pcall(function() require("expansions/script/c25000011") end) then require("script/c25000011") end
local m,cm=rscf.DefineCard(25000016)
function cm.initial_effect(c)
	local e1=rsef.SV_CHANGE(c,"code",25000014)
	e1:SetRange(LOCATION_MZONE)
	local e2=rsgs.FusTypeFun(c,m,TYPE_XYZ)
	local e3=rsef.FTO(c,EVENT_SPSUMMON_SUCCESS,{m,1},{1,m+100},"con,eq","de",LOCATION_HAND+LOCATION_GRAVE,cm.eqcon,nil,rsop.target2(cm.fun,cm.eqfilter,"con",0,LOCATION_MZONE),cm.eqop)
end
function cm.eqcon(e,tp,eg)
	local tc=eg:GetFirst()
	return #eg==1 and tc:GetSummonLocation()&LOCATION_EXTRA ~=0 and tc:IsSummonType(SUMMON_TYPE_SPECIAL) 
end
function cm.fun(g,e,tp,eg)
	Duel.SetTargetCard(eg:GetFirst())
end
function cm.eqfilter(c,e,tp,eg)
	return eg:IsContains(c) and c:IsControler(1-tp) and c:IsControlerCanBeChanged() and Duel.GetLocationCount(tp,LOCATION_SZONE)>0
end
function cm.eqop(e,tp)
	local c,tc=aux.ExceptThisCard(e),rscf.GetTargetCard()
	if tc and Duel.GetControl(tc,tp,0,1) and c then
		rsop.eqop(e,c,tc)
	end
end
--寄生斯菲亚
if not pcall(function() require("expansions/script/c25000011") end) then require("script/c25000011") end
local m,cm=rscf.DefineCard(25000016)
function cm.initial_effect(c)
	local e1=rsef.SV_CHANGE(c,"code",25000014)
	e1:SetRange(LOCATION_MZONE)
	local e2=rsgs.FusTypeFun(c,m,TYPE_XYZ)
	local e3=rsef.FTO(c,EVENT_SPSUMMON_SUCCESS,{m,1},{1,m+200},"ctrl,sp","de",LOCATION_HAND+LOCATION_GRAVE,cm.eqcon,rsgs.ToDeckCost(c),rsop.target2(cm.fun,cm.eqfilter,"ctrl",0,LOCATION_MZONE),cm.eqop)
end
function cm.eqcon(e,tp,eg)
	local tc=eg:GetFirst()
	return #eg==1 and tc:GetSummonLocation()&LOCATION_EXTRA ~=0 and tc:IsSummonType(SUMMON_TYPE_SPECIAL) 
end
function cm.fun(g,e,tp,eg)
	Duel.SetTargetCard(eg:GetFirst())
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function cm.eqfilter(c,e,tp,eg)
	return eg:IsContains(c) and c:IsControler(1-tp) and c:IsControlerCanBeChanged() and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetLocationCount(tp,LOCATION_MZONE)>=2
end
function cm.eqop(e,tp)
	local c,tc=aux.ExceptThisCard(e),rscf.GetTargetCard()
	if tc and Duel.GetControl(tc,tp,0,1) and c then
		rssf.SpecialSummon(c)
	end
end
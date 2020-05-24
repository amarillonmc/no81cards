--灼热斯菲亚
if not pcall(function() require("expansions/script/c25000011") end) then require("script/c25000011") end
local m,cm=rscf.DefineCard(25000015)
function cm.initial_effect(c)
	local e1=rsef.SV_CHANGE(c,"code",25000014)
	e1:SetRange(LOCATION_MZONE)
	local e2=rsgs.FusTypeFun(c,m,TYPE_SYNCHRO)
	local e3=rsef.FTO(c,EVENT_LEAVE_FIELD,{m,1},{1,m+200},"sp,dr","de",LOCATION_HAND+LOCATION_GRAVE,cm.spcon,rsgs.ToDeckCost(c),rsop.target(rscf.spfilter2(),"sp"),cm.spop)
end
function cm.cfilter(c,tp)
	return c:IsPreviousLocation(LOCATION_MZONE) and c:GetSummonLocation()==LOCATION_EXTRA and c:IsSummonType(SUMMON_TYPE_SPECIAL) and c:GetPreviousControler()~=tp
end
function cm.spcon(e,tp,eg)
	return eg:IsExists(cm.cfilter,1,nil,tp)
end
function cm.spop(e,tp)
	local c=aux.ExceptThisCard(e)
	if rssf.SpecialSummon(c)>0 and Duel.IsPlayerCanDraw(tp,2) and Duel.SelectYesNo(tp,aux.Stringid(m,2)) then
		Duel.BreakEffect()
		Duel.Draw(tp,2,REASON_EFFECT)
	end
end
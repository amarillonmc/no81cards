--光与暗的引导
if not pcall(function() require("expansions/script/c10199990") end) then require("script/c10199990") end
local m,cm=rscf.DefineCard(10150089)
function cm.initial_effect(c)
	aux.AddCodeList(c,47297616)
	local e1=rsef.ACT(c,nil,nil,{1,m},"sp",nil,nil,rscost.reglabel(100),cm.tg,cm.act)
	local e2=rsef.STO(c,EVENT_DESTROYED,{m,0},{1,m+100},"sp","de,dsp",cm.spcon,nil,rsop.target(cm.spfilter2,"sp",rsloc.hdg),cm.spop)
end
function cm.cfilter(c,e,tp)
	return c:IsReason(REASON_DESTROY) and c:IsAbleToRemoveAsCost() and c:IsLevelAbove(5) and c:IsAttribute(ATTRIBUTE_LIGHT+ATTRIBUTE_DARK) and c:GetTurnID()==Duel.GetTurnCount() and Duel.IsExistingMatchingCard(cm.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp,c) 
end
function cm.spfilter(c,e,tp,rc)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0 and c:IsAttribute(ATTRIBUTE_LIGHT+ATTRIBUTE_DARK) and c:IsLevel(rc:GetLevel()) and c:GetAttribute()~=rc:GetAttribute()
end
function cm.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetLabel()==100 and Duel.IsExistingMatchingCard(cm.cfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	e:SetLabel(0)
	rshint.Select(tp,"rm")
	local tc=Duel.SelectMatchingCard(tp,cm.cfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp):GetFirst()
	Duel.Remove(tc,POS_FACEUP,REASON_COST)
	e:SetLabelObject(tc)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function cm.act(e,tp)
	rsop.SelectSpecialSummon(tp,cm.spfilter,tp,LOCATION_EXTRA,0,1,1,nil,{},e,tp,e:GetLabelObject())
end
function cm.spcon(e,tp)
	return e:GetHandler():IsReason(REASON_EFFECT)
end
function cm.spfilter2(c,e,tp)
	return c:IsCode(47297616) and c:IsCanBeSpecialSummoned(e,0,tp,true,false) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
end
function cm.spop(e,tp)
	rsop.SelectSpecialSummon(tp,aux.NecroValleyFilter(cm.spfilter2),tp,rsloc.hdg,0,1,1,nil,{0,tp,tp,true,false,POS_FACEUP,nil,nil,{1}},e,tp)
end
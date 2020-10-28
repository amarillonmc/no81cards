--羽化的唤士
if not pcall(function() require("expansions/script/c130005101") end) then require("script/c130005101") end
local m,cm=rscf.DefineCard(130005118,"DragonCaller")
function cm.initial_effect(c)
	local e1=rsdc.HandActFun(c)
	local e2=rsef.ACT(c,nil,nil,{1,m},"sp",nil,nil,rscost.reglabel(100),cm.tg,cm.act)
	local e3=rsef.QO(c,nil,{m,0},{1,m+100},"se,th",nil,LOCATION_GRAVE,aux.exccon,aux.bfgcost,rsop.target(cm.thfilter,"th",rsloc.dg+LOCATION_REMOVED),cm.thop)
end
function cm.thfilter(c)
	return c:IsAbleToHand() and c:IsCode(130005101) and rscf.RemovePosCheck(c)
end
function cm.thop(e,tp)
	rsop.SelectToHand(tp,aux.NecroValleyFilter(cm.thfilter),tp,rsloc.dg+LOCATION_REMOVED,0,1,1,nil,{})
end
function cm.resfilter(c,e,tp)
	return rsdc.IsSetM(c) and c:IsReleasable() and Duel.IsExistingMatchingCard(cm.spfilter,tp,LOCATION_EXTRA,0,1,nil,c:GetAttribute(),e,tp)
end
function cm.spfilter(c,att,e,tp)
	return rsdc.IsSet(c) and c:IsType(TYPE_SYNCHRO) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_SYNCHRO,tp,false,false) and aux.MustMaterialCheck(nil,tp,EFFECT_MUST_BE_SMATERIAL) and c:IsAttribute(att)
end
function cm.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetLabel()==100 and Duel.IsExistingMatchingCard(cm.resfilter,tp,LOCATION_HAND,0,1,nil,e,tp) end
	e:SetLabel(0)
	local ct,og,tc=rsop.SelectRelease(tp,cm.resfilter,tp,LOCATION_HAND,0,1,1,nil,{},e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
	e:SetValue(tc:GetAttribute())
end
function cm.act(e,tp)
	local att=e:GetValue()
	if not aux.MustMaterialCheck(nil,tp,EFFECT_MUST_BE_SMATERIAL) then return end
	rsop.SelectSpecialSummon(tp,cm.spfilter,tp,LOCATION_EXTRA,0,1,1,nil,{SUMMON_TYPE_SYNCHRO,tp,tp,false,false,POS_FACEUP,nil,{"cp"}},att,e,tp)
end
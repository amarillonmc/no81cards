--零冰降临
if not pcall(function() require("expansions/script/c10199990") end) then require("script/c10199990") end
local m,cm=rscf.DefineCard(10150094)
function cm.initial_effect(c)
	local e1=rsef.ACT(c,nil,nil,{1,m,1},"rm,sp","tg",nil,nil,cm.tg,cm.act)
end
function cm.tgfilter(c,e)
	return c:IsFaceup() and c:IsType(TYPE_SYNCHRO) and c:IsAbleToRemove() and c:IsCanBeEffectTarget(e)
end
function cm.gcheck(g,e,tp)
	return Duel.IsExistingMatchingCard(cm.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp,g)
end
function cm.spfilter(c,e,tp,g)
	local og=g:Clone()
	og:AddCard(c)
	return c:IsType(TYPE_SYNCHRO) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_SYNCHRO,tp,false,false) and aux.MustMaterialCheck(nil,tp,EFFECT_MUST_BE_SMATERIAL) and Duel.GetLocationCountFromEx(tp,tp,g,c)>0 and og:GetClassCount(Card.GetAttribute)==1 and og:GetClassCount(Card.GetRace)==1
end
function cm.tg(e,tp,eg,ep,ev,re,r,rp,chk)   
	local g=Duel.GetMatchingGroup(cm.tgfilter,tp,LOCATION_MZONE,0,nil,e)
	if chk==0 then return g:CheckSubGroup(cm.gcheck,2,2,e,tp) end
	rshint.Select(tp,"rm")
	local rg=g:SelectSubGroup(tp,cm.gcheck,false,2,2,e,tp)
	Duel.SetTargetCard(rg)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,rg,#rg,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)	
end
function cm.act(e,tp)
	local rg=rsgf.GetTargetGroup()
	if #rg<2 or Duel.Remove(rg,POS_FACEUP,REASON_EFFECT)<2 or Duel.GetOperatedGroup():FilterCount(Card.IsLocation,nil,LOCATION_REMOVED)<2 or not Duel.IsExistingMatchingCard(cm.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp,rg) then return end
	rsop.SelectSpecialSummon(tp,cm.spfilter,tp,LOCATION_EXTRA,0,1,1,nil,{ SUMMON_TYPE_SYNCHRO,tp,tp,false,false,POS_FACEUP,nil,{"mat,pc"} },e,tp,rg)
end

--强敌来袭\
if not pcall(function() require("expansions/script/c10199990") end) then require("script/c10199990") end
local m,cm=rscf.DefineCard(10151006)
function cm.initial_effect(c)
	aux.AddCodeList(c,46986414,38033121)
	local e1=rsef.ACT(c,nil,nil,{1,m,1},"des","tg",nil,nil,rstg.target(aux.TRUE,"des",0,LOCATION_ONFIELD,1,cm.maxct),cm.act)
	local e2=rsef.FTO(c,EVENT_ATTACK_ANNOUNCE,{m,0},nil,"sp",nil,LOCATION_GRAVE,cm.spcon,aux.bfgcost,cm.sptg,cm.spop)
end
function cm.maxct(e,tp)
	return Duel.GetMatchingGroupCount(rscf.fufilter(Card.IsCode,46986414,38033121),tp,LOCATION_ONFIELD,0,nil)
end
function cm.act(e,tp)
	local dg=rsgf.GetTargetGroup()
	if #dg>0 then
		Duel.Destroy(dg,REASON_EFFECT)
	end
end
function cm.spcon(e,tp)
	return Duel.GetAttacker():IsControler(1-tp) and not Duel.GetAttackTarget()
end
function cm.spfilter(c,e,tp)
	return c:IsCode(46986414,38033121) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) 
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(cm.spfilter,tp,rsloc.hdg,0,nil,e,tp)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>1
		and not Duel.IsPlayerAffectedByEffect(tp,59822133)
		and g:CheckSubGroup(aux.gfcheck,2,2,Card.IsCode,46986414,38033121) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,2,tp,rsloc.hdg)
end
function cm.spop(e,tp)
	local g=Duel.GetMatchingGroup(cm.spfilter,tp,rsloc.hdg,0,nil,e,tp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=1 or Duel.IsPlayerAffectedByEffect(tp,59822133) then return end
	rshint.Select(tp,"sp")
	local sg=g:SelectSubGroup(tp,aux.gfcheck,false,2,2,Card.IsCode,46986414,38033121)
	if #sg==2 then
		rssf.SpecialSummon(sg)
	end
end
--机械恐龙军团
if not pcall(function() require("expansions/script/c10199990") end) then require("script/c10199990") end
local m,cm=rscf.DefineCard(10174046)
function cm.initial_effect(c)
	local e1=rsef.I(c,{m,0},{1,m},"sp",nil,LOCATION_HAND,nil,nil,cm.tg,cm.op)
end
function cm.spfilter(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsCode(m)
end
function cm.gfilter(g,c)
	return g:IsContains(c) and g:IsExists(Card.IsLocation,2,nil,LOCATION_HAND) 
end
function cm.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local g=Duel.GetMatchingGroup(cm.spfilter,tp,LOCATION_HAND+LOCATION_GRAVE+LOCATION_DECK,0,nil,e,tp)
	if chk==0 then return not Duel.IsPlayerAffectedByEffect(tp,59822133) and ft>=2 and g:CheckSubGroup(cm.gfilter,2,ft,c) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,2,tp,LOCATION_HAND+LOCATION_GRAVE+LOCATION_DECK)
end
function cm.op(e,tp)
	local c=aux.ExceptThisCard(e)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local g=Duel.GetMatchingGroup(cm.spfilter,tp,LOCATION_HAND+LOCATION_GRAVE+LOCATION_DECK,0,nil,e,tp)
	if not c or Duel.IsPlayerAffectedByEffect(tp,59822133) or ft<2 or #g<=0 then return end
	rshint.Select(tp,"sp")
	Duel.SetSelectedCard(c)
	local sg=g:SelectSubGroup(tp,cm.gfilter,false,2,ft,c)
	rssf.SpecialSummon(sg)
end
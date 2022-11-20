--唤狼人
if not pcall(function() require("expansions/script/c10199990") end) then require("script/c10199990") end
local s,id,o = GetID()
function s.initial_effect(c)
	aux.AddCodeList(c,10133001)
	local e1 = rsef.SV_Card(c,id,1,"sr,sa",LOCATION_HAND+LOCATION_DECK)
	local e2 = rsef.QO(c,EVENT_CHAINING,{id,0},{1,id},nil,nil,LOCATION_MZONE,
		s.cecon,rscost.cost(s.resfilter,"res"),nil,s.ceop)
	local e3 = rsef.QO(c,nil,"sp",{1,id+100},"sp",nil,LOCATION_GRAVE,nil,
		rscost.cost2(s.hint,Card.IsAbleToDeckAsCost,"td"),
		rsop.target(s.sprfilter,"sp",LOCATION_EXTRA),s.spop)
end
function s.resfilter(c,e,tp)
	return c:IsReleasable() and Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp)
end
function s.cecon(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp and (re:IsHasCategory(CATEGORY_SPECIAL_SUMMON) or re:IsHasCategory(CATEGORY_SUMMON))
end
function s.spfilter(c,e,tp)
	return c:IsCode(10133001) and rscf.spfilter()(c,e,tp) and Duel.GetLocationCountFromEx(tp,tp,e:GetHandler(),c) > 0
end
function s.ceop(e,tp,eg,ep,ev,re,r,rp)
	local g=Group.CreateGroup()
	Duel.ChangeTargetCard(ev,g)
	Duel.ChangeChainOperation(ev,s.repop)
end
function s.repop(e,tp)
	rsop.SelectSpecialSummon(1-tp,s.spfilter,1-tp,LOCATION_EXTRA,0,1,1,nil,{},e,1-tp)
end
function s.hint(g,e,tp)
	Duel.ConfirmCards(1-tp,g)
end
function s.sprfilter(c)
	return c:IsType(TYPE_FUSION) and c:IsSetCard(0x3334) and c:IsSpecialSummonable(SUMMON_VALUE_SELF)
end
function s.spop(e,tp)
	local og,tc = rsop.SelectCards("sp",tp,s.sprfilter,tp,LOCATION_EXTRA,0,1,1,nil)
	if not tc then return end
	Duel.SpecialSummonRule(tp,tc,SUMMON_VALUE_SELF)
end
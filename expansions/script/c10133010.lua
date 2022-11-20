--残虐之卢西恩
if not pcall(function() require("expansions/script/c10199990") end) then require("script/c10199990") end
local s,id,o = GetID()
function s.initial_effect(c)
	rscf.SetSummonCondition(c,false,s.slimit)
	aux.AddCodeList(c,10133001)
	aux.AddFusionProcCodeRep(c,10133001,2,false,false)
	local e0 = aux.AddContactFusionProcedure(c,Card.IsReleasable,LOCATION_ONFIELD,0,Duel.Release,REASON_COST)
	e0:SetValue(SUMMON_VALUE_SELF)
	local e1 = rsef.STO(c,EVENT_SPSUMMON_SUCCESS,"des",nil,"des","de",nil,nil,
		rsop.target(s.dfilter,"des",LOCATION_ONFIELD,LOCATION_ONFIELD,true),s.desop)
	local e2 = rsef.STO(c,EVENT_LEAVE_FIELD,"sp",nil,"sp","de",s.spcon,nil,
		rsop.target2(s.reg,s.spfilter,"dum",LOCATION_EXTRA+
		LOCATION_DECK+LOCATION_HAND),s.spop)
end
function s.slimit(e,se,sp,st)
	return not e:GetHandler():IsLocation(LOCATION_EXTRA)
end
function s.dfilter(c)
	return not c:IsLocation(LOCATION_MZONE) or not c:IsAttackPos()
end
function s.desop(e,tp)
	local g = Duel.GetMatchingGroup(s.dfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	Duel.Destroy(g,REASON_EFFECT)
end
function s.spcon(e,tp)
	local c = e:GetHandler()
	return c:IsPreviousPosition(POS_FACEUP) and c:IsPreviousControler(tp) and c:GetReasonPlayer() ~= tp
end
function s.reg(g,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function s.spfilter(c,e,tp)
	return (c:IsCode(10133001) or c:IsHasEffect(10133009)) and rscf.spfilter2()(c,e,tp)
end
function s.spop(e,tp)
	rsop.SelectSpecialSummon(tp,s.spfilter,tp,LOCATION_EXTRA+LOCATION_HAND+LOCATION_DECK,0,1,1,nil,{},e,tp)
end
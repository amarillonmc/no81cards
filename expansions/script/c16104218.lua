--March
if not pcall(function() require("expansions/script/c16104200") end) then require("script/c16104200") end
local m,cm=rk.set(16104218)
function cm.initial_effect(c)
	local e1=rsef.ACT(c,nil,nil,{1,m,1})
	local e2=rsef.I(c,{m,0},{1},"se,th",nil,LOCATION_SZONE,nil,cm.thcost,rsop.target(cm.thfilter,"th",LOCATION_DECK),cm.thop)
	local e3=rsef.QO(c,EVENT_FREE_CHAIN,{m,1},{1,m},"sum",nil,LOCATION_GRAVE,nil,aux.bfgcost,rsop.target(cm.sumfilter,"sum",LOCATION_HAND+LOCATION_PZONE),cm.sumop)
end
function cm.rlfilter(c,tp)
	local re=Duel.IsPlayerAffectedByEffect(tp,EFFECT_CANNOT_RELEASE)
	local val=nil
	if re then
		val=re:GetValue()
	end
	return c:IsReleasable() or (c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsLocation(LOCATION_HAND) and (val==nil or val(re,c)~=true))
end
function cm.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.rlfilter,tp,LOCATION_ONFIELD+LOCATION_HAND,0,1,e:GetHandler(),tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local g=Duel.SelectMatchingCard(tp,cm.rlfilter,tp,LOCATION_ONFIELD+LOCATION_HAND,0,1,1,e:GetHandler(),tp)
	Duel.Release(g,REASON_COST)
end
function cm.thfilter(c)
	return c:IsSetCard(0x3ccd) and c:IsAbleToHand()
end
function cm.thop(e,tp)
	if rscf.GetSelf(e) then
		rsop.SelectToHand(tp,cm.thfilter,tp,LOCATION_DECK,0,1,1,nil,{})
	end
end
function cm.sumfilter(c)
	if c:IsLocation(LOCATION_HAND) then
		return c:IsSummonable(true,nil)
	else
		local minc,maxc=c:GetTributeRequirement()
		return Duel.IsPlayerCanSummon(tp,SUMMON_TYPE_NORMAL,c) and Duel.CheckTribute(c,minc,maxc)
	end
end
function cm.sumop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SUMMON)
	local tc=Duel.SelectMatchingCard(tp,cm.sumfilter,tp,LOCATION_HAND+LOCATION_PZONE,0,1,1,nil):GetFirst()
	if tc then
		Duel.Summon(tp,tc,true,nil)
	end
end
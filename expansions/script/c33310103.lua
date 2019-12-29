--可可莉柯特·兽耳布偶
if not pcall(function() require("expansions/script/c10199990") end) then require("script/c10199990") end
local m,cm=rsof.DefineCard(33310103,"Cochrot")
function cm.initial_effect(c)
	c:EnableReviveLimit()
	local e1=rsef.I(c,{m,0},{1,m},"se,th,sp,dish,ga",nil,LOCATION_HAND,nil,nil,rsop.target({aux.FilterBoolFunction(Card.IsDiscardable,REASON_EFFECT),"dish",LOCATION_HAND },{cm.thfilter,"th",LOCATION_DECK }),cm.thop)
	local e2=rsef.FC(c,EVENT_SPSUMMON_SUCCESS)
	e2:SetOperation(cm.limitop)
	local e3=rsef.RegisterClone(c,e2,"code",EVENT_SUMMON_SUCCESS)
	local e4=rsef.RegisterClone(c,e2,"code",EVENT_FLIP_SUMMON_SUCCESS)
	local e5=rsef.RegisterClone(c,e2,"code",EVENT_TO_GRAVE,"op",cm.limitop2)
	local e6=rsef.STO(c,EVENT_REMOVE,{m,1},{1,m+100},"th","de,dsp",nil,nil,rsop.target(cm.thfilter2,"th",LOCATION_GRAVE),cm.thop2)
end
function cm.thfilter(c)
	return c:IsCode(33310102) and c:IsAbleToHand()
end
function cm.thop(e,tp)
	local ct=Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_EFFECT,nil,REASON_EFFECT)
	if ct==0 then return end
	rsof.SelectHint(tp,"th")
	local g=Duel.SelectMatchingCard(tp,cm.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if #g<=0 or Duel.SendtoHand(g,nil,REASON_EFFECT)<=0 then return end
	Duel.ConfirmCards(1-tp,g)
	local sg=Duel.GetMatchingGroup(aux.NecroValleyFilter(cm.spfilter),tp,0,LOCATION_GRAVE,nil,e,tp)
	if #sg>0 and Duel.SelectYesNo(tp,aux.Stringid(m,2)) then
		Duel.BreakEffect()
		rsof.SelectHint(tp,"sp")
		local sc=sg:Select(tp,1,1,nil):GetFirst()
		if Duel.SpecialSummon(sc,0,tp,1-tp,false,false,POS_FACEUP)>0 then
			local e1,e2=rsef.SV_LIMIT({e:GetHandler(),sc,true},"dis,dise",nil,nil,rsreset.est)
		end
	end
end
function cm.spfilter(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP,1-tp) and Duel.GetLocationCount(1-tp,LOCATION_MZONE)>0
end
function cm.cfilter(c,tp)
	return c:GetSummonPlayer()~=tp
end
function cm.limitop(e,tp,eg,ep,ev,re,r,rp)
	if eg:IsExists(cm.cfilter,1,nil,tp) then
		Duel.SetChainLimitTillChainEnd(cm.chlimit)
	end
end
function cm.cfilter2(c,tp)
	return c:GetOwner()~=tp
end
function cm.limitop2(e,tp,eg,ep,ev,re,r,rp)
	if eg:IsExists(cm.cfilter2,1,nil,tp) then
		Duel.SetChainLimitTillChainEnd(cm.chlimit)
	end
end
function cm.chlimit(e,ep,tp)
	return tp==ep
end
function cm.thfilter2(c)
	return c:IsAbleToHand() and c:GetType()&0x82==0x82
end
function cm.thop2(e,tp)
	rsof.SelectHint(tp,"th")
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(cm.thfilter2),tp,LOCATION_GRAVE,0,1,1,nil)
	rsof.SendtoHand(g)
end
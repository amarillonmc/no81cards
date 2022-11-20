--光与暗的化身
if not pcall(function() require("expansions/script/c10199990") end) then require("script/c10199990") end
local m,cm=rscf.DefineCard(10150087)
function cm.initial_effect(c)
	aux.AddCodeList(c,47297616)
	local e1=rsef.I(c,{m,0},{1,m},"des,sp",nil,LOCATION_HAND+LOCATION_GRAVE,nil,nil,rsop.target({rscf.spfilter2(),"sp"},{cm.desfilter,"des",LOCATION_HAND+LOCATION_MZONE }),cm.spop)
	local e2=rsef.STO(c,EVENT_DESTROYED,{m,1},{1,m+100},"se,th","de,dsp",cm.thcon,nil,rsop.target(cm.thfilter,"th",LOCATION_DECK),cm.thop)
	local e3=rsef.SV_ADD(c,"att",ATTRIBUTE_LIGHT)
	e3:SetRange(LOCATION_MZONE) 
end
function cm.desfilter(c,e,tp)
	return c:IsAttribute(ATTRIBUTE_LIGHT+ATTRIBUTE_DARK) and (c:IsFaceup() or c:IsLocation(LOCATION_HAND)) and c:IsLevelAbove(5)
end
function cm.spop(e,tp)
	local c=aux.ExceptThisCard(e)
	if not c or rssf.SpecialSummon(c)<=0 or not Duel.IsExistingMatchingCard(cm.desfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,c) then return end
	Duel.BreakEffect()
	rsop.SelectDestroy(tp,cm.desfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,1,c,{})
end
function cm.thcon(e,tp)
	return e:GetHandler():IsReason(REASON_EFFECT+REASON_BATTLE)
end
function cm.thfilter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and aux.IsCodeListed(c,47297616) and c:IsAbleToHand()
end
function cm.thop(e,tp)
	rsop.SelectToHand(tp,cm.thfilter,tp,LOCATION_DECK,0,1,1,nil,{})
end
--念动空间跳跃者
if not pcall(function() require("expansions/script/c130001000") end) then require("script/c130001000") end
local m,cm=rscf.DefineCard(130006006)
function cm.initial_effect(c)
	local e1 = rsef.FTO(c,EVENT_SUMMON_SUCCESS,"sp",nil,"sp,dr","de",LOCATION_HAND,cm.con,nil,rsop.target({rscf.spfilter2(),"sp"},{1,"dr"}),cm.spop)
	local e2 = rsef.RegisterClone(c,e1,"code",EVENT_MSET)
	local e3 = rsef.FTO(c,EVENT_SPSUMMON_SUCCESS,"th",nil,"th,dr","de",LOCATION_MZONE,cm.con,nil,rsop.target({Card.IsAbleToHand,"th"},{1,"dr"}),cm.thop)
end
function cm.cfilter(c,tp)
	return c:GetSummonPlayer() ~= tp
end
function cm.con(e,tp,eg)
	return eg:IsExists(cm.cfilter,1,nil,tp)
end
function cm.spop(e,tp)
	local c = rscf.GetSelf(e)
	if not c or rssf.SpecialSummon(c) <= 0 then return end
	Duel.Draw(tp,1,REASON_EFFECT)
end
function cm.thop(e,tp)
	local c = rscf.GetSelf(e)
	if not c or Duel.SendtoHand(c,nil,REASON_EFFECT) <= 0 then return end
	Duel.Draw(tp,1,REASON_EFFECT)
end
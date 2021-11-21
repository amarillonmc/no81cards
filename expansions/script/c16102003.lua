--SCP基金会 Doctors
if not pcall(function() require("expansions/script/c16101100") end) then require("script/c16101100") end
local m,cm=rscf.DefineCard(16102003,"SCP_J")
function cm.initial_effect(c)
	local e1=rsef.I(c,{m,0},{1,m},"sp",nil,LOCATION_HAND+LOCATION_GRAVE,rscon.excard2(Card.IsCode,LOCATION_ONFIELD,0,1,nil,m+1),rscost.cost(Card.IsReleasable,"res",LOCATION_HAND+LOCATION_ONFIELD),rsop.target2(cm.fun,rscf.spfilter2(),"sp"),cm.spop)
	local e2=rsef.STO(c,EVENT_SUMMON_SUCCESS,{m,1},nil,"se,th","de,dsp",nil,nil,rsop.target(cm.thfilter,"th",LOCATION_DECK),cm.thop)
	local e3=rsef.RegisterClone(c,e2,"code",EVENT_SPSUMMON_SUCCESS)
end
function cm.fun(g,e,tp)
	if e:GetHandler():IsLocation(rsloc.hg) then
		Duel.SetTargetCard(e:GetHandler())
	end
end
function cm.spop(e,tp)
	local c=aux.ExceptThisCard(e)
	if c then
		rssf.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP,nil,{"leave",LOCATION_REMOVED })
	end
end
function cm.thfilter(c)
	return c:IsAbleToHand() and c:IsType(TYPE_MONSTER) and c:CheckSetCard("SCP")
end
function cm.thop(e,tp)
	local c=e:GetHandler()
	local e1,e2=rsef.FV_LIMIT_PLAYER({c,tp},"sp,sum",nil,cm.ltg,{1,0},nil,rsreset.pend)
	rsop.SelectToHand(tp,cm.thfilter,tp,LOCATION_DECK,0,1,1,nil,{})
end
function cm.ltg(e,c)
	return not c:CheckSetCard("SCP")
end
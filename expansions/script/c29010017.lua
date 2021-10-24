--方舟之骑士·歌蕾蒂娅
if not pcall(function() require("expansions/script/c29010000") end) then require("script/c29010000") end
local m,cm = rscf.DefineCard(29010017)
function cm.initial_effect(c)
	local e1 = rsef.QO(c,nil,"sp",{1,m},"sp",nil,LOCATION_HAND,cm.spcon,
		rsop.target(rscf.spfilter2(),"sp"),cm.spop)
	local e2 = rsef.FTO(c,EVENT_PHASE+PHASE_STANDBY,"sp",1,"sp",nil,
		LOCATION_MZONE,nil,nil,
		rsop.target(cm.spfilter,"sp",LOCATION_DECK),cm.spop2)
	local e3 = rsef.FC(c,EVENT_CHAINING,nil,nil,nil,LOCATION_MZONE,
		cm.limcon,cm.limop)
end
function cm.dfilter(c)
	return c:IsType(TYPE_TRAP) and c:IsDiscardable()
end
function cm.spcon(e,tp)
	return Duel.IsEnvironment(22702055)
end
function cm.spop(e,tp)
	local c = rscf.GetSelf(e)
	if c then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
function cm.spfilter(c,e,tp)
	return not c:IsCode(m) and rscf.spfilter2()(c,e,tp) and c:IsRace(RACE_AQUA) and c:IsLevelBelow(4)
end
function cm.spop2(e,tp)
	rsop.SelectOperate("sp",tp,cm.spfilter,tp,LOCATION_DECK,0,1,1,nil,{},e,tp)
end
function cm.limcon(e,tp,eg,ep,ev,re,r,rp)
	return re:IsActiveType(TYPE_TRAP) and ep==tp
end
function cm.limop(e,tp)
	Duel.SetChainLimit(cm.chainlm)
end
function cm.chainlm(e,rp,tp)
	return tp==rp
end

--反转世界的倒影 米拉
if not pcall(function() require("expansions/script/c130001000") end) then require("script/c130001000") end
local m,cm=rscf.DefineCard(130006013,"FanZhuanShiJie")
if rsfz then return end
rsfz = cm 
rscf.DefineSet(rsfz,"FanZhuanShiJie")
---------------------
function cm.initial_effect(c)
	local e1 = rsef.QO(c,nil,"sp",nil,"ctrl,sp","tg",LOCATION_HAND,nil,rscost.regflag(100),rstg.target({cm.ctfilter,"ctrl",0,LOCATION_MZONE},{"opc",rscf.spfilter(),"sp"}),cm.spop)
	local e2 = rsef.STF(c,EVENT_SPSUMMON_SUCCESS,"sp",nil,"sp,dh","tg",nil,nil,rstg.target(cm.cfilter,"dum",LOCATION_MZONE,LOCATION_MZONE),cm.nop)
end
function cm.cfilter(c)
	return c:IsFaceup() and not c:IsControler(c:GetOwner())
end
function cm.ctfilter(c,e,tp)
	return c:IsControlerCanBeChanged() and Duel.GetMZoneCount(1-tp,c,tp) > 0
end
function cm.spop(e,tp)
	local c, tc = rscf.GetSelf(e), rscf.GetTargetCard()
	if not tc or not Duel.GetControl(tc,tp,0) or not c then return end
	Duel.SpecialSummon(c,0,tp,1-tp,false,false,POS_FACEUP)
end
function cm.spfilter(c,e,tp,code)
	return rscf.spfilter2()(c,e,tp) and c:IsCode(code)
end
function cm.spfilter2(c,e,tp,race,att)
	return rscf.spfilter2()(c,e,tp) and (c:IsRace(race) or c:IsAttribute(att))
end
function cm.nop(e,tp)
	local c,tc = e:GetHandler(), rscf.GetTargetCard(Card.IsFaceup)
	if not tc then return end
	local p1,p2 = tc:GetOwner(),tc:GetControler()
	local sg = Duel.GetMatchingGroup(cm.spfilter,p1,rsloc.de,0,nil,e,tp,tc:GetCode())
	if Duel.IsChainDisablable(0) and #sg > 0
		and rshint.SelectYesNo(p1,"sp") then
		rsgf.SelectSpecialSummon(sg,p1,aux.TRUE,1,1,nil,{0,p1,p1,false,false,POS_FACEUP},e,tp)
		Duel.NegateEffect(0)
		return
	end
	local sg2 = Duel.GetMatchingGroup(cm.spfilter2,p2,LOCATION_DECK,0,nil,e,tp,tc:GetRace(),tc:GetAttribute())
	if #sg2>0 and rshint.SelectYesNo(p2,"sp") then
		 rsgf.SelectSpecialSummon(sg2,p2,aux.TRUE,1,1,nil,{0,p2,p2,false,false,POS_FACEUP },e,tp)   
	end
end
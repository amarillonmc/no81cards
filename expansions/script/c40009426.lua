--机械加工·坏
if not pcall(function() require("expansions/script/c40008000") end) then require("script/c40008000") end
local m,cm=rscf.DefineCard(40009426)
function cm.initial_effect(c)
	local e1=rsef.ACT(c,nil,nil,{1,m,1},"sp","tg",nil,nil,rstg.target({cm.tgfilter,nil,LOCATION_MZONE },{"opc",cm.spfilter,"sp",rsloc.hg}),cm.act)
end
function cm.tgfilter(c)
	return c:IsType(TYPE_LINK) and c:IsFaceup() and c:IsSetCard(0x5f1d) and c:IsLinkAbove(1)
end
function cm.spfilter(c,e,tp)
	return c:IsRace(RACE_INSECT) and c:IsType(TYPE_NORMAL) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_DEFENSE)
end
function cm.act(e,tp)
	local tc=rscf.GetTargetCard()
	if not tc then return end
	local ct = tc:GetLink()
	ct = math.min(ct,Duel.GetLocationCount(tp,LOCATION_MZONE))
	if ct<=0 then return end
	if rscon.bsdcheck(tp) then ct = 1 end
	rsop.SelectSpecialSummon(tp,cm.spfilter,tp,rsloc.hg,0,1,ct,nil,{ 0,tp,tp,false,false,POS_FACEUP },e,tp)
end
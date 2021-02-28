--古代龙 催眠古魔翼龙
if not pcall(function() require("expansions/script/c40009451") end) then require("script/c40009451") end
local m,cm = rscf.DefineCard(40009460)
function cm.initial_effect(c)
	local e1=rsad.RitualFun(c)
	local e2=rsad.TributeSFun(c,m,"sp",nil,rsop.target({"cost",cm.resfilter,"res",LOCATION_MZONE+LOCATION_HAND },{"opc",cm.spfilter,"sp",rsloc.hg}),cm.spop)
	local e3=rsad.TributeTFun(c,m,"con","tg,de",rstg.target(cm.confilter,"con",0,LOCATION_MZONE),cm.conop)
end
function cm.resfilter(c,e,tp)
	local rc=e:GetHandler()
	return (c==rc and rc:IsLocation(LOCATION_HAND)) or (c:IsOnField() and rc:IsRace(RACE_DINOSAUR)) and Duel.GetMZoneCount(tp,c,tp)>0
end
function cm.spfilter(c,e,tp)
	return aux.IsCodeListed(c,40009452) and c:IsType(TYPE_MONSTER) and c:IsCanBeSpecialSummoned(e,0,tp,true,false)
end
function cm.spop(e,tp)
	rsop.SelectSpecialSummon(tp,aux.NecroValleyFilter(cm.spfilter),tp,rsloc.hg,0,1,1,nil,{0,tp,tp,true,false,POS_FACEUP,nil,{"dis,dise"}},e,tp)
end
function cm.confilter(c)
	return c:IsFaceup() and c:IsControlerCanBeChanged()
end
function cm.conop(e,tp)
	local tc=rscf.GetTargetCard(Card.IsControler,1-tp)
	if tc then
		local tct=1
		if Duel.GetTurnPlayer()~=tp then tct=2
		elseif Duel.GetCurrentPhase()==PHASE_END then tct=3 
		end
		Duel.GetControl(tc,tp,PHASE_END,tct)
	end
end
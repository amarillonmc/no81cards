--基金会
if not pcall(function() require("expansions/script/c16101100") end) then require("script/c16101100") end
local m,cm=rscf.DefineCard(16102004,"SCP_J")
function cm.initial_effect(c)
	local e1=rsef.ACT(c,nil,nil,{1,m,1},"se,th,tg",nil,nil,nil,rsop.target(cm.thfilter,"th",LOCATION_DECK),cm.thop)
	local e2=rsef.FTO(c,EVENT_SPSUMMON_SUCCESS,{m,1},nil,"sp","de,tg",LOCATION_FZONE,cm.spcon,nil,rstg.target(rscf.spfilter2(Card.IsCode,m-2),"sp",LOCATION_GRAVE),cm.spop)
	local e3,e4=rsef.FV_LIMIT_PLAYER(c,"sp,sum",nil,cm.ltg,{1,0})
	--local e5=rsef.SV_REDIRECT(c,"leave",LOCATION_HAND,rscon.excard2(rscf.CheckSetCard,LOCATION_MZONE,0,1,nil,"SCP"))
end
function cm.thfilter(c)
	return c:CheckSetCard("SCP") and (c:IsAbleToHand() or c:IsAbleToGrave()) and c:IsType(TYPE_MONSTER)
end
function cm.thop(e,tp)
	rsop.SelectSolve(HINTMSG_SELF,tp,cm.thfilter,tp,LOCATION_DECK,0,1,1,nil,{cm.solvefun,tp})
end
function cm.solvefun(g,tp)
	local tc=g:GetFirst()
	local b1=tc:CheckSetCard("SCP") and (tc:IsAbleToHand() or tc:IsAbleToGrave()) and tc:IsType(TYPE_MONSTER)
	local op=rsop.SelectOption(tp,b1,{m,0},b1,{m,2},true)
	if op==1 then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc)
	else
		Duel.SendtoGrave(tc,REASON_EFFECT)
	end
end
function cm.cfilter(c,tp)
	return c:CheckSetCard("SCP") and c:IsControler(tp) and not c:CheckSetCard("SCP_J") 
end
function cm.spcon(e,tp,eg)
	return eg:IsExists(cm.cfilter,1,nil,tp)
end
function cm.spop(e,tp)
	local tc=rscf.GetTargetCard()
	if tc then
		rssf.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP,nil,{"dis,dise",true,"tri",true})
	end
end
function cm.ltg(e,c)
	return not c:CheckSetCard("SCP")
end
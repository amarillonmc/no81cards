--天知胤龙 魔域幽灵龙
if not pcall(function() require("expansions/script/c10199990") end) then require("script/c10199990") end
local m,cm=rscf.DefineCard(65010566,"TianZhi")
function cm.initial_effect(c)
	local e1=rsef.FTO(c,EVENT_TO_HAND,{m,0},{1,m},"sp","de",LOCATION_HAND,cm.spcon,nil,rsop.target({rscf.spfilter2(),"sp"},{cm.spfilter,"sp",rsloc.hd }),cm.spop)
	local e2=rsef.SC(c,EVENT_TO_GRAVE,nil,nil,"cd",nil,cm.regop)
	local e3=rsef.RegisterClone(c,e2,"code",EVENT_REMOVE)
	local e4=rsef.FTO(c,EVENT_PHASE+PHASE_STANDBY,{m,1},{1,m+100},"td,des","tg",rsloc.gr,cm.descon,nil,rstg.target({aux.TRUE,"des",LOCATION_ONFIELD,LOCATION_ONFIELD },rsop.list(Card.IsAbleToDeck,"td",LOCATION_REMOVED)),cm.desop)
	e2:SetLabelObject(e4)
	e3:SetLabelObject(e4)
end
function cm.cfilter(c,tp)
	return c:GetReasonPlayer() ~= tp
end
function cm.spcon(e,tp,eg)
	return eg:IsExists(cm.cfilter,1,nil,tp)
end
function cm.spfilter(c,e,tp)
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>1 and rscf.spfilter2(Card.IsCode,65010558)(c,e,tp) and not rscon.bsdcheck(tp)
end 
function cm.spop(e,tp)
	local e1=rsef.FV_LIMIT_PLAYER({e:GetHandler(),tp},"sp",nil,cm.tg,{1,0},nil,rsreset.pend)
	local c=rscf.GetSelf(e)
	if not c or Duel.GetLocationCount(tp,LOCATION_MZONE)<2 or rscon.bsdcheck(tp) then return end
	rsop.SelectSolve(HINTMSG_SPSUMMON,tp,cm.spfilter,tp,rsloc.hd,0,1,1,c,cm.spfun,e,tp)
end
function cm.spfun(g,e,tp)
	local tc=g:GetFirst()
	local sg=rsgf.Mix2(tc,e:GetHandler())
	rssf.SpecialSummon(sg)
	return true
end
function cm.tg(e,c)
	return c:IsLocation(LOCATION_EXTRA) and not c:IsType(TYPE_FUSION)
end
function cm.regop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetTurnPlayer()==tp and Duel.GetCurrentPhase()==PHASE_STANDBY then
		e:GetLabelObject():SetLabel(Duel.GetTurnCount())
		c:RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_STANDBY+RESET_SELF_TURN,0,2)
	else
		e:GetLabelObject():SetLabel(0)
		c:RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_STANDBY+RESET_SELF_TURN,0,1)
	end
end
function cm.descon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and e:GetLabel()~=Duel.GetTurnCount() and tp==Duel.GetTurnPlayer() and c:GetFlagEffect(m)>0
end
function cm.desop(e,tp)
	local tc=rscf.GetTargetCard()
	if rsop.SelectToDeck(tp,Card.IsAbleToDeck,tp,LOCATION_REMOVED,0,1,1,nil,{})>0 and tc then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end
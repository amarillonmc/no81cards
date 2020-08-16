--天知海龙 深渊硬甲鱼
if not pcall(function() require("expansions/script/c10199990") end) then require("script/c10199990") end
local m,cm=rscf.DefineCard(65020219,"TianZhi")
function cm.initial_effect(c)
	local e1=rsef.FTO(c,EVENT_SPSUMMON_SUCCESS,{m,0},{1,m},"sp",nil,LOCATION_HAND,cm.spcon,nil,rsop.target(cm.spfilter,"sp"),cm.spop)
	local e2=rsef.STO(c,EVENT_SPSUMMON_SUCCESS,{m,1},{1,m+100},"sp","de,dsp",cm.spcon2,nil,rsop.target(rscf.spfilter2(Card.IsCode,65010558),"sp",rsloc.hd),cm.spop2)
	local e3=rsef.SC(c,EVENT_REMOVE,nil,nil,"cd",nil,cm.regop)
	local e4=rsef.FTO(c,EVENT_PHASE+PHASE_STANDBY,{m,2},{1,m+200},"td,dr",nil,LOCATION_REMOVED,cm.tdcon,nil,rsop.target({Card.IsAbleToDeck,"td",LOCATION_REMOVED },{1,"dr"}),cm.tdop)
	e4:SetLabelObject(e3)
end
function cm.cfilter(c,tp)
	return c:GetSummonPlayer() ~= tp
end
function cm.spcon(e,tp,eg)
	return eg:IsExists(cm.cfilter,1,nil,tp)
end
function cm.spfilter(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_DEFENSE)
end
function cm.spop(e,tp)
	local c=rscf.GetSelf(e)
	if c then rssf.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP_DEFENSE) end
end
function cm.spcon2(e,tp,eg,ep,ev,re,r,rp)
	return re and re:IsHasType(EFFECT_TYPE_ACTIONS) and re:GetHandler():CheckSetCard("TianZhi")
end
function cm.spop2(e,tp)
	rsop.SelectSpecialSummon(tp,rscf.spfilter2(Card.IsCode,65010558),tp,rsloc.hd,0,1,1,nil,{},e,tp)
	local e1=rsef.FV_LIMIT_PLAYER({e:GetHandler(),tp},"sp",nil,cm.tg,{1,0},nil,rsreset.pend)
end
function cm.tg(e,c)
	return c:IsLocation(LOCATION_EXTRA) and not c:IsType(TYPE_FUSION)
end
function cm.regop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetTurnPlayer()==tp and Duel.GetCurrentPhase()==PHASE_STANDBY then
		e:SetLabel(Duel.GetTurnCount())
		c:RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_STANDBY+RESET_SELF_TURN,0,2)
	else
		e:SetLabel(0)
		c:RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_STANDBY+RESET_SELF_TURN,0,1)
	end
end
function cm.tdcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp and e:GetHandler():GetFlagEffect(m)>0
		and e:GetLabelObject():GetLabel()~=Duel.GetTurnCount()
end
function cm.tdop(e,tp)
	if rsop.SelectToDeck(tp,Card.IsAbleToDeck,tp,LOCATION_REMOVED,0,1,1,nil,{})>0 then
		rsop.ToDeckDraw(tp,1)
	end
end

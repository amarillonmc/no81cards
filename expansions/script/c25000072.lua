--千兆恩多拉•最终重置光
if not pcall(function() require("expansions/script/c25010000") end) then require("script/c25010000") end
local m,cm=rscf.DefineCard(25000072)
function cm.initial_effect(c)
	local e1=rsef.SV_ACTIVATE_IMMEDIATELY(c,"hand")
	local e2=rsef.ACT(c,EVENT_LEAVE_FIELD,nil,nil,"tg","de",cm.con,nil,cm.tg,cm.act)
	if cm.switch then return end
	cm.switch = {[0]={},[1]={}}
	local ge1=rsef.FC({c,0},EVENT_SPSUMMON_SUCCESS)
	ge1:SetOperation(cm.regop)
end
function cm.regop(e,tp,eg)
	for tc in aux.Next(eg) do
		local sp=tc:GetSummonPlayer()
		local code=tc:GetCode()
		if tc:IsType(TYPE_LINK) and tc:IsRace(RACE_MACHINE) and not rsof.Table_List(cm.switch[sp],code) then
			table.insert(cm.switch[sp],code)
		end
	end
end
function cm.cfilter(c,tp)
	return c:IsPreviousPosition(POS_FACEUP) and c:GetPreviousControler()==tp and c:GetPreviousRaceOnField() & RACE_MACHINE ~=0 and c:GetPreviousTypeOnField() & TYPE_LINK ~=0
end
function cm.con(e,tp,eg)
	local ph=Duel.GetCurrentPhase()
	return eg:IsExists(cm.cfilter,1,nil,tp) and #(cm.switch[tp])>=3 and Duel.GetTurnPlayer()~=tp and (ph>=PHASE_DRAW and ph<=PHASE_MAIN1 )
end
function cm.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	if e:IsHasType(EFFECT_TYPE_ACTIVATE) then
		Duel.SetChainLimit(aux.FALSE)
	end
end
function cm.act(e,tp)
	local e1=rsef.FC({e:GetHandler(),tp},EVENT_PHASE+PHASE_BATTLE_START,nil,1,nil,nil,nil,cm.tdop,rsreset.pend)
end
function cm.tdfilter(c)
	return Duel.IsPlayerCanSendtoDeck(tp,c)
end
function cm.tdop(e,tp)
	local g=Duel.GetMatchingGroup(cm.tdfilter,tp,0,rsloc.hog,nil)
	rshint.Card(m)
	Duel.SendtoDeck(g,nil,2,REASON_RULE)
end
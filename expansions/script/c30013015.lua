--深土之物 塔里克丝贝牛
if not pcall(function() require("expansions/script/c30000100") end) then require("script/c30000100") end
local m,cm = rscf.DefineCard(30013015)
function cm.initial_effect(c)
	c:EnableReviveLimit()
	local e1 = rsef.QO(c,EVENT_CHAINING,{m,1},{75,m},nil,"dsp,dcal",LOCATION_HAND,cm.imcon,rscost.cost(0,"dh"),rsop.target(cm.cfilter,"dum",LOCATION_MZONE),cm.imop)
	local e2 = rsef.STO_Flip(c,"sp",{75,m+100},"sp,pos,dd","de",aux.NOT(cm.qcon),nil,nil,cm.spop)
	local e3 = rsef.STO_Flip(c,"sp",{75,m+100},"sp,pos,dd","de",cm.qcon,nil,rsop.target(cm.spfilter,"sp",rsloc.dg),cm.spop3)
	local e4 = rsef.FTO(c,EVENT_PHASE+PHASE_END,"pos",{1,m+200},"pos,se,th",nil,LOCATION_GRAVE,nil,rscost.cost(1,"dh"),rsop.target({cm.pfilter,"pos",LOCATION_MZONE},{cm.thfilter,"th",rsloc.dg}),cm.posop)
	local e5 = rsef.RegisterOPTurn(c,e4,cm.qcon)
	e5:SetCode(EVENT_FREE_CHAIN)
end
function cm.pfilter(c)
	return c:IsFacedown() and c:IsCanChangePosition()
end
function cm.thfilter(c)
	return c:IsSetCard(0x92c) and c:IsType(TYPE_SPELL) and c:IsAbleToHand()
end
function cm.posop(e,tp)
	local g,tc = rsop.SelectSolve("pos",tp,cm.pfilter,tp,LOCATION_MZONE,0,1,1,nil,{})
	if not tc or Duel.ChangePosition(tc,Duel.SelectPosition(tp,tc,POS_FACEUP)) <= 0 then return end
	rsop.SelectOC(nil,true)
	rsop.SelectToHand(tp,aux.NecroValleyFilter(cm.thfilter),tp,rsloc.dg,0,1,1,nil,{})
end
function cm.qcon(e,tp)
	return Duel.IsPlayerAffectedByEffect(tp,30013020)
end
function cm.spop(e,tp)
	local c = rscf.GetFaceUpSelf(e)
	local e1 = rsef.FC({e:GetHandler(),tp},EVENT_PHASE+PHASE_END,nil,1,nil,nil,cm.spcon2,cm.spop2,rsrst.ep)
	if c and c:IsCanTurnSet() and rshint.SelectYesNo(tp,"pos") then
		Duel.BreakEffect()
		Duel.ChangePosition(c,POS_FACEDOWN_DEFENSE)
	end
end
function cm.spfilter(c,e,tp)
	return c:IsType(TYPE_FLIP) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEDOWN_DEFENSE)
end 
function cm.spcon2(e,tp)
	return Duel.IsExistingMatchingCard(aux.NecroValleyFilter(cm.spfilter),tp,rsloc.dg,0,1,nil,e,tp)
end
function cm.spop2(e,tp)
	rshint.Card(m)
	local ct,og = rsop.SelectSpecialSummon(tp,aux.NecroValleyFilter(cm.spfilter),tp,rsloc.dg,0,1,1,nil,{0,tp,tp,false,false,POS_FACEDOWN_DEFENSE},e,tp)
	if ct > 0 then
		Duel.ConfirmCards(1-tp,og)
	end
end
function cm.spop3(e,tp)
	local c = rscf.GetFaceUpSelf(e)
	local ct,og = rsop.SelectSpecialSummon(tp,aux.NecroValleyFilter(cm.spfilter),tp,rsloc.dg,0,1,1,nil,{0,tp,tp,false,false,POS_FACEDOWN_DEFENSE},e,tp)
	if ct <= 0 then return end
	Duel.ConfirmCards(1-tp,og)
	if c and c:IsCanTurnSet() and rshint.SelectYesNo(tp,"pos") then
		Duel.BreakEffect()
		Duel.ChangePosition(c,POS_FACEDOWN_DEFENSE)
	end
end
function cm.imcon(e,tp,eg,ep,ev,re,r,rp)
	return rp ~= tp
end
function cm.cfilter(c)
	return c:IsType(TYPE_FLIP) or c:IsFacedown() or c:IsSetCard(0x92c)
end 
function cm.imop(e,tp)
	local g = Duel.GetMatchingGroup(cm.cfilter,tp,LOCATION_MZONE,0,nil)
	for tc in aux.Next(g) do
		local e1 = rscf.QuickBuff({e:GetHandler(),tc},"im",rsval.imoe,"rst",RESET_CHAIN)
	end
end
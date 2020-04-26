--斯菲亚合成兽 新达兰比尔
if not pcall(function() require("expansions/script/c25000011") end) then require("script/c25000011") end
local m,cm=rscf.DefineCard(25000018)
function cm.initial_effect(c)
	local e1,e2,e3,e4=rsgs.FusProcFun(c,m,TYPE_XYZ,"tg",nil,rsop.target(cm.tgfilter,"tg",LOCATION_DECK),cm.tgop)
	local e5=rsef.QO(c,EVENT_CHAINING,{m,0},{1,m},"neg,pos","dcal,dsp",LOCATION_MZONE,rscon.negcon(2,true),nil,rstg.negtg("nil"),cm.disop)
end
function cm.tgfilter(c)
	return c:IsSetCard(0xaf2) and c:IsAbleToGrave()
end
function cm.tgop(e,tp)
	rsop.SelectToGrave(tp,cm.tgfilter,tp,LOCATION_DECK,0,1,1,nil,{})
end
function cm.posfilter(c)
	return not c:IsPosition(POS_FACEUP_DEFENSE) and c:IsCanChangePosition()
end
function cm.disop(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.NegateActivation(ev) then return end
	local g=Duel.GetMatchingGroup(cm.posfilter,tp,0,LOCATION_MZONE,nil)
	if #g>0 and Duel.SelectYesNo(tp,aux.Stringid(m,2)) then
		rshint.Select(tp,"pos")
		local tg=g:Select(tp,1,1,nil)
		Duel.HintSelection(tg)
		Duel.ChangePosition(tg,POS_FACEUP_DEFENSE)
	end
end
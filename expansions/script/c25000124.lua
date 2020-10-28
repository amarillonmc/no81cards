--圆盘生物 撒旦莫亚
if not pcall(function() require("expansions/script/c25000119") end) then require("script/c25000119") end
local m,cm=rscf.DefineCard(25000124)
function cm.initial_effect(c)
	local e1=rsufo.ShowFunT(c,m,EVENT_TO_HAND,"td,dish",nil,cm.con,nil,rsop.target(1,"dish",0,LOCATION_HAND),cm.op,true)
	e1:SetDescription(aux.Stringid(m,1))
	local e2=rsufo.ShowFunT(c,m,EVENT_TO_HAND,"td,rm",nil,cm.con,rscost.cost(cm.rmcfilter,"rm_d",LOCATION_HAND,0,1,1,c),rsop.target(cm.rmfilter,"rm",0,LOCATION_HAND),cm.op2,true)
	e2:SetDescription(aux.Stringid(m,2))
end
function cm.con(e,tp,eg)
	return Duel.GetCurrentPhase()~=PHASE_DRAW and eg:IsExists(Card.IsControler,1,nil,1-tp)
end 
function cm.op(e,tp)
	local c=rscf.GetSelf(e)
	if not rsufo.ToDeck(e,true) then return end
	local g=Duel.GetFieldGroup(tp,0,LOCATION_HAND)
	local dg=g:RandomSelect(tp,1)
	Duel.SendtoGrave(dg,REASON_EFFECT+REASON_DISCARD)
end
function cm.rmcfilter(c)
	return c:IsAbleToRemoveAsCost(POS_FACEDOWN)
end
function cm.rmfilter(c,e,tp)
	return c:IsAbleToRemove(tp,POS_FACEDOWN)
end
function cm.op2(e,tp)
	local c=rscf.GetSelf(e)
	if not rsufo.ToDeck(e,true) then return end
	local g=Duel.GetFieldGroup(tp,0,LOCATION_HAND)
	Duel.ConfirmCards(tp,g)
	rsgf.SelectRemove(g,tp,cm.rmfilter,1,1,nil,{ POS_FACEDOWN,REASON_EFFECT },e,tp)
end


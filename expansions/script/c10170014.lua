--
if not pcall(function() require("expansions/script/c10170001") end) then require("script/c10170001") end
local m=10170014
local cm=_G["c"..m]
function cm.initial_effect(c)
	local e1=rssp.ActivateFun(c,m,"te","lp",cm.fun,cm.op)
end
function cm.fun(e,tp,...)
	local g1=Duel.GetMatchingGroup(cm.tefilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,nil)
	local g2=Duel.GetMatchingGroup(cm.setfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,nil)
	local b1={ "te,lg",rshint.te,tp,LOCATION_DECK+LOCATION_GRAVE }
	local b2={ "lg",HINTMSG_SET,tp,LOCATION_DECK+LOCATION_GRAVE }
	return g1,g2,b1,b2
end
function cm.op(op,g,e,tp)
	if op==1 then
		Duel.SendtoExtraP(g,nil,REASON_EFFECT)
	else
		Duel.SSet(tp,g:GetFirst())
		Duel.ConfirmCards(1-tp,g)
	end
end
function cm.setfilter(c)
	return c:IsSSetable() and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsSetCard(0xa333) and not c:IsCode(m)
end
function cm.tefilter(c)
	return c:IsType(TYPE_PENDULUM) and not c:IsForbidden() and c:IsSetCard(0xa333)
end
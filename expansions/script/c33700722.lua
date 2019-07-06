--铁虹的狙击手
if not pcall(function() require("expansions/script/c33700720") end) then require("script/c33700720") end
local m=33700722
local cm=_G["c"..m]
function cm.initial_effect(c)
	rsneov.TunerFun(c,1600)
	rsneov.RDTurnFun(c,CATEGORY_TOGRAVE,nil,1200,cm.tg,cm.op)  
	rsneov.LPChangeFun(c) 
end
function cm.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToGrave,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,PLAYER_ALL,LOCATION_ONFIELD)
	if Duel.GetLP(tp)<Duel.GetLP(1-tp) then
		Duel.SetChainLimit(cm.chlimit)
	end
end
function cm.chlimit(e,ep,tp)
	return tp==ep
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,Card.IsAbleToGrave,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	if g:GetCount()>0 then
		Duel.HintSelection(g)
		Duel.SendtoGrave(g,REASON_EFFECT)
	end
end
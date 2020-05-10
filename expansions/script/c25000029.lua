--超古代生物 加鲁拉
if not pcall(function() require("expansions/script/c25000024") end) then require("script/c25000024") end
local m,cm=rscf.DefineCard(25000029)
function cm.initial_effect(c)
	local e1,e2,e3=rsoc.SpSummonFun(c,m,2,"th",nil,rsop.target(cm.thfilter,"th",LOCATION_GRAVE),cm.thop)
	local e4=rsoc.TributeFun(c,m,"dish","ptg",cm.dishtg,cm.dishop)
end
function cm.thfilter(c)
	return c:IsAbleToHand() and rsoc.IsSet(c)
end
function cm.thop(e,tp)
	rsop.SelectToHand(tp,aux.NecroValleyFilter(cm.thfilter),tp,LOCATION_GRAVE,0,1,2,nil,{})
end
function cm.dishtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)>0 end
	Duel.SetTargetPlayer(tp)
	Duel.SetOperationInfo(0,CATEGORY_HANDES,nil,0,1-tp,LOCATION_HAND)
end
function cm.dishop(e,tp,eg,ep,ev,re,r,rp)
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	local g=Duel.GetFieldGroup(p,0,LOCATION_HAND)
	if #g>0 then
		Duel.ConfirmCards(p,g)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
		local sg=g:Select(tp,1,1,nil)
		Duel.SendtoGrave(sg,REASON_EFFECT+REASON_DISCARD)
		Duel.ShuffleHand(1-tp)
	end
end
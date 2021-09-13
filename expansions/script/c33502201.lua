--冰汽时代 患者
local m=33502201
local cm=_G["c"..m]
Duel.LoadScript("c33502200.lua")
function cm.initial_effect(c)
	local e1=syu.turnup(c,m,nil,nil,cm.turnupop,CATEGORY_TOGRAVE)
	local e2=syu.tograve(c,m,nil,nil,cm.gop,CATEGORY_RECOVER)
end
function cm.turnupop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(nil,1-tp,LOCATION_ONFIELD+LOCATION_HAND,0,nil)
	if g:GetCount()>0 then
		if not Duel.IsPlayerAffectedByEffect(tp,33502206) then Duel.SetLP(tp,Duel.GetLP(tp)-1000) end
		Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_TOGRAVE)
		local sg=g:Select(1-tp,1,1,nil)
		Duel.HintSelection(sg)
		Duel.SendtoGrave(sg,REASON_RULE)
	end
end
function cm.gop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)
	if g>0 then
		Duel.Recover(tp,g*200,REASON_EFFECT)
	end
end
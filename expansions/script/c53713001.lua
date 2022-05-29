local m=53713001
local cm=_G["c"..m]
cm.name="爱丽丝役 TRS"
cm.alc_yaku=true
if not pcall(function() require("expansions/script/c53702500") end) then require("script/c53702500") end
function cm.initial_effect(c)
	SNNM.ALCYakuNew(c,m,cm.confirm,LOCATION_HAND,{1900,300,4,RACE_WARRIOR,ATTRIBUTE_DARK})
	SNNM.AllGlobalCheck(c)
end
function cm.confirm(c,tp)
	local g=Group.CreateGroup()
	local ct=Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)
	if ct>0 then
		local ac=1
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(m,1))
		if ct>1 then ac=Duel.AnnounceNumber(tp,1,2) end
		g=Duel.GetFieldGroup(tp,0,LOCATION_HAND):RandomSelect(tp,ac)
		Duel.ConfirmCards(tp,g)
	end
	return g
end

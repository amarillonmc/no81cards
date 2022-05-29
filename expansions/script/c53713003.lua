local m=53713003
local cm=_G["c"..m]
cm.name="爱丽丝役 TIS"
cm.alc_yaku=true
if not pcall(function() require("expansions/script/c53702500") end) then require("script/c53702500") end
function cm.initial_effect(c)
	SNNM.ALCYakuNew(c,m,cm.confirm,LOCATION_DECK,{200,2200,4,RACE_WARRIOR,ATTRIBUTE_DARK})
	SNNM.AllGlobalCheck(c)
end
function cm.confirm(c,tp)
	local g=Group.CreateGroup()
	local ct=Duel.GetFieldGroupCount(tp,0,LOCATION_DECK)
	if ct>0 then
		local ac,t=1,{}
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(m,1))
		for i=1,math.min(7,ct) do table.insert(t,i) end
		if ct>1 then ac=Duel.AnnounceNumber(tp,table.unpack(t)) end
		g=Duel.GetFieldGroup(tp,0,LOCATION_DECK):RandomSelect(tp,ac)
		Duel.ConfirmCards(tp,g)
	end
	return g
end

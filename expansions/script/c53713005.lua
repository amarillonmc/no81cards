local m=53713005
local cm=_G["c"..m]
cm.name="爱丽丝役 HNS"
if not pcall(function() require("expansions/script/c53702500") end) then require("script/c53702500") end
function cm.initial_effect(c)
	SNNM.ALCYakuNew(c,m,cm.confirm,LOCATION_EXTRA,{1800,1800,4,RACE_WARRIOR,ATTRIBUTE_DARK})
	SNNM.AllGlobalCheck(c)
end
function cm.confirm(c,tp)
	local g=Group.CreateGroup()
	local ct=Duel.GetFieldGroupCount(tp,0,LOCATION_EXTRA)
	if ct>0 then
		local ac,t=1,{}
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(m,1))
		for i=1,math.min(4,ct) do table.insert(t,i) end
		if ct>1 then ac=Duel.AnnounceNumber(tp,table.unpack(t)) end
		g=Duel.GetFieldGroup(tp,0,LOCATION_EXTRA):RandomSelect(tp,ac)
		Duel.ConfirmCards(tp,g)
	end
	return g
end

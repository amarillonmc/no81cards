--末日神判
if not pcall(function() require("expansions/script/c10199990") end) then require("script/c10199990") end
local m,cm=rscf.DefineCard(10174054)
function cm.initial_effect(c)
	local e1=aux.AddRitualProcGreater2Code2(c,m-1,m-2)
	e1:SetTarget(cm.tg(e1:GetTarget()))
end
function cm.tg(tg)
	return function(e,tp,eg,ep,ev,re,r,rp,chk)
		local res=tg(e,tp,eg,ep,ev,re,r,rp,chk)
		if chk~=0 and e:IsHasType(EFFECT_TYPE_ACTIVATE) then
			Duel.SetChainLimit(cm.chlimit)
		end
		return res
	end
end
function cm.chlimit(e,ep,tp)
	return tp==ep
end
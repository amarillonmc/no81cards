--奉神天使 宏伟
local s,m,o=GetID()
if not pcall(function() require("expansions/script/c20000350") end) then require("script/c20000350") end
function s.initial_effect(c)
	local e = {fu_god.Counter(c,CATEGORY_NEGATE,EVENT_CHAINING,EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL,s.con,s.tg,s.op)}
end
function s.con(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsChainNegatable(ev) and Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION)&LOCATION_REMOVED~=0
end
function s.tg(e,tp,eg,ep,ev,re,r,rp,chk)
		if chk==0 then return true end
		Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
end
function s.op(e,tp,eg,ep,ev,re,r,rp)
		Duel.NegateActivation(ev)
		fu_god.Reg(e,m,tp)
end
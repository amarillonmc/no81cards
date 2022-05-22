--奉神天使 胜利
local s,m,o=GetID()
if not pcall(function() require("expansions/script/c20000350") end) then require("script/c20000350") end
function s.initial_effect(c)
	local e = {fu_god.Counter(c,CATEGORY_NEGATE+CATEGORY_REMOVE,EVENT_CHAINING,EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL,s.con,s.tg,s.op)}
end
function s.con(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsChainNegatable(ev) and Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION)&LOCATION_GRAVE~=0
end
function s.tg(e,tp,eg,ep,ev,re,r,rp,chk)
		if chk==0 then return true end
		Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
		if re:GetHandler():IsAbleToRemove() and re:GetHandler():IsRelateToEffect(re) then
			Duel.SetOperationInfo(0,CATEGORY_REMOVE,eg,1,0,0)
		end
end
function s.op(e,tp,eg,ep,ev,re,r,rp)
		local tc = re:GetHandler()
		if Duel.NegateActivation(ev) and tc:IsRelateToEffect(re) then
			Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)
		end
		fu_god.Reg(e,m,tp)
end
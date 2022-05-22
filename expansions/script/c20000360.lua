--奉神天使 智慧
local cm,m,o=GetID()
if not pcall(function() require("expansions/script/c20000350") end) then require("script/c20000350") end
function cm.initial_effect(c)
	local e = {fu_god.Counter(c,CATEGORY_NEGATE+CATEGORY_DESTROY,EVENT_CHAINING,EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL,cm.con,cm.tg,cm.op)}
end
function cm.con(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsChainNegatable(ev) and re:GetHandler():GetOriginalType()&TYPE_MONSTER~=0
end
function cm.tg(e,tp,eg,ep,ev,re,r,rp,chk)
		if chk==0 then return true end
		Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
		if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
			Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
		end
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
		local tc = re:GetHandler()
		if Duel.NegateActivation(ev) and tc:IsRelateToEffect(re) then
			Duel.Destroy(tc,REASON_EFFECT)
		end
		fu_god.Reg(e,m,tp)
end
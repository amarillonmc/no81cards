--虚拟水神一闪
if not pcall(function() require("expansions/script/c65020201") end) then require("script/c65020201") end
local m,cm=rscf.DefineCard(65020205,"VrAqua")
function cm.initial_effect(c)
	local e1=rsef.ACT(c,EVENT_CHAINING,nil,{1,m,1},"neg,des",nil,cm.con,nil,cm.tg,cm.act)   
end
function cm.con(e,tp,eg,ep,ev,re,r,rp)
	if not rscon.excard2(rsva.filter_ar,LOCATION_MZONE)(e,tp) then return false end
	if not Duel.IsChainNegatable(ev) then return false end
	return re:IsActiveType(TYPE_MONSTER) or re:IsHasType(EFFECT_TYPE_ACTIVATE)
end
function cm.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
	if rscon.excard2(rsva.filter_l,LOCATION_MZONE)(e,tp) and e:IsHasType(EFFECT_TYPE_ACTIVATE) then
		e:SetLabel(100)
	else
		e:SetLabel(0)
	end
end
function cm.act(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	if Duel.NegateActivation(ev) and rc:IsRelateToEffect(re) and Duel.Destroy(eg,REASON_EFFECT)>0 and e:GetLabel()==100 then
		local e1=rsef.FV_LIMIT_PLAYER({e:GetHandler(),tp},"act",cm.val(rc),nil,{0,1},nil,{rsreset.pend+RESET_OPPO_TURN,2})
	end
end
function cm.val(rc)
	return function(e,re)
		return re:GetHandler():IsCode(rc:GetCode())
	end
end
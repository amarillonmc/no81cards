--虚拟水神旅者
if not pcall(function() require("expansions/script/c65020201") end) then require("script/c65020201") end
local m,cm=rscf.DefineCard(65020210,"VrAqua")
function cm.initial_effect(c)
	local e1,e2,e3=rsva.MonsterEffect(c,m,cm.op)
end
function cm.op(e,tp)
	local c=e:GetHandler()
	local e1=rsef.FC({c,tp},EVENT_CHAIN_SOLVING,nil,nil,nil,nil,cm.negcon,cm.negop,rsreset.pend)
end
function cm.cfilter(c)
	return c:IsFaceup() and c:IsLevel(10)
end
function cm.negcon(e,tp,eg,ep,ev,re,r,rp)
	local ct=Duel.GetMatchingGroupCount(cm.cfilter,tp,LOCATION_MZONE,0,nil)
	return rp~=tp and Duel.IsChainDisablable(ev) and (re:IsHasType(EFFECT_TYPE_ACTIVATE) or re:IsActiveType(TYPE_MONSTER)) and Duel.CheckLPCost(tp,800) and ct>Duel.GetFlagEffect(tp,m)
end
function cm.negop(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	if rsop.SelectYesNo(tp,{m,0}) then
		Duel.PayLPCost(tp,800) 
		Duel.Hint(HINT_CARD,0,m)
		Duel.RegisterFlagEffect(tp,m,rsreset.pend,0,1)
		Duel.NegateEffect(ev) 
	end
end
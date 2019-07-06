--虚毒构造 WHOLE
if not pcall(function() require("expansions/script/c33700701") end) then require("script/c33700701") end
local m=33700709
local cm=_G["c"..m]
function cm.initial_effect(c)
	rsve.FusionMaterialFunction(c,5)
	rsve.ToGraveFunction(c,11,cm.con,cm.cost)
	rsve.AttackUpFunction(c,500)	 
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsCanRemoveCounter(tp,1,1,0x144b,2,REASON_COST) end
	Duel.RemoveCounter(tp,1,1,0x144b,2,REASON_COST)
end
function cm.con(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsReason(REASON_EFFECT) and re and re:GetHandler():IsSetCard(0x144b)
end
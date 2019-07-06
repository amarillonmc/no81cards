--虚毒构造 MATERIAL
if not pcall(function() require("expansions/script/c33700701") end) then require("script/c33700701") end
local m=33700708
local cm=_G["c"..m]
function cm.initial_effect(c)
	rsve.FusionMaterialFunction(c,4)
	rsve.ToGraveFunction(c,7,cm.con)
	rsve.AttackUpFunction(c,500)   
end
function cm.con(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsReason(REASON_EFFECT) and re:GetHandler():IsSetCard(0x144b)
end
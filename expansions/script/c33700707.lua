--虚毒构造 BASIC
if not pcall(function() require("expansions/script/c33700701") end) then require("script/c33700701") end
local m=33700707
local cm=_G["c"..m]
function cm.initial_effect(c)
	rsve.FusionMaterialFunction(c,3)
	rsve.ToGraveFunction(c,2)
	rsve.AttackUpFunction(c,300)
end

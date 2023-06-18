--量子驱动 β干扰机
if not pcall(function() require("expansions/script/c10130001") end) then require("script/c10130001") end
local s,id = GetID()
function s.initial_effect(c)
	local e1 = Scl_Quantadrive.FilpEffect(c, s, id, "NegateEffect", "NegateEffect", { "~Target", "NegateEffect", aux.NegateAnyFilter, 0, "OnField" }, s.negop)
	local e2 = Scl_Quantadrive.NormalSummonEffect(c, s, id, "BeFlippedFaceup")
	Scl_Quantadrive.CreateNerveContact(s, e1, e2)
end
function s.negop(e,tp)
	Scl.SelectAndOperateCards("NegateEffect", tp, aux.NegateAnyFilter, tp, 0, "OnField", 1, 1, nil)(false, RESETS_EP_SCL)
end
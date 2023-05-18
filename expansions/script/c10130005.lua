--量子驱动 ζ强击机
if not pcall(function() require("expansions/script/c10130001") end) then require("script/c10130001") end
local s,id = GetID()
function s.initial_effect(c)
	local e1 = Scl_Quantadrive.FilpEffect(c, s, id, "Destroy", "Destroy", { "~Target", "Destroy", aux.TRUE, 0, "MonsterZone" }, s.desop)
	local e2 = Scl_Quantadrive.NormalSummonEffect(c, s, id, "BeSet")
	Scl_Quantadrive.CreateNerveContact(s, e1, e2)
end
function s.desop(e,tp)
	Scl.SelectAndOperateCards("Destroy",tp,aux.TRUE,tp,0,"MonsterZone",1,1,nil)()
end
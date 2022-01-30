--Snowflakes
if not pcall(function() require("expansions/script/c20000200") end) then require("script/c20000200") end
function c20000205.initial_effect(c)
	aux.AddCodeList(c,20000200)
	local e1=fufu_loop.ctadt(c)
	local e5=fufu_loop.b(c,EFFECT_IMMUNE_EFFECT,function(e,te)
		return te:IsActiveType(TYPE_SPELL+TYPE_TRAP) and not te:IsActiveType(TYPE_CONTINUOUS)
	end)
end
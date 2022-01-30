--Squares
if not pcall(function() require("expansions/script/c20000200") end) then require("script/c20000200") end
function c20000206.initial_effect(c)
	aux.AddCodeList(c,20000200)
	local e1=fufu_loop.ctadt(c)
	local e5=fufu_loop.b(c,EFFECT_CANNOT_CHANGE_CONTROL,1)
end
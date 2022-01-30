--Diagonals
if not pcall(function() require("expansions/script/c20000200") end) then require("script/c20000200") end
function c20000202.initial_effect(c)
	aux.AddCodeList(c,20000200)
	local e1=fufu_loop.ctadt(c)
	local e5=fufu_loop.b(c,EFFECT_INDESTRUCTABLE_BATTLE,function(e,c)
		return c and not c:GetBattleTarget():GetColumnGroup():IsContains(c)
	end)
	local e6=e5:Clone()
	e6:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e6:SetCode(EFFECT_AVOID_BATTLE_DAMAGE)
	c:RegisterEffect(e6)
end
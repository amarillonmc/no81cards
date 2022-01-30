--Kites
if not pcall(function() require("expansions/script/c20000200") end) then require("script/c20000200") end
function c20000204.initial_effect(c)
	aux.AddCodeList(c,20000200)
	local e1=fufu_loop.ctadt(c)
	local e5=fufu_loop.b(c,EFFECT_EXTRA_ATTACK,function(e,c)
		return Duel.GetMatchingGroupCount(function(c)
			return c:IsType(TYPE_SPELL) and c:IsType(TYPE_CONTINUOUS) and c:IsFaceup()
		end,0,LOCATION_ONFIELD,0,nil)
	end)
end
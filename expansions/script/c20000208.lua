--Easygame
if not pcall(function() require("expansions/script/c20000200") end) then require("script/c20000200") end
function c20000208.initial_effect(c)
	aux.AddCodeList(c,20000200)
	local e1=fufu_loop.s(c)
	local e2=fufu_loop.ro(c,CATEGORY_DRAW,20000208,function(e,tp,eg,ep,ev,re,r,rp)
		if Duel.IsPlayerCanDraw(tp,1) and Duel.SelectYesNo(tp,aux.Stringid(20000208,0)) then
			Duel.BreakEffect()
			Duel.Draw(tp,1,REASON_EFFECT)
		end
	end)
end
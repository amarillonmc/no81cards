--Goastray
if not pcall(function() require("expansions/script/c20000200") end) then require("script/c20000200") end
function c20000209.initial_effect(c)
	aux.AddCodeList(c,20000200)
	local e1=fufu_loop.s(c)
	local e2=fufu_loop.ro(c,CATEGORY_TOHAND,20000209,function(e,tp,eg,ep,ev,re,r,rp)
		local g=Duel.GetMatchingGroup(nil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
		if #g>0 and Duel.SelectYesNo(tp,aux.Stringid(20000209,0)) then
			Duel.BreakEffect()
			Duel.SendtoDeck(g:Select(tp,1,1,nil),nil,2,REASON_EFFECT)
		end
	end)
end
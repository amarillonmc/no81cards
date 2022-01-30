--Selectgame
if not pcall(function() require("expansions/script/c20000200") end) then require("script/c20000200") end
function c20000210.initial_effect(c)
	aux.AddCodeList(c,20000200)
	local e1=fufu_loop.s(c)
	local e2=fufu_loop.ro(c,0,20000210,function(e,tp,eg,ep,ev,re,r,rp)
		local g=Duel.GetMatchingGroup(function(c,tp)
			return aux.IsCodeListed(c,20000200) and c:GetType()==0x20002 end,tp,LOCATION_DECK,0,nil,tp)
		if Duel.GetLocationCount(1-tp,LOCATION_SZONE,tp)>0 and #g>0 and Duel.SelectYesNo(tp,aux.Stringid(20000210,0)) then
			Duel.BreakEffect()
			local tc=Duel.SelectMatchingCard(tp,function(c) return aux.IsCodeListed(c,20000200) and c:GetType()==0x20002 end,tp,LOCATION_DECK,0,1,1,nil):GetFirst()
			Duel.MoveToField(tc,tp,1-tp,LOCATION_SZONE,POS_FACEUP,true)
			local te=tc:GetActivateEffect()
			if te then
				te:UseCountLimit(tp,1,true)
			end
		end
	end)
end
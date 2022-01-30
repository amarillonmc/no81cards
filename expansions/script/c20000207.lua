--Completegame
if not pcall(function() require("expansions/script/c20000200") end) then require("script/c20000200") end
function c20000207.initial_effect(c)
	aux.AddCodeList(c,20000200)
	local e1=fufu_loop.s(c)
	local e2=fufu_loop.ro(c,CATEGORY_ATKCHANGE,20000207,function(e,tp,eg,ep,ev,re,r,rp)
		if Duel.GetMatchingGroup(Card.IsCode,tp,LOCATION_MZONE,0,nil,20000200):GetCount()~=0 then
			Duel.BreakEffect()
			local sg=Duel.GetMatchingGroup(Card.IsCode,tp,LOCATION_MZONE,0,nil,20000200)
			local tc=sg:GetFirst()
			while tc do
				local e1=Effect.CreateEffect(e:GetHandler())
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_UPDATE_ATTACK)
				e1:SetReset(RESET_EVENT+RESETS_STANDARD)
				e1:SetValue(700)
				tc:RegisterEffect(e1)
				tc=sg:GetNext()
			end
		end
	end)
end
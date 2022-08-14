--天基兵器 上帝之杖
local cm,m,o=GetID()
if not pcall(function() require("expansions/script/c33330048") end) then require("script/c33330048") end
function cm.initial_effect(c)
	local e1,e2 = Rule_SpaceWeapon.initial(c,m,cm.op)
end
function cm.op(e,tp,eg,ep,ev,re,r,rp,c)
	local g=Duel.GetMatchingGroup(aux.NegateMonsterFilter,tp,0,LOCATION_MZONE,nil)
	if #g>0 then
		Duel.BreakEffect()
		for tc in aux.Next(g) do
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_DISABLE)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			tc:RegisterEffect(e1)
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_DISABLE_EFFECT)
			e2:SetValue(RESET_TURN_SET)
			e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			tc:RegisterEffect(e2)
		end
	end
end
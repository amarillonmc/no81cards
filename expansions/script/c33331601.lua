--天基兵器 普罗米修斯之炎
local cm,m,o=GetID()
if not pcall(function() require("expansions/script/c33330048") end) then require("script/c33330048") end
function cm.initial_effect(c)
	local e1,e2 = Rule_SpaceWeapon.initial(c,m,cm.op)
end
function cm.op(e,tp,eg,ep,ev,re,r,rp,c)
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_MZONE,nil)
	if #g>0 then
		Duel.BreakEffect()
		local total=0
		for tc in aux.Next(g) do
			local preatk=tc:GetAttack()
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_SET_ATTACK_FINAL)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			e1:SetValue(0)
			tc:RegisterEffect(e1)
			total = total + (preatk-tc:GetAttack())/2
		end
		if total>0 then Duel.Damage(1-tp,total,REASON_EFFECT) end
	end
end
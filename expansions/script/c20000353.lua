--奉神天使 拉斐尔
local cm,m,o=GetID()
if not pcall(function() require("expansions/script/c20000350") end) then require("script/c20000350") end
function cm.initial_effect(c)
	local e = {fu_god.Summon(c,m,cm.filter,cm.op)}
end
function cm.filter(c)
	return c:IsLocation(LOCATION_MZONE)and c:IsFaceup()
end
function cm.op(e,tp,eg,ep,ev,re,r,rp,g,fc)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_ATTACK_FINAL)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetValue(fc:GetAttack()*2)
		fc:RegisterEffect(e1)
end
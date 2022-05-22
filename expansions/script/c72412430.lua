--极武孤王拳 雪蓉
function c72412430.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,nil,2,4)
	c:EnableReviveLimit()
	--multi attack
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_EXTRA_ATTACK)
	e1:SetValue(c72412430.val)
	c:RegisterEffect(e1)
end
function c72412430.val(e,c)
	local lp=Duel.GetLP(c:GetControler())
	local ac=math.floor(lp/3000)
	return ac
end

--真武龙崩拳 雪蓉
function c72412020.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,nil,2,4)
	c:EnableReviveLimit()
	--atkup
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetCondition(c72412020.atkcon)
	e1:SetValue(c72412020.atkval)
	c:RegisterEffect(e1)
end
function c72412020.atkcon(e)
	local ph=Duel.GetCurrentPhase()
	local bc=e:GetHandler():GetBattleTarget()
	return (ph==PHASE_DAMAGE or ph==PHASE_DAMAGE_CAL) and bc and bc:GetControler()~=e:GetHandler():GetControler()
end
function c72412020.atkval(e,c)
	return Duel.GetLP(c:GetControler())
end
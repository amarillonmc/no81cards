--标准差的妖精 奥莉安娜
function c33700042.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--splimit
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c33700042.splimit)
	c:RegisterEffect(e1)
	 --direct attack
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_DIRECT_ATTACK)
	e2:SetRange(LOCATION_PZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetCondition(c33700042.con)
	c:RegisterEffect(e2)
end
function c33700042.splimit(e,c,sump,sumtype,sumpos,targetp)
	if not bit.band(sumtype,SUMMON_TYPE_PENDULUM)==SUMMON_TYPE_PENDULUM then return end
	return c:GetLevel()>=4
end
function c33700042.filter(c)
	return not (c:IsFaceup() and c:IsLevelBelow(2))
end
function c33700042.con(e)
	local tp=e:GetHandlerPlayer()
	return not Duel.IsExistingMatchingCard(c33700042.filter,tp,LOCATION_MZONE,0,1,nil)
end

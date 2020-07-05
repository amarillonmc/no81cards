--整合运动·磐蟹
function c79020003.initial_effect(c)
	--deepen damage
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
	e1:SetCode(EVENT_PRE_BATTLE_DAMAGE)
	e1:SetCondition(c79020003.dcon)
	e1:SetOperation(c79020003.dop)
	c:RegisterEffect(e1)	
	--self des
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EFFECT_SELF_DESTROY)
	e3:SetCondition(c79020003.sdcon)
	c:RegisterEffect(e3)
end
function c79020003.dcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return ep~=tp and Duel.GetAttackTarget()==c
end
function c79020003.dop(e,tp,eg,ep,ev,re,r,rp)
	Duel.ChangeBattleDamage(ep,ev*2)
end
function c79020003.sdcon(e)
	return e:GetHandler():GetOwnerTargetCount()>0
end
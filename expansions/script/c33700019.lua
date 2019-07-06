--大往生
function c33700019.initial_effect(c)
	 --Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DAMAGE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_DESTROYED)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCondition(c33700019.condition) 
	e1:SetTarget(c33700019.target)
	e1:SetOperation(c33700019.activate)
	c:RegisterEffect(e1)
end
function c33700019.condition(e,tp,eg,ep,ev,re,r,rp)
	return rp==1-tp and bit.band(r,REASON_DESTROY)~=0 and eg:IsExists(c33700019.filter,1,nil)
end
function c33700019.filter(c)
	return c:IsPreviousPosition(POS_FACEUP)  and c:IsPreviousLocation(LOCATION_MZONE) and c:IsReason(REASON_EFFECT) 
	and (bit.band(c:GetPreviousRaceOnField(),RACE_MACHINE)~=0 or bit.band(c:GetPreviousRaceOnField(),RACE_PSYCHO)~=0) and c:GetAttack()>0 
end
function c33700019.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local g=eg:Filter(c33700019.filter,nil)
	local tg=g:GetFirst()
	local dam=0
	while tg do
		dam=dam+tg:GetAttack()
	  tg=g:GetNext()
end
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,PLAYER_ALL,dam*2)
end
function c33700019.activate(e,tp,eg,ep,ev,re,r,rp)
	 local g=eg:Filter(c33700019.filter,nil)
	local tg=g:GetFirst()
	local dam=0
	while tg do
		dam=dam+tg:GetAttack()
	  tg=g:GetNext()
end
	Duel.Damage(tp,dam*2,REASON_EFFECT,true)
	Duel.Damage(1-tp,dam*2,REASON_EFFECT,true)
	Duel.RDComplete()
end
--魔物使 御堂
function c33700000.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--splimit
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetRange(LOCATION_PZONE)
	e1:SetTargetRange(1,0)
	e1:SetCondition(c33700000.spcon)
	e1:SetTarget(c33700000.splimit)
	c:RegisterEffect(e1)
	--scarup
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(33700000,0))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_PZONE)
	e2:SetCountLimit(1)
	e2:SetCost(c33700000.cost)
	e2:SetOperation(c33700000.operation)
	c:RegisterEffect(e2)
	--destroy replace
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EFFECT_DESTROY_REPLACE)
	e3:SetTarget(c33700000.desreptg)
	c:RegisterEffect(e3)
end
function c33700000.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return bit.band(sumtype,SUMMON_TYPE_PENDULUM)==SUMMON_TYPE_PENDULUM
end
function c33700000.spfilter(c)
	return not c:IsFaceup() or not (c:IsSetCard(0x3440) or c:IsSetCard(0x6440)) 
end
function c33700000.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c33700000.spfilter,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil)
end
function c33700000.cfilter(c,g)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x6440) and not c:IsPublic() and c:GetLevel()~=g:GetRightScale() and c:GetLevel()~=g:GetLeftScale()
end
function c33700000.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c33700000.cfilter,tp,LOCATION_HAND,0,1,nil,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local g=Duel.SelectMatchingCard(tp,c33700000.cfilter,tp,LOCATION_HAND,0,1,1,nil,e:GetHandler())
	Duel.ConfirmCards(1-tp,g)
	Duel.ShuffleHand(tp)
	e:SetLabel(g:GetFirst():GetLevel())
end
function c33700000.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_LSCALE)
		e1:SetValue(e:GetLabel())
		e1:SetReset(RESET_EVENT+0x1ff0000+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_CHANGE_RSCALE)
		c:RegisterEffect(e2)
	end
end
function c33700000.filter(c)
	return  c:IsFaceup() and  c:IsSetCard(0x6440) and c:IsReleasableByEffect() and not c:IsStatus(STATUS_DESTROY_CONFIRMED)
end
function c33700000.desreptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return not c:IsReason(REASON_REPLACE) and c:IsOnField() and c:IsFaceup()
		and Duel.CheckReleaseGroup(tp,c33700000.filter,1,c) end
	if Duel.SelectYesNo(tp,aux.Stringid(33700000,1)) then
		local g=Duel.SelectReleaseGroup(tp,c33700000.filter,1,1,c)
		Duel.Release(g,REASON_EFFECT+REASON_REPLACE)
		Duel.BreakEffect()
		Duel.Damage(1-tp,g:GetFirst():GetAttack(),REASON_EFFECT)
		return true
	else return false end
end

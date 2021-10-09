--Clock Up
function c9980576.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_END_PHASE)
	e1:SetCountLimit(1,9980576+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c9980576.condition)
	e1:SetTarget(c9980576.target)
	e1:SetOperation(c9980576.activate)
	c:RegisterEffect(e1)
end
function c9980576.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xcbca) and (c:IsLevelAbove(8) or c:IsType(TYPE_XYZ+TYPE_LINK))
end
function c9980576.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c9980576.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c9980576.rmfilter(c)
	return c:IsAbleToRemove() and not c:IsType(TYPE_TOKEN)
end
function c9980576.filter(c)
	return c:IsFaceup() and c:IsSetCard(0xcbca)
end
function c9980576.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9980576.rmfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,e:GetHandler()) end
	local g=Duel.GetMatchingGroup(c9980576.rmfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
end
function c9980576.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c9980576.rmfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,aux.ExceptThisCard(e))
	if g:GetCount()>0 then
		Duel.HintSelection(g)
		Duel.Remove(g,POS_FACEDOWN,REASON_EFFECT)
	end
	local g2=Duel.GetMatchingGroup(c9980576.filter,tp,LOCATION_MZONE,0,nil)
	local tc=g2:GetFirst()
	while tc do
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e1:SetRange(LOCATION_MZONE)
		e1:SetCode(EFFECT_IMMUNE_EFFECT)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		e1:SetValue(c9980576.efilter)
		tc:RegisterEffect(e1)
		tc=g2:GetNext()
	end
end
function c9980576.efilter(e,te)
	return te:IsActiveType(TYPE_SPELL+TYPE_TRAP) and te:GetOwner()~=e:GetOwner()
end
--单调士的叛者
function c9310068.initial_effect(c)
	--negate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(9310068,0))
	e1:SetCategory(CATEGORY_NEGATE+CATEGORY_DISABLE+CATEGORY_DESTROY+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e1:SetCode(EVENT_CHAINING)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,9310068)
	e1:SetCondition(c9310068.negcon)
	e1:SetCost(c9310068.negcost)
	e1:SetTarget(c9310068.negtg)
	e1:SetOperation(c9310068.negop)
	c:RegisterEffect(e1)
	--nontuner
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_NONTUNER)
	e2:SetValue(c9310068.tnval)
	c:RegisterEffect(e2)
end
function c9310068.negcon(e,tp,eg,ep,ev,re,r,rp)
	if not re:GetHandler():IsType(TYPE_TUNER) then return false end
	return re:IsActiveType(TYPE_MONSTER)
end
function c9310068.negcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsDiscardable() 
		or (Duel.IsPlayerAffectedByEffect(tp,9310027) and not c:IsPublic()) end
	if Duel.IsPlayerAffectedByEffect(tp,9310027) and not c:IsPublic() 
	   and (not c:IsDiscardable() or Duel.SelectOption(tp,aux.Stringid(9310027,0),aux.Stringid(9310027,1))==0) then
	   Duel.ConfirmCards(1-tp,c)
	else
	   Duel.SendtoGrave(e:GetHandler(),REASON_COST+REASON_DISCARD)
	end
end
function c9310068.negtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local b1=Duel.IsChainNegatable(ev)
	local b2=c:IsLocation(LOCATION_HAND)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
	if chk==0 then return b1 or b2 end
end
function c9310068.negop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local b1=Duel.IsChainNegatable(ev)
	local b2=c:IsLocation(LOCATION_HAND) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
			   and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
			   and not re:GetHandler():IsDisabled()
	if b1 or b2 then
		local s
		if b1 and b2 then
			s=Duel.SelectOption(tp,aux.Stringid(9310068,0),aux.Stringid(9310068,1))
		elseif b1 then
			s=Duel.SelectOption(tp,aux.Stringid(9310068,0))
		else
			s=Duel.SelectOption(tp,aux.Stringid(9310068,1))+1
		end
		if s==0 then
			Duel.BreakEffect()
			if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
				Duel.Destroy(eg,REASON_EFFECT)
			end
		elseif s==1 then
			Duel.BreakEffect()
			if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0 
			   and not re:GetHandler():IsDisabled() 
			   and Duel.SelectYesNo(tp,aux.Stringid(9310068,2)) then
				Duel.BreakEffect()
				Duel.NegateEffect(ev)
			end
		end
	end
end
function c9310068.tnval(e,c)
	return e:GetHandler():IsAttackPos()
end
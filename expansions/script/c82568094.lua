--AK-捕虫家雪雉
function c82568094.initial_effect(c)
	--double
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DISABLE+CATEGORY_POSITION)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,82568094)
	e1:SetCondition(c82568094.condition)
	e1:SetTarget(c82568094.target)
	e1:SetOperation(c82568094.operation)
	c:RegisterEffect(e1)
end
function c82568094.condition(e,tp,eg,ep,ev,re,r,rp)
	return re:GetHandler():IsOnField() and re:GetHandler():IsRelateToEffect(re) and re:IsActiveType(TYPE_MONSTER)
		and re:GetHandler():IsPosition(POS_FACEUP_ATTACK) and re:GetHandler():IsCanChangePosition() and ep==1-e:GetHandler():GetControler()
end
function c82568094.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 
		 and Duel.GetCounter(tp,LOCATION_ONFIELD,0,0x5825)>0 end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,LOCATION_HAND)
	Duel.SetOperationInfo(0,CATEGORY_POSITION,eg,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,eg,1,0,0)
end
function c82568094.operation(e,tp,eg,ep,ev,re,r,rp)
	if re:GetHandler():IsRelateToEffect(re) and Duel.GetCounter(tp,LOCATION_ONFIELD,0,0x5825)>0 and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
	if Duel.SpecialSummon(e:GetHandler(),0,tp,tp,false,false,POS_FACEUP)~=0 then
	if Duel.ChangePosition(re:GetHandler(),POS_FACEUP_DEFENSE)~=0 then
	local e3=Effect.CreateEffect(e:GetHandler())
				  e3:SetType(EFFECT_TYPE_SINGLE)
				  e3:SetCode(EFFECT_DISABLE)
				  e3:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
				  re:GetHandler():RegisterEffect(e3)
				  local e4=Effect.CreateEffect(e:GetHandler())
		e4:SetType(EFFECT_TYPE_SINGLE)
		e4:SetCode(EFFECT_DISABLE_EFFECT)
		e4:SetValue(RESET_TURN_SET)
		e4:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		re:GetHandler():RegisterEffect(e4)
	end
	end
	end
end

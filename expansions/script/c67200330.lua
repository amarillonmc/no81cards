-- 结天缘神 甜点时光
function c67200330.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_NEGATE+CATEGORY_TODECK+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCondition(c67200330.condition)
	e1:SetCost(c67200330.excost)
	e1:SetTarget(c67200330.target)
	e1:SetOperation(c67200330.activate)
	c:RegisterEffect(e1)	
end
--
function c67200330.actfilter(c)
	return c:IsFaceup() and c:GetSequence()<5 and c:IsSetCard(0x671)
end
function c67200330.condition(e,tp,eg,ep,ev,re,r,rp)
	local tp=e:GetHandler():GetControler()
	return Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)==1
		and Duel.IsExistingMatchingCard(c67200330.actfilter,tp,LOCATION_MZONE,0,1,nil) and Duel.IsChainNegatable(ev) and (re:IsActiveType(TYPE_MONSTER) or re:IsHasType(EFFECT_TYPE_ACTIVATE))
end
function c67200330.excostfilter(c)
	return c:IsSetCard(0x671) and c:IsAbleToHandAsCost()
end
function c67200330.excost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c67200330.excostfilter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=Duel.SelectMatchingCard(tp,c67200330.excostfilter,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SendtoHand(g,nil,REASON_COST)
	e:SetLabel(g:GetFirst():GetBaseAttack())
end
function c67200330.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,67200330,0x671,TYPES_EFFECT_TRAP_MONSTER,1000,1000,2,RACE_FAIRY,ATTRIBUTE_LIGHT,POS_FACEUP_ATTACK) and aux.nbcon(tp,re) end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_TODECK,eg,1,0,0)
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
	end
end
function c67200330.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
		Duel.SendtoDeck(eg,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
		Duel.BreakEffect()
		if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
		local c=e:GetHandler()
		if not c:IsRelateToEffect(e)
			or not Duel.IsPlayerCanSpecialSummonMonster(tp,67200330,0x671,TYPES_EFFECT_TRAP_MONSTER,1000,1000,2,RACE_FAIRY,ATTRIBUTE_LIGHT,POS_FACEUP_ATTACK) then return end
		c:AddMonsterAttribute(TYPE_EFFECT)
		if Duel.SpecialSummonStep(c,SUMMON_VALUE_SELF,tp,tp,true,false,POS_FACEUP_ATTACK)~=0 then
			local e1=Effect.CreateEffect(c)
			--e1:SetDescription(aux.Stringid(67200330,2))
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetReset(RESET_EVENT+RESETS_REDIRECT)
			e1:SetValue(LOCATION_DECK)
			c:RegisterEffect(e1)
			c:RegisterFlagEffect(67200330,RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(67200330,2))
			Duel.SpecialSummonComplete()
		end
	end
end
--里魂的残念
function c98500506.initial_effect(c)
	--act in set turn
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_TRAP_ACT_IN_SET_TURN)
	e0:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e0:SetCondition(c98500506.actcon)
	c:RegisterEffect(e0)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--SPECIAL_SUMMON
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(98500506,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCountLimit(1,98500506)
	e2:SetHintTiming(0,TIMING_END_PHASE)
	e2:SetTarget(c98500506.target)
	e2:SetOperation(c98500506.activate)
	c:RegisterEffect(e2)
	--sset
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(98500506,1))
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O) 
	e3:SetCode(EVENT_CHAINING)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCountLimit(1,98500506)
	e3:SetCondition(c98500506.setcon)
	e3:SetTarget(c98500506.settg)
	e3:SetOperation(c98500506.setop)
	c:RegisterEffect(e3)
	--set
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(98500506,2))
	e4:SetCategory(CATEGORY_HANDES)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCost(c98500506.cost)
	e4:SetCountLimit(1,98500506)
	e4:SetTarget(c98500506.settg2)
	e4:SetOperation(c98500506.setop2)
	c:RegisterEffect(e4)
end
function c98500506.afilter(c)
	return c:IsPosition(POS_FACEUP)
end
function c98500506.afilter2(c)
	return c:IsPosition(POS_FACEDOWN)
end
function c98500506.actcon(e)
	return Duel.IsExistingMatchingCard(c98500506.afilter2,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil) and not Duel.IsExistingMatchingCard(c98500506.afilter,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil)
end
function c98500506.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:IsCostChecked() and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsPlayerCanSpecialSummonMonster(tp,98500506,0,TYPES_EFFECT_TRAP_MONSTER,1000,2000,4,RACE_ILLUSION,ATTRIBUTE_EARTH) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c98500506.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.IsPlayerCanSpecialSummonMonster(tp,98500506,0,TYPES_EFFECT_TRAP_MONSTER,1000,2000,4,RACE_ILLUSION,ATTRIBUTE_EARTH) then
		c:AddMonsterAttribute(TYPE_EFFECT+TYPE_FLIP)
		if Duel.SpecialSummonStep(c,0,tp,tp,true,false,POS_FACEUP) then
			c:RegisterFlagEffect(98500506,RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(98500506,3))
			--double tribute
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_DOUBLE_TRIBUTE)
			e1:SetValue(c98500506.condition)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET+RESET_PHASE+PHASE_END,2)
			c:RegisterEffect(e1)
		end
		Duel.SpecialSummonComplete()
		Duel.BreakEffect()
		Duel.ChangePosition(c,POS_FACEDOWN_DEFENSE)
	end
end
function c98500506.condition(e,c)
	return c:IsType(TYPE_FLIP) and e:GetHandler():IsFacedown()
end
function c98500506.setcon(e,tp,eg,ep,ev,re,r,rp)
	return re:IsActiveType(TYPE_FLIP)
end
function c98500506.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsSSetable() end
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,e:GetHandler(),1,0,0)
end
function c98500506.setop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SSet(tp,c)
	end
end
function c98500506.setfilter(c)
	return c:IsSetCard(0x985) and c:IsType(TYPE_SPELL+TYPE_TRAP) and not c:IsCode(98500506) and c:IsSSetable()
end
function c98500506.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,e:GetHandler()) end
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)
end
function c98500506.settg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c98500506.setfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_HANDES,nil,0,tp,1)
end
function c98500506.setop2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g=Duel.SelectMatchingCard(tp,c98500506.setfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
	local tc=g:GetFirst()
	if tc then
		Duel.SSet(tp,tc)
	end
end

--三十六计·擒贼擒王
function c9360018.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_CONTROL)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,9360018)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetTarget(c9360018.target)
	e1:SetOperation(c9360018.activate)
	c:RegisterEffect(e1)
	--to hand
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,9361018)
	e2:SetCost(c9360018.thcost)
	e2:SetTarget(c9360018.thtg)
	e2:SetOperation(c9360018.thop)
	c:RegisterEffect(e2)
end
c9360018.setname="36Stratagems"
function c9360018.tgfilter(c)
	return c:IsFaceup() and c:IsControlerCanBeChanged()
end
function c9360018.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_MZONE,nil)
	local tg=g:GetMaxGroup(Card.GetAttack)
	if chk==0 then return Duel.IsExistingMatchingCard(c9360018.tgfilter,tp,0,LOCATION_MZONE,1,nil,tg) end
	Duel.SetOperationInfo(0,CATEGORY_CONTROL,tg,1,1-tp,LOCATION_MZONE)
end
function c9360018.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_MZONE,nil)
	if g:GetCount()>0 then
		local tg=g:GetMaxGroup(Card.GetAttack)
		local sg=tg:Select(tp,1,1,nil)
		local tc=sg:GetFirst()
		e:SetLabelObject(sg:GetFirst())
		local atk=tc:GetBaseAttack()
		if tg:GetCount()>1 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONTROL)
			Duel.HintSelection(sg)
			Duel.GetControl(sg,tp)
		else Duel.GetControl(tg,tp) end
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CANNOT_ATTACK)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_CONTROL)
		tc:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_CANNOT_TRIGGER)
		tc:RegisterEffect(e2)
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_FIELD)
		e3:SetCode(EFFECT_CANNOT_ATTACK)
		e3:SetTargetRange(0,LOCATION_MZONE)
		e3:SetTarget(aux.TargetBoolFunction(Card.IsAttackBelow,atk))
		e3:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_CONTROL)
		Duel.RegisterEffect(e3,tp)
	end
end
function c9360018.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,2,nil) end
	Duel.DiscardHand(tp,Card.IsDiscardable,2,2,REASON_COST+REASON_DISCARD)
end
function c9360018.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToHand() end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
end
function c9360018.thop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsRelateToEffect(e) then
		Duel.SendtoHand(e:GetHandler(),nil,REASON_EFFECT)
	end
end

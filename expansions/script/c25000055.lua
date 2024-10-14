--蜂之武藏
function c25000055.initial_effect(c)
	--destroy
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_BATTLE_DESTROYED)
	e1:SetCountLimit(1,25000055)
	e1:SetCondition(c25000055.descon)
	e1:SetCost(c25000055.cost)
	e1:SetTarget(c25000055.destg)
	e1:SetOperation(c25000055.desop)
	c:RegisterEffect(e1)
end
function c25000055.descon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousPosition(POS_ATTACK) and e:GetHandler():IsReason(REASON_BATTLE)
end
function c25000055.tgfilter(c)
	return c:IsAttackAbove(100) and c:IsAbleToGraveAsCost()
end
function c25000055.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local tc=e:GetHandler():GetReasonCard()
	local g=Duel.GetMatchingGroup(c25000055.tgfilter,tp,LOCATION_DECK+LOCATION_EXTRA,0,nil)
	if chk==0 then return tc and g:CheckWithSumGreater(Card.GetAttack,tc:GetAttack()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local tg=g:SelectWithSumGreater(tp,Card.GetAttack,tc:GetAttack())
	Duel.SendtoGrave(tg,REASON_COST)
end
function c25000055.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(Card.IsPosition,tp,0,LOCATION_MZONE,nil,POS_FACEUP_ATTACK)
	if chk==0 then return #g>0 end
	local tg=g:GetMaxGroup(Card.GetAttack)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,tg,1,0,0)
end
function c25000055.desop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsPosition,tp,0,LOCATION_MZONE,nil,POS_FACEUP_ATTACK)
	if g:GetCount()>0 then
		local tg=g:GetMaxGroup(Card.GetAttack)
		if tg:GetCount()>1 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
			local sg=tg:Select(tp,1,1,nil)
			Duel.HintSelection(sg)
			Duel.Destroy(sg,REASON_EFFECT)
		else Duel.Destroy(tg,REASON_EFFECT) end
	end
end

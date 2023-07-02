--先史遗产 罗马正十二面体
function c98921031.initial_effect(c)
	--search
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(98921031,1))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,98921031)
	e1:SetCost(c98921031.cost)
	e1:SetTarget(c98921031.target)
	e1:SetOperation(c98921031.operation)
	c:RegisterEffect(e1)
end
function c98921031.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToDeckAsCost() end
	Duel.SendtoDeck(c,nil,SEQ_DECKSHUFFLE,REASON_COST)
end
function c98921031.filter2(c)
	return c:IsSetCard(0x70) and c:IsType(TYPE_SPELL) and c:IsAbleToHand()
end
function c98921031.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c98921031.filter2,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c98921031.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local tg=Duel.SelectMatchingCard(tp,c98921031.filter2,tp,LOCATION_DECK,0,1,1,nil)
	if tg:GetCount()>0 then
		Duel.SendtoHand(tg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tg)
	end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e1:SetValue(c98921031.val)
	e1:SetReset(RESET_PHASE+PHASE_END,2)
	Duel.RegisterEffect(e1,tp)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetCondition(c98921031.reccon)
	e2:SetOperation(c98921031.recop)
	e2:SetReset(RESET_PHASE+PHASE_END,2)
	Duel.RegisterEffect(e2,tp)
	local e3=e2:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	Duel.RegisterEffect(e3,tp)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_CHAIN_SOLVING)
	e4:SetReset(RESET_PHASE+PHASE_END,2)
	e4:SetOperation(c98921031.disop)
	Duel.RegisterEffect(e4,tp)
end
function c98921031.val(e,c)
   return c:GetLevel()*-200
end
function c98921031.cfilter(c,tp)
	return c:IsSummonPlayer(tp)
end
function c98921031.reccon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c98921031.cfilter,1,nil,1-tp)
end
function c98921031.atkfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x70)
end
function c98921031.recop(e,tp,eg,ep,ev,re,r,rp)
	local tg=Duel.GetMatchingGroup(c98921031.atkfilter,tp,LOCATION_MZONE,0,nil)
	local ct=tg:GetCount()
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_MZONE,nil)
	local tc=g:GetFirst()
	while tc do
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(-ct*200)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		tc=g:GetNext()
	end
end
function c98921031.disfilter(c)
	return c:IsSetCard(0x70) and c:IsAttackAbove(1) and c:IsFaceup()
end
function c98921031.disop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rc=re:GetHandler()
	if rp==1-tp and Duel.IsChainDisablable(ev) and c:GetFlagEffect(98921031)==0 and re:IsActiveType(TYPE_MONSTER)
		and rc:IsFaceup() and rc:IsLocation(LOCATION_MZONE) and (rc:IsAttack(0))
		and Duel.IsExistingMatchingCard(c98921031.disfilter,tp,LOCATION_MZONE,0,1,nil)
		and Duel.SelectYesNo(tp,aux.Stringid(98921031,0)) then
		Duel.Hint(HINT_CARD,0,98921031)
		Duel.NegateEffect(ev)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
		local g=Duel.SelectMatchingCard(tp,c98921031.disfilter,tp,LOCATION_MZONE,0,1,1,nil)
		if g:GetCount()>0 then
			Duel.HintSelection(g)
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_SET_ATTACK_FINAL)
			e1:SetValue(0)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			g:GetFirst():RegisterEffect(e1)
		end
	end
end
--复仇乐士 栀子
function c19209711.initial_effect(c)
	--negate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(19209711,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,19209711)
	e1:SetCondition(c19209711.thcon)
	e1:SetTarget(c19209711.thtg)
	e1:SetOperation(c19209711.thop)
	c:RegisterEffect(e1)
	--atk up
	local e2=Effect.CreateEffect(c)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
	e2:SetDescription(aux.Stringid(19209711,1))
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,19209711+1)
	e2:SetTarget(c19209711.atktg)
	e2:SetOperation(c19209711.atkop)
	c:RegisterEffect(e2)
end
function c19209711.thcon(e,tp,eg,ep,ev,re,r,rp)
	local ex,tg,tc=Duel.GetOperationInfo(ev,CATEGORY_DESTROY)
	return rp==1-tp and ((ex and (tg~=nil or tc>0)) or re:IsActiveType(TYPE_MONSTER) and re:GetActivateLocation()==LOCATION_HAND)
end
function c19209711.thfilter(c,chk)
	return c:IsSetCard(0xb53) and c:IsType(TYPE_TRAP) and c:IsAbleToHand()
end
function c19209711.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c19209711.thfilter,tp,LOCATION_DECK,0,1,nil,0) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c19209711.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local tc=Duel.SelectMatchingCard(tp,c19209711.thfilter,tp,LOCATION_DECK,0,1,1,nil,1):GetFirst()
	if not tc then return end
	Duel.SendtoHand(tc,nil,REASON_EFFECT)
	Duel.ConfirmCards(1-tp,tc)
	--if not tc:IsLocation(LOCATION_HAND) or not Duel.SelectYesNo(tp,aux.Stringid(19209711,2)) then return end
end
function c19209711.tfilter(c)
	return c:IsFaceup()
end
function c19209711.atktg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c19209711.tfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c19209711.tfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c19209711.tfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
end
function c19209711.cfilter(c)
	return c:IsAttackAbove(c:GetBaseAttack()+2500) and c:IsFaceup()
end
function c19209711.pfilter(c)
	return not c:IsPublic()
end
function c19209711.atkop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToChain() then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetValue(500)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
		local g=Duel.GetMatchingGroup(c19209711.pfilter,tp,0,LOCATION_HAND,nil)
		if Duel.IsExistingMatchingCard(c19209711.cfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) and #g>0 and Duel.SelectYesNo(tp,aux.Stringid(19209711,2)) then
			Duel.ConfirmCards(tp,g)
			for tc in aux.Next(g) do
				local e1=Effect.CreateEffect(e:GetHandler())
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_PUBLIC)
				e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
				tc:RegisterEffect(e1)
			end
		end
	end
end

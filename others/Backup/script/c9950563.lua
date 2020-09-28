--Unlimited Blade Works
function c9950563.initial_effect(c)
	c:SetUniqueOnField(1,0,9950563)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--self destroy
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_SZONE)
	e1:SetCode(EFFECT_SELF_DESTROY)
	e1:SetCondition(c9950563.descon)
	c:RegisterEffect(e1)
 --tohand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(9950563,1))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1,9950563)
	e2:SetTarget(c9950563.thtg)
	e2:SetOperation(c9950563.thop)
	c:RegisterEffect(e2)
 --disable
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(9950563,0))
	e2:SetCategory(CATEGORY_DISABLE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER)
	e2:SetCondition(c9950563.negcon)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c9950563.negtg)
	e2:SetOperation(c9950563.negop)
	c:RegisterEffect(e2)
end
function c9950563.filter2(c)
	return c:IsFaceup() and c:IsSetCard(0x6ba6)
end
function c9950563.descon(e)
	return not Duel.IsExistingMatchingCard(c9950563.filter2,0,LOCATION_MZONE,LOCATION_MZONE,1,e:GetHandler())
end
function c9950563.filter(c)
	return (c:IsSetCard(0x6ba6) and c:IsType(TYPE_SPELL+TYPE_TRAP)) or  (c:IsSetCard(0xba5) and c:IsType(TYPE_EQUIP)) and not c:IsCode(9950563) and c:IsAbleToHand()
end
function c9950563.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9950563.filter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function c9950563.thop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c9950563.filter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
 Duel.Hint(HINT_MUSIC,0,aux.Stringid(9950563,0))
end
function c9950563.cfilter(c)
	return c:IsSetCard(0x6ba6) and c:IsFaceup()
end
function c9950563.negcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c9950563.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c9950563.negfilter(c)
	return aux.disfilter1(c) 
end
function c9950563.negtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsControler(1-tp) and c9950563.negfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c9950563.negfilter,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c9950563.negfilter,tp,0,LOCATION_ONFIELD,1,1,nil)
end
function c9950563.negop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() and not tc:IsDisabled() then
		Duel.NegateRelatedChain(tc,RESET_TURN_SET)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetValue(RESET_TURN_SET)
		tc:RegisterEffect(e2)
		if tc:IsType(TYPE_TRAPMONSTER) then
			local e3=e1:Clone()
			e3:SetCode(EFFECT_DISABLE_TRAPMONSTER)
			tc:RegisterEffect(e3)
		end
	end
 Duel.Hint(HINT_MUSIC,0,aux.Stringid(9950563,0))
end
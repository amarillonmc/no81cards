--炼金工房一根筋 兰托·马斯林克
function c75011021.initial_effect(c)
	aux.AddCodeList(c,46130346)
	--=
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DAMAGE)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_HAND+LOCATION_MZONE)
	e1:SetCountLimit(1,75011021)
	e1:SetCost(c75011021.cost)
	e1:SetTarget(c75011021.target)
	e1:SetOperation(c75011021.operation)
	c:RegisterEffect(e1)
	--destroy replace
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EFFECT_DESTROY_REPLACE)
	e2:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e2:SetCountLimit(1,75011022)
	e2:SetTarget(c75011021.reptg)
	e2:SetValue(c75011021.repval)
	e2:SetOperation(c75011021.repop)
	c:RegisterEffect(e2)
end
function c75011021.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsReleasable() end
	if e:GetHandler():IsLocation(LOCATION_MZONE) then
		e:SetLabel(2)
	else
		e:SetLabel(1)
	end
	Duel.Release(e:GetHandler(),REASON_COST)
end
function c75011021.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and chkc:IsFaceup() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsFaceup,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,Card.IsFaceup,tp,0,LOCATION_MZONE,1,1,nil)
end
function c75011021.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) and tc:IsFaceup() then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetDescription(aux.Stringid(75011021,0))
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CANNOT_TRIGGER)
		e1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		if not tc:IsImmuneToEffect(e) and e:GetLabel()==2 then
			Duel.BreakEffect()
			Duel.Damage(1-tp,math.floor(tc:GetBaseAttack()/2),REASON_EFFECT)
		end
	end
end
function c75011021.repfilter(c,tp)
	return c:IsFaceup() and c:IsSetCard(0x75e)
		and c:IsLocation(LOCATION_MZONE) and c:IsControler(tp) and c:IsReason(REASON_EFFECT+REASON_BATTLE) and not c:IsReason(REASON_REPLACE)
end
function c75011021.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemove() and eg:IsExists(c75011021.repfilter,1,nil,tp) end
	return Duel.SelectEffectYesNo(tp,e:GetHandler(),96)
end
function c75011021.repval(e,c)
	return c75011021.repfilter(c,e:GetHandlerPlayer())
end
function c75011021.thfilter(c)
	return c:IsCode(46130346) and c:IsAbleToHand()
end
function c75011021.repop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,75011021)
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_EFFECT)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local tc=Duel.SelectMatchingCard(tp,c75011021.thfilter,tp,LOCATION_DECK,0,1,1,nil):GetFirst()
	if tc then
		Duel.BreakEffect()
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc)
	end
end

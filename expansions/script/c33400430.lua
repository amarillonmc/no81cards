--「紧急着装行动装置」
function c33400430.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,33400430+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c33400430.target)
	e1:SetOperation(c33400430.activate)
	c:RegisterEffect(e1)
end
function c33400430.filter(c,tp)
	return c:IsFaceup() and c:IsSetCard(0xc343)
		and Duel.IsExistingMatchingCard(c33400430.eqfilter,tp,LOCATION_DECK,0,1,nil,c,tp)
end
function c33400430.eqfilter(c,tc,tp)
	return c:IsType(TYPE_EQUIP) and c:IsSetCard(0x6343) and c:CheckEquipTarget(tc) and c:CheckUniqueOnField(tp) and not c:IsForbidden()
end
function c33400430.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c33400430.filter(chkc,tp) end
	local ft=0
	if e:GetHandler():IsLocation(LOCATION_HAND) then ft=1 end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>ft
		and Duel.IsExistingTarget(c33400430.filter,tp,LOCATION_MZONE,0,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c33400430.filter,tp,LOCATION_MZONE,0,1,1,nil,tp)
end
function c33400430.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() and tc:IsControler(tp) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
		local g=Duel.SelectMatchingCard(tp,c33400430.eqfilter,tp,LOCATION_DECK,0,1,1,nil,tc,tp)
		if g:GetCount()>0 then
			Duel.Equip(tp,g:GetFirst(),tc)
			 if   not Duel.IsExistingMatchingCard(Card.IsSetCard,tp,LOCATION_MZONE,0,1,nil,0x341)and Duel.IsExistingMatchingCard(Card.IsSetCard,tp,0,LOCATION_MZONE,1,nil,0x341)   
				or (  Duel.IsExistingMatchingCard(Card.IsFaceup,tp,0,LOCATION_MZONE,1,nil) and 
					(Duel.IsExistingMatchingCard(c33400430.cccfilter1,tp,LOCATION_ONFIELD,0,1,nil) or 
					Duel.IsExistingMatchingCard(c33400430.cccfilter2,tp,LOCATION_MZONE,0,1,nil))) 
				then
				local e3=Effect.CreateEffect(e:GetHandler())
				e3:SetType(EFFECT_TYPE_SINGLE)
				e3:SetCode(EFFECT_IMMUNE_EFFECT)
				e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
				e3:SetRange(LOCATION_MZONE)
				e3:SetValue(c33400430.efilter)
				e3:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
				e3:SetOwnerPlayer(tp)
				tc:RegisterEffect(e3) 
			 end
		end
	end
end
function c33400430.cccfilter1(c)
	return c:IsCode(33400428) and c:IsFaceup()
end
function c33400430.cccfilter2(c)
	return c:IsCode(33400425) and c:IsFaceup() and c:IsSummonType(SUMMON_TYPE_XYZ)
end
function c33400430.efilter(e,re)
	return e:GetOwnerPlayer()~=re:GetOwnerPlayer()
end
--机关傀儡-噩梦人偶
function c40008781.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsAttribute,ATTRIBUTE_DARK),8,2,c40008781.ovfilter,aux.Stringid(40008781,0),2,c40008781.xyzop)
	c:EnableReviveLimit()
	--tohand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(40008781,0))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_TOGRAVE)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,40008781)
	e2:SetCost(c40008781.thcost)
	e2:SetTarget(c40008781.thtg)
	e2:SetOperation(c40008781.thop)
	c:RegisterEffect(e2)
	--direct attack
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_DIRECT_ATTACK)
	e4:SetCondition(c40008781.dircon)
	c:RegisterEffect(e4)
end
function c40008781.ovfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x83) and not c:IsCode(40008781)
end
function c40008781.xyzop(e,tp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,40008781)==0 end
	Duel.RegisterFlagEffect(tp,40008781,RESET_PHASE+PHASE_END,0,1)
end
function c40008781.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c40008781.thfilter(c)
	return c:IsSetCard(0x83) and c:IsType(TYPE_MONSTER) and (c:IsAbleToHand() or c:IsAbleToGrave())
end
function c40008781.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c40008781.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function c40008781.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(40008781,3))
	local g=Duel.SelectMatchingCard(tp,c40008781.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		local tc=g:GetFirst()
		if tc and tc:IsAbleToHand() and (not tc:IsAbleToGrave() or Duel.SelectOption(tp,1190,1191)==0) then
			Duel.SendtoHand(tc,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,tc)
			if tc and c:IsRelateToEffect(e) and c:IsFaceup() and tc:IsLocation(LOCATION_HAND) then
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UPDATE_ATTACK)
			e1:SetValue(tc:GetLevel()*100)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
			c:RegisterEffect(e1)
			local e2=e1:Clone()
			e2:SetCode(EFFECT_UPDATE_DEFENSE)
			c:RegisterEffect(e2)
			end
		else
			Duel.SendtoGrave(tc,REASON_EFFECT)
			if tc and c:IsRelateToEffect(e) and c:IsFaceup() and tc:IsLocation(LOCATION_GRAVE) then
			local e3=Effect.CreateEffect(c)
			e3:SetType(EFFECT_TYPE_SINGLE)
			e3:SetCode(EFFECT_UPDATE_ATTACK)
			e3:SetValue(tc:GetLevel()*100)
			e3:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
			c:RegisterEffect(e3)
			local e4=e3:Clone()
			e4:SetCode(EFFECT_UPDATE_DEFENSE)
			c:RegisterEffect(e4)
			end
		end
	end
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e5:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e5:SetTargetRange(1,0)
	e5:SetTarget(c40008781.splimit)
	e5:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e5,tp)
end
function c40008781.splimit(e,c)
	return not c:IsSetCard(0x83) and c:IsLocation(LOCATION_EXTRA)
end
function c40008781.dircon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:GetOverlayGroup():IsExists(Card.IsSetCard,1,nil,0x83) 
end
--神树勇者 东乡美森
function c9910318.initial_effect(c)
	--search
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,9910318)
	e1:SetCost(c9910318.thcost)
	e1:SetTarget(c9910318.thtg)
	e1:SetOperation(c9910318.thop)
	c:RegisterEffect(e1)
	--tohand
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_EQUIP)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetCountLimit(1,9910319)
	e2:SetCondition(c9910318.thcon2)
	e2:SetTarget(c9910318.thtg2)
	e2:SetOperation(c9910318.thop2)
	c:RegisterEffect(e2)
end
function c9910318.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsDiscardable() end
	Duel.SendtoGrave(c,REASON_COST+REASON_DISCARD)
end
function c9910318.thfilter(c)
	return c:IsCode(9910307) and c:IsAbleToHand()
end
function c9910318.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9910318.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c9910318.thop(e,tp,eg,ep,ev,re,r,rp,chk)
	local tg=Duel.GetFirstMatchingCard(c9910318.thfilter,tp,LOCATION_DECK,0,nil)
	if tg then
		Duel.SendtoHand(tg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tg)
	end
end
function c9910318.thcon2(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD)
end
function c9910318.thfilter2(c)
	return c:IsSetCard(0x956) and c:IsAbleToHand()
end
function c9910318.thtg2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c9910318.thfilter2(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c9910318.thfilter2,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,c9910318.thfilter2,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c9910318.eqfilter(c,tp)
	return c:IsRace(RACE_PLANT) and c:IsAttribute(ATTRIBUTE_LIGHT)
		and c:CheckUniqueOnField(tp) and not c:IsForbidden()
end
function c9910318.cfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_SYNCHRO)
end
function c9910318.thop2(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.SendtoHand(tc,nil,REASON_EFFECT)~=0 and tc:IsLocation(LOCATION_HAND)
		and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 then
		local g1=Duel.GetMatchingGroup(aux.NecroValleyFilter(c9910318.eqfilter),tp,LOCATION_GRAVE,0,nil,tp)
		local g2=Duel.GetMatchingGroup(c9910318.cfilter,tp,LOCATION_MZONE,0,nil)
		if #g1>0 and #g2>0 and Duel.SelectYesNo(tp,aux.Stringid(9910318,0)) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(9910318,1))
			local ec=g1:Select(tp,1,1,nil):GetFirst()
			Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(9910318,2))
			local sc=g2:Select(tp,1,1,nil):GetFirst()
			Duel.HintSelection(Group.FromCards(ec,sc))
			if not Duel.Equip(tp,ec,sc) then return end
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_EQUIP_LIMIT)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			e1:SetValue(c9910318.eqlimit)
			e1:SetLabelObject(sc)
			ec:RegisterEffect(e1)
		end
	end
end
function c9910318.eqlimit(e,c)
	return e:GetLabelObject()==c
end

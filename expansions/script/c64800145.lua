--神代丰 府中之鬼
function c64800145.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--Equip
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(64800145,0))
	e1:SetCategory(CATEGORY_EQUIP+CATEGORY_TODECK)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCountLimit(1,64800145)
	e1:SetTarget(c64800145.eqtg)
	e1:SetOperation(c64800145.eqop)
	c:RegisterEffect(e1)
	--change name
	aux.EnableChangeCode(c,64800097,LOCATION_DECK+LOCATION_GRAVE)
	--to hand
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(64800145,1))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOHAND+CATEGORY_SEARCH)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_TO_HAND)
	e3:SetCountLimit(1,64810145)
	e3:SetCondition(c64800145.thcon)
	e3:SetCost(c64800145.thcost)
	e3:SetTarget(c64800145.thtg)
	e3:SetOperation(c64800145.thop)
	c:RegisterEffect(e3)
end

--e2
function c64800145.mfilter(c)
	return c:IsFaceup()
end
function c64800145.eqfilter(c)
	return c:IsCode(64800097) and not c:IsForbidden()
end
function c64800145.eqtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c64800145.mfilter(chkc) end
	if chk==0 then return e:GetHandler():IsAbleToDeck() and Duel.IsExistingMatchingCard(Card.IsFaceup,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,c64800145.mfilter,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,e:GetHandler(),1,0,0)
end
function c64800145.eqop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if Duel.SendtoDeck(c,nil,2,REASON_EFFECT) and tc and tc:IsRelateToEffect(e) and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and tc:IsFaceup()
		and Duel.IsExistingMatchingCard(c64800145.eqfilter,tp,LOCATION_DECK,0,1,nil)
		and Duel.SelectYesNo(tp,aux.Stringid(64800145,2))
	then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
		local g1=Duel.SelectMatchingCard(tp,c64800145.eqfilter,tp,LOCATION_DECK,0,1,1,nil)
		local tc1=g1:GetFirst()
		if tc1 then
			if Duel.Equip(tp,tc1,tc) then  
				local e1=Effect.CreateEffect(e:GetHandler())
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_EQUIP_LIMIT)
				e1:SetReset(RESET_EVENT+RESETS_STANDARD)
				e1:SetValue(c64800145.eqlimit)
				e1:SetLabelObject(tc)
				tc1:RegisterEffect(e1)
			end
		end
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_FIELD)
		e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e2:SetCode(EFFECT_CANNOT_ACTIVATE)
		e2:SetTargetRange(1,0)
		e2:SetValue(c64800145.aclimit)
		e2:SetLabel(64800145)
		e2:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e2,tp)
	end
end
function c64800145.eqlimit(e,c)
	return c==e:GetLabelObject()
end
function c64800145.aclimit(e,re,tp)
	return re:GetHandler():IsCode(e:GetLabel()) and re:IsActiveType(TYPE_MONSTER)
end

--e3
function c64800145.thfilter(c)
	return c:IsCode(64800097)
end
function c64800145.spsmfilter(c,e,tp)
	return c:IsCode(64800097) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c64800145.thcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()~=PHASE_DRAW
end
function c64800145.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsDiscardable() end
	Duel.SendtoGrave(c,REASON_COST+REASON_DISCARD)
end
function c64800145.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c64800145.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c64800145.thop(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.IsExistingMatchingCard(c64800145.thfilter,tp,LOCATION_DECK,0,1,nil) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local tg=Duel.SelectMatchingCard(tp,c64800145.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	local thc=tg:GetFirst()
	if thc then
		Duel.SendtoHand(thc,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,thc)
		Duel.ShuffleHand(tp)
		if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(c64800145.spsmfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil,e,tp) and Duel.SelectYesNo(tp,aux.Stringid(64800145,3)) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local g=Duel.SelectMatchingCard(tp,c64800145.spsmfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil,e,tp)
			local tc=g:GetFirst()
			if tc then
				if Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP) then
					local e2=Effect.CreateEffect(e:GetHandler())
					e2:SetType(EFFECT_TYPE_FIELD)
					e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
					e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
					e2:SetRange(LOCATION_MZONE)
					e2:SetAbsoluteRange(tp,1,0)
					e2:SetTarget(c64800145.splimit)
					e2:SetReset(RESET_EVENT+RESETS_STANDARD)
					tc:RegisterEffect(e2)
				end
				Duel.SpecialSummonComplete()
			end
		end
	end
end
function c64800145.splimit(e,c)
	return not c:IsSetCard(0x641a) and c:IsLocation(LOCATION_EXTRA)
end
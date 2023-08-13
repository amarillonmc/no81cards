--永夏的释怀
function c9910959.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOGRAVE+CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,9910959)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetTarget(c9910959.target)
	e1:SetOperation(c9910959.activate)
	c:RegisterEffect(e1)
	--to hand
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,9910960)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c9910959.thtg)
	e2:SetOperation(c9910959.thop)
	c:RegisterEffect(e2)
end
function c9910959.filter1(c)
	return c:IsSetCard(0x5954) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c9910959.filter2(c,lv)
	return c:IsSetCard(0x5954) and not c:IsLevel(lv) and c:IsLevelAbove(1) and c:IsAbleToHand()
end
function c9910959.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToGrave,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,e:GetHandler())
		and Duel.IsExistingMatchingCard(c9910959.filter1,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_HAND+LOCATION_ONFIELD)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c9910959.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local tg=Duel.SelectMatchingCard(tp,Card.IsAbleToGrave,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,1,e:GetHandler())
	local tc=tg:GetFirst()
	local res=tc:GetCounter(0x6954)>0
	if tc and Duel.SendtoGrave(tc,REASON_EFFECT)~=0 and tc:IsLocation(LOCATION_GRAVE) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=Duel.SelectMatchingCard(tp,c9910959.filter1,tp,LOCATION_DECK,0,1,1,nil)
		local sc=sg:GetFirst()
		if Duel.SendtoHand(sc,nil,REASON_EFFECT)>0 and sc:IsLocation(LOCATION_HAND) then
			Duel.ConfirmCards(1-tp,sc)
			if res and Duel.IsExistingMatchingCard(c9910959.filter2,tp,LOCATION_DECK,0,1,nil,sc:GetLevel())
				and Duel.SelectYesNo(tp,aux.Stringid(9910959,0)) then
				Duel.BreakEffect()
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
				local sg2=Duel.SelectMatchingCard(tp,c9910959.filter2,tp,LOCATION_DECK,0,1,1,nil,sc:GetLevel())
				Duel.SendtoHand(sg2,nil,REASON_EFFECT)
				Duel.ConfirmCards(1-tp,sg2)
			end
		end
	end
end
function c9910959.thfilter(c)
	return c:IsSetCard(0x5954) and c:GetTurnID()<Duel.GetTurnCount() and not c:IsReason(REASON_RETURN) and c:IsAbleToHand()
end
function c9910959.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c9910959.thfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c9910959.thfilter,tp,LOCATION_GRAVE,0,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,c9910959.thfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c9910959.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and aux.NecroValleyFilter()(tc) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
	end
end

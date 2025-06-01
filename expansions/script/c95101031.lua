--受诅的罪人 韩赛尔
function c95101031.initial_effect(c)
	aux.AddCodeList(c,95101001)
	--pendulum summon
	aux.EnablePendulumAttribute(c,false)
	--Activate
	local e0=Effect.CreateEffect(c)
	e0:SetDescription(1160)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	e0:SetRange(LOCATION_HAND)
	e0:SetCost(c95101031.regop)
	c:RegisterEffect(e0)
	--set/to hand
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_TOGRAVE+CATEGORY_DECKDES)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCountLimit(1,95101031)
	e1:SetCondition(c95101031.thcon)
	e1:SetTarget(c95101031.thtg)
	e1:SetOperation(c95101031.thop)
	c:RegisterEffect(e1)
end
function c95101031.regop(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	e:GetHandler():RegisterFlagEffect(95101031,RESET_PHASE+PHASE_END,EFFECT_FLAG_OATH,1)
end
function c95101031.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetFlagEffect(95101031)~=0
end
function c95101031.penfilter(c)
	return c:IsCode(95101030) and c:IsType(TYPE_PENDULUM) and not c:IsForbidden()
end
function c95101031.thfilter(c)
	return c:IsSetCard(0xbbb) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c95101031.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local check=Duel.IsExistingMatchingCard(Card.IsCode,tp,LOCATION_PZONE,0,1,nil,95101030)
	if chk==0 then return ((Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1)) and Duel.IsExistingMatchingCard(c95101031.penfilter,tp,LOCATION_DECK,0,1,nil) and not check) or (check and Duel.IsExistingMatchingCard(c95101031.thfilter,tp,LOCATION_DECK,0,1,nil) and Duel.IsPlayerCanDiscardDeck(1-tp,5)) end
end
function c95101031.tgfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsAbleToGrave()
end
function c95101031.thop(e,tp,eg,ep,ev,re,r,rp)
	local check=Duel.IsExistingMatchingCard(Card.IsCode,tp,LOCATION_PZONE,0,1,nil,95101030)
	if check then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local tc=Duel.SelectMatchingCard(tp,c95101031.thfilter,tp,LOCATION_DECK,0,1,1,nil):GetFirst()
		if tc then
			Duel.SendtoHand(tc,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,tc)
			Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_TOGRAVE)
			local g=Duel.SelectMatchingCard(1-tp,c95101031.thfilter,1-tp,LOCATION_DECK,0,5,5,nil)
			if g:GetCount()~=5 then return end
			Duel.BreakEffect()
			Duel.SendtoGrave(g,REASON_EFFECT)
		end
	else
		if not Duel.CheckLocation(tp,LOCATION_PZONE,0) and not Duel.CheckLocation(tp,LOCATION_PZONE,1) then return end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
		local tc=Duel.SelectMatchingCard(tp,c95101031.penfilter,tp,LOCATION_DECK,0,1,1,nil):GetFirst()
		if tc then
			Duel.MoveToField(tc,tp,tp,LOCATION_PZONE,POS_FACEUP,true)
		end
	end
end

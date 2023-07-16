--拟态武装 小小飓风
function c67200642.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,c67200642.mfilter,1)
	c:EnableReviveLimit()
	--tohand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(67200642,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1,67200642)
	e1:SetCondition(c67200642.thcon1)
	e1:SetTarget(c67200642.thtg1)
	e1:SetOperation(c67200642.thop1)
	c:RegisterEffect(e1)
	--tohand2
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(67200642,1))
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,67200643)
	e2:SetTarget(c67200642.thtg2)
	e2:SetOperation(c67200642.thop2)
	c:RegisterEffect(e2)	
end
function c67200642.mfilter(c)
	return c:IsLevel(3) and c:IsLinkSetCard(0x667b)
end
function c67200642.thcon1(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end
function c67200642.thfilter1(c)
	return c:IsCode(67200644) and c:IsAbleToHand()
end
function c67200642.thtg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c67200642.thfilter1,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c67200642.thop1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c67200642.thfilter1,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
--
function c67200642.thfilter2(c)
	return c:IsSetCard(0x667b) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c67200642.thtg2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c952523.thfilter2(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c67200642.thfilter2,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g2=Duel.SelectTarget(tp,c67200642.thfilter2,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g2,1,0,0)
end
function c67200642.thop2(e,tp,eg,ep,ev,re,r,rp)
	local tc2=Duel.GetFirstTarget()
	if tc2:IsRelateToEffect(e) then
		if Duel.SendtoHand(tc2,nil,REASON_EFFECT)~=0 then
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_FIELD)
			e1:SetCode(EFFECT_UPDATE_ATTACK)
			e1:SetTargetRange(LOCATION_MZONE,0)
			e1:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x667b))
			e1:SetValue(500)
			e1:SetReset(RESET_PHASE+PHASE_END)
			Duel.RegisterEffect(e1,tp)  
		end
	end
end



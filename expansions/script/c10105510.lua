--熊猫头
function c10105510.initial_effect(c)
--link summon
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkAttribute,ATTRIBUTE_EARTH),2,2,c10105510.lcheck)
	c:EnableReviveLimit()
	--tohand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(10105510,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1,10105510)
	e1:SetCondition(c10105510.thcon)
	e1:SetTarget(c10105510.thtg)
	e1:SetOperation(c10105510.thop)
	c:RegisterEffect(e1)
--disable
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(10105510,0))
	e2:SetCategory(CATEGORY_DISABLE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER)
	e2:SetCondition(c10105510.negcon)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c10105510.negtg)
	e2:SetOperation(c10105510.negop)
	c:RegisterEffect(e2)
end
function c10105510.lcheck(g,lc)
	return g:IsExists(Card.IsSetCard,1,nil,0x7ccd)
end
function c10105510.cfilter(c)
	return c:IsSetCard(0x7ccd) and c:IsFaceup()
end
function c10105510.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end
function c10105510.thfilter(c)
	return c:IsSetCard(0x7ccd) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c10105510.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c10105510.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c10105510.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c10105510.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c10105510.negcon(e,tp,eg,ep,ev,re,r,rp)
	return aux.exccon(e) and Duel.IsExistingMatchingCard(c10105510.cfilter,tp,LOCATION_ONFIELD,0,1,nil)
end
function c10105510.negfilter(c)
	return aux.NegateAnyFilter(c) and c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function c10105510.negtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsControler(1-tp) and c10105510.negfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c10105510.negfilter,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISABLE)
	Duel.SelectTarget(tp,c10105510.negfilter,tp,0,LOCATION_ONFIELD,1,1,nil)
end
function c10105510.negop(e,tp,eg,ep,ev,re,r,rp)
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
end
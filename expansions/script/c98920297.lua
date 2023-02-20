--影灵衣的仪式姬
function c98920297.initial_effect(c)
	 --spirit return
	aux.EnableSpiritReturn(c,EVENT_SUMMON_SUCCESS,EVENT_FLIP)
	--cannot special summon
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(aux.FALSE)
	c:RegisterEffect(e1)
--search
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(98920297,0))
	e3:SetCategory(CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_SUMMON_SUCCESS)
	e3:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e3:SetTarget(c98920297.thtg)
	e3:SetOperation(c98920297.thop)
	c:RegisterEffect(e3)
	local e5=e3:Clone()
	e5:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
	c:RegisterEffect(e5)
--search
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(98920297,0))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCost(c98920297.thcost)
	e2:SetTarget(c98920297.thtg1)
	e2:SetOperation(c98920297.thop1)
	c:RegisterEffect(e2)
end
function c98920297.thfilter0(c,tp)
	return c:IsSetCard(0xb4,0x3a) and c:GetType()==TYPE_SPELL+TYPE_RITUAL and c:IsAbleToHand()
end
function c98920297.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c98920297.thfilter0(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c98920297.thfilter0,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local sg=Duel.SelectTarget(tp,c98920297.thfilter0,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,sg,1,0,0)
end
function c98920297.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		local g2=Duel.GetMatchingGroup(c98920297.thfilter,tp,LOCATION_DECK,0,nil)
		local g3=Duel.GetMatchingGroup(c98920297.thfilter1,tp,LOCATION_DECK,0,nil)
		if #g3>0 and tc:IsSetCard(0x3a) and Duel.SelectYesNo(tp,aux.Stringid(98920297,1)) then
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
				local sg3=g3:Select(tp,1,1,nil)
				Duel.BreakEffect()
				Duel.SendtoHand(sg3,nil,REASON_EFFECT)
				Duel.ConfirmCards(1-tp,sg3)
			end
		if tc:IsSetCard(0xb4) and Duel.SelectYesNo(tp,aux.Stringid(98920297,1)) and #g2>0 then
			   Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
				local sg2=g2:Select(tp,1,1,nil)
				Duel.BreakEffect()
				Duel.SendtoHand(sg2,nil,REASON_EFFECT)
				Duel.ConfirmCards(1-tp,sg2)
		 end
	end
end
function c98920297.thfilter(c,tp)
	return c:IsSetCard(0xb4) and c:GetType()==TYPE_RITUAL+TYPE_MONSTER 
end
function c98920297.thfilter1(c,tp)
	return c:IsSetCard(0x3a) and c:GetType()==TYPE_MONSTER+TYPE_RITUAL 
end
function c98920297.cfilter(c)
	return c:IsType(TYPE_SPELL+TYPE_RITUAL) and c:IsSetCard(0x3a) and c:IsDiscardable()
end
function c98920297.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c98920297.cfilter,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,c98920297.cfilter,1,1,REASON_COST+REASON_DISCARD)
end
function c98920297.thfilter11(c)
	return c:IsSetCard(0xb4) and c:IsType(TYPE_RITUAL+TYPE_SPELL) and c:IsAbleToHand()
end
function c98920297.thtg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c98920297.thfilter11,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c98920297.thop1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c98920297.thfilter11,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
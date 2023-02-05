--星遗物的妖精
function c98920188.initial_effect(c)
   c:SetSPSummonOnce(98920188)
		--link summon
	aux.AddLinkProcedure(c,c98920188.mfilter,1,1)
	c:EnableReviveLimit()  
  --spsummon condition
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_SPSUMMON_COST)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCost(c98920188.spcost)
	c:RegisterEffect(e0)	
--to hand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(98920188,0))
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,98920188)
	e1:SetCondition(c98920188.thcon)
	e1:SetTarget(c98920188.thtg)
	e1:SetOperation(c98920188.thop)
	c:RegisterEffect(e1)	
--Search
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(98920188,1))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,98920188)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c98920188.thtg1)
	e2:SetOperation(c98920188.thop1)
	c:RegisterEffect(e2)
end
function c98920188.mfilter(c)
	return c:IsLinkRace(RACE_MACHINE)
end
function c98920188.spcost(e,c,tp,st)
	if bit.band(st,SUMMON_TYPE_LINK)~=SUMMON_TYPE_LINK then return true end
	return Duel.IsExistingMatchingCard(Card.IsSetCard,tp,LOCATION_GRAVE,0,1,nil,0xfe)
end
function c98920188.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end
function c98920188.thfilter(c)
	return c:IsSetCard(0xfe) and c:IsAbleToHand()
end
function c98920188.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c98920188.thfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c98920188.thfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,c98920188.thfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c98920188.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
	end
end
function c98920188.thfilter1(c)
	return c:IsCode(21893603) and c:IsAbleToHand()
end
function c98920188.thtg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c98920188.thfilter1,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c98920188.thop1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c98920188.thfilter1,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
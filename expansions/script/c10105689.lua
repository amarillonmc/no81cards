function c10105689.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,c10105689.matfilter,1,1)
	c:EnableReviveLimit()
    	--search
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(10105689,2))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1,10105689)
	e1:SetCondition(c10105689.thcon)
	e1:SetTarget(c10105689.thtg)
	e1:SetOperation(c10105689.thop)
	c:RegisterEffect(e1)
    	--extra summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(10105689,0))
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_EXTRA_SUMMON_COUNT)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(LOCATION_HAND+LOCATION_MZONE,0)
	e2:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x5a))
	c:RegisterEffect(e2)
end
function c10105689.matfilter(c)
	return c:IsLinkSetCard(0x5a) and not c:IsLinkType(TYPE_LINK)
end
function c10105689.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end
function c10105689.thfilter(c)
	return c:IsSetCard(0x5a) and c:IsType(TYPE_SPELL) and c:IsAbleToHand()
end
function c10105689.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c10105689.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c10105689.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c10105689.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
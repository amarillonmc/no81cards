--超自研的迟刻
function c33701078.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_END_PHASE)
	c:RegisterEffect(e1)
	--cannot attack
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_TO_HAND)
	e2:SetRange(LOCATION_SZONE)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetTargetRange(1,0)
	e2:SetLabelObject(e)
	e2:SetTarget(aux.TargetBoolFunction(Card.IsLocation,LOCATION_DECK))
	e2:SetTarget(c33701078.atktarget)
	c:RegisterEffect(e2)
	--cannot attack
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_DRAW)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetTargetRange(1,0)
	e2:SetRange(LOCATION_SZONE)
	e2:SetLabelObject(e)
	e2:SetTarget(c33701078.atktarget)
	c:RegisterEffect(e2)
	--to hand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(33701078,1))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetHintTiming(0,TIMING_END_PHASE)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCondition(c33701078.thcon)
	e2:SetTarget(c33701078.thtg)
	e2:SetOperation(c33701078.thop)
	c:RegisterEffect(e2)
end
function c33701078.atktarget(e,c,sump,sumtype,sumpos,targetp,se,re)
	return not re:GetHandler():IsCode(33701078)
end
function c33701078.sdfilter(c)
	return c:IsLevel(5) and c:IsAttribute(ATTRIBUTE_EARTH)
end
function c33701078.thcon(e)
	return not Duel.IsExistingMatchingCard(c33701078.sdfilter,tp,LOCATION_HAND,0,1,nil)
end
function c33701078.thfilter(c)
	return c:IsLevel(5) and c:IsAttribute(ATTRIBUTE_EARTH) and c:IsAbleToHand()
end
function c33701078.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c33701078.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c33701078.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not e:GetHandler():IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c33701078.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
		Duel.SendtoHand(c,nil,REASON_EFFECT)
		Duel.Hint(HINT_MUSIC,0,aux.Stringid(33701078,2))
	end
end
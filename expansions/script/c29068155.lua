--引领者 -方舟骑士-
function c29068155.initial_effect(c)
	--link summon
	c:EnableReviveLimit()
	aux.AddCodeList(c,29065500)
	c:SetSPSummonOnce(29068155)
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkSetCard,0x87af),2,2)
	--change name
	aux.EnableChangeCode(c,29065500,LOCATION_MZONE+LOCATION_GRAVE)
	--search
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(29068155,0))
	e1:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCondition(c29068155.thcon)
	e1:SetTarget(c29068155.thtg)
	e1:SetOperation(c29068155.thop)
	c:RegisterEffect(e1)
end
function c29068155.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end
function c29068155.thfilter(c)
	return c:IsCode(29065510) and c:IsAbleToHand()
end
function c29068155.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c29068155.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function c29068155.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c29068155.thfilter),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
--银河眼溯星龙
local m=11561072
local cm=_G["c"..m]
function cm.initial_effect(c)
	aux.AddLinkProcedure(c,c11561072.mfilter,1,1)
	c:EnableReviveLimit()
	--to hand
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_TOGRAVE+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e1:SetCondition(c11561072.thcon)
	e1:SetTarget(c11561072.thtg)
	e1:SetOperation(c11561072.thop)
	c:RegisterEffect(e1)
	
end
function c11561072.mfilter(c)
	return c:IsAttackAbove(2000) and c:IsLinkAttribute(ATTRIBUTE_LIGHT)
end
function c11561072.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end
function c11561072.tgfilter(c,tp)
	return c:IsAbleToGrave() and Duel.IsExistingMatchingCard(c11561072.thfilter,tp,LOCATION_DECK,0,1,nil,c)
end
function c11561072.thfilter(c,gc)
	return c:IsAbleToHand() and  ((gc:IsSetCard(0x55,0x7b) and c:IsCode(97617181)) or (gc:IsCode(97617181) and c:IsCode(897409)) or (gc:IsCode(897409) and c:IsSetCard(0x55,0x7b)))
end
function c11561072.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c11561072.tgfilter,tp,LOCATION_HAND,0,1,nil,tp) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_HAND)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c11561072.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c11561072.tgfilter,tp,LOCATION_HAND,0,1,1,nil,tp)
	if g:GetCount()>0 and Duel.SendtoGrave(g,REASON_EFFECT)~=0 and g:GetFirst():IsLocation(LOCATION_GRAVE) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local hg=Duel.SelectMatchingCard(tp,c11561072.thfilter,tp,LOCATION_DECK,0,1,1,nil,g:GetFirst())
		if hg:GetCount()>0 then
			Duel.SendtoHand(hg,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,hg)
		end
	end
end


--幻变骚灵·堆栈戈尔狄亚
function c19198112.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,c19198112.matfilter,1,1)
	c:EnableReviveLimit()
--to grave
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(19198112,0))
	e1:SetCategory(CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,19198112)
	e1:SetCondition(c19198112.tgcon)
	e1:SetTarget(c19198112.tgtg)
	e1:SetOperation(c19198112.tgop)
	c:RegisterEffect(e1)
 --to hand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(19198112,1))
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1,19198113)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetCondition(c19198112.thcon)
	e2:SetTarget(c19198112.thtg2)
	e2:SetOperation(c19198112.thop2)
	c:RegisterEffect(e2)
end
function c19198112.matfilter(c)
	return not c:IsLink(1) and  c:IsSetCard(0x103)
end
--to grave
function c19198112.tgcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end
function c19198112.tgfilter(c)
	return c:IsSetCard(0x103) and c:IsAbleToGrave()
end
function c19198112.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c19198112.tgfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function c19198112.tgop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c19198112.tgfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoGrave(g,REASON_EFFECT)
	end
end
function c19198112.thfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x103) and c:IsAbleToHand()
end
function c19198112.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD)
end
function c19198112.thtg2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_REMOVED) and chkc:IsControler(tp) and c19198112.thfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c19198112.thfilter,tp,LOCATION_REMOVED,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local sg=Duel.SelectTarget(tp,c19198112.thfilter,tp,LOCATION_REMOVED,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,sg,1,0,0)
end
function c19198112.thop2(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
	end
end
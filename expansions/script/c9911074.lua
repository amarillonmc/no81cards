--魔血姬-吸血鬼·柏夜
function c9911074.initial_effect(c)
	Duel.EnableGlobalFlag(GLOBALFLAG_DETACH_EVENT)
	aux.AddCodeList(c,9911056)
	--xyz summon
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsAttribute,ATTRIBUTE_DARK),6,2)
	c:EnableReviveLimit()
	--change name
	aux.EnableChangeCode(c,9911056,LOCATION_MZONE+LOCATION_GRAVE)
	--search
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,9911074)
	e1:SetCondition(c9911074.thcon)
	e1:SetTarget(c9911074.thtg)
	e1:SetOperation(c9911074.thop)
	c:RegisterEffect(e1)
	--material
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(9911074,0))
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_DETACH_MATERIAL)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,9911059)
	e2:SetCondition(c9911074.xmcon)
	e2:SetTarget(c9911074.xmtg)
	e2:SetOperation(c9911074.xmop)
	c:RegisterEffect(e2)
end
function c9911074.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_XYZ)
end
function c9911074.thfilter(c)
	return c:IsSetCard(0x9954) and c:IsType(TYPE_SPELL) and c:IsAbleToHand()
end
function c9911074.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9911074.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function c9911074.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c9911074.thfilter),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c9911074.xmcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(Card.IsLocation,1,nil,LOCATION_MZONE)
end
function c9911074.xmfilter(c,tp,e)
	local b1=c:IsSetCard(0x9954) and c:IsLocation(LOCATION_DECK)
	local b2=c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsOnField() and not (e and c:IsImmuneToEffect(e))
	return c:IsCanOverlay(tp) and (b1 or b2)
end
function c9911074.xmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsType(TYPE_XYZ)
		and Duel.IsExistingMatchingCard(c9911074.xmfilter,tp,LOCATION_DECK,LOCATION_ONFIELD,1,nil,tp) end
end
function c9911074.xmop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not (c:IsType(TYPE_XYZ) and c:IsRelateToEffect(e)) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
	local g=Duel.SelectMatchingCard(tp,c9911074.xmfilter,tp,LOCATION_DECK,LOCATION_ONFIELD,1,1,nil,tp,e)
	if #g==0 then return end
	local tc=g:GetFirst()
	if tc:IsOnField() then
		Duel.HintSelection(g)
		local og=tc:GetOverlayGroup()
		if #og>0 then Duel.SendtoGrave(og,REASON_RULE) end
		tc:CancelToGrave()
	end
	Duel.Overlay(c,Group.FromCards(tc))
end

--六角之巅 朔月
function c12524010.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,c12524010.mfilter,1,1)
	c:EnableReviveLimit()
	--mat check
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_MATERIAL_CHECK)
	e1:SetValue(c12524010.valcheck)
	c:RegisterEffect(e1)
	--search
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,12524010)
	e2:SetCondition(c12524010.thcon)
	e2:SetTarget(c12524010.thtg)
	e2:SetOperation(c12524010.thop)
	e2:SetLabelObject(e1)
	c:RegisterEffect(e2)
end
function c12524010.mfilter(c)
	return not c:IsCode(12524010) and c:IsSetCard(0x730,0x732)
end
function c12524010.valcheck(e,c)
	local g=c:GetMaterial()
	local op=0
	local tc=g:GetFirst()
	if tc:IsSetCard(0x730) then
	bit.bor(op,TYPE_MONSTER)
	end
	if tc:IsSetCard(0x732) then
	bit.bor(op,TYPE_SPELL)
	end
	e:SetLabel(op)
end
function c12524010.thcon(e,tp,eg,ep,ev,re,r,rp)
	local mg=e:GetHandler():GetMaterial()
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK) and (mg:IsExists(Card.IsSetCard,1,nil,0x732) or mg:IsExists(Card.IsSetCard,1,nil,0x730))
end
function c12524010.thfilter1(c)
	return c:IsSetCard(0x732) and c:IsAbleToHand()
end
function c12524010.thfilter2(c)
	return c:IsSetCard(0x730) and c:IsAbleToHand()
end
function c12524010.thtg(e,tp,eg,ep,ev,re,r,rp,chk) 
	local mg=e:GetHandler():GetMaterial()
	local b1=Duel.IsExistingMatchingCard(c12524010.thfilter1,tp,LOCATION_DECK,0,1,nil) and mg:IsExists(Card.IsSetCard,1,nil,0x730)
	local b2=Duel.IsExistingMatchingCard(c12524010.thfilter2,tp,LOCATION_DECK,0,1,nil) and mg:IsExists(Card.IsSetCard,1,nil,0x732)
	if chk==0 then return b1 or b2 end
	if b1 then 
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	end
	if b2 then 
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	end
end
function c12524010.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local mg=e:GetHandler():GetMaterial()
	local b1=Duel.IsExistingMatchingCard(c12524010.thfilter1,tp,LOCATION_DECK,0,1,nil) and mg:IsExists(Card.IsSetCard,1,nil,0x730)
	local b2=Duel.IsExistingMatchingCard(c12524010.thfilter2,tp,LOCATION_DECK,0,1,nil) and mg:IsExists(Card.IsSetCard,1,nil,0x732)
	if b1 then 
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c12524010.thfilter1,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
	end
	if b2 then 
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c12524010.thfilter2,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
	end
end













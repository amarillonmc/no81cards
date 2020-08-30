function c82224014.initial_effect(c)  
	--link summon  
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkType,TYPE_MONSTER),2,2,c82224014.lcheck)  
	c:EnableReviveLimit()  
	--search 
	local e1=Effect.CreateEffect(c)  
	e1:SetDescription(aux.Stringid(82224014,0))  
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)  
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)  
	e1:SetProperty(EFFECT_FLAG_DELAY)  
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)  
	e1:SetCountLimit(1,82224014)  
	e1:SetCondition(c82224014.thcon)  
	e1:SetTarget(c82224014.thtg)  
	e1:SetOperation(c82224014.thop)  
	c:RegisterEffect(e1) 
	--destroy  
	local e2=Effect.CreateEffect(c)  
	e2:SetCategory(CATEGORY_TOHAND)  
	e2:SetDescription(aux.Stringid(82224014,1))  
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)  
	e2:SetCode(EVENT_SUMMON_SUCCESS)  
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)  
	e2:SetRange(LOCATION_MZONE)  
	e2:SetCountLimit(1,82234014)  
	e2:SetCondition(c82224014.descon)  
	e2:SetTarget(c82224014.destg)  
	e2:SetOperation(c82224014.desop)  
	c:RegisterEffect(e2) 
	local e3=e2:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3) 
end
function c82224014.lcheck(g)  
	return g:IsExists(Card.IsLinkSetCard,1,nil,0xdf)  
end  
function c82224014.thcon(e,tp,eg,ep,ev,re,r,rp)  
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)  
end  
function c82224014.thfilter(c)  
	return c:IsCode(48444114) and c:IsAbleToHand()  
end  
function c82224014.thtg(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return Duel.IsExistingMatchingCard(c82224014.thfilter,tp,LOCATION_DECK,0,1,nil) end  
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)  
end  
function c82224014.thop(e,tp,eg,ep,ev,re,r,rp)  
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)  
	local g=Duel.SelectMatchingCard(tp,c82224014.thfilter,tp,LOCATION_DECK,0,1,1,nil)  
	if g:GetCount()>0 then  
		Duel.SendtoHand(g,nil,REASON_EFFECT)  
		Duel.ConfirmCards(1-tp,g)  
	end  
end  
function c82224014.descfilter(c,lg)  
	return c:IsFaceup() and c:IsSetCard(0xdf) and lg:IsContains(c)  
end  
function c82224014.filter(c)  
	return c:IsFaceup() and c:IsAbleToHand()  
end  
function c82224014.descon(e,tp,eg,ep,ev,re,r,rp)  
	local lg=e:GetHandler():GetLinkedGroup()  
	return eg:IsExists(c82224014.descfilter,1,nil,lg)  
end  
function c82224014.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)  
	if chkc then return chkc:IsOnField() end  
	if chk==0 then return Duel.IsExistingTarget(c82224014.filter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end  
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)  
	local g=Duel.SelectTarget(tp,c82224014.filter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)  
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,PLAYER_ALL,LOCATION_ONFIELD)  
end  
function c82224014.desop(e,tp,eg,ep,ev,re,r,rp)  
	local tc=Duel.GetFirstTarget()  
	if tc:IsRelateToEffect(e) then  
		Duel.SendtoHand(tc,nil,REASON_EFFECT)  
	end  
end  
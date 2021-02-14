--涌泉净水·清流
function c79035110.initial_effect(c)
	--link summon
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0xca3),2,2) 
	--to hand 
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EVENT_RECOVER)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,79035110)
	e1:SetTarget(c79035110.thtg)
	e1:SetOperation(c79035110.thop)
	c:RegisterEffect(e1)
	--up 
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e2:SetCategory(CATEGORY_DEFCHANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EVENT_RECOVER)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetTarget(c79035110.uptg)
	e2:SetOperation(c79035110.upop)
	c:RegisterEffect(e2)
   
end
function c79035110.thfil1(c)
	return c:IsAbleToHand() and c:IsSetCard(0xca3) and (c:IsType(TYPE_SPELL) or c:IsType(TYPE_TRAP))
end
function c79035110.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c79035110.thfil1,tp,LOCATION_DECK,0,1,nil) and ep==tp end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c79035110.thop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c79035110.thfil1,tp,LOCATION_DECK,0,nil)
	if g:GetCount()<=0 then return end
	local tg=g:Select(tp,1,1,nil)
	Duel.SendtoHand(tg,tp,REASON_EFFECT)
	Duel.ConfirmCards(1-tp,tg)
end
function c79035110.uptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return ep==tp end
	Duel.SetOperationInfo(0,CATEGORY_DEFCHANGE,nil,0,0,0)
end
function c79035110.upop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(nil,tp,LOCATION_MZONE,0,nil)
	local tc=g:GetFirst()
	while tc do
	--
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_DEFENSE)
	e1:SetValue(300)
	e1:SetRange(LOCATION_MZONE)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	tc:RegisterEffect(e1)
	tc=g:GetNext()
	end
end











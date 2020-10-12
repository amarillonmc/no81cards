function c82221060.initial_effect(c)  
	--link summon  
	aux.AddLinkProcedure(c,nil,2,2,c82221060.lcheck)  
	c:EnableReviveLimit()
	--add to hand  
	local e1=Effect.CreateEffect(c)  
	e1:SetDescription(aux.Stringid(82221060,0))  
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)  
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)  
	e1:SetProperty(EFFECT_FLAG_DELAY)  
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)  
	e1:SetCountLimit(1,82221060)  
	e1:SetCondition(c82221060.thcon)  
	e1:SetTarget(c82221060.thtg)  
	e1:SetOperation(c82221060.thop)  
	c:RegisterEffect(e1)  
	--return to hand
	local e2=Effect.CreateEffect(c)  
	e2:SetDescription(aux.Stringid(82221061,1))  
	e2:SetCategory(CATEGORY_TOHAND)  
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)  
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)  
	e2:SetCode(EVENT_DESTROYED)  
	e2:SetRange(LOCATION_MZONE)  
	e2:SetCountLimit(1,82231060)  
	e2:SetCondition(c82221060.rhcon)  
	e2:SetTarget(c82221060.rhtg)  
	e2:SetOperation(c82221060.rhop)  
	c:RegisterEffect(e2)  
end  
function c82221060.lcheck(g,lc)  
	return g:IsExists(Card.IsLinkSetCard,1,nil,0x99)  
end  
function c82221060.thcon(e,tp,eg,ep,ev,re,r,rp)  
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)  
end  
function c82221060.thfilter(c)  
	return c:IsSetCard(0x99) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToHand()  
end  
function c82221060.thtg(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return Duel.IsExistingMatchingCard(c82221060.thfilter,tp,LOCATION_DECK,0,1,nil) end  
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)  
end  
function c82221060.thop(e,tp,eg,ep,ev,re,r,rp)  
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)  
	local g=Duel.SelectMatchingCard(tp,c82221060.thfilter,tp,LOCATION_DECK,0,1,1,nil)  
	if g:GetCount()>0 then  
		Duel.SendtoHand(g,nil,REASON_EFFECT)  
		Duel.ConfirmCards(1-tp,g)  
	end  
end  
function c82221060.cfilter(c,tp)  
	return c:IsPreviousSetCard(0x99)  
		and c:GetPreviousControler()==tp and c:IsPreviousLocation(LOCATION_ONFIELD)   
end  
function c82221060.rhcon(e,tp,eg,ep,ev,re,r,rp)  
	return eg:IsExists(c82221060.cfilter,1,nil,tp)  
end  
function c82221060.rhfilter(c)  
	return c:IsFaceup() and c:IsSetCard(0x99) and c:IsType(TYPE_PENDULUM) and c:IsAbleToHand()  
end  
function c82221060.rhtg(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return Duel.IsExistingMatchingCard(c82221060.rhfilter,tp,LOCATION_EXTRA,0,1,nil) end  
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_EXTRA)  
end  
function c82221060.rhop(e,tp,eg,ep,ev,re,r,rp)  
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)  
	local g=Duel.SelectMatchingCard(tp,c82221060.rhfilter,tp,LOCATION_EXTRA,0,1,1,nil)  
	if g:GetCount()>0 then  
		Duel.SendtoHand(g,nil,REASON_EFFECT)  
		Duel.ConfirmCards(1-tp,g)  
	end  
end  
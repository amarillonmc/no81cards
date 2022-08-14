--
function c6160002.initial_effect(c)
	--SpecialSummon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,6160002)
	e1:SetCondition(c6160002.spcon)
	c:RegisterEffect(e1)
	--search
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(6160002,0))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCondition(c6160002.thcon)
	e2:SetCost(c6160002.cost)
	e2:SetTarget(c6160002.thtg1)
	e2:SetOperation(c6160002.thop1)
	c:RegisterEffect(e2)
end
function c6160002.filter(c)
	return c:IsFaceup() and c:IsSetCard(0x616)
end
function c6160002.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c6160002.filter,tp,LOCATION_MZONE,0,1,nil)
end
function c6160002.cfilter(c)  
	return c:IsFaceup() and c:IsSetCard(0x616)
end  
function c6160002.atkcon(e)  
	return Duel.IsExistingMatchingCard(c6160002.cfilter,e:GetHandlerPlayer(),LOCATION_ONFIELD,0,1,e:GetHandler())  
end  
function c6160002.cost(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,e:GetHandler()) end  
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)  
end  
function c6160002.thfilter1(c)
	return c:IsSetCard(0x616) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToHand()
end
function c6160002.thtg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c6160002.thfilter1,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c6160002.thop1(e,tp,eg,ep,ev,te,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c6160002.thfilter1,tp,LOCATION_DECK,0,1,1,nil) 
	if g:GetCount()>0 then
		 Duel.SendtoHand(g,nil,REASON_EFFECT)
		 Duel.ConfirmCards(1-tp,g)
	end
end
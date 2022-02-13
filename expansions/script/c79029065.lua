--啸岚寒域 谢拉格
function c79029065.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--atk&def
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetRange(LOCATION_FZONE)
	e2:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e2:SetValue(500)
	e2:SetTarget(aux.TargetBoolFunction(Card.IsAttribute,ATTRIBUTE_WATER))
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e3)
	--indes
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e3:SetRange(LOCATION_FZONE)
	e3:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e3:SetTarget(c79029065.intg)
	e3:SetValue(1)
	c:RegisterEffect(e3)   
	--to hand 
	local e4=Effect.CreateEffect(c) 
	e4:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_CHAINING)
	e4:SetRange(LOCATION_FZONE)  
	e4:SetCountLimit(1,79029065)
	e4:SetCondition(c79029065.thcon)  
	e4:SetCost(c79029065.thcost)
	e4:SetTarget(c79029065.thtg)
	e4:SetOperation(c79029065.thop)
	c:RegisterEffect(e4) 
end
c79029065.named_with_KarlanTrade=true 
function c79029065.intg(e,c)
	return c.named_with_KarlanTrade 
end
function c79029065.thcon(e,tp,eg,ep,ev,re,r,rp,chk)
	return re:GetHandler():IsAttribute(ATTRIBUTE_WATER)
end
function c79029065.thcost(e,tp,eg,ep,ev,re,r,rp,chk) 
	if chk==0 then return Duel.CheckLPCost(tp,1000) end 
	Duel.PayLPCost(tp,1000) 
end
function c79029065.thfil(c)
	return c.named_with_KarlanTrade and c:IsAbleToHand()
end
function c79029065.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c79029065.thfil,tp,LOCATION_DECK,0,1,nil) end 
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c79029065.thop(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(c79029065.thfil,tp,LOCATION_DECK,0,nil) 
	if g:GetCount()>0 then 
	local sg=g:Select(tp,1,1,nil)
	Duel.SendtoHand(sg,tp,REASON_EFFECT)
	Duel.ConfirmCards(1-tp,sg)
	end 
end



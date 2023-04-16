--无个性伊吕波
function c65130317.initial_effect(c)
	--disable search
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_TO_HAND)
	e1:SetRange(LOCATION_MZONE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,1)
	e1:SetTarget(aux.TargetBoolFunction(Card.IsLocation,LOCATION_DECK) and aux.TargetBoolFunction(Card.IsLevelAbove,4))
	c:RegisterEffect(e1)
	--to hand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(65130317,2))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,65130317)
	e2:SetTarget(c65130317.thtg)
	e2:SetOperation(c65130317.thop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
end
function c65130317.cfilter(c) 
	return c:IsAttack(878) and c:IsDefense(1157) and c:IsFaceup()
end
function c65130317.filter2(c) 
	return c:IsCode(65130319,65130326) and c:IsAbleToHand()
end
function c65130317.filter(c) 
	return c:IsAttack(878) and c:IsDefense(1157) and c:IsAbleToHand()
end
function c65130317.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c65130317.filter,tp,LOCATION_DECK,0,1,nil) or Duel.IsExistingMatchingCard(c65130317.filter,tp,LOCATION_DECK,0,1,nil) and Duel.IsExistingMatchingCard(c65130317.cfilter,tp,LOCATION_MZONE,LOCATION_MZONE,3,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c65130317.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.GetMatchingGroup(c65130317.filter,tp,LOCATION_DECK,0,nil)
	if Duel.IsExistingMatchingCard(c65130317.cfilter,tp,LOCATION_MZONE,LOCATION_MZONE,3,nil) then
		g=Group.__add(g,Duel.GetMatchingGroup(c65130317.filter2,tp,LOCATION_DECK,0,nil))
	end
	if g:GetCount()>0 then
		local tc =g:Select(tp,1,1,nil)
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc)
	end
end
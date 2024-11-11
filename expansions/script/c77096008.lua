--万圣邀请函
function c77096008.initial_effect(c)
	aux.AddCodeList(c,77096005) 
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,77096008)
	e1:SetCondition(c77096008.condition)
	e1:SetTarget(c77096008.target)
	e1:SetOperation(c77096008.activate)
	c:RegisterEffect(e1) 
	--to hand
	local e2=Effect.CreateEffect(c) 
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_IGNITION) 
	e2:SetRange(LOCATION_GRAVE) 
	e2:SetCountLimit(1,17096008) 
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c77096008.thtg)
	e2:SetOperation(c77096008.thop)
	c:RegisterEffect(e2)
end 
function c77096008.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(function(c) return c:IsFaceup() and c:IsCode(77096005) end,tp,LOCATION_MZONE,0,1,nil)
end
function c77096008.target(e,tp,eg,ep,ev,re,r,rp,chk) 
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,77096014,0,TYPES_TOKEN_MONSTER,1432,1432,4,RACE_FAIRY,ATTRIBUTE_DARK,POS_FACEUP) end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
function c77096008.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler() 
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0
		or not Duel.IsPlayerCanSpecialSummonMonster(tp,77096014,0,TYPES_TOKEN_MONSTER,1432,1432,4,RACE_FAIRY,ATTRIBUTE_DARK,POS_FACEUP) then return end
	local token=Duel.CreateToken(tp,77096014)
	Duel.SpecialSummon(token,0,tp,tp,false,false,POS_FACEUP) 
end 
function c77096008.thfilter(c)
	return aux.IsCodeListed(c,77096005) and not c:IsCode(77096008) and c:IsAbleToHand()
end
function c77096008.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c77096008.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c77096008.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c77096008.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end







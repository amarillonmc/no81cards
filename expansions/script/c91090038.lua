--相剑·莫邪
function c91090038.initial_effect(c)
	 local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(91090038,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,91090038)
	e1:SetTarget(c91090038.target)
	e1:SetOperation(c91090038.activate)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(91090038,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCost(aux.bfgcost)
	e2:SetCountLimit(1,91090039)
	e2:SetTarget(c91090038.sptg)
	e2:SetOperation(c91090038.spop)
	c:RegisterEffect(e2)
end
function c91090038.thfilter(c)
	return  c:IsAbleToHand()
		and (c:IsSetCard(0x16b))
end
function c91090038.thfilter2(c)
	return  c:IsAbleToGrave() and c:IsType(TYPE_SPELL+TYPE_TRAP) 
		and (c:IsSetCard(0x16b))
end
function c91090038.thfilter3(c)
	return  c:IsAbleToHand()  and (c:IsSetCard(0x16b)) and not c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function c91090038.checkfilter(c)
	return c:IsType(TYPE_SYNCHRO) and c:IsFaceup()
end
function c91090038.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsExistingMatchingCard(c91090038.thfilter,tp,LOCATION_DECK,0,2,nil) and  Duel.IsExistingMatchingCard(c91090038.thfilter2,tp,LOCATION_DECK,0,1,nil) 
	end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function c91090038.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=nil
	if Duel.GetMatchingGroupCount(c91090038.thfilter2,tp,LOCATION_DECK,0,nil)==1 then
	g=Duel.SelectMatchingCard(tp,c91090038.thfilter3,tp,LOCATION_DECK,0,1,1,nil,check)
	else
	g=Duel.SelectMatchingCard(tp,c91090038.thfilter,tp,LOCATION_DECK,0,1,1,nil,check)
	end
	if g:GetCount()>0 then
		if Duel.SendtoHand(g,nil,REASON_EFFECT)~=0 then  
		Duel.ConfirmCards(1-tp,g)
	local g2=Duel.SelectMatchingCard(tp,c91090038.thfilter2,tp,LOCATION_DECK,0,1,1,nil,check)   
	if g2:GetCount()>0 then Duel.SendtoGrave(g2,REASON_EFFECT) end
		end
	end
end
function c91090038.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,20001444,0x16b,TYPES_TOKEN_MONSTER,0,0,4,RACE_WYRM,ATTRIBUTE_WATER) end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
function c91090038.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,20001444,0x16b,TYPES_TOKEN_MONSTER,0,0,4,RACE_WYRM,ATTRIBUTE_WATER) then
		local token=Duel.CreateToken(tp,14821891)
		Duel.SpecialSummon(token,0,tp,tp,false,false,POS_FACEUP)
	end
end

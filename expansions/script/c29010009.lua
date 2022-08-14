--深海的引导
function c29010009.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,29010009+EFFECT_COUNT_CODE_OATH)
	e1:SetHintTiming(TIMING_STANDBY_PHASE+TIMING_END_PHASE)
	e1:SetCost(c29010009.cost)
	e1:SetTarget(c29010009.target)
	e1:SetOperation(c29010009.activate)
	c:RegisterEffect(e1)
end
function c29010009.costfilter(c,e,tp)
	return c:IsDiscardable() and Duel.IsExistingMatchingCard(c29010009.filter,tp,LOCATION_DECK,0,1,c,e,tp)
end
function c29010009.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil,REASON_COST) end
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST,nil)
end
function c29010009.filter(c,e,tp)
	return (c:IsSetCard(0x87af) or (_G["c"..c:GetCode()] and  _G["c"..c:GetCode()].named_with_Arknight)) and c:IsRace(RACE_FISH) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c29010009.cfilter(c)
	return c:IsSetCard(0x77af) and c:IsType(TYPE_TRAP) and c:IsAbleToHand()
end
function c29010009.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(c29010009.filter,tp,LOCATION_DECK,0,1,nil,e,tp) and Duel.IsExistingMatchingCard(c29010009.cfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK) 
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c29010009.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler() 
	local g1=Duel.GetMatchingGroup(c29010009.filter,tp,LOCATION_DECK,0,nil,e,tp) 
	local g2=Duel.GetMatchingGroup(c29010009.cfilter,tp,LOCATION_DECK,0,nil)
	if g1:GetCount()<=0 or Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local sg=g1:Select(tp,1,1,nil) 
	Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP) 
	if g2:GetCount()<=0 then return end 
	local dg=g2:Select(tp,1,1,nil) 
	Duel.SendtoHand(dg,tp,REASON_EFFECT) 
	Duel.ConfirmCards(1-tp,dg)	  
end

--默示之暗 布拉米蒙德
function c75000827.initial_effect(c)
	aux.AddCodeList(c,75000812)   
	--special summon self
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(75000827,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,75000827)
	--e1:SetCondition(c75000827.spcon)
	e1:SetCost(c75000827.spcost)
	e1:SetTarget(c75000827.sptg)
	e1:SetOperation(c75000827.spop)
	c:RegisterEffect(e1)
	--to hand
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,75000828)
	e2:SetTarget(c75000827.thtg)
	e2:SetOperation(c75000827.thop)
	c:RegisterEffect(e2) 
end
function c75000827.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2
end
function c75000827.excostfilter(c)
	return aux.IsCodeListed(c,75000812)
end
function c75000827.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c75000827.excostfilter,tp,LOCATION_SZONE,0,1,nil) end
	local rg=Duel.GetMatchingGroup(c75000827.excostfilter,tp,LOCATION_SZONE,0,nil)
	local g=nil
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	g=rg:Select(tp,1,1,nil)
	Duel.SendtoHand(g,nil,REASON_COST)
end
function c75000827.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,true,true) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c75000827.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	if Duel.SpecialSummon(c,0,tp,tp,true,false,POS_FACEUP)~=0 then
		c:CompleteProcedure()
	end
end
--
function c75000827.thfilter(c)
	return (c:IsCode(75000812) or aux.IsCodeListed(c,75000812) and not c:IsCode(75000827)) and c:IsAbleToHand()
end
function c75000827.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c75000827.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c75000827.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c75000827.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
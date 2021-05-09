--旧世迷庙的化身·羽蛇神 LV3
function c10700600.initial_effect(c)
	--SearchCard
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(10700600,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_MAIN_END)
	e1:SetCountLimit(1,10700600)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(c10700600.thcon)
	e1:SetCost(c10700600.thcost)
	e1:SetTarget(c10700600.thtg)
	e1:SetOperation(c10700600.thop)
	c:RegisterEffect(e1)  
	--to grave
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetCode(EVENT_RELEASE)
	e2:SetOperation(c10700600.regop)
	c:RegisterEffect(e2)
end
c10700600.lvup={10700605}
function c10700600.thcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2
end
function c10700600.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroupEx(tp,Card.IsType,1,nil,TYPE_MONSTER) end
	local g=Duel.SelectReleaseGroupEx(tp,Card.IsType,1,1,nil,TYPE_MONSTER)
	Duel.Release(g,REASON_COST)
end
function c10700600.thfilter(c)
	return c:IsSetCard(0x7ca) and c:IsAbleToHand()
end
function c10700600.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c10700600.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,nil)
end
function c10700600.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c10700600.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c10700600.regop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsPreviousLocation(LOCATION_ONFIELD) or c:IsPreviousLocation(LOCATION_HAND) then
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(10700600,1))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetRange(LOCATION_GRAVE)
	e1:SetCountLimit(1,10700601)
	e1:SetTarget(c10700600.sptg)
	e1:SetOperation(c10700600.spop)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
	c:RegisterEffect(e1)
	end
end
function c10700600.spfilter(c,e,tp)
	return c:IsCode(10700605) and c:IsCanBeSpecialSummoned(e,0,tp,true,true)
end
function c10700600.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>-1
		and Duel.IsExistingMatchingCard(c10700600.spfilter,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE)
end
function c10700600.tgfilter(c)
	return c:IsAbleToRemove()
end
function c10700600.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c10700600.spfilter,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,e,tp)
	local tc=g:GetFirst()
	if tc then
		Duel.SpecialSummon(tc,0,tp,tp,true,true,POS_FACEUP)
		tc:CompleteProcedure()
	end
	if tc:IsPreviousLocation(LOCATION_GRAVE) and Duel.SelectYesNo(tp,aux.Stringid(10700600,2)) then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		local tg=Duel.SelectMatchingCard(tp,c10700600.tgfilter,tp,nil,LOCATION_GRAVE,1,1,nil)
		Duel.Remove(tg,POS_FACEUP,REASON_EFFECT)
	end
end
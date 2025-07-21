function c4875206.initial_effect(c)
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
    e1:SetRange(LOCATION_HAND)
    e1:SetCountLimit(1,4875206)
    e1:SetCost(c4875206.cost)
    e1:SetTarget(c4875206.thtg)
    e1:SetOperation(c4875206.thop)
    c:RegisterEffect(e1)
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(4875206,0))
    e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e3:SetType(EFFECT_TYPE_QUICK_O)
    e3:SetRange(LOCATION_GRAVE)
    e3:SetCode(EVENT_FREE_CHAIN)
    e3:SetCountLimit(1,4875206)
    e3:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e3:SetCost(c4875206.spcost2)
    e3:SetTarget(c4875206.sptg)
    e3:SetOperation(c4875206.spop2)
    c:RegisterEffect(e3)
	Duel.AddCustomActivityCounter(4875206,ACTIVITY_SPSUMMON,c4875206.counterfilter)
end
function c4875206.cfilter(c)
	return c:IsRace(RACE_FIEND)
end
function c4875206.spcost2(e,tp,eg,ep,ev,re,r,rp,chk)
if chk==0 then return Duel.IsExistingMatchingCard(c4875206.cfilter,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
	local g=Duel.SelectMatchingCard(tp,c4875206.cfilter,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,1,nil)
	Duel.SendtoGrave(g,REASON_COST)
end
function c4875206.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
	 local g=Duel.GetFieldGroup(tp,0,LOCATION_ONFIELD)
    if g:GetCount()>0 then
        Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
    end
end
function c4875206.cfilter1(c)
	return c:IsRace(RACE_FIEND) and c:IsFaceup()
end
function c4875206.spop2(e,tp,eg,ep,ev,re,r,rp)
local c=e:GetHandler()
    if e:GetHandler():IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP_DEFENSE)~=0  then
	 if Duel.SpecialSummonStep(c,0,tp,tp,false,false,POS_FACEUP) then
            local e1=Effect.CreateEffect(c)
            e1:SetType(EFFECT_TYPE_SINGLE)
            e1:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
            e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
            e1:SetReset(RESET_EVENT+RESETS_REDIRECT)
            e1:SetValue(LOCATION_REMOVED)
            c:RegisterEffect(e1)
        end
        Duel.SpecialSummonComplete()
		local g=Duel.GetMatchingGroupCount(Card.IsRace,tp,LOCATION_MZONE,0,nil,RACE_FIEND)
	if g~=0 and Duel.SelectYesNo(tp,aux.Stringid(4875206,2)) then
	Duel.BreakEffect()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
    local g2=Duel.SelectMatchingCard(tp,nil,tp,0,LOCATION_ONFIELD,1,g,nil)
    Duel.Destroy(g2,REASON_EFFECT)
	end
    end
end
function c4875206.counterfilter(c)
    return not c:IsSummonLocation(LOCATION_EXTRA) or c:IsRace(RACE_FIEND)
end
function c4875206.cost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():IsDiscardable() and Duel.GetCustomActivityCount(4875206,tp,ACTIVITY_SPSUMMON)==0 end
    Duel.SendtoGrave(e:GetHandler(),REASON_COST+REASON_DISCARD)
	local e1=Effect.CreateEffect(e:GetHandler())
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
    e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
    e1:SetTargetRange(1,0)
    e1:SetTarget(c4875206.splimit)
    e1:SetReset(RESET_PHASE+PHASE_END)
    Duel.RegisterEffect(e1,tp)
end
function c4875206.splimit(e,c,sump,sumtype,sumpos,targetp,se)
    return not c:IsRace(RACE_FIEND) and c:IsLocation(LOCATION_EXTRA)
end
function c4875206.thfilter(c)
    return c:IsRace(RACE_FIEND) and c:IsLevelBelow(8) and c:IsAbleToHand()
end
function c4875206.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c4875206.thfilter,tp,LOCATION_DECK,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c4875206.thop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g=Duel.SelectMatchingCard(tp,c4875206.thfilter,tp,LOCATION_DECK,0,1,1,nil)
    if g:GetCount()>0 then
        Duel.SendtoHand(g,nil,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,g)
    end
end
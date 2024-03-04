--パワー☆クイック－A.B.J.
function c49811307.initial_effect(c)
    --spsummon proc
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetCode(EFFECT_SPSUMMON_PROC)
    e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
    e1:SetRange(LOCATION_HAND+LOCATION_GRAVE)
    e1:SetCountLimit(1,49811307+EFFECT_COUNT_CODE_OATH)
    e1:SetCondition(c49811307.spcon)
    e1:SetOperation(c49811307.spop)
    c:RegisterEffect(e1)
    --search
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(49811307,0))
    e2:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
    e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e2:SetCode(EVENT_SPSUMMON_SUCCESS)
    e2:SetCountLimit(1,49811308)
    e2:SetProperty(EFFECT_FLAG_DELAY)
    e2:SetTarget(c49811307.thtg)
    e2:SetOperation(c49811307.thop)
    c:RegisterEffect(e2)
    --spsummon opponent
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(49811307,1))
    e3:SetCategory(CATEGORY_SPSUMMON)
    e3:SetType(EFFECT_TYPE_IGNITION)
    e3:SetRange(LOCATION_MZONE)
    e3:SetCountLimit(1,49811309)
    e3:SetCondition(c49811307.ospcon)
    e3:SetTarget(c49811307.osptg)
    e3:SetOperation(c49811307.ospop)
    c:RegisterEffect(e3)
end
function c49811307.spfilter(c,ft)
    return c:IsRace(RACE_WINDBEAST+RACE_BEAST) and c:IsAbleToRemoveAsCost()
end
function c49811307.spcon(e,c)
    if c==nil then return true end
    local tp=c:GetControler()
    return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and Duel.IsExistingMatchingCard(c49811307.spfilter,tp,LOCATION_HAND,0,1,nil)
end
function c49811307.spop(e,tp,eg,ep,ev,re,r,rp,c)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
    local g=Duel.SelectMatchingCard(tp,c49811307.spfilter,tp,LOCATION_HAND,0,1,1,nil)
    Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c49811307.filter(c)
    return c:IsType(TYPE_MONSTER) and c:IsRace(RACE_WARRIOR) and c:IsLevel(4) and c:IsAbleToHand() and not c:IsSummonableCard() 
end
function c49811307.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c49811307.filter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
    Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function c49811307.thop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c49811307.filter),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
    if #g>0 then
        Duel.SendtoHand(g,nil,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,g)
    end
    Duel.RegisterFlagEffect(tp,49811307,RESET_PHASE+PHASE_END,0,1)
end
function c49811307.ospcon(e,tp,eg,ep,ev,re,r,rp)
    return Duel.GetFlagEffect(tp,49811307)>0
end
function c49811307.osptg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then 
    	return Duel.IsExistingMatchingCard(nil,tp,0,LOCATION_HAND,1,nil)
    end
end
function c49811307.cfilter(c)
    return c:IsType(TYPE_SPELL) and c:IsAbleToRemoveAsCost()
end
function c49811307.ospfilter(c,e,tp)
    return c:IsType(TYPE_MONSTER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEDOWN,1-tp) and Duel.GetLocationCount(1-tp,LOCATION_MZONE)>0
end
function c49811307.ospop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if Duel.IsChainDisablable(0) then
    	local g=Duel.GetMatchingGroup(c49811307.cfilter,tp,0,LOCATION_HAND,nil)
    	local sel=1
        Duel.Hint(HINT_SELECTMSG,1-tp,aux.Stringid(49811307,2))
        if g:GetCount()>0 then
            sel=Duel.SelectOption(1-tp,1213,1214)
        else
            sel=Duel.SelectOption(1-tp,1214)+1
        end
        if sel==0 then
            Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_TOGRAVE)
            local sg=g:Select(1-tp,1,1,nil)
            Duel.Remove(sg,POS_FACEUP,REASON_EFFECT)
            Duel.NegateEffect(0)
            return
        end
    end
    local gh=Duel.GetFieldGroup(tp,0,LOCATION_HAND)
    if gh:GetCount()==0 then return end
    Duel.ConfirmCards(tp,gh)
    local osg=gh:Filter(c49811307.ospfilter,nil,e,tp)
    if osg:GetCount()>0 then
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
        local setg=osg:Select(tp,1,1,nil)
        Duel.SpecialSummon(setg:GetFirst(),0,tp,1-tp,false,false,POS_FACEDOWN_DEFENSE)
    end
    Duel.ShuffleHand(1-tp)
end
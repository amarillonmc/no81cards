function c116301233.initial_effect(c)
    c:SetSPSummonOnce(116301233)
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
    e1:SetCode(EFFECT_SPSUMMON_CONDITION)
    e1:SetValue(c116301233.splimit)
    c:RegisterEffect(e1)
    local e2=Effect.CreateEffect(c)
    e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e2:SetType(EFFECT_TYPE_QUICK_O)
    e2:SetRange(LOCATION_HAND+LOCATION_GRAVE)
    e2:SetCode(EVENT_FREE_CHAIN)
    e2:SetCost(c116301233.spcost)
    e2:SetTarget(c116301233.sptg)
    e2:SetOperation(c116301233.spop)
    c:RegisterEffect(e2)
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(116301233,2))
    e3:SetCategory(CATEGORY_DECKDES+CATEGORY_TOGRAVE+CATEGORY_TODECK)
    e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
    e3:SetProperty(EFFECT_FLAG_DELAY)
    e3:SetCode(EVENT_SPSUMMON_SUCCESS)
    e3:SetRange(LOCATION_MZONE)
    e3:SetCondition(c116301233.condition)
    e3:SetTarget(c116301233.target)
    e3:SetOperation(c116301233.operation)
    c:RegisterEffect(e3)
    local e4=Effect.CreateEffect(c)
    e4:SetDescription(aux.Stringid(116301233,3))
    e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
    e4:SetProperty(EFFECT_FLAG_DELAY)
    e4:SetCode(EVENT_SPSUMMON_SUCCESS)
    e4:SetRange(LOCATION_MZONE)
    e4:SetCondition(c116301233.con)
    e4:SetTarget(aux.TargetBoolFunction(aux.TRUE))
    e4:SetOperation(c116301233.op)
    c:RegisterEffect(e4)
end
function c116301233.splimit(e,se,sp,st)
    return se:IsHasType(EFFECT_TYPE_ACTIONS)
end
function c116301233.spfilter(c)
    return c:IsCode(04064256) and not c:IsForbidden()
end
function c116301233.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil) and e:GetHandler():GetFlagEffect(116301230)==0 and Duel.IsExistingMatchingCard(c116301233.spfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
    Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
    local g=Duel.SelectMatchingCard(tp,c116301233.spfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
    local tc=g:GetFirst()
    if tc then
        local fc=Duel.GetFieldCard(tp,LOCATION_FZONE,0)
        if fc then
            Duel.SendtoGrave(fc,REASON_RULE)
            Duel.BreakEffect()
        end
        Duel.MoveToField(tc,tp,tp,LOCATION_FZONE,POS_FACEUP,true)
    end
    e:GetHandler():RegisterFlagEffect(116301230,RESET_PHASE+PHASE_END,0,1)
end
function c116301233.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(1-tp,LOCATION_MZONE)>0 and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,tp,LOCATION_HAND+LOCATION_GRAVE)
end
function c116301233.spop(e,tp,eg,ep,ev,re,r,rp)
    if Duel.GetLocationCount(1-tp,LOCATION_MZONE)<1 then return end
    Duel.SpecialSummon(e:GetHandler(),0,tp,1-tp,false,false,POS_FACEUP)
end
function c116301233.filter(c)
    return c:IsFaceup() and c:IsRace(RACE_ZOMBIE)
end
function c116301233.condition(e,tp,eg,ep,ev,re,r,rp)
    return not eg:IsContains(e:GetHandler()) and eg:IsExists(c116301233.filter,1,nil)
end
function c116301233.thfilter(c)
    return not c:IsType(TYPE_PENDULUM) or c:IsLocation(LOCATION_EXTRA)
end
function c116301233.target(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    if chk==0 then return c:GetFlagEffect(116301233)==0 and eg:GetFirst()~=c end
    local op
    if Duel.IsPlayerCanDiscardDeck(1-tp,1) then
        op=Duel.SelectOption(1-tp,aux.Stringid(116301233,0),aux.Stringid(116301233,1))
    else
        op=2
    end
    e:SetLabel(op)
    if op==2 then
        local g=Duel.GetMatchingGroup(c116301233.thfilter,1-tp,LOCATION_GRAVE+LOCATION_REMOVED+LOCATION_EXTRA,0,nil)
        Duel.SetOperationInfo(0,CATEGORY_TODECK,g,1,0,0)
    elseif op==1 then
        local g=Duel.GetMatchingGroup(aux.TRUE,1-tp,LOCATION_DECK,0,nil)
        Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,1,0,0)
        e:GetHandler():RegisterFlagEffect(116301233,RESET_PHASE+PHASE_END,0,1)
    else
        Duel.SetOperationInfo(0,CATEGORY_DECKDES,nil,0,1-tp,2)
    end
end
function c116301233.operation(e,tp,eg,ep,ev,re,r,rp)
    local op=e:GetLabel()
    if op==0 then
        Duel.DiscardDeck(1-tp,2,REASON_EFFECT)
    elseif op==1 then
        local g=Duel.SelectMatchingCard(1-tp,aux.TRUE,1-tp,LOCATION_DECK,0,1,1,nil)
        if g:GetCount()>0 then
            Duel.SendtoGrave(g,REASON_EFFECT)
        end
    else
        local g=Duel.GetMatchingGroup(c116301233.thfilter,1-tp,LOCATION_GRAVE+LOCATION_REMOVED+LOCATION_EXTRA,0,nil)
        if g:GetCount()>0 then
            Duel.SendtoDeck(g,nil,nil,REASON_EFFECT)
            Duel.BreakEffect()
            Duel.DiscardDeck(1-tp,3,REASON_EFFECT)
        end
    end
end
function c116301233.gfilter(c,tc)
    return c:IsPreviousLocation(LOCATION_GRAVE) and c:IsCode(34193084,71200730,116301233) and c~=tc
end
function c116301233.con(e,tp,eg,ep,ev,re,r,rp)
    return eg:IsExists(c116301233.gfilter,1,nil,e:GetHandler())
end
function c116301233.op(e,tp,eg,ep,ev,re,r,rp)
    local tc=eg:GetFirst()
    local atk=0
    while tc do
        if tc:IsCode(34193084,71200730,116301233) and e:GetHandler()~=tc then
            atk=atk+tc:GetBaseAttack()
        end
        tc=eg:GetNext()
    end
    if Duel.GetLP(tp)>=atk then
        Duel.SetLP(tp,Duel.GetLP(tp)-atk)
    end
end
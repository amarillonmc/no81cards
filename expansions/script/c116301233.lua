--闇より顕現し絶望の塔
function c116301233.initial_effect(c)
    c:SetSPSummonOnce(116301233)
    --splimit
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
    e1:SetCode(EFFECT_SPSUMMON_CONDITION)
    e1:SetValue(c116301233.splimit)
    c:RegisterEffect(e1)
    --spsummon
    local e2=Effect.CreateEffect(c)
    e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e2:SetType(EFFECT_TYPE_QUICK_O)
    e2:SetCode(EVENT_FREE_CHAIN)
    e2:SetRange(LOCATION_HAND+LOCATION_GRAVE)
    e2:SetCondition(c116301233.spcon)
    e2:SetCost(c116301233.spcost)
    e2:SetTarget(c116301233.sptg)
    e2:SetOperation(c116301233.spop)
    c:RegisterEffect(e2)
    local e3=e2:Clone()
    e3:SetCode(EVENT_CHAINING)
    e3:SetCondition(c116301233.spcon2)
    c:RegisterEffect(e3)
    --deckdes
    local e4=Effect.CreateEffect(c)
    e4:SetDescription(aux.Stringid(116301233,1))
    e4:SetCategory(CATEGORY_DECKDES)
    e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
    e4:SetCode(EVENT_SPSUMMON_SUCCESS)
    e4:SetRange(LOCATION_MZONE)
    e4:SetCondition(c116301233.tgcon)
    e4:SetTarget(c116301233.tgtg)
    e4:SetOperation(c116301233.tgop)
    c:RegisterEffect(e4)
    --lifedes
    local e5=Effect.CreateEffect(c)
    e5:SetDescription(aux.Stringid(116301233,5))
    e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
    e5:SetCode(EVENT_SPSUMMON_SUCCESS)
    e5:SetRange(LOCATION_MZONE)
    e5:SetCondition(c116301233.lfcon)
    e5:SetTarget(c116301233.lftg)
    e5:SetOperation(c116301233.lfop)
    c:RegisterEffect(e5)
end

function c116301233.splimit(e,se,sp,st)
    return se:IsHasType(EFFECT_TYPE_ACTIONS)
end

function c116301233.spcon(e,tp,eg,ep,ev,re,r,rp)
    return not Duel.CheckEvent(EVENT_CHAINING)
end
function c116301233.spcon2(e,tp,eg,ep,ev,re,r,rp)
    return Duel.CheckEvent(EVENT_CHAINING) and re:GetHandler()~=e:GetHandler()
end
function c116301233.actfilter(c,tp)
    return c:IsCode(4064256) and c:GetActivateEffect():IsActivatable(tp,true,true)
end
function c116301233.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
    local exc=(e:GetHandler():IsLocation(LOCATION_HAND) and not e:GetHandler():IsAbleToGraveAsCost()) and e:GetHandler() or nil
    if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,exc)
        and Duel.IsExistingMatchingCard(c116301233.actfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil,tp) end
    Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD,exc)
    local g=Duel.SelectMatchingCard(tp,c116301233.actfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,tp)
    local tc=g:GetFirst()
    if tc then
        local fc=Duel.GetFieldCard(tp,LOCATION_SZONE,5)
        if fc then
            Duel.SendtoGrave(fc,REASON_RULE)
            Duel.BreakEffect()
        end
        Duel.MoveToField(tc,tp,tp,LOCATION_FZONE,POS_FACEUP,true)
    end
end
function c116301233.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(1-tp,LOCATION_MZONE)>0
        and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
    Duel.SetTargetCard(e:GetHandler())
end
function c116301233.spop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if not c:IsRelateToEffect(e) then return end
    Duel.SpecialSummon(c,0,tp,1-tp,false,false,POS_FACEUP)
end

function c116301233.filter(c)
    return c:IsFaceup() and c:IsRace(RACE_ZOMBIE)
end
function c116301233.tgcon(e,tp,eg,ep,ev,re,r,rp)
    return not eg:IsContains(e:GetHandler()) and eg:IsExists(c116301233.filter,1,nil)
end
function c116301233.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():GetFlagEffect(116301233)==0 end
    Duel.SetOperationInfo(0,CATEGORY_DECKDES,nil,0,1-tp,nil)
    Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function c116301233.tgfilter(c)
    return c:IsAbleToGrave()
end
function c116301233.tdfilter(c)
    return (c:IsLocation(LOCATION_GRAVE) or c:IsLocation(LOCATION_REMOVED) or (c:IsFaceup() and c:IsType(TYPE_PENDULUM))) and c:IsAbleToDeck()
end
function c116301233.tgop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local b=Duel.IsExistingMatchingCard(c116301233.tgfilter,tp,0,LOCATION_DECK,1,nil)
    local op=3
    if b then
        op=Duel.SelectOption(1-tp,aux.Stringid(116301233,2),aux.Stringid(116301233,3))
    else
        op=Duel.SelectOption(1-tp,aux.Stringid(116301233,4))+2
    end
    if op==0 then
        Duel.DiscardDeck(1-tp,2,REASON_EFFECT)
    elseif op==1 then
        Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_TOGRAVE)
        local g=Duel.SelectMatchingCard(tp,c116301233.tgfilter,1-tp,LOCATION_DECK,0,1,1,nil)
        if g:GetCount()>0 then
            Duel.SendtoGrave(g,REASON_EFFECT)
            c:RegisterFlagEffect(116301233,RESET_PHASE+PHASE_END,0,1)
        end
    elseif op==2 then
        local g=Duel.GetMatchingGroup(c116301233.tdfilter,tp,0,LOCATION_GRAVE+LOCATION_REMOVED+LOCATION_EXTRA,nil)
        Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
        Duel.ShuffleDeck(1-tp)
        Duel.DiscardDeck(1-tp,3,REASON_EFFECT)
    else
        return
    end
end

function c116301233.lffilter(c)
    return c:IsFaceup() and c:IsCode(116301233,71200730,34193084) and c:IsPreviousLocation(LOCATION_GRAVE)
end
function c116301233.lfcon(e,tp,eg,ep,ev,re,r,rp)
    return not eg:IsContains(e:GetHandler()) and eg:IsExists(c116301233.lffilter,1,nil)
end
function c116301233.lftg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function c116301233.lfop(e,tp,eg,ep,ev,re,r,rp)
    local tc=eg:GetFirst()
    while tc do
        local atk=tc:GetTextAttack()
        local life=Duel.GetLP(tp)
        if life>=atk then
            Duel.SetLP(tp,life-atk)
        end
        tc=eg:GetNext()
    end
end

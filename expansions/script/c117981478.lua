--閃光の白石
function c117981478.initial_effect(c)
    --special summon
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e1:SetType(EFFECT_TYPE_QUICK_O)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetRange(LOCATION_HAND)
    e1:SetCountLimit(1,117981478)
    e1:SetCost(c117981478.spcost)
    e1:SetTarget(c117981478.sptg)
    e1:SetOperation(c117981478.spop)
    c:RegisterEffect(e1)
    --race
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_FIELD)
    e2:SetRange(LOCATION_GRAVE)
    e2:SetTargetRange(LOCATION_HAND+LOCATION_MZONE+LOCATION_GRAVE,0)
    e2:SetCode(EFFECT_CHANGE_RACE)
    e2:SetValue(RACE_DRAGON)
    c:RegisterEffect(e2)
    --become material
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
    e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
    e3:SetCode(EVENT_BE_MATERIAL)
    e3:SetCondition(c117981478.condition)
    e3:SetOperation(c117981478.operation)
    c:RegisterEffect(e3)
end

function c117981478.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,e:GetHandler()) end
    Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD,e:GetHandler())
end
function c117981478.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>1 and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false)
        and Duel.IsExistingMatchingCard(c117981478.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp)
        and Duel.IsPlayerCanSpecialSummonCount(tp,2) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,2,tp,LOCATION_HAND+LOCATION_DECK)
end
function c117981478.spfilter(c,e,tp)
    return c:IsSetCard(0xdd) and c:IsType(TYPE_MONSTER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c117981478.scfilter(c,mg)
    return c:IsSynchroSummonable(nil,mg)
end
function c117981478.spop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if c:IsRelateToEffect(e) then
        Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
        local g=Duel.SelectMatchingCard(tp,c117981478.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
        if g:GetCount()==0 then return end
        Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
        local mg=Group.FromCards(c,g:GetFirst())
        local sg=Duel.GetMatchingGroup(c117981478.scfilter,tp,LOCATION_EXTRA,0,nil,mg)
        if sg:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(117981478,1)) then
            Duel.BreakEffect()
            Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
            local syg=sg:Select(tp,1,1,nil)
            Duel.SynchroSummon(tp,syg:GetFirst(),nil,mg)
        end
    end
end

function c117981478.condition(e,tp,eg,ep,ev,re,r,rp)
    return r==REASON_SYNCHRO
end
function c117981478.operation(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local rc=c:GetReasonCard()
    if rc:GetFlagEffect(117981478)==0 then
        --negate
        local e1=Effect.CreateEffect(e:GetHandler())
        e1:SetDescription(aux.Stringid(117981478,2))
        e1:SetProperty(EFFECT_FLAG_CLIENT_HINT+EFFECT_FLAG_PLAYER_TARGET)
        e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
        e1:SetRange(LOCATION_MZONE)
        e1:SetCode(EVENT_CHAIN_SOLVING)
        e1:SetCondition(c117981478.discon)
        e1:SetOperation(c117981478.disop)
        e1:SetReset(RESET_EVENT+0x1fe0000)
        rc:RegisterEffect(e1,true)
        local e2=Effect.CreateEffect(e:GetHandler())
        e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE+EFFECT_FLAG_IGNORE_IMMUNE)
        e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
        e2:SetCode(EVENT_CONTROL_CHANGED)
        e2:SetOperation(c117981478.crop)
        e2:SetLabelObject(e1)
        e2:SetReset(RESET_EVENT+0x1fe0000)
        rc:RegisterEffect(e2,true)
        rc:RegisterFlagEffect(117981478,RESET_EVENT+0x1fe0000,0,1)
    end
end
function c117981478.discon(e,tp,eg,ep,ev,re,r,rp)
    return re:IsActiveType(TYPE_MONSTER) and 2500>=re:GetHandler():GetAttack()
        and ((ep~=tp and e:GetLabel()%2==0) or (ep==tp and e:GetLabel()%2==1))
end
function c117981478.disop(e,tp,eg,ep,ev,re,r,rp)
    Duel.NegateEffect(ev)
end

function c117981478.crop(e,tp,eg,ep,ev,re,r,rp)
    local ct=e:GetLabelObject():GetLabel()
    e:GetLabelObject():SetLabel(ct+1)
end

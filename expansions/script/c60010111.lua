--追月神·水月
local cm,m,o=GetID()
function cm.initial_effect(c)
    c:EnableCounterPermit(0x628)
    --summon success
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_COUNTER+CATEGORY_REMOVE)
    e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
    e1:SetCode(EVENT_SUMMON_SUCCESS)
    e1:SetTarget(cm.tg4)
    e1:SetOperation(cm.op4)
    c:RegisterEffect(e1)
    local e2=e1:Clone()
    e2:SetCode(EVENT_SPSUMMON_SUCCESS)
    c:RegisterEffect(e2)
    --to hand
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(m,1))
    e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e3:SetCode(EVENT_CUSTOM+60010111)
    e3:SetRange(LOCATION_MZONE)
    e3:SetCountLimit(1)
    e3:SetCondition(cm.con)
    e3:SetOperation(cm.op)
    c:RegisterEffect(e3)
    --special summon
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(60461804,1))
    e3:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_GRAVE_SPSUMMON)
    e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e3:SetProperty(EFFECT_FLAG_DELAY)
    e3:SetCode(EVENT_LEAVE_FIELD)
    e3:SetCountLimit(1,m)
    e3:SetOperation(cm.regop)
    c:RegisterEffect(e3)
end
function cm.tg4(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    Duel.SetOperationInfo(0,CATEGORY_COUNTER,nil,2,0,0x628)
end
function cm.op4(e,tp,eg,ep,ev,re,r,rp)
    if e:GetHandler():IsRelateToEffect(e) then
        e:GetHandler():AddCounter(0x628,2)
        for i=60010120,60010122 do
            local rg=Duel.GetMatchingGroup(Card.IsCode,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,nil,i):Filter(Card.IsAbleToRemove,nil)
            if Duel.GetFlagEffect(tp,i)~=0 and #rg>0 then
                Duel.Remove(rg:GetFirst(),POS_FACEUP,REASON_EFFECT)
            end
        end
    end
end
function cm.con(e,tp,eg,ep,ev,re,r,rp)
    return ((e:GetHandler():IsRelateToEffect(e) and e:GetHandler():IsCanHaveCounter(0x628) 
    and Duel.IsCanAddCounter(tp,0x628,1,e:GetHandler())) or (Duel.GetFlagEffect(tp,60010119)~=0))
    and Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,LOCATION_DECK,0,1,nil)
end

function cm.pfil(c,tp)
    return c:IsCanHaveCounter(0x628) 
    and Duel.IsCanAddCounter(tp,0x628,1,c)
end

function cm.op(e,tp,eg,ep,ev,re,r,rp)
    if e:GetHandler():IsRelateToEffect(e) and Duel.GetFlagEffect(tp,60010119)==0 then
        e:GetHandler():AddCounter(0x628,1)
    elseif Duel.IsExistingMatchingCard(cm.pfil,tp,LOCATION_MZONE,0,1,nil,tp) then
        local ng=Duel.GetMatchingGroup(cm.pfil,tp,LOCATION_MZONE,0,nil,tp)
        for c in aux.Next(ng) do
            c:AddCounter(0x628,1)
        end
    end
    local rg=Duel.GetDecktopGroup(tp,1)
    Duel.Remove(rg,POS_FACEUP,REASON_EFFECT)
end

function cm.regop(e,tp,eg,ep,ev,re,r,rp)
    local e1=Effect.CreateEffect(e:GetHandler())
    e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e1:SetCode(EVENT_PHASE+PHASE_STANDBY)
    e1:SetCountLimit(1)
    e1:SetLabel(Duel.GetTurnCount())
    e1:SetCondition(cm.spcon)
    e1:SetOperation(cm.spop)
    if Duel.GetCurrentPhase()<=PHASE_STANDBY then
        e1:SetReset(RESET_PHASE+PHASE_STANDBY,2)
    else
        e1:SetReset(RESET_PHASE+PHASE_STANDBY)
    end
    Duel.RegisterEffect(e1,tp)
end
function cm.spfilter(c,e,tp)
    return c:IsCode(60010111) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function cm.spcon(e,tp,eg,ep,ev,re,r,rp)
    return Duel.GetTurnCount()~=e:GetLabel() and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and Duel.IsExistingMatchingCard(cm.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_CARD,0,m)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(cm.spfilter),tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
    if g:GetCount()>0 then
        Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
    end
end

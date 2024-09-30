--对月歌
local cm,m,o=GetID()
function cm.initial_effect(c)
    --xyz summon
    aux.AddXyzProcedure(c,nil,4,2,cm.ovfilter,aux.Stringid(m,0),4,cm.xyzop)
    c:EnableReviveLimit()
    --code
    aux.EnableChangeCode(c,60010111,LOCATION_MZONE)
    c:EnableCounterPermit(0x628)
    --summon success
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_COUNTER+CATEGORY_REMOVE)
    e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
    e1:SetCode(EVENT_SUMMON_SUCCESS)
    e1:SetTarget(cm.tg4)
    e1:SetOperation(cm.op4)
    c:RegisterEffect(e1)
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

function cm.ovfilter(c)
    return c:IsFaceup() and c:IsCode(60010111) and c:IsLevel(4) 
end
function cm.xyzop(e,tp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(Card.IsFaceup,tp,LOCATION_REMOVED,0,12,nil) end
end
function cm.tg4(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    Duel.SetOperationInfo(0,CATEGORY_COUNTER,nil,2,0,0x628)
end
function cm.op4(e,tp,eg,ep,ev,re,r,rp)
    if e:GetHandler():IsRelateToEffect(e) then
        e:GetHandler():AddCounter(0x628,2)
    end
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

function cm.con(e,tp,eg,ep,ev,re,r,rp)
    return (e:GetHandler():IsRelateToEffect(e) and e:GetHandler():IsCanHaveCounter(0x628) 
    and Duel.IsCanAddCounter(tp,0x628,1,e:GetHandler())) or (Duel.GetFlagEffect(tp,60010119)~=0)
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
    local rg=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_HAND,0,nil)
    if Duel.Remove(rg,POS_FACEUP,REASON_EFFECT)~=0 then
        local cg=Duel.GetOperatedGroup()
        local num=#cg+1
        for c in aux.Next(cg) do
            Card.RegisterFlagEffect(c,m,0,0,1)
        end
        local ag=Duel.GetMatchingGroup(cm.adfil,tp,LOCATION_REMOVED,0,nil)
        local tag=Group.CreateGroup()
        if num<=#ag then
            tag=ag:RandomSelect(tp,num)
        else
            local fg=Duel.GetMatchingGroup(cm.adfil2,tp,LOCATION_REMOVED,0,nil)
            local snum=math.min(#fg,num)
            tag=fg:RandomSelect(tp,snum)
        end
        Duel.SendtoHand(tag,nil,REASON_EFFECT)
        local ug=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_HAND+LOCATION_REMOVED,0,nil)
        for c in aux.Next(ug) do
            Card.ResetFlagEffect(c,m)
        end
    end
end
function cm.adfil(c)
    return c:IsAbleToHand() and c:IsFaceup() and Card.GetFlagEffect(c,m)==0
end
function cm.adfil2(c)
    return c:IsAbleToHand() and c:IsFaceup() 
end

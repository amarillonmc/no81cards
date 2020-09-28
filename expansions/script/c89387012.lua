--捕食植物 太阳瓶子草恐龙
local m=89387012
local cm=_G["c"..m]
function cm.initial_effect(c)
    c:EnableReviveLimit()
    aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkRace,RACE_PLANT),2,2)
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(m,0))
    e2:SetCategory(CATEGORY_COUNTER+CATEGORY_SPECIAL_SUMMON)
    e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
    e2:SetCode(EVENT_SPSUMMON_SUCCESS)
    e2:SetCountLimit(1,m)
    e2:SetCondition(cm.condition)
    e2:SetOperation(cm.cop)
    c:RegisterEffect(e2)
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e1:SetRange(LOCATION_MZONE)
    e1:SetCode(EVENT_SPSUMMON_SUCCESS)
    e1:SetOperation(cm.ctop)
    c:RegisterEffect(e1)
end
function cm.condition(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end
function cm.spcfilter(c)
    return c:IsFaceup() and c:GetCounter(0x1041)>0
end
function cm.spfilter(c,e,tp)
    return c:IsSetCard(0x10f3) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_DEFENSE)
end
function cm.cop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local g=Duel.GetMatchingGroup(Card.IsCanAddCounter,tp,0,LOCATION_MZONE,nil,0x1041,1)
    for tc in aux.Next(g) do
        tc:AddCounter(0x1041,1)
        if tc:IsLevelAbove(2) then
            local e1=Effect.CreateEffect(c)
            e1:SetType(EFFECT_TYPE_SINGLE)
            e1:SetCode(EFFECT_CHANGE_LEVEL)
            e1:SetReset(RESET_EVENT+RESETS_STANDARD)
            e1:SetCondition(cm.lvcon)
            e1:SetValue(1)
            tc:RegisterEffect(e1)
        end
    end
    local cg=Duel.GetMatchingGroup(cm.spcfilter,tp,0,LOCATION_MZONE,nil)
    local sg=Duel.GetMatchingGroup(cm.spfilter,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,nil,e,tp)
    if cg and cg:GetCount()>0 and sg and sg:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(m,0)) then
        Duel.BreakEffect()
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
        local n=cg:GetCount()
        if n>Duel.GetMZoneCount(tp) then n=Duel.GetMZoneCount(tp) end
        if Duel.IsPlayerAffectedByEffect(tp,59822133) and n>1 then n=1 end
        local hg=sg:SelectSubGroup(tp,aux.dncheck,false,1,n)
        Duel.SpecialSummon(hg,0,tp,tp,false,false,POS_FACEUP_DEFENSE)
    end
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
    e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e1:SetTargetRange(1,0)
    e1:SetTarget(cm.splimit)
    e1:SetReset(RESET_PHASE+PHASE_END)
    Duel.RegisterEffect(e1,tp)
end
function cm.lvcon(e)
    return e:GetHandler():GetCounter(0x1041)>0
end
function cm.splimit(e,c)
    return not c:IsType(TYPE_FUSION) and c:IsLocation(LOCATION_EXTRA)
end
function cm.ctop(e,tp,eg,ep,ev,re,r,rp)
    for tc in aux.Next(eg) do
        if tc:IsFaceup() and tc:IsControler(1-tp) then
            tc:AddCounter(0x1041,1)
        end
    end
end

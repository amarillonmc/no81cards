--Welcome To Hell
function c260023020.initial_effect(c)
    --Activate
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetCountLimit(1,260023020+EFFECT_COUNT_CODE_OATH)
    e1:SetCost(c260023020.cost)
    e1:SetTarget(c260023020.target)
    e1:SetOperation(c260023020.activate)
    c:RegisterEffect(e1)
    Duel.AddCustomActivityCounter(260023020,ACTIVITY_SPSUMMON,c260023020.counterfilter)
end
    

--【特殊召喚】
function c260023020.counterfilter(c)
    return c:IsSetCard(0x941) or c:IsRace(RACE_FIEND)
end
function c260023020.cost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetCustomActivityCount(260023020,tp,ACTIVITY_SPSUMMON)==0 end
    local e1=Effect.CreateEffect(e:GetHandler())
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
    e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
    e1:SetReset(RESET_PHASE+PHASE_END)
    e1:SetTargetRange(1,0)
    e1:SetLabelObject(e)
    e1:SetTarget(c260023020.splimit)
    Duel.RegisterEffect(e1,tp)
end
function c260023020.splimit(e,c,sump,sumtype,sumpos,targetp,se)
    return not (c:IsSetCard(0x941) or c:IsRace(RACE_FIEND))
end
function c260023020.filter(c,e,tp)
    return c:IsSetCard(0x2045) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c260023020.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and Duel.IsExistingMatchingCard(c260023020.filter,tp,LOCATION_DECK+LOCATION_HAND,0,1,nil,e,tp) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,LOCATION_DECK+LOCATION_HAND)
end
function c260023020.activate(e,tp,eg,ep,ev,re,r,rp)
    if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectMatchingCard(tp,c260023020.filter,tp,LOCATION_DECK+LOCATION_HAND,0,1,1,nil,e,tp)
    if g:GetCount()>0 and Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP_DEFENSE)~=0 then
        local e1=Effect.CreateEffect(e:GetHandler())
        e1:SetType(EFFECT_TYPE_FIELD)
        e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_IGNORE_RANGE+EFFECT_FLAG_IGNORE_IMMUNE)
        e1:SetCode(EFFECT_TO_GRAVE_REDIRECT)
        e1:SetTarget(c260023020.rmtarget)
        e1:SetTargetRange(0xff,0xff)
        e1:SetValue(LOCATION_REMOVED)
        e1:SetReset(RESET_PHASE+PHASE_END)
        Duel.RegisterEffect(e1,tp)
    end
end

function c260023020.rmtarget(e,c)
    return not c:IsLocation(0x80) and not c:IsType(TYPE_SPELL+TYPE_TRAP)
end

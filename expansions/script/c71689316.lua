--"总感觉...脑袋晕乎乎的..."
local s,id=GetID()
function s.initial_effect(c)
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetCountLimit(1,id+EFFECT_COUNT_CODE_OATH)
    c:RegisterEffect(e1)
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_FIELD)
    e2:SetRange(LOCATION_SZONE)
    e2:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
    e2:SetTarget(s.disable)
    e2:SetCode(EFFECT_DISABLE)
    c:RegisterEffect(e2)
    local e3=e2:Clone()
    e3:SetCode(EFFECT_CANNOT_BE_FUSION_MATERIAL)
    e3:SetValue(s.fuslimit)
    e3:SetTarget(s.cfilter)
    c:RegisterEffect(e3)
    local e4=e2:Clone()
    e4:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
    e4:SetValue(1)
    e4:SetTarget(s.cfilter)
    c:RegisterEffect(e4)
    local e5=e2:Clone()
    e5:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL)
    e5:SetValue(1)
    e5:SetTarget(s.cfilter)
    c:RegisterEffect(e5)
    local e6=e2:Clone()
    e6:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
    e6:SetValue(1)
    e6:SetTarget(s.cfilter)
    c:RegisterEffect(e6)
    local e7=Effect.CreateEffect(c)
    e7:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e7:SetType(EFFECT_TYPE_IGNITION)
    e7:SetRange(LOCATION_SZONE)
    e7:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e7:SetCountLimit(1,id+id)
    e7:SetTarget(s.sptg2)
    e7:SetOperation(s.spop2)
    c:RegisterEffect(e7)
    if not s.global_check then
        s.global_check=true
        local ge1=Effect.CreateEffect(c)
        ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
        ge1:SetCode(EVENT_CONTROL_CHANGED)
        ge1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
        ge1:SetOperation(s.sumreg)
        Duel.RegisterEffect(ge1,0)
    end
end
function s.fuslimit(e,c,st)
    return st==SUMMON_TYPE_FUSION
end
function s.disable(e,c)
    local tp=e:GetHandlerPlayer()
    return (c:IsType(TYPE_EFFECT) or c:GetOriginalType()&TYPE_EFFECT~=0) and c:GetOwner()~=tp and c:GetFlagEffect(id)~=0
end
function s.cfilter(e,c)
    local tp=e:GetHandlerPlayer()
    return c:GetOwner()~=tp and c:GetFlagEffect(id)~=0
end
function s.sumreg(e,tp,eg,ep,ev,re,r,rp)
    local tc=eg:GetFirst()
    while tc do
    if tc:GetFlagEffect(id)==0 then
    tc:RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD,0,nil)
    end
    tc=eg:GetNext()
    end
end
function s.spfilter(c,e,tp)
    return (((c:IsFaceup() and c:GetEquipTarget()~=0))or c:IsLocation(LOCATION_GRAVE))and c:IsLevel(8) and c:IsRace(RACE_ILLUSION) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.sptg2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsLocation(LOCATION_SZONE+LOCATION_GRAVE) and chkc:IsControler(tp) and s.spfilter(chkc,e,tp) end
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and Duel.IsExistingTarget(s.spfilter,tp,LOCATION_SZONE+LOCATION_GRAVE,0,1,nil,e,tp) end
    Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectTarget(tp,s.spfilter,tp,LOCATION_SZONE+LOCATION_GRAVE,0,1,1,nil,e,tp)
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function s.spop2(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetFirstTarget()
    if tc:IsRelateToEffect(e) then
        Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
    end
end
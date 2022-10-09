--缝合僵尸预报
local m=4865022
local cm=_G["c"..m]
local s,id,o=GetID()
function cm.initial_effect(c)
    --Activate
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetCountLimit(1,m+EFFECT_COUNT_CODE_OATH)
    e1:SetOperation(cm.activate)
    c:RegisterEffect(e1)
    --extra material
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_FIELD)
    e2:SetCode(EFFECT_EXTRA_LINK_MATERIAL)
    e2:SetRange(LOCATION_FZONE)
    e2:SetTargetRange(LOCATION_SZONE,0)
    e2:SetCountLimit(1,m+o)
    e2:SetTarget(cm.mattg)
    e2:SetValue(cm.matval)
    c:RegisterEffect(e2)
    --summon
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(m,0))
    e3:SetCategory(CATEGORY_SUMMON)
    e3:SetType(EFFECT_TYPE_IGNITION)
    e3:SetRange(LOCATION_FZONE)
    e3:SetCountLimit(1,m+o*2)
    e3:SetTarget(cm.sumtg)
    e3:SetOperation(cm.sumop)
    c:RegisterEffect(e3)
end
function cm.tffilter(c,tp)
    return c:IsType(TYPE_SPELL+TYPE_TRAP) and not c:IsType(TYPE_FIELD) and c:IsSetCard(0x332b)
        and not c:IsForbidden() and c:CheckUniqueOnField(tp)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
    local g=Duel.GetMatchingGroup(cm.tffilter,tp,LOCATION_DECK,0,nil,tp)
    if g:GetCount()>0 and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and Duel.SelectYesNo(tp,aux.Stringid(m,1)) then
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
        local sg=g:Select(tp,1,1,nil)
        Duel.MoveToField(sg:GetFirst(),tp,tp,LOCATION_SZONE,POS_FACEUP,true)
    end
end
function cm.mattg(e,c)
    return c:IsSetCard(0x332b) and c:GetSequence()<5
end
function cm.matval(e,lc,mg,c,tp)
    if not (lc:IsSetCard(0x332b) and e:GetHandlerPlayer()==tp) then return false,nil end
    return true,true
end
function cm.sumfilter(c)
    return c:IsSetCard(0x332b) and c:IsSummonable(true,nil)
end
function cm.sumtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(cm.sumfilter,tp,LOCATION_HAND,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_SUMMON,nil,1,0,0)
end
function cm.sumop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SUMMON)
    local g=Duel.SelectMatchingCard(tp,cm.sumfilter,tp,LOCATION_HAND,0,1,1,nil)
    local tc=g:GetFirst()
    if tc then
        Duel.Summon(tp,tc,true,nil)
    end
end


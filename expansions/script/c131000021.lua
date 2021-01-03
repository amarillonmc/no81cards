--Wonderlands×Showtime 凤绘梦
local m=131000021
local cm=_G["c"..m]
function cm.initial_effect(c)
    aux.EnablePendulumAttribute(c)
    c:EnableReviveLimit()
    --cannot special summon
    local e10=Effect.CreateEffect(c)
    e10:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_SINGLE_RANGE)
    e10:SetType(EFFECT_TYPE_SINGLE)
    e10:SetRange(LOCATION_GRAVE+LOCATION_HAND)
    e10:SetCode(EFFECT_SPSUMMON_CONDITION)
    e10:SetValue(aux.FALSE)
    c:RegisterEffect(e10)
    --pendulum set
    local e2=Effect.CreateEffect(c)
    e2:SetCategory(CATEGORY_DESTROY)
    e2:SetType(EFFECT_TYPE_IGNITION)
    e2:SetRange(LOCATION_PZONE)
    e2:SetCountLimit(1,131000021)
    e2:SetTarget(c131000021.pentg)
    e2:SetOperation(c131000021.penop)
    c:RegisterEffect(e2)
     --become material
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
    e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_EVENT_PLAYER)
    e1:SetCode(EVENT_BE_MATERIAL)
    e1:SetCountLimit(1,131000011)
    e1:SetCondition(c131000021.condition)
    e1:SetOperation(c131000021.operation)
    c:RegisterEffect(e1)
end


function c131000021.penfilter(c)
    return c:IsType(TYPE_RITUAL)  and c:IsType(TYPE_PENDULUM)  and not c:IsForbidden()
end
function c131000021.pentg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():IsDestructable()
        and Duel.IsExistingMatchingCard(c131000021.penfilter,tp,LOCATION_DECK,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_DESTROY,e:GetHandler(),1,0,0)
end
function c131000021.penop(e,tp,eg,ep,ev,re,r,rp)
    if not e:GetHandler():IsRelateToEffect(e) then return end
    if Duel.Destroy(e:GetHandler(),REASON_EFFECT)~=0 then
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
        local g=Duel.SelectMatchingCard(tp,c131000021.penfilter,tp,LOCATION_DECK,0,1,1,nil)
        local tc=g:GetFirst()
        if tc then
            Duel.MoveToField(tc,tp,tp,LOCATION_PZONE,POS_FACEUP,true)
        end
    end
end

function c131000021.condition(e,tp,eg,ep,ev,re,r,rp)
    return r==REASON_RITUAL
end
function c131000021.operation(e,tp,eg,ep,ev,re,r,rp)
    local rc=eg:GetFirst()
    while rc do
        if rc:GetFlagEffect(131000021)==0 then
            --untargetable
            local e1=Effect.CreateEffect(e:GetHandler())
            e1:SetDescription(aux.Stringid(131000021,1))
            e1:SetType(EFFECT_TYPE_SINGLE)
            e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CLIENT_HINT+EFFECT_FLAG_CANNOT_DISABLE)
            e1:SetRange(LOCATION_MZONE)
            e1:SetCode(EFFECT_ADD_TYPE)
            e1:SetLabel(ep)
            e1:SetValue(TYPE_TUNER)
            e1:SetReset(RESET_EVENT+RESETS_STANDARD)
            rc:RegisterEffect(e1,true)
            rc:RegisterFlagEffect(131000021,RESET_EVENT+RESETS_STANDARD,0,1)
        end
        rc=eg:GetNext()
    end
end

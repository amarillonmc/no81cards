--日诫
local cm,m,o=GetID()
function cm.initial_effect(c)
    --cannot set
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_FIELD)
    e2:SetCode(EFFECT_CANNOT_SSET)
    e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_SET_AVAILABLE)
    e2:SetRange(LOCATION_HAND)
    e2:SetTargetRange(1,0)
    e2:SetLabelObject(c)
    e2:SetTarget(cm.tg)
    c:RegisterEffect(e2)
    --cannot trigger
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_FIELD)
    e3:SetCode(EFFECT_CANNOT_TRIGGER)
    e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_SET_AVAILABLE)
    e3:SetRange(LOCATION_HAND)
    e3:SetTargetRange(1,0)
    e3:SetLabelObject(c)
    e3:SetTarget(cm.tg)
    c:RegisterEffect(e3)
    --activated
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(m,0))
    e1:SetCategory(CATEGORY_DRAW+CATEGORY_TOGRAVE)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
    e1:SetCost(cm.cos1)
    e1:SetTarget(cm.tg1)
    e1:SetOperation(cm.op1)
    c:RegisterEffect(e1)
end
function cm.tg(e,c)
    return c==e:GetLabelObject()
end
function cm.cos1(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsCanRemoveCounter(tp,1,0,0x628,1,REASON_COST) end
    Duel.RemoveCounter(tp,1,0,0x628,1,REASON_COST)
end
function cm.rmfil(c)
    return c:IsType(TYPE_MONSTER) and c:IsFaceup() and c:IsSummonLocation(LOCATION_EXTRA)
end
function cm.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return  Duel.IsExistingMatchingCard(cm.rmfil,tp,0,LOCATION_MZONE,1,nil)
    and Duel.IsPlayerCanDraw(1-tp,1) end
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local tc=Duel.GetMatchingGroup(cm.rmfil,tp,0,LOCATION_MZONE,nil):Select(tp,1,1,nil):GetFirst()
    if tc then
        Duel.SendtoGrave(tc,REASON_EFFECT)
    end
end
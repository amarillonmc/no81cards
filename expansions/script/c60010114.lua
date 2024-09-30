--映月
local cm,m,o=GetID()
function cm.initial_effect(c)
    aux.AddCodeList(c,60010111)
    --act in hand
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_SINGLE)
    e2:SetCode(EFFECT_QP_ACT_IN_NTPHAND)
    e2:SetCondition(cm.con)
    c:RegisterEffect(e2)
    --activated
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(m,0))
    e1:SetCategory(CATEGORY_REMOVE)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
    e1:SetCost(cm.cos1)
    e1:SetTarget(cm.tg1)
    e1:SetOperation(cm.op1)
    c:RegisterEffect(e1)
end
function cm.confil(c)
    return c:IsCode(60010111) and c:IsFaceup()
end
function cm.con(e,tp,eg,ep,ev,re,r,rp)
    return Duel.IsExistingMatchingCard(cm.confil,tp,LOCATION_MZONE,0,1,nil)
end
function cm.cos1(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsCanRemoveCounter(tp,1,0,0x628,1,REASON_COST) end
    Duel.RemoveCounter(tp,1,0,0x628,1,REASON_COST)
end
function cm.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(aux.TRUE,tp,0,LOCATION_SZONE,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,1-tp,LOCATION_SZONE)
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    Duel.RegisterFlagEffect(tp,60010111,0,0,1)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
    local rg=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_SZONE,nil):Select(tp,1,1,nil)
    Duel.Remove(rg,POS_FACEUP,REASON_EFFECT)
    if c:IsRelateToEffect(e) and e:IsHasType(EFFECT_TYPE_ACTIVATE) and c:IsPreviousLocation(LOCATION_HAND) then
        Duel.BreakEffect()
        c:CancelToGrave()
        Duel.Remove(c,POS_FACEUP,REASON_RULE)
    end
    Duel.RaiseEvent(c,EVENT_CUSTOM+60010111,e,0,tp,tp,0)
end
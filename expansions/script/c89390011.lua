--全装幽灵
local m=89390011
local cm=_G["c"..m]
function cm.initial_effect(c)
    c:SetSPSummonOnce(m)
    c:EnableReviveLimit()
    aux.AddFusionProcFun2(c,aux.FilterBoolFunction(Card.IsRace,RACE_MACHINE),aux.FilterBoolFunction(Card.IsRace,RACE_PSYCHO),true)
    aux.AddContactFusionProcedure(c,Card.IsAbleToRemoveAsCost,LOCATION_ONFIELD,0,Duel.Remove,POS_FACEUP,REASON_COST+REASON_MATERIAL)
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
    e1:SetCode(EFFECT_SPSUMMON_CONDITION)
    e1:SetValue(aux.fuslimit)
    c:RegisterEffect(e1)
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(m,0))
    e3:SetCategory(CATEGORY_REMOVE)
    e3:SetType(EFFECT_TYPE_QUICK_O)
    e3:SetCode(EVENT_FREE_CHAIN)
    e3:SetRange(LOCATION_MZONE)
    e3:SetCountLimit(1)
    e3:SetCost(cm.cost)
    e3:SetTarget(cm.rmtg)
    e3:SetOperation(cm.rmop)
    c:RegisterEffect(e3)
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToRemoveAsCost,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,c) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
    local g=Duel.SelectMatchingCard(tp,Card.IsAbleToRemoveAsCost,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,1,c)
    Duel.Remove(g,POS_FACEUP,REASON_COST)
    local ct=Duel.GetOperatedGroup():GetFirst()
    e:SetLabelObject(ct)
end
function cm.rmfilter(c,tp)
    return c:IsAbleToRemove(tp)
end
function cm.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(cm.rmfilter,tp,0,LOCATION_EXTRA,1,nil,tp) end
    Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,1-tp,LOCATION_EXTRA)
    local ct=e:GetLabelObject()
    if ct:IsType(TYPE_MONSTER) and ct:IsRace(RACE_PSYCHO) then
        Duel.SetChainLimit(aux.FALSE)
    end
end
function cm.rmop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if not c:IsRelateToEffect(e) or not c:IsFaceup() then return end
    local g=Duel.GetFieldGroup(tp,0,LOCATION_EXTRA)
    Duel.ConfirmCards(tp,g)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
    local sg=g:FilterSelect(tp,cm.rmfilter,1,1,nil,tp)
    if not sg or sg:GetCount()<=0 then return end
    local tc=sg:GetFirst()
    if Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)<1 then return end
    c:CopyEffect(tc:GetOriginalCode(),RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
end

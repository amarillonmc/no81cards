--草野优衣的祝福
local m=60152322
local cm=_G["c"..m]
function cm.initial_effect(c)
    --Activate
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_ATKCHANGE)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetCountLimit(1,60152322)
    e1:SetTarget(c60152322.e1tg)
    e1:SetOperation(c60152322.e1op)
    c:RegisterEffect(e1)
    --
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(60152322,3))
    e2:SetType(EFFECT_TYPE_IGNITION)
    e2:SetRange(LOCATION_GRAVE)
    e2:SetCondition(aux.exccon)
    e2:SetCost(aux.bfgcost)
    e2:SetTarget(c60152322.e2tg)
    e2:SetOperation(c60152322.e2op)
    c:RegisterEffect(e2)
end
function c60152322.e1tgfilter(c)
    return c:IsFaceup() and c:IsSetCard(0xcb26) and c:IsType(TYPE_MONSTER)
end
function c60152322.e1tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and c60152322.e1tgfilter(chkc) end
    if chk==0 then return Duel.IsExistingTarget(c60152322.e1tgfilter,tp,LOCATION_MZONE,0,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
    Duel.SelectTarget(tp,c60152322.e1tgfilter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c60152322.e1opfilter2(c,e)
    return not c:IsImmuneToEffect(e) and c:IsSetCard(0xcb26) and c:IsType(TYPE_XYZ)
end
function c60152322.e1op(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local tc=Duel.GetFirstTarget()
    if tc:IsRelateToEffect(e) and tc:IsFaceup() then
        local g=Duel.GetMatchingGroup(c60152322.e1opfilter2,tp,LOCATION_EXTRA,0,nil,e)
        if g:GetCount()>0 and tc:IsType(TYPE_XYZ) and tc:IsLocation(LOCATION_MZONE) and Duel.SelectYesNo(tp,aux.Stringid(60152322,0)) then
            Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(60152301,6))
            local g1=Duel.SelectMatchingCard(tp,c60152322.e1opfilter2,tp,LOCATION_EXTRA,0,1,1,e:GetHandler(),e)
            Duel.Overlay(tc,g1)
        end
        local atk=Duel.GetOverlayCount(tp,1,1)*600
        local e1=Effect.CreateEffect(c)
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_UPDATE_ATTACK)
        e1:SetValue(atk)
        e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
        tc:RegisterEffect(e1)
        local e2=Effect.CreateEffect(c)
        e2:SetDescription(aux.Stringid(60152322,1))
        e2:SetType(EFFECT_TYPE_SINGLE)
        e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CLIENT_HINT)
        e2:SetRange(LOCATION_MZONE)
        e2:SetCode(EFFECT_IMMUNE_EFFECT)
        e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
        e2:SetValue(c60152322.e1opfilter)
        tc:RegisterEffect(e2)
        local e3=Effect.CreateEffect(c)
        e3:SetDescription(aux.Stringid(60152322,2))
        e3:SetProperty(EFFECT_FLAG_CLIENT_HINT)
        e3:SetType(EFFECT_TYPE_SINGLE)
        e3:SetCode(EFFECT_PIERCE)
        e3:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
        tc:RegisterEffect(e3)
    end
end
function c60152322.e1opfilter(e,te)
    return te:IsActiveType(TYPE_SPELL+TYPE_TRAP) and te:GetOwner()~=e:GetOwner()
end
function c60152322.e2tgfilter(c,e)
    return not c:IsImmuneToEffect(e) and c:IsSetCard(0xcb26) and c:IsType(TYPE_MONSTER)
end
function c60152322.e2tgfilter2(c)
    return c:IsFaceup() and c:IsSetCard(0xcb26) and c:IsType(TYPE_XYZ)
end
function c60152322.e2tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chk==0 then return Duel.IsExistingTarget(c60152322.e2tgfilter,tp,LOCATION_DECK,0,1,nil,e) 
        and Duel.IsExistingMatchingCard(c60152322.e2tgfilter2,tp,LOCATION_MZONE,0,1,nil) end
    Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function c60152322.e2op(e,tp,eg,ep,ev,re,r,rp)
    local g0=Duel.GetMatchingGroup(c60152322.e2tgfilter2,tp,LOCATION_MZONE,0,nil)
    if g0:GetCount()>0 then
        Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(60152301,6))
        local g1=Duel.SelectMatchingCard(tp,c60152322.e2tgfilter,tp,LOCATION_DECK,0,1,1,nil,e)
        Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(60152301,7))
        local g2=Duel.SelectMatchingCard(tp,c60152322.e2tgfilter2,tp,LOCATION_MZONE,0,1,1,nil)
        Duel.HintSelection(g2)
        local tc2=g2:GetFirst()
        Duel.Overlay(tc2,g1)
    end
end
--支仓伊绪的恶作剧
local m=60152323
local cm=_G["c"..m]
function cm.initial_effect(c)
    --Activate
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_DISABLE+CATEGORY_REMOVE)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER)
    e1:SetCountLimit(1,60152323)
    e1:SetTarget(c60152323.e1tg)
    e1:SetOperation(c60152323.e1op)
    c:RegisterEffect(e1)
    --
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(60152323,4))
    e2:SetType(EFFECT_TYPE_IGNITION)
    e2:SetRange(LOCATION_GRAVE)
    e2:SetCondition(aux.exccon)
    e2:SetCost(aux.bfgcost)
    e2:SetTarget(c60152323.e2tg)
    e2:SetOperation(c60152323.e2op)
    c:RegisterEffect(e2)
end
function c60152323.e1tgfilter(c)
    return c:IsFaceup() and c:IsSetCard(0xcb26) and c:IsType(TYPE_EFFECT) and not c:IsDisabled()
end
function c60152323.e1tgfilter2(c)
    return c:IsFaceup() and c:IsType(TYPE_EFFECT) and not c:IsDisabled()
end
function c60152323.e1tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chk==0 then return Duel.IsExistingTarget(c60152323.e1tgfilter,tp,LOCATION_MZONE,0,1,nil) 
        and Duel.IsExistingTarget(c60152323.e1tgfilter2,tp,0,LOCATION_MZONE,1,nil) end
    local a=Duel.GetMatchingGroup(c60152323.e1tgfilter,tp,LOCATION_MZONE,0,nil)
    local b=Duel.GetMatchingGroup(c60152323.e1tgfilter2,tp,0,LOCATION_MZONE,nil)
    local ca=a:GetCount()
    local cb=b:GetCount()
    if ca>cb then
        Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(60152323,0))
        local ga=Duel.SelectTarget(tp,c60152323.e1tgfilter,tp,LOCATION_MZONE,0,1,cb,nil)
        local gca=ga:GetCount()
        Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(60152323,1))
        local gb=Duel.SelectTarget(tp,c60152323.e1tgfilter2,tp,0,LOCATION_MZONE,gca,gca,nil)
        local g0=Group.CreateGroup()
        Group.Merge(g0,ga)
        Group.Merge(g0,gb)
        Duel.SetOperationInfo(0,CATEGORY_DISABLE,g0,g0:GetCount(),0,0)
    else
        Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(60152323,0))
        local ga=Duel.SelectTarget(tp,c60152323.e1tgfilter,tp,LOCATION_MZONE,0,1,ca,nil)
        local gca=ga:GetCount()
        Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(60152323,1))
        local gb=Duel.SelectTarget(tp,c60152323.e1tgfilter2,tp,0,LOCATION_MZONE,gca,gca,nil)
        local g0=Group.CreateGroup()
        Group.Merge(g0,ga)
        Group.Merge(g0,gb)
        Duel.SetOperationInfo(0,CATEGORY_DISABLE,g0,g0:GetCount(),0,0)
    end
end
function c60152323.e1opfilter(c,e)
    return c:IsRelateToEffect(e) and c:IsFaceup() and c:IsType(TYPE_EFFECT) and not c:IsDisabled()
end
function c60152323.e1op(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
    if not g then return end
    g=g:Filter(c60152323.e1opfilter,nil,e)
    if g:GetCount()>0 then
        local tc=g:GetFirst()
        while tc do
            Duel.NegateRelatedChain(tc,RESET_TURN_SET)
            local e1=Effect.CreateEffect(c)
            e1:SetType(EFFECT_TYPE_SINGLE)
            e1:SetCode(EFFECT_DISABLE)
            e1:SetReset(RESET_EVENT+RESETS_STANDARD)
            tc:RegisterEffect(e1)
            local e2=Effect.CreateEffect(c)
            e2:SetType(EFFECT_TYPE_SINGLE)
            e2:SetCode(EFFECT_DISABLE_EFFECT)
            e2:SetValue(RESET_TURN_SET)
            e2:SetReset(RESET_EVENT+RESETS_STANDARD)
            tc:RegisterEffect(e2)
            local e3=Effect.CreateEffect(c)
            e3:SetDescription(aux.Stringid(60152323,2))
            e3:SetProperty(EFFECT_FLAG_CLIENT_HINT)
            e3:SetType(EFFECT_TYPE_SINGLE)
            e3:SetCode(EFFECT_CANNOT_ATTACK_ANNOUNCE)
            e3:SetReset(RESET_EVENT+RESETS_STANDARD)
            tc:RegisterEffect(e3)
            if tc:IsControler(1-tp) then
                local e4=Effect.CreateEffect(c)
                e4:SetDescription(aux.Stringid(60152323,3))
                e4:SetType(EFFECT_TYPE_SINGLE)
                e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CLIENT_HINT)
                e4:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
                e4:SetValue(LOCATION_REMOVED)
                e4:SetReset(RESET_EVENT+RESETS_REDIRECT)
                tc:RegisterEffect(e4,true)
            end
            tc=g:GetNext()
        end
    end
end
function c60152323.e2tgfilter(c,e)
    return not c:IsImmuneToEffect(e) and c:IsSetCard(0xcb26) and c:IsType(TYPE_MONSTER)
end
function c60152323.e2tgfilter2(c)
    return c:IsFaceup() and c:IsSetCard(0xcb26) and c:IsType(TYPE_XYZ)
end
function c60152323.e2tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chk==0 then return Duel.IsExistingTarget(c60152323.e2tgfilter,tp,LOCATION_DECK,0,1,nil,e) 
        and Duel.IsExistingMatchingCard(c60152323.e2tgfilter2,tp,LOCATION_MZONE,0,1,nil) end
    Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function c60152323.e2op(e,tp,eg,ep,ev,re,r,rp)
    local g0=Duel.GetMatchingGroup(c60152323.e2tgfilter2,tp,LOCATION_MZONE,0,nil)
    if g0:GetCount()>0 then
        Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(60152301,6))
        local g1=Duel.SelectMatchingCard(tp,c60152323.e2tgfilter,tp,LOCATION_DECK,0,1,1,nil,e)
        Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(60152301,7))
        local g2=Duel.SelectMatchingCard(tp,c60152323.e2tgfilter2,tp,LOCATION_MZONE,0,1,1,nil)
        Duel.HintSelection(g2)
        local tc2=g2:GetFirst()
        Duel.Overlay(tc2,g1)
    end
end
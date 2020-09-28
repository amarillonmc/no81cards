--改造决战兵器 电子多哥兰
local m=89387003
local cm=_G["c"..m]
function cm.initial_effect(c)
    aux.AddLinkProcedure(c,cm.matfilter,1,1)
    c:EnableReviveLimit()
    c:EnableCounterPermit(0x37)
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetRange(LOCATION_MZONE)
    e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
    e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e1:SetTargetRange(1,1)
    e1:SetTarget(cm.sumlimit)
    c:RegisterEffect(e1)
    local e2=e1:Clone()
    e2:SetCode(EFFECT_CANNOT_SUMMON)
    c:RegisterEffect(e2)
    local e3=e1:Clone()
    e3:SetCode(EFFECT_CANNOT_FLIP_SUMMON)
    c:RegisterEffect(e3)
    local e4=Effect.CreateEffect(c)
    e4:SetDescription(aux.Stringid(m,0))
    e4:SetCategory(CATEGORY_REMOVE+CATEGORY_COUNTER+CATEGORY_ATKCHANGE)
    e4:SetType(EFFECT_TYPE_IGNITION)
    e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e4:SetRange(LOCATION_MZONE)
    e4:SetCountLimit(1)
    e4:SetTarget(cm.target)
    e4:SetOperation(cm.operation)
    c:RegisterEffect(e4)
    local e5=Effect.CreateEffect(c)
    e5:SetDescription(aux.Stringid(m,1))
    e5:SetCategory(CATEGORY_REMOVE)
    e5:SetType(EFFECT_TYPE_IGNITION)
    e5:SetRange(LOCATION_MZONE)
    e5:SetTarget(cm.damtg)
    e5:SetOperation(cm.damop)
    c:RegisterEffect(e5)
end
function cm.matfilter(c)
    return c:IsSetCard(0xd3) and c:GetOwner()~=c:GetControler()
end
function cm.sumlimit(e,c,sump,sumtype,sumpos,targetp)
    return c:IsSetCard(0xd3)
end
function cm.filter(c)
    return c:IsType(TYPE_MONSTER) and c:IsAbleToRemove()
end
function cm.counter(c)
    if c:IsType(TYPE_XYZ) then return c:GetRank() end
    if c:IsType(TYPE_LINK) then return c:GetLink() end
    return c:GetLevel()
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsLocation(LOCATION_GRAVE) and cm.filter(chkc) end
    if chk==0 then return Duel.IsExistingTarget(cm.filter,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
    local g=Duel.SelectTarget(tp,cm.filter,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,1,nil)
    Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,tp,LOCATION_GRAVE)
    Duel.SetOperationInfo(0,CATEGORY_COUNTER,nil,cm.counter(g:GetFirst()),0,0x37)
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local tc=Duel.GetFirstTarget()
    if c:IsRelateToEffect(e) and c:IsFaceup() and tc:IsRelateToEffect(e) then
        if Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)<1 then return end
        c:AddCounter(0x37,cm.counter(tc))
        local e2=Effect.CreateEffect(c)
        e2:SetType(EFFECT_TYPE_SINGLE)
        e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
        e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
        e2:SetLabelObject(e1)
        e2:SetCode(EFFECT_UPDATE_ATTACK)
        e2:SetValue(tc:GetBaseAttack())
        c:RegisterEffect(e2)
    end
end
function cm.damfilter(c)
    return c:GetCounter(0x37)>0
end
function cm.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then
        local g=Duel.GetMatchingGroup(cm.damfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
        if not g or g:GetCount()==0 then return false end
        local n=g:GetSum(Card.GetCounter,0x37)
        return Duel.GetDecktopGroup(1-tp,n):FilterCount(Card.IsAbleToRemove,nil)==n
    end
    Duel.SetOperationInfo(0,CATEGORY_REMOVE,Duel.GetDecktopGroup(1-tp,1),1,0,0)
end
function cm.damop(e,tp,eg,ep,ev,re,r,rp)
    local g=Duel.GetMatchingGroup(cm.damfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
    if not g or g:GetCount()==0 then return false end
    local n=g:GetSum(Card.GetCounter,0x37)
    if Duel.GetDecktopGroup(1-tp,n):FilterCount(Card.IsAbleToRemove,nil)<n then return end
    for tc in aux.Next(g) do
        local sct=tc:GetCounter(0x37)
        tc:RemoveCounter(tp,0x37,sct,0)
    end
    Duel.DisableShuffleCheck()
    Duel.Remove(Duel.GetDecktopGroup(1-tp,n),POS_FACEDOWN,REASON_EFFECT)
end

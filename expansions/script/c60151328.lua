--超人 圣白莲
local m=60151328
local cm=_G["c"..m]
function cm.initial_effect(c)
    --link summon
    c:EnableReviveLimit()
    aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkSetCard,0xcb23),2,2)
    --special summon
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(60151301,1))
    e1:SetCategory(CATEGORY_EQUIP)
    e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL+EFFECT_FLAG_DELAY)
    e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e1:SetCode(EVENT_SPSUMMON_SUCCESS)
    e1:SetCondition(c60151328.e1con)
    e1:SetTarget(c60151328.e1tg)
    e1:SetOperation(c60151328.e1op)
    c:RegisterEffect(e1)
    --spsummon
    local e2=Effect.CreateEffect(c)
    e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e2:SetType(EFFECT_TYPE_IGNITION)
    e2:SetRange(LOCATION_MZONE)
    e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e2:SetCountLimit(1)
    e2:SetTarget(c60151328.e2tg)
    e2:SetOperation(c60151328.e2op)
    c:RegisterEffect(e2)
    --Actlimit
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_EQUIP)
    e3:SetCode(EFFECT_PIERCE)
    e3:SetCondition(c60151328.e3con)
    c:RegisterEffect(e3)
    --equip
    local e4=Effect.CreateEffect(c)
    e4:SetCategory(CATEGORY_EQUIP)
    e4:SetType(EFFECT_TYPE_IGNITION)
    e4:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_NO_TURN_RESET)
    e4:SetRange(LOCATION_MZONE)
    e4:SetCountLimit(1)
    e4:SetTarget(c60151328.e4tg)
    e4:SetOperation(c60151328.e4op)
    c:RegisterEffect(e4)
end
function c60151328.e1con(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():GetSummonType()==SUMMON_TYPE_LINK
end
function c60151328.filter2(c,e,tp)
    return not c:IsType(TYPE_XYZ) and c:IsSetCard(0xcb23) and c:IsType(TYPE_MONSTER)
end
function c60151328.filter3(c,e,tp)
    return c:IsLocation(LOCATION_MZONE) and c:IsPosition(POS_FACEUP) and c:GetControler()==tp
        and c:IsSetCard(0xcb23) and c:IsType(TYPE_MONSTER)
end
function c60151328.e1tg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c60151328.filter2,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil,e,tp)
        and Duel.IsExistingMatchingCard(c60151328.filter3,tp,LOCATION_ONFIELD,0,1,nil,e,tp) end
    local g=Duel.GetMatchingGroup(c60151328.filter2,tp,LOCATION_DECK+LOCATION_GRAVE,0,nil,e,tp)
    Duel.SetOperationInfo(0,CATEGORY_EQUIP,g,1,0,0)
end
function c60151328.e1op(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
    Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(60151301,3))
    local g=Duel.SelectMatchingCard(tp,c60151328.filter3,tp,LOCATION_ONFIELD,0,1,1,nil,e,tp)
    if g:GetCount()>0 then
        Duel.HintSelection(g)
        local tc=g:GetFirst()
        if tc:IsImmuneToEffect(e) then return end
        Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(60151301,2))
        local g1=Duel.SelectMatchingCard(tp,c60151328.filter2,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,e,tp)
        if g1:GetCount()>0 then
            local tc2=g1:GetFirst()
            if tc2:IsLocation(LOCATION_GRAVE) then Duel.HintSelection(g1) end
            Duel.Equip(tp,tc2,tc,true,true)
            Duel.EquipComplete()
            local e1=Effect.CreateEffect(e:GetHandler())
            e1:SetType(EFFECT_TYPE_SINGLE)
            e1:SetCode(EFFECT_EQUIP_LIMIT)
            e1:SetReset(RESET_EVENT+0x1fe0000)
            e1:SetValue(c60151328.eqlimit)
            e1:SetLabelObject(tc)
            tc2:RegisterEffect(e1)
        end
    end
end
function c60151328.eqlimit(e,c)
    return c==e:GetLabelObject()
end
function c60151328.e2filter2(c)
    return c:IsType(TYPE_XYZ)
end
function c60151328.e2filter(c,e,tp)
    return c:IsSetCard(0xcb23) and c:IsType(TYPE_MONSTER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c60151328.e2tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c60151328.e2filter(chkc,e,tp) end
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and e:GetHandler():GetMaterial():FilterCount(Card.IsLinkType,nil,TYPE_XYZ)<1
        and Duel.IsExistingTarget(c60151328.e2filter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectTarget(tp,c60151328.e2filter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c60151328.e2op(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetFirstTarget()
    if tc:IsRelateToEffect(e) then
        Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
    end
end
function c60151328.e4filter(c)
    return c:IsSetCard(0xcb23) and c:IsType(TYPE_XYZ) and not c:IsForbidden()
end
function c60151328.e4tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    local c=e:GetHandler()
    if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_GRAVE) and c60151328.e4filter(chkc,e) end
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and e:GetHandler():GetMaterial():FilterCount(Card.IsLinkType,nil,TYPE_XYZ)>1
        and Duel.IsExistingMatchingCard(c60151328.e4filter,tp,LOCATION_GRAVE,0,1,nil,e) end
    local ft=Duel.GetLocationCount(tp,LOCATION_SZONE)
    local ft2=Duel.GetMatchingGroupCount(c60151328.e4filter,tp,LOCATION_GRAVE,0,nil,e)
    if ft>ft2 then
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
        local g=Duel.SelectTarget(tp,c60151328.e4filter,tp,LOCATION_GRAVE,0,1,ft2,nil)
        Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,g,g:GetCount(),0,0)
    else
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
        local g=Duel.SelectTarget(tp,c60151328.e4filter,tp,LOCATION_GRAVE,0,1,ft,nil)
        Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,g,g:GetCount(),0,0)
    end
    c:RegisterFlagEffect(0,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(5043010,2))
end
function c60151328.e4op(e,tp,eg,ep,ev,re,r,rp)
    local ft=Duel.GetLocationCount(tp,LOCATION_SZONE)
    local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
    if ft<=0 then return end
    local c=e:GetHandler()
    if c:IsFacedown() or not c:IsRelateToEffect(e) then return end
    local tc=g:GetFirst()
    while tc do
        Duel.Equip(tp,tc,c,true,true)
        local e3=Effect.CreateEffect(e:GetHandler())
        e3:SetType(EFFECT_TYPE_SINGLE)
        e3:SetCode(EFFECT_EQUIP_LIMIT)
        e3:SetReset(RESET_EVENT+0x1fe0000)
        e3:SetValue(c60151328.eqlimit2)
        tc:RegisterEffect(e3)
        tc=g:GetNext()
    end
    Duel.EquipComplete()
    local atk=g:GetSum(Card.GetRank)*300
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_SINGLE)
    e2:SetCode(EFFECT_UPDATE_ATTACK)
    e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
    e2:SetReset(RESET_EVENT+RESETS_STANDARD)
    e2:SetValue(atk)
    c:RegisterEffect(e2)
end
function c60151328.e3con(e,tp,eg,ep,ev,re,r,rp)
    local tg=e:GetHandler():GetEquipTarget()
    return tg:IsSetCard(0xcb23) and tg:IsType(TYPE_MONSTER)
end
function c60151328.eqlimit2(e,c)
    return e:GetOwner()==c
end
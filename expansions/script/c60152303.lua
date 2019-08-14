--连接姬 樱井望
local m=60152303
local cm=_G["c"..m]
function cm.initial_effect(c)
    --special summon
    local e0=Effect.CreateEffect(c)
    e0:SetDescription(aux.Stringid(60152303,0))
    e0:SetType(EFFECT_TYPE_FIELD)
    e0:SetCode(EFFECT_SPSUMMON_PROC)
    e0:SetProperty(EFFECT_FLAG_UNCOPYABLE)
    e0:SetRange(LOCATION_HAND)
    e0:SetCondition(c60152303.spcon)
    c:RegisterEffect(e0)
    --
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(60152303,1))
    e1:SetCategory(CATEGORY_ATKCHANGE)
    e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e1:SetCode(EVENT_SUMMON_SUCCESS)
    e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
    e1:SetCountLimit(1,60152303)
    e1:SetTarget(c60152303.e1tg)
    e1:SetOperation(c60152303.e1op)
    c:RegisterEffect(e1)
    local e11=e1:Clone()
    e11:SetCode(EVENT_SPSUMMON_SUCCESS)
    c:RegisterEffect(e11)
    --to hand
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(60152303,2))
    e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
    e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e2:SetCode(EVENT_TO_GRAVE)
    e2:SetProperty(EFFECT_FLAG_DELAY)
    e2:SetCountLimit(1,6012303)
    e2:SetCondition(c60152303.e2con)
    e2:SetTarget(c60152303.e2tg)
    e2:SetOperation(c60152303.e2op)
    c:RegisterEffect(e2)
end
function c60152303.spcon(e,c)
    if c==nil then return true end
    local tp=c:GetControler()
    return Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0,nil)==0
        and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
end
function c60152303.e1tgfilter(c)
    return c:IsFaceup() and c:IsSetCard(0xcb26) and c:IsType(TYPE_MONSTER)
end
function c60152303.e1tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c60152303.e1tgfilter(chkc) end
    if chk==0 then return Duel.IsExistingTarget(c60152303.e1tgfilter,tp,LOCATION_MZONE,0,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
    Duel.SelectTarget(tp,c60152303.e1tgfilter,tp,LOCATION_MZONE,0,1,1,nil)
    Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function c60152303.e1op(e,tp,eg,ep,ev,re,r,rp)
    local tc0=Duel.GetFirstTarget()
    if tc0:IsRelateToEffect(e) and tc0:IsFaceup() then
        local e1=Effect.CreateEffect(e:GetHandler())
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_UPDATE_ATTACK)
        e1:SetValue(1200)
        e1:SetReset(RESET_EVENT+RESETS_STANDARD)
        tc0:RegisterEffect(e1)
        if tc0:IsType(TYPE_XYZ) and e:GetHandler():IsRelateToEffect(e) and not e:GetHandler():IsImmuneToEffect(e) 
            and tc0:IsLocation(LOCATION_MZONE) and tc0:IsFaceup() and Duel.SelectYesNo(tp,aux.Stringid(60152301,4)) then
            Duel.Overlay(tc0,Group.FromCards(e:GetHandler()))
        end
    end
end
function c60152303.e2con(e,tp,eg,ep,ev,re,r,rp)
    return not e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD)
end
function c60152303.e2tgfilter(c)
    return c:IsSetCard(0xcb26) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToHand()
end
function c60152303.e2tg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c60152303.e2tgfilter,tp,LOCATION_DECK,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
    Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function c60152303.e2op(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g=Duel.SelectMatchingCard(tp,c60152303.e2tgfilter,tp,LOCATION_DECK,0,1,1,nil)
    if g:GetCount()>0 then
        Duel.SendtoHand(g,nil,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,g)
    end
end
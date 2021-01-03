--MORE MORE JUMP! 日野森雫
local m=131000025
local cm=_G["c"..m]
function cm.initial_effect(c)
    --pendulum summon
    aux.EnablePendulumAttribute(c)
    --splimit
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_FIELD)
    e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
    e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e2:SetRange(LOCATION_PZONE)
    e2:SetTargetRange(1,0)
    e2:SetTarget(c131000025.splimit)
    c:RegisterEffect(e2) 

    --pendulum
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(131000025,0))
    e1:SetCategory(CATEGORY_TOEXTRA)
    e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
    e1:SetCode(EVENT_TO_DECK)
    e1:SetCountLimit(1,131000025)
    e1:SetCondition(c131000025.pencon)
    e1:SetTarget(c131000025.target)
    e1:SetOperation(c131000025.activate)
    c:RegisterEffect(e1)
end
function c131000025.splimit(e,c)
    return not c:IsSetCard(0xacdc)
end
function c131000025.pencon(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():IsLocation(LOCATION_EXTRA) and e:GetHandler():IsFaceup() and e:GetHandler():IsControler(tp)
and Duel.IsExistingMatchingCard(Card.IsSetCard,e:GetHandlerPlayer(),LOCATION_PZONE,0,1,nil,0xacdc)
end
function c131000025.filter(c)
    return c:IsType(TYPE_PENDULUM) and c:IsSetCard(0xacdc) 
end
function c131000025.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c131000025.filter,tp,LOCATION_DECK,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_TOEXTRA,nil,1,tp,LOCATION_DECK)
end
function c131000025.activate(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(131000025,0))
    local g=Duel.SelectMatchingCard(tp,c131000025.filter,tp,LOCATION_DECK,0,1,1,nil)
    if g:GetCount()>0 then
        Duel.SendtoExtraP(g,tp,REASON_EFFECT)
    end
end

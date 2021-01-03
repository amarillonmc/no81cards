--MORE MORE JUMP! 桐谷遥
local m=131000023
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
    e2:SetTarget(c131000023.splimit)
    c:RegisterEffect(e2) 

    --spsummon
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(131000023,0))
    e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
    e2:SetCode(EVENT_TO_DECK)
    e2:SetCountLimit(1,131000023)
    e2:SetCondition(c131000023.pencon)
    e2:SetTarget(c131000023.sptg)
    e2:SetOperation(c131000023.spop)
    c:RegisterEffect(e2)
end
function c131000023.splimit(e,c)
    return not c:IsSetCard(0xacdc)
end
function c131000023.pencon(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():IsLocation(LOCATION_EXTRA) and e:GetHandler():IsFaceup() and e:GetHandler():IsControler(tp)
and Duel.IsExistingMatchingCard(Card.IsSetCard,e:GetHandlerPlayer(),LOCATION_PZONE,0,1,nil,0xacdc)
end
function c131000023.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return  e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP) and Duel.GetLocationCountFromEx(tp,tp,nil,e:GetHandler())>0 end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c131000023.spop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0 and Duel.GetLocationCountFromEx(tp,tp,nil,e:GetHandler())>0 then
        Duel.ConfirmCards(1-tp,c)
    end
end

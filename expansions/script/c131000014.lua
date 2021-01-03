--Wonderlands×Showtime 初音未来
local m=131000014
local cm=_G["c"..m]
function cm.initial_effect(c)
    aux.EnablePendulumAttribute(c)
    c:EnableReviveLimit()
    --cannot special summon
    local e10=Effect.CreateEffect(c)
    e10:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_SINGLE_RANGE)
    e10:SetType(EFFECT_TYPE_SINGLE)
    e10:SetRange(LOCATION_GRAVE+LOCATION_HAND)
    e10:SetCode(EFFECT_SPSUMMON_CONDITION)
    e10:SetValue(aux.FALSE)
    c:RegisterEffect(e10)
    --tohand
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(131000014,0))
    e3:SetCategory(CATEGORY_DESTROY+CATEGORY_TOHAND+CATEGORY_SEARCH)
    e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
    e3:SetType(EFFECT_TYPE_IGNITION)
    e3:SetRange(LOCATION_PZONE)
    e3:SetCountLimit(1,131000004)
    e3:SetTarget(c131000014.thtg)
    e3:SetOperation(c131000014.thop)
    c:RegisterEffect(e3)
    --search
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(131000014,1))
    e1:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
    e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e1:SetCode(EVENT_SPSUMMON_SUCCESS)
    e1:SetProperty(EFFECT_FLAG_DELAY)
    e1:SetCountLimit(1,131000014)
    e1:SetCondition(c131000014.srcon)
    e1:SetTarget(c131000014.srtg)
    e1:SetOperation(c131000014.srop)
    c:RegisterEffect(e1)

end
function c131000014.filter(c)
    return c:IsCode(131000015) and c:IsAbleToHand()
end
function c131000014.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():IsDestructable()
        and Duel.IsExistingMatchingCard(c131000014.filter,tp,LOCATION_DECK+LOCATION_ONFIELD,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_DESTROY,e:GetHandler(),1,0,0)
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_ONFIELD)
end
function c131000014.thop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if not c:IsRelateToEffect(e) or Duel.Destroy(c,REASON_EFFECT)==0 then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g=Duel.SelectMatchingCard(tp,c131000014.filter,tp,LOCATION_DECK+LOCATION_ONFIELD,0,1,1,nil)
    if g:GetCount()>0 then
        Duel.SendtoHand(g,nil,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,g)
    end
end
function c131000014.srfilter(c)
    return c:IsRace(RACE_CYBERSE) and c:IsType(TYPE_RITUAL) and c:IsAbleToHand()
end
function c131000014.srcon(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():IsSummonType(SUMMON_TYPE_RITUAL)
end
function c131000014.srtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c131000014.srfilter,tp,LOCATION_DECK,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c131000014.srop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g=Duel.SelectMatchingCard(tp,c131000014.srfilter,tp,LOCATION_DECK,0,1,1,nil)
    if g:GetCount()>0 then
        Duel.SendtoHand(g,nil,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,g)
    end
end
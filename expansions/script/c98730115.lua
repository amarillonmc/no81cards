--XDR-タイダル
function c98730115.initial_effect(c)
    --xyz summon
    aux.AddXyzProcedure(c,c98730115.mfilter,7,2)
    c:EnableReviveLimit()
    --pendulum summon
    aux.EnablePendulumAttribute(c,false)
    --pendulum set
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_IGNITION)
    e1:SetRange(LOCATION_PZONE)
    e1:SetCountLimit(1,98730115)
    e1:SetTarget(c98730115.pctg)
    e1:SetOperation(c98730115.pcop)
    c:RegisterEffect(e1)
    --tograve pendulum
    local e2=Effect.CreateEffect(c)
    e2:SetCategory(CATEGORY_TOGRAVE)
    e2:SetType(EFFECT_TYPE_IGNITION)
    e2:SetRange(LOCATION_PZONE)
    e2:SetCountLimit(1,98730115)
    e2:SetCondition(c98730115.descon)
    e2:SetTarget(c98730115.destg)
    e2:SetOperation(c98730115.desop)
    c:RegisterEffect(e2)
    --tograve monster
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(98730115,0))
    e3:SetType(EFFECT_TYPE_IGNITION)
    e3:SetCategory(CATEGORY_TOGRAVE)
    e3:SetRange(LOCATION_MZONE)
    e3:SetCountLimit(1,98730116)
    e3:SetCost(c98730115.descost2)
    e3:SetTarget(c98730115.destg2)
    e3:SetOperation(c98730115.desop2)
    c:RegisterEffect(e3)
    --xyz charge
    local e4=Effect.CreateEffect(c)
    e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e4:SetCode(EVENT_SPSUMMON_SUCCESS)
    e4:SetProperty(EFFECT_FLAG_DELAY)
    e4:SetCountLimit(1,98730116)
    e4:SetCondition(c98730115.thcon)
    e4:SetTarget(c98730115.thtg)
    e4:SetOperation(c98730115.thop)
    c:RegisterEffect(e4)
    --pendulum set
    local e5=Effect.CreateEffect(c)
    e5:SetDescription(aux.Stringid(98730115,1))
    e5:SetCategory(CATEGORY_DESTROY)
    e5:SetType(EFFECT_TYPE_IGNITION)
    e5:SetRange(LOCATION_MZONE)
    e5:SetCountLimit(1,98730116)
    e5:SetTarget(c98730115.pentg)
    e5:SetOperation(c98730115.penop)
    c:RegisterEffect(e5)
end
c98730115.pendulum_level=7
function c98730115.mfilter(c)
    return c:IsRace(RACE_DRAGON) or c:IsAttribute(ATTRIBUTE_WATER)
end
function c98730115.pcfilter(c)
    return c:IsFaceup() and c:IsRace(RACE_DRAGON) and c:IsAttribute(ATTRIBUTE_WATER) and c:IsType(TYPE_PENDULUM) and not c:IsForbidden()
end
function c98730115.pctg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return (Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1))
        and Duel.IsExistingMatchingCard(c98730115.pcfilter,tp,LOCATION_EXTRA,0,1,nil) end
end
function c98730115.pcop(e,tp,eg,ep,ev,re,r,rp)
    if not e:GetHandler():IsRelateToEffect(e) then return end
    if not (Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1)) then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
    local g=Duel.SelectMatchingCard(tp,c98730115.pcfilter,tp,LOCATION_EXTRA,0,1,1,nil)
    if g:GetCount()>0 then
        Duel.MoveToField(g:GetFirst(),tp,tp,LOCATION_PZONE,POS_FACEUP,true)
    end
end

function c98730115.descon(e,tp,eg,ep,ev,re,r,rp)
    return Duel.IsExistingMatchingCard(Card.IsAttribute,tp,LOCATION_PZONE,0,1,e:GetHandler(),ATTRIBUTE_WATER)
end
function c98730115.shfilter2(c)
    return c:IsType(TYPE_MONSTER) and c:IsAbleToGrave()
end
function c98730115.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chk==0 then return e:GetHandler():IsAbleToExtra() and Duel.IsExistingMatchingCard(c98730115.shfilter2,tp,LOCATION_DECK,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c98730115.desop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local tc=Duel.GetFirstTarget()
    if not c:IsRelateToEffect(e) then return end
    if Duel.SendtoDeck(c,nil,0,REASON_EFFECT)~=0 then
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
        local g=Duel.SelectMatchingCard(tp,c98730115.shfilter2,tp,LOCATION_DECK,0,1,1,nil)
        if g:GetCount()>0 then
            Duel.SendtoGrave(g,REASON_EFFECT)
        end
    end
end

function c98730115.descost2(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,2,REASON_COST) end
    e:GetHandler():RemoveOverlayCard(tp,2,2,REASON_COST)
end
function c98730115.destg2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chk==0 then return Duel.IsExistingMatchingCard(c98730115.shfilter2,tp,LOCATION_DECK,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c98730115.desop2(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
    local g=Duel.SelectMatchingCard(tp,c98730115.shfilter2,tp,LOCATION_DECK,0,1,1,nil)
    if g:GetCount()>0 then
        Duel.SendtoGrave(g,REASON_EFFECT)
    end
end

function c98730115.thcon(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():GetSummonLocation()==LOCATION_EXTRA
end
function c98730115.thfilter(c)
    return (c:IsRace(RACE_DRAGON) or c:IsAttribute(ATTRIBUTE_WATER))
end
function c98730115.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c98730115.thfilter,tp,LOCATION_REMOVED,0,2,nil) end
    Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,nil,2,tp,LOCATION_GRAVE)
end
function c98730115.thop(e,tp,eg,ep,ev,re,r,rp)
    if not e:GetHandler():IsRelateToEffect(e) then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
    local g=Duel.SelectMatchingCard(tp,c98730115.thfilter,tp,LOCATION_REMOVED,0,2,2,nil)
    local tc=g:GetFirst()
    if g:GetCount()>0 then
        while tc do
            Duel.Overlay(e:GetHandler(),tc)
            tc=g:GetNext()
        end
    end
end

function c98730115.pentg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return (not Duel.CheckLocation(tp,LOCATION_PZONE,0) or not Duel.CheckLocation(tp,LOCATION_PZONE,1)) end
    local g=Duel.GetFieldGroup(tp,LOCATION_PZONE,0)
    Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c98730115.penop(e,tp,eg,ep,ev,re,r,rp)
    local g=Duel.GetFieldGroup(tp,LOCATION_PZONE,0)
    if Duel.Destroy(g,REASON_EFFECT)~=0 and e:GetHandler():IsRelateToEffect(e) then
        Duel.MoveToField(e:GetHandler(),tp,tp,LOCATION_PZONE,POS_FACEUP,true)
    end
end

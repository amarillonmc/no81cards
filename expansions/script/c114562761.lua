--EMファンタズム・マジシャン
function c114562761.initial_effect(c)
    --xyz summon
    aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsType,TYPE_PENDULUM),4,2,nil,nil,5)
    c:EnableReviveLimit()
    --pendulum summon
    aux.EnablePendulumAttribute(c,false)
    --pendulum set
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
    e1:SetCode(EVENT_DESTROYED)
    e1:SetRange(LOCATION_EXTRA)
    e1:SetProperty(EFFECT_FLAG_DELAY)
    e1:SetCondition(c114562761.condition)
    e1:SetTarget(c114562761.target)
    e1:SetOperation(c114562761.operation)
    c:RegisterEffect(e1)
    --salvage
    local e2=Effect.CreateEffect(c)
    e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e2:SetCategory(CATEGORY_TODECK)
    e2:SetType(EFFECT_TYPE_IGNITION)
    e2:SetRange(LOCATION_PZONE)
    e2:SetCountLimit(1,114562761)
    e2:SetTarget(c114562761.sltg)
    e2:SetOperation(c114562761.slop)
    c:RegisterEffect(e2)
    --not pendulum
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_FIELD)
    e3:SetRange(LOCATION_PZONE)
    e3:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
    e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e3:SetTargetRange(1,1)
    e3:SetTarget(c114562761.splimit)
    c:RegisterEffect(e3)
    --immune
    local e4=Effect.CreateEffect(c)
    e4:SetType(EFFECT_TYPE_SINGLE)
    e4:SetCode(EFFECT_IMMUNE_EFFECT)
    e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e4:SetRange(LOCATION_MZONE)
    e4:SetCondition(c114562761.efcon)
    e4:SetValue(c114562761.efilter)
    c:RegisterEffect(e4)
    --xyz charge
    local e5=Effect.CreateEffect(c)
    e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e5:SetCode(EVENT_SPSUMMON_SUCCESS)
    e5:SetProperty(EFFECT_FLAG_DELAY)
    e5:SetCondition(c114562761.thcon)
    e5:SetTarget(c114562761.thtg)
    e5:SetOperation(c114562761.thop)
    c:RegisterEffect(e5)
    --negate
    local e6=Effect.CreateEffect(c)
    e6:SetCategory(CATEGORY_NEGATE)
    e6:SetType(EFFECT_TYPE_QUICK_O)
    e6:SetCode(EVENT_CHAINING)
    e6:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
    e6:SetRange(LOCATION_MZONE)
    e6:SetCondition(c114562761.ngcon)
    e6:SetCost(c114562761.ngcost)
    e6:SetTarget(c114562761.ngtg)
    e6:SetOperation(c114562761.ngop)
    c:RegisterEffect(e6)
end
c114562761.pendulum_level=4
function c114562761.cfilter(c,tp)
    return c:IsPreviousLocation(LOCATION_PZONE) and c:GetPreviousControler()==tp
        and c:IsSetCard(0x9f) and not c:IsCode(114562761)
end
function c114562761.condition(e,tp,eg,ep,ev,re,r,rp)
    return eg:IsExists(c114562761.cfilter,1,nil,tp)
end
function c114562761.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return not e:GetHandler():IsPublic()
        and (Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1)) end
    Duel.ConfirmCards(1-tp,e:GetHandler())
end
function c114562761.operation(e,tp,eg,ep,ev,re,r,rp)
    if not e:GetHandler():IsRelateToEffect(e) then return end
    if not (Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1)) then return end
    Duel.MoveToField(e:GetHandler(),tp,tp,LOCATION_PZONE,POS_FACEUP,true)
end

function c114562761.filter(c)
    return c:IsRace(RACE_SPELLCASTER) and c:IsType(TYPE_PENDULUM)
end
function c114562761.sltg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c114562761.filter(chkc) end
    if chk==0 then return Duel.IsExistingTarget(c114562761.filter,tp,LOCATION_GRAVE,0,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
    local g=Duel.SelectTarget(tp,c114562761.filter,tp,LOCATION_GRAVE,0,1,1,nil)
    Duel.SetOperationInfo(0,CATEGORY_TODECK,g,1,0,0)
end
function c114562761.slop(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetFirstTarget()
    if tc:IsFaceup() and tc:IsRelateToEffect(e) then
        Duel.SendtoExtraP(tc,nil,REASON_EFFECT)
    end
end

function c114562761.splimit(e,c,tp,sumtp,sumpos)
    return bit.band(sumtp,SUMMON_TYPE_PENDULUM)~=SUMMON_TYPE_PENDULUM
end

function c114562761.efcon(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():GetOverlayCount()>0
end
function c114562761.efilter(e,te)
    return not te:IsActiveType(TYPE_PENDULUM)
end

function c114562761.thcon(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():GetSummonType()==SUMMON_TYPE_PENDULUM
end
function c114562761.thfilter(c)
    return c:IsSetCard(0x9f)
end
function c114562761.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c114562761.thfilter,tp,LOCATION_GRAVE,0,2,nil) end
end
function c114562761.thop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
    local g=Duel.SelectMatchingCard(tp,c114562761.thfilter,tp,LOCATION_GRAVE,0,2,2,nil)
    local tc=g:GetFirst()
    if g:GetCount()>0 then
        while tc do
            Duel.Overlay(e:GetHandler(),tc)
            tc=g:GetNext()
        end
    end
end

function c114562761.ngcon(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local rc=re:GetHandler()
    return re:IsActiveType(TYPE_MONSTER) and not re:IsActiveType(TYPE_PENDULUM)
        and not c:IsStatus(STATUS_BATTLE_DESTROYED) and Duel.IsChainNegatable(ev)
end
function c114562761.ngcost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST)  end
    e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c114562761.ngtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
end
function c114562761.ngop(e,tp,eg,ep,ev,re,r,rp)
    Duel.NegateActivation(ev)
end

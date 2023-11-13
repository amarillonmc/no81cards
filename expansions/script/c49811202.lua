--バージェストマ・ワプティア
function c49811202.initial_effect(c)
    --xyz summon
    aux.AddXyzProcedure(c,nil,2,2)
    c:EnableReviveLimit()
    --immune
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetCode(EFFECT_IMMUNE_EFFECT)
    e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e1:SetRange(LOCATION_MZONE)
    e1:SetValue(c49811202.efilter)
    c:RegisterEffect(e1)
    --destroy replace
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
    e2:SetCode(EFFECT_DESTROY_REPLACE)
    e2:SetRange(LOCATION_MZONE)
    e2:SetCountLimit(1)
    e2:SetTarget(c49811202.destg)
    e2:SetValue(c49811202.value)
    e2:SetOperation(c49811202.desop)
    c:RegisterEffect(e2)
    --negate
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(49811202,0))
    e3:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
    e3:SetType(EFFECT_TYPE_QUICK_O)
    e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
    e3:SetCode(EVENT_CHAINING)
    e3:SetRange(LOCATION_MZONE)
    e3:SetCountLimit(1)
    e3:SetCost(c49811202.negcost)
    e3:SetCondition(c49811202.negcon)
    e3:SetTarget(c49811202.negtg)
    e3:SetOperation(c49811202.negop)
    c:RegisterEffect(e3)
end
function c49811202.efilter(e,re)
    return re:IsActiveType(TYPE_MONSTER) and re:GetOwner()~=e:GetOwner()
end    
function c49811202.dfilter(c,tp)
    return c:IsControler(tp) and c:IsSetCard(0xd4) and c:IsReason(REASON_BATTLE)
end
function c49811202.repfilter(c)
    return c:GetType()==TYPE_TRAP and c:IsAbleToGrave()
end
function c49811202.destg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return eg:IsExists(c49811202.dfilter,1,nil,tp)
        and Duel.IsExistingMatchingCard(c49811202.repfilter,tp,LOCATION_DECK,0,1,nil) end
    return Duel.SelectEffectYesNo(tp,e:GetHandler(),96)
end
function c49811202.value(e,c)
    return c:IsControler(e:GetHandlerPlayer()) and c:IsReason(REASON_BATTLE)
end
function c49811202.desop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
    local g=Duel.SelectMatchingCard(tp,c49811202.repfilter,tp,LOCATION_DECK,0,1,1,nil)
    Duel.SendtoGrave(g,REASON_EFFECT)
end
function c49811202.negcon(e,tp,eg,ep,ev,re,r,rp)
    return not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) and ep~=tp
        and re:IsHasType(EFFECT_TYPE_ACTIVATE) and Duel.IsChainNegatable(ev) and e:GetHandler():GetOverlayGroup():IsExists(Card.IsType,1,nil,TYPE_TRAP)
end
function c49811202.negcost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
    e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c49811202.negtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
end
function c49811202.negop(e,tp,eg,ep,ev,re,r,rp)
    local rc=re:GetHandler()
    if not Duel.NegateActivation(ev) then return end
    if rc:IsRelateToEffect(re) and rc:IsRelateToEffect(re) and rc:IsCanTurnSet() then
        local code=rc:GetCode()
        rc:CancelToGrave()
        Duel.ChangePosition(rc,POS_FACEDOWN)
        Duel.RaiseEvent(rc,EVENT_SSET,e,REASON_EFFECT,tp,tp,0)
        local e1=Effect.CreateEffect(e:GetHandler())
        e1:SetType(EFFECT_TYPE_FIELD)
        e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
        e1:SetCode(EFFECT_CANNOT_ACTIVATE)
        e1:SetTargetRange(0,1)
        e1:SetValue(c49811202.aclimit)
        e1:SetLabel(code)
        e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,2)
        Duel.RegisterEffect(e1,tp)
    end
end
function c49811202.aclimit(e,re,tp)
    return re:IsHasType(EFFECT_TYPE_ACTIVATE) and re:GetHandler():IsCode(e:GetLabel())
end
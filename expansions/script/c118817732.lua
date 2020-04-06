function c118817732.initial_effect(c)
    c:EnableReviveLimit()
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(118817732,0))
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetCode(EFFECT_SPSUMMON_PROC)
    e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
    e1:SetRange(LOCATION_EXTRA)
    e1:SetCondition(aux.XyzCondition(nil,8,2,2))
    e1:SetTarget(aux.XyzTarget(nil,8,2,2))
    e1:SetOperation(aux.XyzOperation(nil,8,2,2))
    e1:SetValue(SUMMON_TYPE_XYZ)
    c:RegisterEffect(e1)
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(118817732,1))
    e2:SetType(EFFECT_TYPE_FIELD)
    e2:SetCode(EFFECT_SPSUMMON_PROC)
    e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
    e2:SetRange(LOCATION_EXTRA)
    e2:SetCountLimit(1,118817732)
    e2:SetCondition(c118817732.xyzcondition)
    e2:SetTarget(c118817732.xyztarget)
    e2:SetOperation(aux.XyzOperation(nil,8,2,2))
    e2:SetValue(SUMMON_TYPE_XYZ)
    c:RegisterEffect(e2)
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_FIELD)
    e3:SetCode(EFFECT_IMMUNE_EFFECT)
    e3:SetRange(LOCATION_MZONE)
    e3:SetCondition(c118817732.indcon)
    e3:SetTargetRange(LOCATION_MZONE,0)
    e3:SetTarget(aux.TargetBoolFunction(Card.IsRace,RACE_DRAGON))
    e3:SetValue(c118817732.imvalue)
    c:RegisterEffect(e3)
    local e4=Effect.CreateEffect(c)
    e4:SetType(EFFECT_TYPE_FIELD)
    e4:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
    e4:SetRange(LOCATION_MZONE)
    e4:SetCondition(c118817732.indcon)
    e4:SetTargetRange(LOCATION_MZONE,0)
    e4:SetTarget(aux.TargetBoolFunction(Card.IsRace,RACE_DRAGON))
    e4:SetValue(c118817732.indvalue)
    c:RegisterEffect(e4)
    local e5=Effect.CreateEffect(c)
    e5:SetDescription(aux.Stringid(118817732,2))
    e5:SetCategory(CATEGORY_DESTROY)
    e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
    e5:SetRange(LOCATION_MZONE)
    e5:SetCode(EVENT_ATTACK_ANNOUNCE)
    e5:SetCondition(c118817732.atkcon)
    e5:SetTarget(c118817732.atktg)
    e5:SetOperation(c118817732.atkop)
    c:RegisterEffect(e5)
    local e6=Effect.CreateEffect(c)
    e6:SetDescription(aux.Stringid(118817732,3))
    e6:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOHAND+CATEGORY_SEARCH)
    e6:SetType(EFFECT_TYPE_QUICK_O)
    e6:SetCode(EVENT_FREE_CHAIN)
    e6:SetRange(LOCATION_MZONE)
    e6:SetCountLimit(1)
    e6:SetCost(c118817732.sccost)
    e6:SetTarget(c118817732.sctg)
    e6:SetOperation(c118817732.scop)
    c:RegisterEffect(e6)
end
function c118817732.xyzfilter(c)
    return c:IsRace(RACE_DRAGON) and c:IsCanOverlay()
end
function c118817732.xyzcondition(e,c,og,min,max)
    if c==nil then return true end
    local tp=c:GetControler()
    local mg=Duel.GetMatchingGroup(c118817732.xyzfilter,tp,LOCATION_HAND,0,nil)
    return mg:IsExists(aux.TRUE,2,nil)
end
function c118817732.xyztarget(e,tp,eg,ep,ev,re,r,rp,chk,c,og,min,max)
    local mg=Duel.GetMatchingGroup(c118817732.xyzfilter,tp,LOCATION_HAND,0,nil)
    local g=mg:Select(tp,2,2,nil)
    if g then
        g:KeepAlive()
        e:SetLabelObject(g)
        return true
    else return false end
end
function c118817732.indcon(e)
    return e:GetHandler():GetOverlayCount()>0
end
function c118817732.imvalue(e,re)
    return re:IsActiveType(TYPE_MONSTER) and re:GetHandlerPlayer()~=e:GetHandlerPlayer()
end
function c118817732.indvalue(e,re)
    return re:GetHandlerPlayer()~=e:GetHandlerPlayer()
end
function c118817732.atkcon(e,tp,eg,ep,ev,re,r,rp)
    return Duel.GetAttacker():IsType(TYPE_NORMAL) and Duel.GetFieldGroupCount(tp,0,LOCATION_ONFIELD)>0
end
function c118817732.atktg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    local g=Duel.GetFieldGroup(tp,0,LOCATION_ONFIELD)
    Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c118817732.atkop(e,tp,eg,ep,ev,re,r,rp)
    if Duel.NegateAttack() then
        local g=Duel.GetFieldGroup(tp,0,LOCATION_ONFIELD)
        if g:GetCount()>0 then
            Duel.Destroy(g,REASON_EFFECT)
        end
    end
end
function c118817732.sccost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
    e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c118817732.scfilter(c,e,tp)
    return c:IsSetCard(0xdd) and c:IsType(TYPE_MONSTER) and (c:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 or c:IsAbleToHand())
end
function c118817732.sctg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c118817732.scfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil,e,tp) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON+CATEGORY_SEARCH+CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function c118817732.scop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SELF)
    local g=Duel.SelectMatchingCard(tp,c118817732.scfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,e,tp)
    local tc=g:GetFirst()
    if tc then
        local b1=tc:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        local b2=tc:IsAbleToHand()
        if b1 and (not b2 or Duel.SelectYesNo(tp,aux.Stringid(118817732,4))) then
            Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
        else
            Duel.SendtoHand(tc,nil,REASON_EFFECT)
            Duel.ConfirmCards(1-tp,tc)
        end
    end
end
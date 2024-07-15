--英龙骑-人鱼风灵
function c46250012.initial_effect(c)
    c:SetSPSummonOnce(46250012)
    c:EnableReviveLimit()
    aux.AddLinkProcedure(c,c46250012.lfilter,1,1)
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_EQUIP)
    e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e1:SetCode(EVENT_SPSUMMON_SUCCESS)
    e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
    e1:SetCondition(c46250012.sumcon)
    e1:SetTarget(c46250012.sumtg)
    e1:SetOperation(c46250012.sumop)
    c:RegisterEffect(e1)
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_SINGLE)
    e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e2:SetRange(LOCATION_MZONE)
    e2:SetCode(EFFECT_UPDATE_ATTACK)
    e2:SetValue(c46250012.atkval)
    c:RegisterEffect(e2)
    local e3=Effect.CreateEffect(c)
    e3:SetCountLimit(1)
    e3:SetCategory(CATEGORY_NEGATE+CATEGORY_TODECK)
    e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
    e3:SetType(EFFECT_TYPE_QUICK_O)
    e3:SetRange(LOCATION_MZONE)
    e3:SetCode(EVENT_CHAINING)
    e3:SetCondition(c46250012.negcon)
    e3:SetCost(c46250012.negcost)
    e3:SetTarget(c46250012.negtg)
    e3:SetOperation(c46250012.negop)
    c:RegisterEffect(e3)
end
function c46250012.lfilter(c)
    return c:IsLinkSetCard(0x1fc0)
end
function c46250012.sumcon(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end
function c46250012.eqfilter(c)
    return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x1fc0) and not c:IsForbidden()
end
function c46250012.sumtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and Duel.IsExistingMatchingCard(c46250012.eqfilter,tp,LOCATION_GRAVE,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_EQUIP,nil,1,tp,LOCATION_GRAVE)
end
function c46250012.sumop(e,tp,eg,ep,ev,re,r,rp)
    if Duel.GetLocationCount(tp,LOCATION_SZONE)<1 then return end
    local c=e:GetHandler()
    if c:IsFaceup() and c:IsRelateToEffect(e) then
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
        local g=Duel.SelectMatchingCard(tp,c46250012.eqfilter,tp,LOCATION_GRAVE,0,1,1,nil)
        if not g then return end
        local tc=g:GetFirst()
        if not Duel.Equip(tp,tc,c,true) then return end
        local e1=Effect.CreateEffect(c)
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetProperty(EFFECT_FLAG_OWNER_RELATE)
        e1:SetCode(EFFECT_EQUIP_LIMIT)
        e1:SetReset(RESET_EVENT+RESETS_STANDARD)
        e1:SetValue(c46250012.eqlimit)
        tc:RegisterEffect(e1)
        local e2=Effect.CreateEffect(c)
        e2:SetType(EFFECT_TYPE_SINGLE)
        e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
        e2:SetCode(EFFECT_EXTRA_LINK_MATERIAL)
        e2:SetRange(LOCATION_SZONE)
        e2:SetReset(RESET_EVENT+RESETS_STANDARD)
        e2:SetValue(c46250012.matval)
        tc:RegisterEffect(e2)
    end
end
function c46250012.eqlimit(e,c)
    return e:GetOwner()==c
end
function c46250012.matval(e,c,mg)
    return c:IsRace(RACE_WYRM) and c:IsControler(e:GetHandlerPlayer())
end
function c46250012.atkval(e,c)
    return Group.GetSum(c:GetEquipGroup():Filter(Card.IsSetCard,nil,0x1fc0),Card.GetTextAttack)
end
function c46250012.negcon(e,tp,eg,ep,ev,re,r,rp)
    local eg=e:GetHandler():GetEquipGroup()
    return eg and eg:IsExists(Card.IsSetCard,1,nil,0x1fc0) and re:GetActivateLocation()==LOCATION_GRAVE and Duel.IsChainNegatable(ev)
end
function c46250012.rfilter(c)
    return c:IsSetCard(0xfc0) and c:IsAbleToDeckAsCost()
end
function c46250012.negcost(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    if chk==0 then return Duel.IsExistingMatchingCard(c46250012.rfilter,tp,LOCATION_GRAVE,0,2,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
    local g=Duel.SelectMatchingCard(tp,c46250012.rfilter,tp,LOCATION_GRAVE,0,2,2,nil)
    Duel.SendtoDeck(g,nil,2,REASON_COST)
end
function c46250012.negtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
    if re:GetHandler():IsRelateToEffect(re) then
        Duel.SetOperationInfo(0,CATEGORY_TODECK,eg,1,0,0)
    end
end
function c46250012.negop(e,tp,eg,ep,ev,re,r,rp)
    local ec=re:GetHandler()
    if Duel.NegateActivation(ev) and ec:IsRelateToEffect(re) then
        ec:CancelToGrave()
        Duel.SendtoDeck(ec,nil,2,REASON_EFFECT)
    end
end

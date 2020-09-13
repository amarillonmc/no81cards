function c89380008.initial_effect(c)
    c:SetUniqueOnField(1,1,89380008)
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
    e1:SetType(EFFECT_TYPE_QUICK_O)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetRange(LOCATION_HAND)
    e1:SetCost(c89380008.spcost)
    e1:SetTarget(c89380008.target)
    e1:SetOperation(c89380008.operation)
    c:RegisterEffect(e1)
    local e2=Effect.CreateEffect(c)
    e2:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
    e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
    e2:SetCode(EVENT_BATTLE_DESTROYING)
    e2:SetRange(LOCATION_SZONE)
    e2:SetCondition(c89380008.drcon)
    e2:SetTarget(c89380008.target)
    e2:SetOperation(c89380008.drop)
    c:RegisterEffect(e2)
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_SINGLE)
    e3:SetCode(EFFECT_IMMUNE_EFFECT)
    e3:SetValue(c89380008.efilter)
    c:RegisterEffect(e3)
end
function c89380008.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():IsDiscardable() end
    Duel.SendtoGrave(e:GetHandler(),REASON_COST+REASON_DISCARD)
end
function c89380008.spfilter(c)
    return c:IsSetCard(0xcc00) and c:IsAbleToHand()
end
function c89380008.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c89380008.spfilter,tp,LOCATION_DECK,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c89380008.eqfilter(c)
    return c:IsCode(89380009) and c:IsFaceup()
end
function c89380008.operation(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local tg=Duel.SelectMatchingCard(tp,c89380008.spfilter,tp,LOCATION_DECK,0,1,1,nil)
    if not tg then return end
    Duel.SendtoHand(tg,nil,REASON_EFFECT)
    Duel.ConfirmCards(1-tp,tg)
    if Duel.IsExistingMatchingCard(c89380008.eqfilter,tp,LOCATION_MZONE,0,1,nil) and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and c:IsLocation(LOCATION_GRAVE) and c:CheckUniqueOnField(tp) and not c:IsForbidden() and Duel.SelectYesNo(tp,aux.Stringid(89380008,0)) then
        Duel.BreakEffect()
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
        local g=Duel.SelectMatchingCard(tp,c89380008.eqfilter,tp,LOCATION_MZONE,0,1,1,nil)
        if not (g and Duel.Equip(tp,c,g:GetFirst(),false)) then return end
        local e1=Effect.CreateEffect(g:GetFirst())
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetProperty(EFFECT_FLAG_OWNER_RELATE)
        e1:SetCode(EFFECT_EQUIP_LIMIT)
        e1:SetReset(RESET_EVENT+RESETS_STANDARD)
        e1:SetValue(c89380008.eqlimit)
        c:RegisterEffect(e1)
    end
end
function c89380008.eqlimit(e,c)
    return e:GetOwner()==c
end
function c89380008.drcon(e,tp,eg,ep,ev,re,r,rp)
    local ec=eg:GetFirst()
    local bc=ec:GetBattleTarget()
    return e:GetHandler():GetEquipTarget()==eg:GetFirst() and ec:IsControler(tp)
end
function c89380008.drop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local tg=Duel.SelectMatchingCard(tp,c89380008.spfilter,tp,LOCATION_DECK,0,1,1,nil)
    if not tg then return end
    Duel.SendtoHand(tg,nil,REASON_EFFECT)
    Duel.ConfirmCards(1-tp,tg)
end
function c89380008.efilter(e,te)
    return te:GetOwner()~=e:GetOwner() and e:GetOwner():IsType(TYPE_EQUIP)
end
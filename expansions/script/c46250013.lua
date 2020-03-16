--英龙骑-星炮手
function c46250013.initial_effect(c)
    c:SetSPSummonOnce(46250013)
    c:EnableReviveLimit()
    aux.AddLinkProcedure(c,c46250013.lfilter,2,2)
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_EQUIP)
    e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e1:SetCode(EVENT_SPSUMMON_SUCCESS)
    e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
    e1:SetTarget(c46250013.sumtg)
    e1:SetOperation(c46250013.sumop)
    c:RegisterEffect(e1)
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_SINGLE)
    e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e2:SetRange(LOCATION_MZONE)
    e2:SetCode(EFFECT_UPDATE_ATTACK)
    e2:SetValue(c46250013.atkval)
    c:RegisterEffect(e2)
    local e5=Effect.CreateEffect(c)
    e5:SetDescription(aux.Stringid(46250013,0))
    e5:SetCategory(CATEGORY_TOHAND+CATEGORY_SUMMON)
    e5:SetType(EFFECT_TYPE_QUICK_O)
    e5:SetCode(EVENT_FREE_CHAIN)
    e5:SetRange(LOCATION_MZONE)
    e5:SetCondition(c46250013.spcon)
    e5:SetCost(c46250013.spcost)
    e5:SetTarget(c46250013.sptg)
    e5:SetOperation(c46250013.spop)
    c:RegisterEffect(e5)
    local e6=Effect.CreateEffect(c)
    e6:SetDescription(aux.Stringid(46250013,1))
    e6:SetCountLimit(1)
    e6:SetCategory(CATEGORY_TOHAND+CATEGORY_NEGATE)
    e6:SetType(EFFECT_TYPE_QUICK_O)
    e6:SetCode(EVENT_CHAINING)
    e6:SetRange(LOCATION_MZONE)
    e6:SetCondition(c46250013.negcon)
    e6:SetCost(c46250013.negcost)
    e6:SetTarget(c46250013.negtg)
    e6:SetOperation(c46250013.negop)
    c:RegisterEffect(e6)
end
function c46250013.lfilter(c)
    return c:IsLinkSetCard(0xfc0)
end
function c46250013.eqfilter(c)
    return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x1fc0) and not c:IsForbidden()
end
function c46250013.sumtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and Duel.IsExistingMatchingCard(c46250013.eqfilter,tp,LOCATION_DECK,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_EQUIP,nil,1,tp,LOCATION_DECK)
end
function c46250013.sumop(e,tp,eg,ep,ev,re,r,rp)
    if Duel.GetLocationCount(tp,LOCATION_SZONE)<1 then return end
    local c=e:GetHandler()
    if c:IsFaceup() and c:IsRelateToEffect(e) then
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
        local g=Duel.SelectMatchingCard(tp,c46250013.eqfilter,tp,LOCATION_DECK,0,1,1,nil)
        if not g then return end
        local tc=g:GetFirst()
        if not Duel.Equip(tp,tc,c,true) then return end
        local e1=Effect.CreateEffect(c)
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetProperty(EFFECT_FLAG_OWNER_RELATE)
        e1:SetCode(EFFECT_EQUIP_LIMIT)
        e1:SetReset(RESET_EVENT+RESETS_STANDARD)
        e1:SetValue(c46250013.eqlimit)
        tc:RegisterEffect(e1)
        local e2=Effect.CreateEffect(c)
        e2:SetType(EFFECT_TYPE_SINGLE)
        e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
        e2:SetCode(EFFECT_EXTRA_LINK_MATERIAL)
        e2:SetRange(LOCATION_SZONE)
        e2:SetReset(RESET_EVENT+RESETS_STANDARD)
        e2:SetValue(c46250013.matval)
        tc:RegisterEffect(e2)
    end
end
function c46250013.eqlimit(e,c)
    return e:GetOwner()==c
end
function c46250013.matval(e,c,mg)
    return c:IsRace(RACE_WYRM)
end
function c46250013.atkval(e,c)
    return Group.GetSum(c:GetEquipGroup():Filter(Card.IsSetCard,nil,0x1fc0),Card.GetTextAttack)
end
function c46250013.spcon(e,tp,eg,ep,ev,re,r,rp)
    local eg=e:GetHandler():GetEquipGroup()
    return eg and eg:IsExists(Card.IsSetCard,1,nil,0x1fc0) and Duel.IsExistingMatchingCard(Card.IsSummonable,tp,LOCATION_HAND,0,1,nil,true,nil)
end
function c46250013.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    if chk==0 then return c:IsReleasable() end
    local g=c:GetEquipGroup()
    g:KeepAlive()
    e:SetLabelObject(g)
    Duel.Release(c,REASON_COST)
end
function c46250013.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
end
function c46250013.spop(e,tp,eg,ep,ev,re,r,rp)
    local g=e:GetLabelObject():Filter(Card.IsLocation,nil,LOCATION_GRAVE)
    if g:GetCount()>0 and Duel.SendtoHand(g,nil,REASON_EFFECT)>0 then
        Duel.ConfirmCards(1-tp,g)
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SUMMON)
        if Duel.IsExistingMatchingCard(Card.IsSummonable,tp,LOCATION_HAND,0,1,nil,true,nil) then
            local tg=Duel.SelectMatchingCard(tp,Card.IsSummonable,tp,LOCATION_HAND,0,1,1,nil,true,nil)
            Duel.BreakEffect()
            Duel.Summon(tp,tg:GetFirst(),true,nil)
        else
            Duel.ConfirmCards(1-tp,Duel.GetFieldGroup(tp,LOCATION_HAND,0))
        end
    end
end
function c46250013.negcon(e,tp,eg,ep,ev,re,r,rp)
    if not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return false end
    local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
    local eg=e:GetHandler():GetEquipGroup()
    return g and g:IsExists(Card.IsLocation,1,nil,LOCATION_MZONE) and eg and eg:IsExists(Card.IsSetCard,1,nil,0x1fc0)
end
function c46250013.rfilter(c)
    return c:IsSetCard(0xfc0) and c:IsType(TYPE_MONSTER) and c:IsAbleToDeckOrExtraAsCost()
end
function c46250013.negcost(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    if chk==0 then return Duel.IsExistingMatchingCard(c46250013.rfilter,tp,LOCATION_GRAVE,0,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
    local g=Duel.SelectMatchingCard(tp,c46250013.rfilter,tp,LOCATION_GRAVE,0,1,1,nil)
    Duel.SendtoDeck(g,nil,2,REASON_COST)
end
function c46250013.thfilter(c)
    return c:IsType(TYPE_MONSTER) and c:IsSetCard(0xfc0) and c:IsFaceup() and c:IsAbleToHand()
end
function c46250013.negtg(e,tp,eg,ep,ev,re,r,rp,chk)
    local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS):Filter(Card.IsLocation,nil,LOCATION_MZONE)
    if chk==0 then return g:GetCount()>0 and Duel.IsExistingMatchingCard(c46250003.thfilter,tp,LOCATION_REMOVED,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,0,1,tp,LOCATION_REMOVED)
end
function c46250013.negop(e,tp,eg,ep,ev,re,r,rp)
    local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS):Filter(Card.IsLocation,nil,LOCATION_MZONE)
    if not g then return end
    if Duel.NegateActivation(ev) then
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
        local tg=Duel.SelectMatchingCard(tp,c46250013.thfilter,tp,LOCATION_REMOVED,0,1,1,nil)
        Duel.SendtoHand(tg,nil,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,tg)
    end
end

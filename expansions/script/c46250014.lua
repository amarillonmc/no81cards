--英龙骑-珍珠拳帝
function c46250014.initial_effect(c)
    c:SetSPSummonOnce(46250014)
    c:EnableReviveLimit()
    aux.AddLinkProcedure(c,c46250014.lfilter,2,2)
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_EQUIP)
    e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e1:SetCode(EVENT_SPSUMMON_SUCCESS)
    e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
    e1:SetCondition(c46250014.sumcon)
    e1:SetTarget(c46250014.sumtg)
    e1:SetOperation(c46250014.sumop)
    c:RegisterEffect(e1)
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_SINGLE)
    e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e2:SetRange(LOCATION_MZONE)
    e2:SetCode(EFFECT_UPDATE_ATTACK)
    e2:SetValue(c46250014.atkval)
    c:RegisterEffect(e2)
    local e5=Effect.CreateEffect(c)
    e5:SetCategory(CATEGORY_TOHAND+CATEGORY_SUMMON)
    e5:SetType(EFFECT_TYPE_QUICK_O)
    e5:SetCode(EVENT_FREE_CHAIN)
    e5:SetRange(LOCATION_MZONE)
    e5:SetCondition(c46250014.spcon)
    e5:SetCost(c46250014.spcost)
    e5:SetTarget(c46250014.sptg)
    e5:SetOperation(c46250014.spop)
    c:RegisterEffect(e5)
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_FIELD)
    e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e3:SetCode(EFFECT_CANNOT_ACTIVATE)
    e3:SetRange(LOCATION_MZONE)
    e3:SetTargetRange(0,1)
    e3:SetValue(c46250014.aclimit)
    e3:SetCondition(c46250014.actcon)
    c:RegisterEffect(e3)
    local e4=Effect.CreateEffect(c)
    e4:SetType(EFFECT_TYPE_SINGLE)
    e4:SetCode(EFFECT_EXTRA_ATTACK)
    e4:SetCondition(c46250014.dircon)
    e4:SetValue(1)
    c:RegisterEffect(e4)
end
function c46250014.lfilter(c)
    return c:IsLinkSetCard(0xfc0)
end
function c46250014.sumcon(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end
function c46250014.eqfilter(c)
    return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x1fc0) and not c:IsForbidden()
end
function c46250014.sumtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and Duel.IsExistingMatchingCard(c46250014.eqfilter,tp,LOCATION_GRAVE,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_EQUIP,nil,1,tp,LOCATION_GRAVE)
end
function c46250014.sumop(e,tp,eg,ep,ev,re,r,rp)
    if Duel.GetLocationCount(tp,LOCATION_SZONE)<1 then return end
    local c=e:GetHandler()
    if c:IsFaceup() and c:IsRelateToEffect(e) then
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
        local g=Duel.SelectMatchingCard(tp,c46250014.eqfilter,tp,LOCATION_GRAVE,0,1,1,nil)
        if not g then return end
        local tc=g:GetFirst()
        if not Duel.Equip(tp,tc,c,true) then return end
        local e1=Effect.CreateEffect(c)
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetProperty(EFFECT_FLAG_OWNER_RELATE)
        e1:SetCode(EFFECT_EQUIP_LIMIT)
        e1:SetReset(RESET_EVENT+RESETS_STANDARD)
        e1:SetValue(c46250014.eqlimit)
        tc:RegisterEffect(e1)
        local e2=Effect.CreateEffect(c)
        e2:SetType(EFFECT_TYPE_SINGLE)
        e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
        e2:SetCode(EFFECT_EXTRA_LINK_MATERIAL)
        e2:SetRange(LOCATION_SZONE)
        e2:SetReset(RESET_EVENT+RESETS_STANDARD)
        e2:SetValue(c46250014.matval)
        tc:RegisterEffect(e2)
    end
end
function c46250014.eqlimit(e,c)
    return e:GetOwner()==c
end
function c46250014.matval(e,c,mg)
    return c:IsRace(RACE_WYRM) and c:IsControler(e:GetHandlerPlayer()),true
end
function c46250014.atkval(e,c)
    return Group.GetSum(c:GetEquipGroup():Filter(Card.IsSetCard,nil,0x1fc0),Card.GetTextAttack)
end
function c46250014.spcon(e,tp,eg,ep,ev,re,r,rp)
    local eg=e:GetHandler():GetEquipGroup()
    return eg and eg:IsExists(Card.IsSetCard,1,nil,0x1fc0) and Duel.IsExistingMatchingCard(Card.IsSummonable,tp,LOCATION_HAND,0,1,nil,true,nil)
end
function c46250014.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    if chk==0 then return c:IsReleasable() end
    local g=c:GetEquipGroup()
    g:KeepAlive()
    e:SetLabelObject(g)
    Duel.Release(c,REASON_COST)
end
function c46250014.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
end
function c46250014.spop(e,tp,eg,ep,ev,re,r,rp)
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
function c46250014.aclimit(e,re,tp)
    return re:IsActiveType(TYPE_MONSTER) and not re:GetHandler():IsImmuneToEffect(e)
end
function c46250014.actcon(e)
    local c=e:GetHandler()
    local a=Duel.GetAttacker()
    local d=Duel.GetAttackTarget()
    local eg=c:GetEquipGroup()
    return eg and eg:IsExists(Card.IsSetCard,1,nil,0x1fc0) and (a and a==c or d and d==c)
end
function c46250014.dircon(e)
    local eg=e:GetHandler():GetEquipGroup()
    return eg and eg:IsExists(Card.IsSetCard,1,nil,0x1fc0)
end

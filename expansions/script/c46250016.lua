--英龙骑-木龙兽
function c46250016.initial_effect(c)
    c:SetSPSummonOnce(46250016)
    c:EnableReviveLimit()
    aux.AddLinkProcedure(c,c46250016.lfilter,2,3)
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_EQUIP)
    e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e1:SetCode(EVENT_SPSUMMON_SUCCESS)
    e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
    e1:SetCondition(c46250016.sumcon)
    e1:SetTarget(c46250016.sumtg)
    e1:SetOperation(c46250016.sumop)
    c:RegisterEffect(e1)
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_SINGLE)
    e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e2:SetRange(LOCATION_MZONE)
    e2:SetCode(EFFECT_UPDATE_ATTACK)
    e2:SetValue(c46250016.atkval)
    c:RegisterEffect(e2)
    local e5=Effect.CreateEffect(c)
    e5:SetDescription(aux.Stringid(46250016,0))
    e5:SetCategory(CATEGORY_TOHAND+CATEGORY_SUMMON)
    e5:SetType(EFFECT_TYPE_QUICK_O)
    e5:SetCode(EVENT_FREE_CHAIN)
    e5:SetRange(LOCATION_MZONE)
    e5:SetCondition(c46250016.spcon)
    e5:SetCost(c46250016.spcost)
    e5:SetTarget(c46250016.sptg)
    e5:SetOperation(c46250016.spop)
    c:RegisterEffect(e5)
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(46250016,1))
    e3:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
    e3:SetType(EFFECT_TYPE_QUICK_O)
    e3:SetCode(EVENT_CHAINING)
    e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
    e3:SetRange(LOCATION_MZONE)
    e3:SetCondition(c46250016.discon)
    e3:SetTarget(c46250016.distg)
    e3:SetOperation(c46250016.disop)
    c:RegisterEffect(e3)
    if not c46250016.global_check then
        c46250016.global_check=true
        c46250016[0]={}
        c46250016[1]={}
        local ge1=Effect.CreateEffect(c)
        ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
        ge1:SetCode(EVENT_TO_GRAVE)
        ge1:SetOperation(c46250016.checkop)
        Duel.RegisterEffect(ge1,0)
        local ge4=Effect.CreateEffect(c)
        ge4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
        ge4:SetCode(EVENT_PHASE_START+PHASE_DRAW)
        ge4:SetOperation(c46250016.clearop)
        Duel.RegisterEffect(ge4,0)
    end
end
function c46250016.lfilter(c)
    return c:IsLinkSetCard(0xfc0) and c:IsLocation(LOCATION_MZONE)
end
function c46250016.sumcon(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end
function c46250016.eqfilter(c)
    return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x1fc0) and not c:IsForbidden()
end
function c46250016.sumtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and Duel.IsExistingMatchingCard(c46250016.eqfilter,tp,LOCATION_GRAVE,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_EQUIP,nil,1,tp,LOCATION_GRAVE)
end
function c46250016.sumop(e,tp,eg,ep,ev,re,r,rp)
    if Duel.GetLocationCount(tp,LOCATION_SZONE)<1 then return end
    local c=e:GetHandler()
    if c:IsFaceup() and c:IsRelateToEffect(e) then
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
        local g=Duel.SelectMatchingCard(tp,c46250016.eqfilter,tp,LOCATION_GRAVE,0,1,1,nil)
        if not g then return end
        local tc=g:GetFirst()
        if not Duel.Equip(tp,tc,c,true) then return end
        local e1=Effect.CreateEffect(c)
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetProperty(EFFECT_FLAG_OWNER_RELATE)
        e1:SetCode(EFFECT_EQUIP_LIMIT)
        e1:SetReset(RESET_EVENT+RESETS_STANDARD)
        e1:SetValue(c46250016.eqlimit)
        tc:RegisterEffect(e1)
    end
end
function c46250016.eqlimit(e,c)
    return e:GetOwner()==c
end
function c46250016.atkval(e,c)
    return Group.GetSum(c:GetEquipGroup():Filter(Card.IsSetCard,nil,0x1fc0),Card.GetTextAttack)
end
function c46250016.spcon(e,tp,eg,ep,ev,re,r,rp)
    local eg=e:GetHandler():GetEquipGroup()
    return eg and eg:IsExists(Card.IsSetCard,1,nil,0x1fc0) and Duel.IsExistingMatchingCard(Card.IsSummonable,tp,LOCATION_HAND,0,1,nil,true,nil)
end
function c46250016.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    if chk==0 then return c:IsReleasable() end
    local g=c:GetEquipGroup()
    g:KeepAlive()
    e:SetLabelObject(g)
    Duel.Release(c,REASON_COST)
end
function c46250016.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
end
function c46250016.spop(e,tp,eg,ep,ev,re,r,rp)
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
function c46250016.discon(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local eg=c:GetEquipGroup()
    return eg and eg:IsExists(Card.IsSetCard,1,nil,0x1fc0) and re:GetHandler()~=c and not c:IsStatus(STATUS_BATTLE_DESTROYED) and not c:IsStatus(STATUS_CHAINING) and (re:IsActiveType(TYPE_MONSTER) or re:IsHasType(EFFECT_TYPE_ACTIVATE)) and Duel.IsChainNegatable(ev)
end
function c46250016.disfilter(c)
    for k,v in ipairs(c46250016[c:GetOwner()]) do
        if v==c:GetCode() then return false end
    end
    return c:IsFaceup() and c:IsSetCard(0xfc0) and c:IsAbleToGrave()
end
function c46250016.distg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c46250016.disfilter,tp,LOCATION_ONFIELD,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
    local rc=re:GetHandler()
    if rc:IsDestructable() and rc:IsRelateToEffect(re) then
        Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
    end
end
function c46250016.disop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
    local g=Duel.SelectMatchingCard(tp,c46250016.disfilter,tp,LOCATION_ONFIELD,0,1,1,nil)
    if not g then return end
    if Duel.SendtoGrave(g,REASON_EFFECT)==0 or not Duel.NegateActivation(ev) then return end
    if re:GetHandler():IsRelateToEffect(re) then
        Duel.Destroy(eg,REASON_EFFECT)
    end
end
function c46250016.checkop(e,tp,eg,ep,ev,re,r,rp)
    for c in aux.Next(eg) do
        table.insert(c46250016[c:GetOwner()],c:GetCode())
    end
end
function c46250016.clearop(e,tp,eg,ep,ev,re,r,rp)
    c46250016[0]={}
    c46250016[1]={}
end

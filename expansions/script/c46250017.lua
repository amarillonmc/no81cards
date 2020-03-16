--英龙骑-枪骑神
function c46250017.initial_effect(c)
    c:SetSPSummonOnce(46250017)
    c:EnableReviveLimit()
    aux.AddLinkProcedure(c,c46250017.lfilter,2)
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_EQUIP)
    e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e1:SetCode(EVENT_SPSUMMON_SUCCESS)
    e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
    e1:SetCondition(c46250017.sumcon)
    e1:SetTarget(c46250017.sumtg)
    e1:SetOperation(c46250017.sumop)
    c:RegisterEffect(e1)
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_SINGLE)
    e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e2:SetRange(LOCATION_MZONE)
    e2:SetCode(EFFECT_UPDATE_ATTACK)
    e2:SetValue(c46250017.atkval)
    c:RegisterEffect(e2)
    local e5=Effect.CreateEffect(c)
    e5:SetDescription(aux.Stringid(46250017,0))
    e5:SetCategory(CATEGORY_TOHAND+CATEGORY_SUMMON)
    e5:SetType(EFFECT_TYPE_QUICK_O)
    e5:SetCode(EVENT_FREE_CHAIN)
    e5:SetRange(LOCATION_MZONE)
    e5:SetCondition(c46250017.spcon)
    e5:SetCost(c46250017.spcost)
    e5:SetTarget(c46250017.sptg)
    e5:SetOperation(c46250017.spop)
    c:RegisterEffect(e5)
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(46250017,1))
    e3:SetCategory(CATEGORY_EQUIP)
    e3:SetType(EFFECT_TYPE_IGNITION)
    e3:SetRange(LOCATION_MZONE)
    e3:SetCountLimit(1)
    e3:SetCondition(c46250017.spcon)
    e3:SetTarget(c46250017.sptg2)
    e3:SetOperation(c46250017.spop2)
    c:RegisterEffect(e3)
    local e4=Effect.CreateEffect(c)
    e4:SetDescription(aux.Stringid(46250017,2))
    e4:SetCategory(CATEGORY_DESTROY+CATEGORY_TODECK)
    e4:SetType(EFFECT_TYPE_IGNITION)
    e4:SetRange(LOCATION_MZONE)
    e4:SetCountLimit(1)
    e4:SetCondition(c46250017.spcon)
    e4:SetTarget(c46250017.tsptg)
    e4:SetOperation(c46250017.tspop)
    c:RegisterEffect(e4)
end
function c46250017.lfilter(c)
    return c:IsLinkSetCard(0xfc0)
end
function c46250017.sumcon(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end
function c46250017.eqfilter(c)
    return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x1fc0) and not c:IsForbidden()
end
function c46250017.sumtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and Duel.IsExistingMatchingCard(c46250017.eqfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil) and e:GetHandler():GetMaterialCount()>0 end
    Duel.SetOperationInfo(0,CATEGORY_EQUIP,nil,1,tp,LOCATION_HAND+LOCATION_GRAVE)
end
function c46250017.sumop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local n=math.min(Duel.GetLocationCount(tp,LOCATION_SZONE),c:GetMaterialCount())
    if n>0 and c:IsFaceup() and c:IsRelateToEffect(e) then
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
        local g=Duel.SelectMatchingCard(tp,c46250017.eqfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,n,nil)
        if not g then return end
        for tc in aux.Next(g) do
            if Duel.Equip(tp,tc,c,true) then
                local e1=Effect.CreateEffect(c)
                e1:SetType(EFFECT_TYPE_SINGLE)
                e1:SetProperty(EFFECT_FLAG_OWNER_RELATE)
                e1:SetCode(EFFECT_EQUIP_LIMIT)
                e1:SetReset(RESET_EVENT+RESETS_STANDARD)
                e1:SetValue(c46250017.eqlimit)
                tc:RegisterEffect(e1)
                local e2=Effect.CreateEffect(c)
                e2:SetType(EFFECT_TYPE_SINGLE)
                e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
                e2:SetCode(EFFECT_EXTRA_LINK_MATERIAL)
                e2:SetRange(LOCATION_SZONE)
                e2:SetReset(RESET_EVENT+RESETS_STANDARD)
                e2:SetValue(c46250017.matval)
                tc:RegisterEffect(e2)
            end
        end
    end
end
function c46250017.eqlimit(e,c)
    return e:GetOwner()==c
end
function c46250017.matval(e,c,mg)
    return c:IsRace(RACE_WYRM)
end
function c46250017.atkval(e,c)
    return Group.GetSum(c:GetEquipGroup():Filter(Card.IsSetCard,nil,0x1fc0),Card.GetTextAttack)
end
function c46250017.spcon(e,tp,eg,ep,ev,re,r,rp)
    local eg=e:GetHandler():GetEquipGroup()
    return eg and eg:IsExists(Card.IsSetCard,1,nil,0x1fc0) and Duel.IsExistingMatchingCard(Card.IsSummonable,tp,LOCATION_HAND,0,1,nil,true,nil)
end
function c46250017.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    if chk==0 then return c:IsReleasable() end
    local g=c:GetEquipGroup()
    g:KeepAlive()
    e:SetLabelObject(g)
    Duel.Release(c,REASON_COST)
end
function c46250017.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
end
function c46250017.spop(e,tp,eg,ep,ev,re,r,rp)
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
function c46250017.eqfilter2(c)
    return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x1fc0) and not c:IsForbidden() and c:IsFaceup()
end
function c46250017.sptg2(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and Duel.IsExistingMatchingCard(c46250017.eqfilter2,tp,LOCATION_REMOVED,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_EQUIP,nil,1,tp,LOCATION_REMOVED)
end
function c46250017.spop2(e,tp,eg,ep,ev,re,r,rp)
    if Duel.GetLocationCount(tp,LOCATION_SZONE)<1 then return end
    local c=e:GetHandler()
    if c:IsFaceup() and c:IsRelateToEffect(e) then
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
        local g=Duel.SelectMatchingCard(tp,c46250017.eqfilter2,tp,LOCATION_REMOVED,0,1,1,nil)
        if not g then return end
        local tc=g:GetFirst()
        if not Duel.Equip(tp,tc,c,true) then return end
        local e1=Effect.CreateEffect(c)
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetProperty(EFFECT_FLAG_OWNER_RELATE)
        e1:SetCode(EFFECT_EQUIP_LIMIT)
        e1:SetReset(RESET_EVENT+RESETS_STANDARD)
        e1:SetValue(c46250017.eqlimit)
        tc:RegisterEffect(e1)
    end
end
function c46250017.tsptg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDestructable,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) and e:GetHandler():GetEquipGroup():IsExists(Card.IsAbleToDeck,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,1,0,0)
end
function c46250017.tspop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local tg=c:GetEquipGroup()
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
    local g=Duel.SelectMatchingCard(tp,Card.IsDestructable,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,tg:GetCount(),nil)
    if not g then return end
    if Duel.Destroy(g,REASON_EFFECT)>0 then
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
        local sg=tg:FilterSelect(tp,Card.IsAbleToDeck,1,1,nil)
        if not sg then return end
        Duel.SendtoDeck(sg,nil,2,REASON_EFFECT)
    end
end

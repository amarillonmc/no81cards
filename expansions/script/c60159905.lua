--麒麟的化身 朔
function c60159905.initial_effect(c)
    c:EnableReviveLimit()
    --special summon condition
    local e11=Effect.CreateEffect(c)
    e11:SetType(EFFECT_TYPE_SINGLE)
    e11:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
    e11:SetCode(EFFECT_SPSUMMON_CONDITION)
    c:RegisterEffect(e11)
    --special summon
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(60159905,0))
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetCode(EFFECT_SPSUMMON_PROC)
    e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
    e1:SetRange(LOCATION_HAND)
    e1:SetCondition(c60159905.spcon)
    e1:SetOperation(c60159905.spop)
    c:RegisterEffect(e1)
    --remove
    local e2=Effect.CreateEffect(c)
    e2:SetCategory(CATEGORY_REMOVE)
    e2:SetType(EFFECT_TYPE_TRIGGER_F+EFFECT_TYPE_SINGLE)
    e2:SetCode(EVENT_SPSUMMON_SUCCESS)
    e2:SetTarget(c60159905.tg)
    e2:SetOperation(c60159905.op)
    c:RegisterEffect(e2)
    --Activate
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(60159905,1))
    e3:SetCategory(CATEGORY_TOGRAVE)
    e3:SetType(EFFECT_TYPE_IGNITION)
    e3:SetRange(LOCATION_MZONE)
    e3:SetCountLimit(1)
    e3:SetTarget(c60159905.tar)
    e3:SetOperation(c60159905.activate)
    c:RegisterEffect(e3)
    --ti
    local e4=Effect.CreateEffect(c)
    e4:SetCategory(CATEGORY_TOHAND)
    e4:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
    e4:SetCode(EVENT_LEAVE_FIELD)
    e4:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
    e4:SetTarget(c60159905.tg2)
    e4:SetOperation(c60159905.op2)
    c:RegisterEffect(e4)
end
function c60159905.spfilter(c,att)
    return c:IsAttribute(att) and c:IsAbleToRemoveAsCost()
end
function c60159905.spcon(e,c)
    if c==nil then return true end
    local tp=c:GetControler()
    return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and Duel.IsExistingMatchingCard(c60159905.spfilter,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,nil,ATTRIBUTE_EARTH)
        and Duel.IsExistingMatchingCard(c60159905.spfilter,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,nil,ATTRIBUTE_WATER)
        and Duel.IsExistingMatchingCard(c60159905.spfilter,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,nil,ATTRIBUTE_FIRE)
        and Duel.IsExistingMatchingCard(c60159905.spfilter,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,nil,ATTRIBUTE_WIND)
end
function c60159905.spop(e,tp,eg,ep,ev,re,r,rp,c)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
    local g1=Duel.SelectMatchingCard(tp,c60159905.spfilter,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,1,nil,ATTRIBUTE_EARTH)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
    local g2=Duel.SelectMatchingCard(tp,c60159905.spfilter,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,1,nil,ATTRIBUTE_WATER)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
    local g3=Duel.SelectMatchingCard(tp,c60159905.spfilter,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,1,nil,ATTRIBUTE_FIRE)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
    local g4=Duel.SelectMatchingCard(tp,c60159905.spfilter,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,1,nil,ATTRIBUTE_WIND)
    g1:Merge(g2)
    g1:Merge(g3)
    g1:Merge(g4)
    Duel.Remove(g1,POS_FACEUP,REASON_COST)
end
function c60159905.filter(c)
    return c:IsAbleToDeck() and (c:IsLocation(LOCATION_REMOVED) or c:IsFaceup())
end
function c60159905.tg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    local g=Duel.GetMatchingGroup(c60159905.filter,tp,LOCATION_REMOVED+LOCATION_EXTRA,LOCATION_REMOVED+LOCATION_EXTRA,e:GetHandler())
    Duel.SetOperationInfo(0,CATEGORY_TODECK,g,g:GetCount(),0,0)
    Duel.SetChainLimit(aux.FALSE)
end
function c60159905.op(e,tp,eg,ep,ev,re,r,rp)
    local g=Duel.GetMatchingGroup(c60159905.filter,tp,LOCATION_REMOVED+LOCATION_EXTRA,LOCATION_REMOVED+LOCATION_EXTRA,e:GetHandler())
    Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
end
function c60159905.tgfilter(c)
    return c:IsType(TYPE_MONSTER) and c:IsAbleToGrave()
end
function c60159905.tar(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c60159905.tgfilter,tp,LOCATION_DECK,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function c60159905.filter2(c)
    return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsDestructable()
end
function c60159905.filter3(c)
    return c:IsType(TYPE_MONSTER) and c:IsDestructable()
end
function c60159905.activate(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
    local g=Duel.SelectMatchingCard(tp,c60159905.tgfilter,tp,LOCATION_DECK,0,1,1,nil)
    if g:GetCount()>0 then
        if Duel.SendtoGrave(g,REASON_EFFECT) then
            local tc=g:GetFirst()
            if tc:IsAttribute(ATTRIBUTE_EARTH) then
                Duel.ShuffleDeck(tp)
                Duel.Draw(tp,1,REASON_EFFECT)
            end
            if tc:IsAttribute(ATTRIBUTE_WATER) then
                Duel.ShuffleDeck(tp)
                Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
                local g1=Duel.SelectMatchingCard(tp,c60159905.filter2,tp,0,LOCATION_ONFIELD,1,2,nil)
                if g1:GetCount()>0 then
                    Duel.HintSelection(g1)
                    Duel.Destroy(g1,REASON_EFFECT)
                end
            end
            if tc:IsAttribute(ATTRIBUTE_FIRE) then
                Duel.ShuffleDeck(tp)
                Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
                local g=Duel.SelectMatchingCard(tp,c60159905.filter3,tp,0,LOCATION_ONFIELD,1,1,nil)
                if g:GetCount()>0 then
                    Duel.HintSelection(g)
                    Duel.Destroy(g,REASON_EFFECT)
                end
            end
            if tc:IsAttribute(ATTRIBUTE_WIND) then
                Duel.ShuffleDeck(tp)
                --attack all
                local e4=Effect.CreateEffect(e:GetHandler())
                e4:SetDescription(aux.Stringid(60159905,2))
                e4:SetType(EFFECT_TYPE_SINGLE)
                e4:SetProperty(EFFECT_FLAG_CLIENT_HINT)
                e4:SetCode(EFFECT_ATTACK_ALL)
                e4:SetValue(1)
                e4:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
                e:GetHandler():RegisterEffect(e4)
            end
        end
    end
end
function c60159905.filter4(c)
    return c:IsType(TYPE_MONSTER) and (c:IsAttribute(ATTRIBUTE_EARTH) or c:IsAttribute(ATTRIBUTE_WATER) 
        or c:IsAttribute(ATTRIBUTE_FIRE) or c:IsAttribute(ATTRIBUTE_WIND) or c:IsAttribute(ATTRIBUTE_DARK) or c:IsAttribute(ATTRIBUTE_LIGHT)) and c:IsAbleToHand()
end
function c60159905.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c60159905.filter4,tp,LOCATION_GRAVE,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE)
end
function c60159905.op2(e,tp,eg,ep,ev,re,r,rp)
    local g=Duel.GetMatchingGroup(c60159905.filter4,tp,LOCATION_GRAVE,0,nil)
    if g:GetCount()==0 then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g1=g:Select(tp,1,1,nil)
    local t={ATTRIBUTE_EARTH,ATTRIBUTE_WATER,ATTRIBUTE_FIRE,ATTRIBUTE_WIND,ATTRIBUTE_LIGHT,ATTRIBUTE_DARK,ATTRIBUTE_DEVINE}
    for i=1,7 do
        if g1:GetFirst():IsAttribute(t[i]) then g:Remove(Card.IsAttribute,nil,t[i]) end
    end
    if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(60159905,0)) then
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
        local g2=g:Select(tp,1,1,nil)
        g1:Merge(g2)
    end
    Duel.SendtoHand(g1,nil,REASON_EFFECT)
    Duel.ConfirmCards(1-tp,g1)
end
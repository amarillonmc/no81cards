--影霊衣の巫女 エリアル
function c115682705.initial_effect(c)
    --level change
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(115682705,0))
    e1:SetType(EFFECT_TYPE_IGNITION)
    e1:SetRange(LOCATION_MZONE)
    e1:SetCountLimit(1)
    e1:SetCost(c115682705.lvcost)
    e1:SetOperation(c115682705.lvop)
    c:RegisterEffect(e1)
    --tohand
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(115682705,1))
    e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
    e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
    e2:SetCode(EVENT_RELEASE)
    e2:SetCountLimit(1,115682705)
    e2:SetCondition(c115682705.thcon)
    e2:SetTarget(c115682705.thtg)
    e2:SetOperation(c115682705.thop)
    c:RegisterEffect(e2)
    --spsummon
    local e3=Effect.CreateEffect(c)
    e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e3:SetType(EFFECT_TYPE_QUICK_O)
    e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e3:SetCode(EVENT_FREE_CHAIN)
    e3:SetRange(LOCATION_HAND)
    e3:SetCountLimit(1,156827051)
    e3:SetCost(c115682705.spcost)
    e3:SetTarget(c115682705.sptg)
    e3:SetOperation(c115682705.spop)
    c:RegisterEffect(e3)
end
function c115682705.cfilter(c)
    return c:IsSetCard(0xb4) and not c:IsPublic()
end
function c115682705.lvcost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c115682705.cfilter,tp,LOCATION_HAND,0,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
    local g=Duel.SelectMatchingCard(tp,c115682705.cfilter,tp,LOCATION_HAND,0,1,63,nil)
    Duel.ConfirmCards(1-tp,g)
    Duel.ShuffleHand(tp)
    e:SetLabel(g:GetCount())
end
function c115682705.lvop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if c:IsFacedown() or not c:IsRelateToEffect(e) then return end
    local ct=e:GetLabel()
    local sel=nil
    if c:GetLevel()==1 then
        sel=Duel.SelectOption(tp,aux.Stringid(115682705,2))
    else
        sel=Duel.SelectOption(tp,aux.Stringid(115682705,2),aux.Stringid(115682705,3))
    end
    if sel==1 then
        ct=ct*-1
    end
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetCode(EFFECT_UPDATE_LEVEL)
    e1:SetValue(ct)
    e1:SetReset(RESET_EVENT+0x1ff0000+RESET_PHASE+PHASE_END)
    c:RegisterEffect(e1)
end
function c115682705.thcon(e,tp,eg,ep,ev,re,r,rp)
    return bit.band(r,REASON_EFFECT)~=0
end
function c115682705.filter(c)
    return c:IsSetCard(0xb4) and c:IsType(TYPE_MONSTER) and not c:IsType(TYPE_RITUAL) and c:IsAbleToHand()
end
function c115682705.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c115682705.filter,tp,LOCATION_DECK,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c115682705.thop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g=Duel.SelectMatchingCard(tp,c115682705.filter,tp,LOCATION_DECK,0,1,1,nil)
    if g:GetCount()>0 then
        Duel.SendtoHand(g,nil,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,g)
    end
end

function c115682705.costfilter(c)
    return c:IsSetCard(0x10b4) and c:IsDiscardable()
end
function c115682705.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    if chk==0 then return c:IsDiscardable()
        and Duel.IsExistingMatchingCard(c115682705.costfilter,tp,LOCATION_HAND,0,1,c) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
    local g=Duel.SelectMatchingCard(tp,c115682705.costfilter,tp,LOCATION_HAND,0,1,1,c)
    g:AddCard(c)
    Duel.SendtoGrave(g,REASON_COST+REASON_DISCARD)
end
function c115682705.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsAbleToDeck() end
    if chk==0 then return true end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
    local g=Duel.SelectTarget(tp,Card.IsAbleToDeck,tp,LOCATION_GRAVE+LOCATION_REMOVED,LOCATION_GRAVE+LOCATION_REMOVED,1,5,nil)
    Duel.SetOperationInfo(0,CATEGORY_TODECK,g,g:GetCount(),0,0)
end
function c115682705.spop(e,tp,eg,ep,ev,re,r,rp)
    local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
    local sg=g:Filter(Card.IsRelateToEffect,nil,e)
    Duel.SendtoDeck(sg,nil,2,REASON_EFFECT)
end
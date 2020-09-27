--森罗的天树 阳精
local m=89387009
local cm=_G["c"..m]
function cm.initial_effect(c)
    c:EnableReviveLimit()
    aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkRace,RACE_PLANT),2,2)
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_DRAW+CATEGORY_DECKDES)
    e1:SetType(EFFECT_TYPE_IGNITION)
    e1:SetRange(LOCATION_MZONE)
    e1:SetCountLimit(1,m)
    e1:SetCost(cm.stcost)
    e1:SetOperation(cm.operation)
    c:RegisterEffect(e1)
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e3:SetRange(LOCATION_MZONE)
    e3:SetCode(EVENT_CHAIN_SOLVING)
    e3:SetCondition(cm.condition1)
    e3:SetOperation(cm.handes)
    c:RegisterEffect(e3)
end
function cm.cfilter(c,tp,lv)
    return c:IsRace(RACE_PLANT) and c:IsLevelBelow(lv) and (c:IsLocation(LOCATION_HAND) or c:IsFaceup()) and c:IsAbleToGraveAsCost() and Duel.IsPlayerCanDiscardDeck(tp,lv)
end
function cm.stcost(e,tp,eg,ep,ev,re,r,rp,chk)
    local ct=Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)
    if chk==0 then return Duel.IsExistingMatchingCard(cm.cfilter,tp,LOCATION_MZONE+LOCATION_HAND,0,1,nil,tp,ct) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
    local g=Duel.SelectMatchingCard(tp,cm.cfilter,tp,LOCATION_MZONE+LOCATION_HAND,0,1,1,nil,tp,ct)
    Duel.SendtoGrave(g,REASON_COST)
    e:SetLabel(Duel.GetOperatedGroup():GetFirst():GetLevel())
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
    local lv=e:GetLabel()
    local c=e:GetHandler()
    if not Duel.IsPlayerCanDiscardDeck(tp,lv) then return end
    Duel.ConfirmDecktop(tp,lv)
    local g=Duel.GetDecktopGroup(tp,lv)
    local sg=g:Filter(Card.IsRace,nil,RACE_PLANT)
    Duel.DisableShuffleCheck()
    local flag=Duel.SendtoGrave(sg,REASON_EFFECT+REASON_REVEAL)>=3
    lv=lv-sg:GetCount()
    if lv>0 then
        Duel.SortDecktop(tp,tp,lv)
        for i=1,lv do
            local mg=Duel.GetDecktopGroup(tp,1)
            Duel.MoveSequence(mg:GetFirst(),1)
        end
    end
    if flag and Duel.IsPlayerCanDraw(tp,1) and Duel.SelectYesNo(tp,aux.Stringid(m,0)) then
        Duel.Draw(tp,1,REASON_EFFECT)
    end
end
function cm.condition1(e,tp,eg,ep,ev,re,r,rp)
    local rc=re:GetHandler()
    return rc:IsSetCard(0x90) and rc:IsType(TYPE_MONSTER) and rc~=e:GetHandler()
end
function cm.desfilter(c)
    return c:IsSetCard(0x90) and c:IsType(TYPE_MONSTER) and c:IsAbleToDeck()
end
function cm.handes(e,tp,eg,ep,ev,re,r,rp)
    if Duel.GetFlagEffect(tp,m)>0 then return end
    local sg=Duel.GetMatchingGroup(cm.desfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,nil)
    if not sg or sg:GetCount()==0 then return end
    if Duel.SelectYesNo(tp,aux.Stringid(m,1)) then
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
        local g=sg:Select(tp,1,2,nil)
        Duel.ShuffleDeck(tp)
        for tc in aux.Next(g) do
            if not tc:IsLocation(LOCATION_DECK) then
                Duel.SendtoDeck(tc,nil,0,REASON_EFFECT)
            else
                Duel.MoveSequence(tc,0)
            end
        end
        Duel.SortDecktop(tp,tp,g:GetCount())
        Duel.ConfirmCards(1-tp,g)
        Duel.RegisterFlagEffect(tp,m,RESET_PHASE+PHASE_END,0,1)
    end
end

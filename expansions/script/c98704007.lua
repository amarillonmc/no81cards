--真帝机 残酷
if not pcall(function() require("expansions/script/c98704001") end) then require("script/c98704001") end
local m=98704007
local cm=_G["c"..m]
cm.mqt=true
function cm.initial_effect(c)
    mqt.SummonWithNoTributeEffect(c)
    mqt.SummonWithDoubledTributeEffect(c)
    mqt.SummonWithExtraTributeEffect(c)
    mqt.SummonWithThreeTributeEffect(c)
    mqt.ChangeLevelEffect(c)
    mqt.ResistanceEffect(c)
    mqt.SummonSuccessEffect(c,CATEGORY_REMOVE+CATEGORY_TODECK+CATEGORY_DAMAGE+CATEGORY_RECOVER+CATEGORY_DECKDES+CATEGORY_TOGRAVE,cm.op)
end
function cm.filter(c)
    return mqt.ismqt(c) and c:IsAbleToGrave()
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
    local g=Duel.GetMatchingGroup(cm.filter,tp,LOCATION_HAND+LOCATION_DECK,0,nil)
    if g:GetClassCount(Card.GetCode)<2 then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
    local tg=g:SelectSubGroup(tp,aux.dncheck,false,2,2)
    Duel.SendtoGrave(tg,REASON_EFFECT)
    if e:GetLabel()==0 then return end
    local rg=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0,LOCATION_GRAVE,niltp,POS_FACEDOWN)
    if rg:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(m,0)) then
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
        local rmg=rg:Select(tp,1,5,nil)
        local dam=Duel.Remove(rmg,POS_FACEDOWN,REASON_EFFECT)
        Duel.Damage(1-tp,dam*300,REASON_EFFECT)
        if Duel.GetLP(1-tp)==0 then return end
    end
    local dg=Duel.GetMatchingGroup(Card.IsAbleToDeck,tp,LOCATION_REMOVED,0,nil)
    if dg:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(m,1)) then
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
        local tdg=dg:Select(tp,1,5,nil)
        local rec=Duel.SendtoDeck(tdg,nil,2,REASON_EFFECT)
        Duel.Recover(tp,rec*300,REASON_EFFECT)
    end
end

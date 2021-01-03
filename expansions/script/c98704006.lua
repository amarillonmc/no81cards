--真帝机 烈风
if not pcall(function() require("expansions/script/c98704001") end) then require("script/c98704001") end
local m=98704006
local cm=_G["c"..m]
cm.mqt=true
function cm.initial_effect(c)
    mqt.SummonWithNoTributeEffect(c)
    mqt.SummonWithDoubledTributeEffect(c)
    mqt.SummonWithExtraTributeEffect(c)
    mqt.SummonWithThreeTributeEffect(c)
    mqt.ChangeLevelEffect(c)
    mqt.ResistanceEffect(c)
    mqt.SummonSuccessEffect(c,CATEGORY_DECKDES+CATEGORY_TOGRAVE+CATEGORY_TODECK,cm.op)
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
    if e:GetLabel()==1 then
        local og=Duel.GetMatchingGroup(aux.NOT(Card.IsPublic),tp,0,LOCATION_HAND+LOCATION_ONFIELD,nil)
        if og:GetCount()>0 then
            Duel.ConfirmCards(tp,og)
        end
        local sg=Duel.GetMatchingGroup(Card.IsAbleToDeck,tp,0,LOCATION_HAND+LOCATION_ONFIELD,nil)
        if sg:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(m,0)) then
            Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
            local dc=sg:Select(tp,1,1,nil):GetFirst()
            if dc:IsType(TYPE_TOKEN+TYPE_LINK+TYPE_XYZ+TYPE_SYNCHRO+TYPE_FUSION) then
                Duel.SendtoDeck(dc,nil,2,REASON_EFFECT)
            else
                local op=Duel.SelectOption(tp,aux.Stringid(m,1),aux.Stringid(m,2))
                Duel.SendtoDeck(dc,nil,op,REASON_EFFECT)
            end
        end
        Duel.ShuffleHand(1-tp)
    end
end

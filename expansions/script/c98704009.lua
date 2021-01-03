--真帝机 怨邪
if not pcall(function() require("expansions/script/c98704001") end) then require("script/c98704001") end
local m=98704009
local cm=_G["c"..m]
cm.mqt=true
function cm.initial_effect(c)
    mqt.SummonWithNoTributeEffect(c)
    mqt.SummonWithDoubledTributeEffect(c)
    mqt.SummonWithExtraTributeEffect(c)
    mqt.SummonWithThreeTributeEffect(c)
    mqt.ChangeLevelEffect(c)
    mqt.ResistanceEffect(c)
    mqt.SummonSuccessEffect(c,CATEGORY_REMOVE+CATEGORY_DECKDES+CATEGORY_TOGRAVE,cm.op)
end
function cm.filter(c)
    return mqt.ismqt(c) and c:IsAbleToGrave()
end
function cm.rmfilter(c,code)
    return c:GetOriginalCode()==code and c:IsAbleToRemove()
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
    local g=Duel.GetMatchingGroup(cm.filter,tp,LOCATION_HAND+LOCATION_DECK,0,nil)
    if g:GetClassCount(Card.GetCode)<2 then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
    local tg=g:SelectSubGroup(tp,aux.dncheck,false,2,2)
    Duel.SendtoGrave(tg,REASON_EFFECT)
    if e:GetLabel()==0 then return end
    local rg=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD+LOCATION_GRAVE,nil)
    if rg:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(m,0)) then
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
        local rmg=rg:Select(tp,1,1,nil)
        local rmc=rmg:GetFirst()
        if rmc:IsFacedown() then
            Duel.ConfirmCards(tp,rmc)
        else
            Duel.HintSelection(rmg)
        end
        local ag=Duel.GetMatchingGroup(cm.rmfilter,1-tp,LOCATION_DECK+LOCATION_HAND+LOCATION_EXTRA+LOCATION_GRAVE+LOCATION_ONFIELD,0,rmc,rmc:GetOriginalCode())
        rmg:Merge(ag)
        Duel.Remove(rmg,POS_FACEUP,REASON_EFFECT)
    end
end

--真帝机 冰帝
if not pcall(function() require("expansions/script/c98704001") end) then require("script/c98704001") end
local m=98704015
local cm=_G["c"..m]
cm.mqt=true
function cm.initial_effect(c)
    mqt.SummonWithNoTributeEffect(c)
    mqt.SummonWithDoubledTributeEffect(c)
    mqt.SummonWithExtraTributeEffect(c)
    mqt.SummonWithThreeTributeEffect(c)
    mqt.ChangeLevelEffect(c)
    mqt.ResistanceEffect(c)
    mqt.SummonSuccessEffect(c,CATEGORY_DECKDES+CATEGORY_TOGRAVE+CATEGORY_SEARCH+CATEGORY_DESTROY+CATEGORY_REMOVE,cm.op)
end
function cm.filter(c)
    return mqt.ismqt(c) and c:IsAbleToGrave()
end
function cm.thfilter(c)
    return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToHand()
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
    local g=Duel.GetMatchingGroup(cm.filter,tp,LOCATION_HAND+LOCATION_DECK,0,nil)
    if g:GetClassCount(Card.GetCode)<2 then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
    local tg=g:SelectSubGroup(tp,aux.dncheck,false,2,2)
    Duel.SendtoGrave(tg,REASON_EFFECT)
    if e:GetLabel()==0 then return end
    local op=0
    local off=1
    local ops={}
    local opval={}
    local g1=Duel.GetMatchingGroup(Card.IsType,tp,0,LOCATION_ONFIELD,nil,TYPE_SPELL+TYPE_TRAP)
    local g2=Duel.GetMatchingGroup(cm.thfilter,tp,LOCATION_DECK,0,nil)
    if g1:GetCount()>0 then
        ops[off]=aux.Stringid(m,1)
        opval[off]=1
        off=off+1
    end
    if g2:GetCount()>0 then
        ops[off]=aux.Stringid(m,2)
        opval[off]=2
        off=off+1
    end
    if off>1 then
        op=Duel.SelectOption(tp,aux.Stringid(m,0),table.unpack(ops))
        if opval[op]==1 then
            Duel.Destroy(g1,REASON_EFFECT,LOCATION_REMOVED)
        elseif opval[op]==2 then
            Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
            local sg=g2:Select(tp,1,1,nil)
            Duel.SendtoHand(sg,nil,REASON_EFFECT)
            Duel.ConfirmCards(1-tp,sg)
        end
    end
end

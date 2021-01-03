--真帝机 轰雷
if not pcall(function() require("expansions/script/c98704001") end) then require("script/c98704001") end
local m=98704010
local cm=_G["c"..m]
cm.mqt=true
function cm.initial_effect(c)
    mqt.SummonWithNoTributeEffect(c)
    mqt.SummonWithDoubledTributeEffect(c)
    mqt.SummonWithExtraTributeEffect(c)
    mqt.SummonWithThreeTributeEffect(c)
    mqt.ChangeLevelEffect(c)
    mqt.ResistanceEffect(c)
    mqt.SummonSuccessEffect(c,CATEGORY_DECKDES+CATEGORY_TOGRAVE,cm.op)
end
function cm.filter(c)
    return mqt.ismqt(c) and c:IsAbleToGrave()
end
function cm.conffilter(c)
    return not c:IsPublic()
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
    local g=Duel.GetMatchingGroup(cm.filter,tp,LOCATION_HAND+LOCATION_DECK,0,nil)
    if g:GetClassCount(Card.GetCode)<2 then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
    local tg=g:SelectSubGroup(tp,aux.dncheck,false,2,2)
    Duel.SendtoGrave(tg,REASON_EFFECT)
    if e:GetLabel()==0 then return end
    local op,off,ops,opval=0,1,{},{}
    if Duel.GetFieldGroupCount(tp,LOCATION_EXTRA,LOCATION_EXTRA)>0 then
        ops[off]=aux.Stringid(m,1)
        opval[off]=1
        off=off+1
    end
    if Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,0,LOCATION_DECK,1,nil,tp,POS_FACEDOWN) then
        ops[off]=aux.Stringid(m,2)
        opval[off]=2
        off=off+1
    end
    if off>1 then
        op=Duel.SelectOption(tp,aux.Stringid(m,0),table.unpack(ops))
        if opval[op]==1 then
            local g1,g2=Group.CreateGroup(),Group.CreateGroup()
            local og=Duel.GetFieldGroup(tp,0,LOCATION_EXTRA)
            if og:GetCount()>0 then
                if og:FilterCount(cm.conffilter,nil)>0 then
                    Duel.ConfirmCards(tp,og)
                end
                Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(m,3))
                g1=og:Select(tp,1,5,nil)
            end
            local sg=Duel.GetFieldGroup(tp,LOCATION_EXTRA,0)
            if sg:GetCount()>0 then
                Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(m,4))
                g2=sg:Select(tp,1,5,nil)
            end
            g1:Merge(g2)
            Duel.SendtoGrave(g1,REASON_EFFECT)
        elseif opval[op]==2 then
            local rg=Duel.GetDecktopGroup(1-tp,5)
            Duel.DisableShuffleCheck()
            Duel.Remove(rg,POS_FACEDOWN,REASON_EFFECT)
        end
    end
end

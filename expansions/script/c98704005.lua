--真帝机 天帝
if not pcall(function() require("expansions/script/c98704001") end) then require("script/c98704001") end
local m=98704005
local cm=_G["c"..m]
cm.mqt=true
function cm.initial_effect(c)
    mqt.SummonWithNoTributeEffect(c)
    mqt.SummonWithDoubledTributeEffect(c)
    mqt.SummonWithExtraTributeEffect(c)
    mqt.SummonWithThreeTributeEffect(c)
    mqt.ChangeLevelEffect(c)
    mqt.ResistanceEffect(c)
    mqt.SummonSuccessEffect(c,CATEGORY_DECKDES+CATEGORY_TOGRAVE+CATEGORY_SPECIAL_SUMMON,cm.op)
end
function cm.filter(c)
    return mqt.ismqt(c) and c:IsAbleToGrave()
end
function cm.spfilter1(c,e,tp)
    return c:IsLevelAbove(5) and c:IsSummonableCard() and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function cm.spfilter2(c,e,tp)
    return mqt.ismqt(c) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
    local g=Duel.GetMatchingGroup(cm.filter,tp,LOCATION_HAND+LOCATION_DECK,0,nil)
    if g:GetClassCount(Card.GetCode)<2 then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
    local tg=g:SelectSubGroup(tp,aux.dncheck,false,2,2)
    Duel.SendtoGrave(tg,REASON_EFFECT)
    if e:GetLabel()==0 then return end
    local b1=Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(cm.spfilter1,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil,e,tp)
    local b2=Duel.GetLocationCount(tp,LOCATION_MZONE)>1 and Duel.IsExistingMatchingCard(cm.spfilter2,tp,LOCATION_HAND+LOCATION_DECK,0,2,nil,e,tp)
    local op=0
    local off=1
    local ops={}
    local opval={}
    if b1 then
        ops[off]=aux.Stringid(m,1)
        opval[off]=1
        off=off+1
    end
    if b2 then
        ops[off]=aux.Stringid(m,2)
        opval[off]=2
        off=off+1
    end
    if off>1 then
        op=Duel.SelectOption(tp,aux.Stringid(m,0),table.unpack(ops))
        if opval[op]==1 then
            Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
            local tc=Duel.SelectMatchingCard(tp,cm.spfilter1,tp,LOCATION_HAND+LOCATION_DECK,0,1,1,nil,e,tp):GetFirst()
            Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
            local fid=e:GetHandler():GetFieldID()
            tc:RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD,0,1,fid)
            local e1=Effect.CreateEffect(e:GetHandler())
            e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
            e1:SetCode(EVENT_PHASE+PHASE_END)
            e1:SetCountLimit(1)
            e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
            e1:SetLabel(fid)
            e1:SetLabelObject(tc)
            e1:SetCondition(cm.thcon)
            e1:SetOperation(cm.thop)
            Duel.RegisterEffect(e1,tp)
        elseif opval[op]==2 then
            Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
            local sg=Duel.SelectMatchingCard(tp,cm.spfilter2,tp,LOCATION_HAND+LOCATION_DECK,0,2,2,nil,e,tp)
            Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
            sg:GetFirst():RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD,0,0,fid)
            sg:GetNext():RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD,0,0,fid)
            sg:KeepAlive()
            local e1=Effect.CreateEffect(e:GetHandler())
            e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
            e1:SetCode(EVENT_PHASE+PHASE_END)
            e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
            e1:SetCountLimit(1)
            e1:SetLabel(fid)
            e1:SetLabelObject(sg)
            e1:SetCondition(cm.descon)
            e1:SetOperation(cm.desop)
            Duel.RegisterEffect(e1,tp)
        end
    end
end
function cm.desfilter(c,fid)
    return c:GetFlagEffectLabel(m)==fid
end
function cm.descon(e,tp,eg,ep,ev,re,r,rp)
    local g=e:GetLabelObject()
    if not g:IsExists(cm.desfilter,1,nil,e:GetLabel()) then
        g:DeleteGroup()
        e:Reset()
        return false
    else return true end
end
function cm.desop(e,tp,eg,ep,ev,re,r,rp)
    local g=e:GetLabelObject()
    local tg=g:Filter(cm.desfilter,nil,e:GetLabel())
    Duel.Destroy(tg,REASON_EFFECT)
end
function cm.thcon(e,tp,eg,ep,ev,re,r,rp)
    local tc=e:GetLabelObject()
    if tc:GetFlagEffectLabel(m)~=e:GetLabel() then
        e:Reset()
        return false
    else return true end
end
function cm.thop(e,tp,eg,ep,ev,re,r,rp)
    Duel.SendtoHand(e:GetLabelObject(),nil,REASON_EFFECT)
end

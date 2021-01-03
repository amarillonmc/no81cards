--真帝机 地帝
if not pcall(function() require("expansions/script/c98704001") end) then require("script/c98704001") end
local m=98704008
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
function cm.desfilter(c,tp,df)
    local seq=2^c:GetSequence()
    if c:IsLocation(LOCATION_SZONE+LOCATION_FZONE) then
        seq=seq*0x100
    end
    if c:IsControler(1-tp) then
        seq=seq*0x10000
    end
    return seq&df~=0
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
    local g=Duel.GetMatchingGroup(cm.filter,tp,LOCATION_HAND+LOCATION_DECK,0,nil)
    if g:GetClassCount(Card.GetCode)<2 then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
    local tg=g:SelectSubGroup(tp,aux.dncheck,false,2,2)
    Duel.SendtoGrave(tg,REASON_EFFECT)
    if e:GetLabel()==0 then return end
    local df,dg=0,Group.CreateGroup()
    for i=1,2 do
        local op,off,ops,opval=0,1,{},{}
        if Duel.GetLocationCount(tp,LOCATION_MZONE,tp,0x1,0x1f7f-df)>0 or Duel.GetLocationCount(tp,LOCATION_SZONE,tp,0x1,0x1f7f-df)>0
            or Duel.GetLocationCount(1-tp,LOCATION_MZONE,1-tp,0x1,0x1f7f0000-df)>0 or Duel.GetLocationCount(1-tp,LOCATION_SZONE,1-tp,0x1,0x1f7f0000-df)>0
            or Duel.GetLocationCountFromEx(tp,tp,nil,nil,0x1f7f-df)>0 or Duel.GetLocationCountFromEx(1-tp,1-tp,nil,nil,0x1f7f0000-df)>0 then
            ops[off]=aux.Stringid(m,1)
            opval[off]=1
            off=off+1
        end
        if Duel.IsExistingMatchingCard(Card.IsAbleToGrave,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,dg) then
            ops[off]=aux.Stringid(m,2)
            opval[off]=2
            off=off+1
        end
        if off>1 then
            op=Duel.SelectOption(tp,aux.Stringid(m,0),table.unpack(ops))
            if opval[op]==0 then return end
            if opval[op]==1 then
                df=df|Duel.SelectDisableField(tp,1,LOCATION_ONFIELD,LOCATION_ONFIELD,df|0x20002000)
            else
                local dc=Duel.SelectMatchingCard(tp,Card.IsAbleToGrave,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,dg):GetFirst()
                dg:AddCard(dc)
                if not dc:IsLocation(LOCATION_FZONE) then
                    local seq=2^dc:GetSequence()
                    if dc:IsLocation(LOCATION_SZONE) then seq=seq*0x100 end
                    if dc:IsControler(1-tp) then seq=seq*0x10000 end
                    df=df|seq
                end
            end
        end
    end
    if dg:GetCount()>0 then
        Duel.HintSelection(dg)
        Duel.SendtoGrave(dg,REASON_EFFECT)
    end
    if df>0 then
        Duel.Hint(HINT_ZONE,tp,df)
        local e1=Effect.CreateEffect(e:GetHandler())
        e1:SetType(EFFECT_TYPE_FIELD)
        e1:SetCode(EFFECT_DISABLE_FIELD)
        e1:SetLabel(df)
        e1:SetCondition(cm.discon)
        e1:SetOperation(cm.disop)
        e1:SetReset(0)
        Duel.RegisterEffect(e1,tp)
    end
end
function cm.discon(e)
    if Duel.IsExistingMatchingCard(Card.IsSummonType,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil,SUMMON_TYPE_ADVANCE) then return true end
    e:Reset()
    return false
end
function cm.disop(e,tp)
    return e:GetLabel()
end

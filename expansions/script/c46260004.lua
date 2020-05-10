--从两仪中诞生的五行星
function c46260004.initial_effect(c)
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_RELEASE)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetCountLimit(1,46260004)
    e1:SetOperation(c46260004.activate)
    c:RegisterEffect(e1)
end
function c46260004.activate(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e1:SetCode(EVENT_SPSUMMON_SUCCESS)
    e1:SetOperation(c46260004.regop1)
    e1:SetReset(RESET_PHASE+PHASE_END)
    Duel.RegisterEffect(e1,tp)
    local g=Group.CreateGroup()
    g:KeepAlive()
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e3:SetCode(EVENT_PHASE+PHASE_END)
    e3:SetCountLimit(1)
    e3:SetOperation(c46260004.effop)
    e3:SetReset(RESET_PHASE+PHASE_END)
    e3:SetLabelObject(g)
    Duel.RegisterEffect(e3,tp)
    e1:SetLabelObject(e3)
end
function c46260004.regfilter(c)
    return c:IsSummonType(SUMMON_TYPE_RITUAL)
end
function c46260004.regop1(e,tp,eg,ep,ev,re,r,rp)
    e:GetLabelObject():GetLabelObject():Merge(eg:Filter(Card.IsSummonType,nil,SUMMON_TYPE_RITUAL))
end
function c46260004.filter(c,e,tp,mg)
    if bit.band(c:GetType(),0x81)~=0x81 or not c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,false,true) then return false end
    local mg1=mg:Clone()
    mg1:RemoveCard(c)
    return mg1:CheckWithSumEqual(Card.GetRitualLevel,c:GetLevel(),1,e:GetLabel(),c)
end
function c46260004.mfilter(c,e)
    return c:GetLevel()>0 and c:IsReleasableByEffect()
end
function c46260004.effop(e,tp,eg,ep,ev,re,r,rp)
    local n=e:GetLabelObject():GetClassCount(Card.GetAttribute)
    Duel.Hint(HINT_CARD,0,46260004)
    if n<=0 or Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
    local mg=Duel.GetMatchingGroup(c46260004.mfilter,tp,LOCATION_DECK,0,nil)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local tg=Duel.SelectMatchingCard(tp,c46260004.filter,tp,LOCATION_DECK+LOCATION_HAND,0,1,1,nil,e,tp,mg)
    local tc=tg:GetFirst()
    if tc then
        mg:RemoveCard(tc)
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
        local mat=mg:SelectWithSumEqual(tp,Card.GetRitualLevel,tc:GetLevel(),1,n,tc)
        tc:SetMaterial(mat)
        Duel.SendtoGrave(mat,REASON_RELEASE+REASON_EFFECT+REASON_RITUAL)
        Duel.BreakEffect()
        Duel.SpecialSummon(tc,SUMMON_TYPE_RITUAL,tp,tp,false,true,POS_FACEUP)
        tc:CompleteProcedure()
    end
end

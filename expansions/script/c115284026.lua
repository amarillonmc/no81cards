--堕天使的御布施
local m=115284026
local cm=_G["c"..m]
function cm.initial_effect(c)
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_HANDES+CATEGORY_DRAW)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetCountLimit(1,m+EFFECT_COUNT_CODE_OATH)
    e1:SetTarget(cm.sptg)
    e1:SetOperation(cm.spop)
    c:RegisterEffect(e1)
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then
        local g=Duel.GetMatchingGroup(Card.IsDiscardable,tp,LOCATION_HAND,0,nil,REASON_EFFECT)
        return g:GetCount()>=2 and g:FilterCount(Card.IsSetCard,nil,0xef)>0 and Duel.IsPlayerCanDraw(tp,3)
    end
    Duel.SetOperationInfo(0,CATEGORY_HANDES,nil,0,tp,2)
    Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,3)
end
function cm.filter(c,e,tp)
    return c:IsSetCard(0xef) and c:IsType(TYPE_MONSTER) and c:IsCanBeSpecialSummoned(e,0,tp,true,false)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
    local g=Duel.GetMatchingGroup(Card.IsDiscardable,tp,LOCATION_HAND,0,nil,REASON_EFFECT)
    if g:GetCount()<2 or g:FilterCount(Card.IsSetCard,nil,0xef)==0 or not Duel.IsPlayerCanDraw(tp,3) then return end
    Duel.Hint(HINT_SELECTMSG,p,HINTMSG_DISCARD)
    local sg1=g:FilterSelect(tp,Card.IsSetCard,1,1,nil,0xef)
    Duel.Hint(HINT_SELECTMSG,p,HINTMSG_DISCARD)
    local sg2=g:Select(tp,1,1,sg1)
    sg1:Merge(sg2)
    Duel.SendtoGrave(sg1,REASON_EFFECT+REASON_DISCARD)
    Duel.Draw(tp,3,REASON_EFFECT)
    local n=sg1:FilterCount(Card.IsSetCard,nil,0xef)
    if n==1 then
        Duel.BreakEffect()
        Duel.Recover(tp,500,REASON_EFFECT)
    end
    if n==2 and Duel.GetMZoneCount(tp)>0 then
        Duel.Hint(HINT_SELECTMSG,p,HINTMSG_SPSUMMON)
        local sg=Duel.SelectMatchingCard(tp,cm.filter,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,e,tp)
        if sg and sg:GetCount()>0 then
            Duel.BreakEffect()
            Duel.SpecialSummon(sg,0,tp,tp,true,false,POS_FACEUP)
        else
            Duel.ConfirmCards(tp,Duel.GetFieldGroup(tp,0,LOCATION_DECK+LOCATION_HAND))
        end
    end
end

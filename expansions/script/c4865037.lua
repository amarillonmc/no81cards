--缝合僵尸 电话
local m=4865037
local cm=_G["c"..m]
function cm.initial_effect(c)
    --speical summon
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(m,0))
    e1:SetCategory(CATEGORY_DICE+CATEGORY_SPECIAL_SUMMON+CATEGORY_RECOVER+CATEGORY_GRAVE_SPSUMMON)
    e1:SetType(EFFECT_TYPE_IGNITION)
    e1:SetRange(LOCATION_MZONE)
    e1:SetCountLimit(1)
    e1:SetCondition(cm.cona)
    e1:SetTarget(cm.tga)
    e1:SetOperation(cm.opa)
    c:RegisterEffect(e1)
    --to grave
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(m,2))
    e2:SetCategory(CATEGORY_DICE+CATEGORY_TOGRAVE+CATEGORY_DECKDES)
    e2:SetType(EFFECT_TYPE_IGNITION)
    e2:SetRange(LOCATION_MZONE)
    e2:SetCountLimit(1)
    e2:SetCondition(cm.cond)
    e2:SetTarget(cm.tgd)
    e2:SetOperation(cm.opd)
    c:RegisterEffect(e2)
end
cm.toss_dice=true
function cm.cona(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():IsAttackPos()
end
function cm.tga(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    Duel.SetOperationInfo(0,CATEGORY_DICE,nil,0,tp,1)
    Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,0)
end
function cm.spfilter(c,e,tp,dc)
    return c:IsSetCard(0x332b) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsLevelBelow(dc)
end
function cm.opa(e,tp,eg,ep,ev,re,r,rp)
    local dc=Duel.TossDice(tp,1)
    local rec=dc*100
    local g=Duel.GetMatchingGroup(aux.NecroValleyFilter(cm.spfilter),tp,LOCATION_GRAVE,0,nil,e,tp,dc)
    if Duel.Recover(tp,rec,REASON_EFFECT)>0 and g:GetCount()>0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and Duel.SelectYesNo(tp,aux.Stringid(m,1)) then
        Duel.BreakEffect()
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
        local tc=g:Select(tp,1,1,nil):GetFirst()
        Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
    end
end
function cm.cond(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():IsDefensePos()
end
function cm.tgd(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>0 end
    Duel.SetOperationInfo(0,CATEGORY_DICE,nil,0,tp,1)
end
function cm.tgfilter(c)
    return c:IsSetCard(0x332b) and c:IsAbleToGrave()
end
function cm.opd(e,tp,eg,ep,ev,re,r,rp)
    if Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)==0 then return end
    local dc=Duel.TossDice(tp,1)
    Duel.ConfirmDecktop(tp,dc)
    local dg=Duel.GetDecktopGroup(tp,dc)
    local ct=dg:GetCount()
    local g=dg:Filter(cm.tgfilter,nil)
    if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(m,3)) then
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
        local sg=g:Select(tp,1,1,nil)
        Duel.DisableShuffleCheck()
        Duel.SendtoGrave(sg,REASON_EFFECT+REASON_REVEAL)
        ct=ct-1
    end
    local op=Duel.SelectOption(tp,aux.Stringid(m,4),aux.Stringid(m,5))
    Duel.SortDecktop(tp,tp,ct)
    if op==0 then return end
    for i=1,ct do
        local tg=Duel.GetDecktopGroup(tp,1)
        Duel.MoveSequence(tg:GetFirst(),SEQ_DECKBOTTOM)
    end
end

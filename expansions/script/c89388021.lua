--Uni☆ties 滑稽圆场 玛卡拉
local m=89388021
local cm=_G["c"..m]
function cm.initial_effect(c)
    local e2=Effect.CreateEffect(c)
    e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
    e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
    e2:SetRange(LOCATION_HAND)
    e2:SetCode(EVENT_TO_DECK)
    e2:SetCondition(cm.spcon)
    e2:SetTarget(cm.sptg)
    e2:SetOperation(cm.spop)
    c:RegisterEffect(e2)
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_DRAW+CATEGORY_TODECK)
    e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e1:SetCode(EVENT_SPSUMMON_SUCCESS)
    e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
    e1:SetCountLimit(1,m)
    e1:SetTarget(cm.thtg1)
    e1:SetOperation(cm.tgop1)
    c:RegisterEffect(e1)
end
function cm.cfilter(c,tp)
    return c:IsControler(tp) and c:GetPreviousControler()==tp and c:IsPreviousLocation(LOCATION_HAND+LOCATION_MZONE)  and c:IsSetCard(0xcc22) and not c:IsCode(m) and not c:IsLocation(LOCATION_EXTRA)
end
function cm.spcon(e,tp,eg,ep,ev,re,r,rp)
    return eg:IsExists(cm.cfilter,1,nil,tp)
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if not c:IsRelateToEffect(e) then return end
    Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
end
function cm.thtg1(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsPlayerCanDraw(tp,2) end
    Duel.SetTargetPlayer(tp)
    Duel.SetTargetParam(2)
    Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,2)
    Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,0,tp,2)
end
function cm.tgop1(e,tp,eg,ep,ev,re,r,rp)
    local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
    if Duel.Draw(p,d,REASON_EFFECT)==2 then
        Duel.ShuffleHand(p)
        Duel.BreakEffect()
        local g=Duel.GetMatchingGroup(Card.IsAbleToDeck,p,LOCATION_HAND,0,nil)
        local n
        if g:GetCount()>1 and g:IsExists(Card.IsSetCard,1,nil,0xcc22) then
            Duel.Hint(HINT_SELECTMSG,p,HINTMSG_TODECK)
            local sg1=g:FilterSelect(p,Card.IsSetCard,1,1,nil,0xcc22)
            Duel.Hint(HINT_SELECTMSG,p,HINTMSG_TODECK)
            local sg2=g:Select(p,1,1,sg1:GetFirst())
            sg1:Merge(sg2)
            Duel.ConfirmCards(1-p,sg1)
            Duel.SendtoDeck(sg1,nil,0,REASON_EFFECT)
            Duel.SortDecktop(p,p,2)
            n=2
        else
            local hg=Duel.GetFieldGroup(p,LOCATION_HAND,0)
            Duel.ConfirmCards(1-p,hg)
            local ct=Duel.SendtoDeck(hg,nil,0,REASON_EFFECT)
            Duel.SortDecktop(p,p,ct)
            n=ct
        end
        for i=1,n do
            local mg=Duel.GetDecktopGroup(p,1)
            Duel.MoveSequence(mg:GetFirst(),1)
        end
    end
end

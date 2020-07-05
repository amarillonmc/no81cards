--机怪巨兵 「TRISHULA」
local m=89388015
local cm=_G["c"..m]
function cm.initial_effect(c)
    c:EnableReviveLimit()
    aux.AddSynchroProcedure(c,nil,aux.NonTuner(Card.IsSetCard,0xcc21),2,2)
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_TODECK)
    e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e1:SetCode(EVENT_SPSUMMON_SUCCESS)
    e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
    e1:SetCondition(cm.remcon)
    e1:SetTarget(cm.remtg)
    e1:SetOperation(cm.remop)
    c:RegisterEffect(e1)
    local e2=Effect.CreateEffect(c)
    e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e2:SetType(EFFECT_TYPE_IGNITION)
    e2:SetRange(LOCATION_GRAVE)
    e2:SetCountLimit(1,m)
    e2:SetCost(cm.rcost)
    e2:SetTarget(cm.rtg)
    e2:SetOperation(cm.rop)
    c:RegisterEffect(e2)
end
function cm.remcon(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():IsSummonType(SUMMON_TYPE_SYNCHRO)
end
function cm.remtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToDeck,tp,0,LOCATION_HAND,1,nil)
        and Duel.IsExistingMatchingCard(Card.IsAbleToDeck,tp,0,LOCATION_ONFIELD,1,nil)
        and Duel.IsExistingMatchingCard(Card.IsAbleToDeck,tp,0,LOCATION_GRAVE,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,0,LOCATION_ONFIELD+LOCATION_GRAVE+LOCATION_HAND)
end
function cm.remop(e,tp,eg,ep,ev,re,r,rp)
    local g1=Duel.GetMatchingGroup(Card.IsAbleToDeck,tp,0,LOCATION_HAND,nil)
    local g2=Duel.GetMatchingGroup(Card.IsAbleToDeck,tp,0,LOCATION_ONFIELD,nil)
    local g3=Duel.GetMatchingGroup(Card.IsAbleToDeck,tp,0,LOCATION_GRAVE,nil)
    if g1:GetCount()>0 and g2:GetCount()>0 and g3:GetCount()>0 then
        Duel.Hint(HINT_SELECTMSG,tp,CATEGORY_TODECK)
        local sg1=g1:RandomSelect(tp,1)
        Duel.Hint(HINT_SELECTMSG,tp,CATEGORY_TODECK)
        local sg2=g2:Select(tp,1,1,nil)
        Duel.Hint(HINT_SELECTMSG,tp,CATEGORY_TODECK)
        local sg3=g3:Select(tp,1,1,nil)
        sg1:Merge(sg2)
        sg1:Merge(sg3)
        Duel.SendtoDeck(sg1,nil,2,REASON_EFFECT)
    end
end
function cm.rfilter(c)
    return c:IsSetCard(0xcc21) and c:GetLevel()>0 and c:IsAbleToRemoveAsCost()
end
function cm.rcost(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    local mg=Duel.GetMatchingGroup(cm.rfilter,tp,LOCATION_MZONE+LOCATION_HAND+LOCATION_GRAVE,0,c)
    if chk==0 then return c:IsCanBeSpecialSummoned(e,nil,tp,false,false) and mg:CheckWithSumEqual(Card.GetLevel,c:GetOriginalLevel(),1,99) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
    local mat=mg:SelectWithSumEqual(tp,Card.GetLevel,c:GetOriginalLevel(),1,99)
    Duel.Remove(mat,POS_FACEUP,REASON_COST)
end
function cm.rtg(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    if chk==0 then return Duel.GetMZoneCount(tp)>0 and c:IsCanBeSpecialSummoned(e,nil,tp,false,false) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function cm.rop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if c:IsRelateToEffect(e) then
        Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
    end
end

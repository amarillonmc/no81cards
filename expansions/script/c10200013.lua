-- 渊灵统御者-溟渊座头鲸
function c10200013.initial_effect(c)
    aux.EnablePendulumAttribute(c)
    -- 自爆特召
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(10200013,0))
    e1:SetCategory(CATEGORY_DESTROY+CATEGORY_SPECIAL_SUMMON)
    e1:SetType(EFFECT_TYPE_IGNITION)
    e1:SetRange(LOCATION_PZONE)
    e1:SetCountLimit(1,10200013)
    e1:SetCondition(c10200013.con1)
    e1:SetTarget(c10200013.tg1)
    e1:SetOperation(c10200013.op1)
    c:RegisterEffect(e1)
    -- 特召除外
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(10200013,1))
    e2:SetCategory(CATEGORY_REMOVE)
    e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e2:SetCode(EVENT_SPSUMMON_SUCCESS)
    e2:SetProperty(EFFECT_FLAG_DELAY)
    e2:SetCountLimit(1,10200014)
    e2:SetCondition(c10200013.con2)
    e2:SetTarget(c10200013.tg2)
    e2:SetOperation(c10200013.op2)
    c:RegisterEffect(e2)
    -- 墓地回收
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(10200013,2))
    e3:SetCategory(CATEGORY_DESTROY)
    e3:SetType(EFFECT_TYPE_IGNITION)
    e3:SetRange(LOCATION_MZONE)
    e3:SetCountLimit(1,10200015)
    e3:SetCost(c10200013.cost3)
    e3:SetTarget(c10200013.tg3)
    e3:SetOperation(c10200013.op3)
    c:RegisterEffect(e3)
end
-- 1
function c10200013.con1(e,tp,eg,ep,ev,re,r,rp)
    return Duel.IsExistingMatchingCard(Card.IsSetCard,tp,LOCATION_MZONE,0,1,nil,0xe21)
        and Duel.IsExistingMatchingCard(Card.IsSetCard,tp,LOCATION_PZONE,0,1,nil,0xe21)
        and Duel.IsExistingMatchingCard(Card.IsSetCard,tp,LOCATION_EXTRA,0,1,nil,0xe21)
end
function c10200013.filter1(c,e,tp)
    return c:IsSetCard(0xe21) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c10200013.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then
        return Duel.GetLocationCount(tp,LOCATION_MZONE)>1
            and not Duel.IsPlayerAffectedByEffect(tp,59822133)
            and Duel.IsExistingMatchingCard(c10200013.filter1,tp,LOCATION_DECK,0,2,nil,e,tp)
    end
    Duel.SetOperationInfo(0,CATEGORY_DESTROY,e:GetHandler(),1,0,0)
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,2,tp,LOCATION_DECK)
    Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function c10200013.op1(e,tp,eg,ep,ev,re,r,rp)
    if not e:GetHandler():IsRelateToEffect(e) then return end
    if Duel.Destroy(e:GetHandler(),REASON_EFFECT)~=0 then
        if Duel.GetLocationCount(tp,LOCATION_MZONE)<2 then return end
        local g=Duel.GetMatchingGroup(c10200013.filter1,tp,LOCATION_DECK,0,nil,e,tp)
        if #g>=2 then
            Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
            local sg=g:Select(tp,2,2,nil)
            Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
        end
    end
end
-- 2
function c10200013.con2(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():IsSummonType(SUMMON_TYPE_SPECIAL)
end
function c10200013.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then
        return Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD+LOCATION_GRAVE,1,nil)
    end
    Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,0,LOCATION_ONFIELD+LOCATION_GRAVE)
    Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function c10200013.op2(e,tp,eg,ep,ev,re,r,rp)
    local g1=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD,nil)
    local g2=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0,LOCATION_GRAVE,nil)
    local sg=Group.CreateGroup()
    if g1:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(10200013,3)) then
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
        local sg1=g1:Select(tp,1,1,nil)
        Duel.HintSelection(sg1)
        sg:Merge(sg1)
    end
    if g2:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(10200013,4)) then
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
        local sg2=g2:Select(tp,1,1,nil)
        Duel.HintSelection(sg2)
        sg:Merge(sg2)
    end
    if sg:GetCount()>0 then
        Duel.Remove(sg,POS_FACEUP,REASON_EFFECT)
    end
end
-- 3
function c10200013.filter3(c)
    return c:IsSetCard(0xe21) and c:IsType(TYPE_MONSTER) and c:IsAbleToDeck()
end
function c10200013.cost3(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then
        return Duel.IsExistingMatchingCard(c10200013.filter3,tp,LOCATION_GRAVE,0,1,nil)
    end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
    local g=Duel.SelectMatchingCard(tp,c10200013.filter3,tp,LOCATION_GRAVE,0,1,1,nil)
    Duel.SendtoDeck(g,nil,SEQ_DECKSHUFFLE,REASON_COST)
end
function c10200013.tg3(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then
        return Duel.IsExistingMatchingCard(Card.IsDestructable,tp,0,LOCATION_ONFIELD,1,nil)
            and Duel.GetFieldGroupCount(1-tp,LOCATION_ONFIELD,0)>0
            and Duel.GetFieldGroupCount(1-tp,LOCATION_HAND,0)>0
    end
    Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,2,0,LOCATION_ONFIELD+LOCATION_HAND)
    Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function c10200013.op3(e,tp,eg,ep,ev,re,r,rp)
    local g1=Duel.GetMatchingGroup(Card.IsDestructable,tp,0,LOCATION_ONFIELD,nil)
    local g2=Duel.GetFieldGroup(1-tp,LOCATION_HAND,0)
    if g1:GetCount()>0 and g2:GetCount()>0 then
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
        local sg1=g1:Select(tp,1,1,nil)
        Duel.HintSelection(sg1)
        local sg2=g2:RandomSelect(1-tp,1)
        Duel.HintSelection(sg2)
        sg1:Merge(sg2)
        Duel.Destroy(sg1,REASON_EFFECT)
    end
end
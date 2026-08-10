local s,id=GetID()

function s.initial_effect(c)
    -- 效果①：展示3只不同的「新式魔厨」仪式怪兽，对方随机选1只特殊召唤
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(id,0))
    e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetCountLimit(1,id)
    e1:SetTarget(s.sptg)
    e1:SetOperation(s.spop)
    c:RegisterEffect(e1)

    -- 效果②：墓地除外自身，解放手卡·场上的怪兽，从手卡仪式召唤「新式魔厨」仪式怪兽
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(id,1))
    e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e2:SetType(EFFECT_TYPE_QUICK_O)
    e2:SetCode(EVENT_FREE_CHAIN)
    e2:SetRange(LOCATION_GRAVE)
    e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
    e2:SetCountLimit(1,id+1)
    e2:SetCost(s.ritcost)
    e2:SetTarget(s.rtarget)
    e2:SetOperation(s.rop)
    c:RegisterEffect(e2)
end

-- 过滤：仅「新式魔厨」仪式怪兽
function s.spfilter(c)
    return c:IsSetCard(0x196) and c:IsType(TYPE_RITUAL) and c:IsLevelAbove(1)
end

----------------------------------------------------------------
-- 效果①（原样）
----------------------------------------------------------------
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then
        local g=Duel.GetMatchingGroup(s.spfilter,tp,LOCATION_DECK,0,nil)
        return g:GetClassCount(Card.GetCode)>=3 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
    end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end

function s.spop(e,tp,eg,ep,ev,re,r,rp)
    local g=Duel.GetMatchingGroup(s.spfilter,tp,LOCATION_DECK,0,nil)
    if g:GetClassCount(Card.GetCode)<3 or Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end

    local sg=Group.CreateGroup()
    for i=1,3 do
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
        local tc=g:Select(tp,1,1,nil):GetFirst()
        if tc then
            sg:AddCard(tc)
            g:Remove(Card.IsCode,nil,tc:GetCode())
        end
    end

    if #sg==3 then
        Duel.ConfirmCards(1-tp,sg)
        Duel.ShuffleDeck(tp)
        Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_SPSUMMON)
        local sc=sg:RandomSelect(1-tp,1):GetFirst()
        if sc then
            sg:RemoveCard(sc)
            if Duel.SpecialSummon(sc,SUMMON_TYPE_RITUAL,tp,tp,false,true,POS_FACEUP)>0 then
                sc:CompleteProcedure()
            end
        end
        if #sg>0 then
            Duel.SendtoDeck(sg,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
        end
    end
end

----------------------------------------------------------------
-- 效果② 的 cost（除外自身）
----------------------------------------------------------------
function s.ritcost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end
    Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end

----------------------------------------------------------------
-- 效果② target：检查手卡是否有可仪式召唤的怪兽，且能凑齐祭品
----------------------------------------------------------------
function s.rtarget(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then
        local g=Duel.GetMatchingGroup(s.spfilter,tp,LOCATION_HAND,0,nil)
        if #g==0 then return false end
        local mg=Duel.GetRitualMaterial(tp)   -- 所有手卡·场上的怪兽
        for tc in aux.Next(g) do
            local tmp=mg:Clone()
            tmp:RemoveCard(tc)   -- 不能解放自身
            -- 检查是否存在任意数量的祭品，等级合计等于 tc 的等级
            if tmp:CheckSubGroup(function(gg) return gg:GetSum(Card.GetLevel)==tc:GetLevel() end, 1, 99) then
                return true
            end
        end
        return false
    end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end

----------------------------------------------------------------
-- 效果② operation：选择仪式怪兽 → 选择祭品 → 解放并特殊召唤
----------------------------------------------------------------
function s.rop(e,tp,eg,ep,ev,re,r,rp)
    local g=Duel.GetMatchingGroup(s.spfilter,tp,LOCATION_HAND,0,nil)
    if #g==0 then return end

    -- 1. 选择要仪式召唤的怪兽
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local tc=g:Select(tp,1,1,nil):GetFirst()
    if not tc then return end

    -- 2. 获取祭品候选（手卡·场上所有怪兽，排除要召唤的自身）
    local mg=Duel.GetRitualMaterial(tp)
    mg:RemoveCard(tc)

    -- 3. 让玩家选择一组祭品，等级合计等于 tc 的等级
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
    local mat=mg:SelectSubGroup(tp, function(gg) return gg:GetSum(Card.GetLevel)==tc:GetLevel() end, true, 1, 99)
    if not mat or #mat==0 then
        -- 玩家取消或无法选择，效果不处理
        return
    end

    -- 4. 执行仪式召唤
    tc:SetMaterial(mat)
    Duel.ReleaseRitualMaterial(mat)
    Duel.BreakEffect()
    if Duel.SpecialSummon(tc, SUMMON_TYPE_RITUAL, tp, tp, false, true, POS_FACEUP)>0 then
        tc:CompleteProcedure()
    end
end
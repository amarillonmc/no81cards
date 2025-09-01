-- 食谱进修中 (需补充卡号)
local s,id=GetID()
function s.initial_effect(c)
    
    -- 效果①: 展示并特殊召唤仪式怪兽
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(id,0))
    e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetCountLimit(1,id)
    e1:SetTarget(s.sptg)
    e1:SetOperation(s.spop)
    c:RegisterEffect(e1)
    
    -- 效果②: 墓地除外进行仪式召唤
	local e2=aux.AddRitualProcEqual2(c,s.filter,LOCATION_HAND,nil,nil,true)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetType(EFFECT_TYPE_QUICK_O)
    e2:SetCode(EVENT_FREE_CHAIN)
    e2:SetRange(LOCATION_GRAVE)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e2:SetCountLimit(1,id+1)
	e2:SetCost(s.ritcost)
	c:RegisterEffect(e2)
end

-- 效果①: 目标设置
function s.spfilter(c)
    return c:IsSetCard(0x196) and c:IsType(TYPE_RITUAL) and c:IsLevelAbove(1)
end

function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then
        local g=Duel.GetMatchingGroup(s.spfilter,tp,LOCATION_DECK,0,nil)
        return g:GetClassCount(Card.GetCode)>=3 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
    end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end

-- 效果①: 操作
function s.spop(e,tp,eg,ep,ev,re,r,rp)
    local g=Duel.GetMatchingGroup(s.spfilter,tp,LOCATION_DECK,0,nil)
    if g:GetClassCount(Card.GetCode)<3 or Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
    
    -- 选择3只不同的仪式怪兽
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
        
        -- 让对方随机选择1只
        Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_SPSUMMON)
        local sc=sg:RandomSelect(1-tp,1):GetFirst()
        if sc then
            sg:RemoveCard(sc)
            -- 特殊召唤到自己场上（修正为在自己场上特殊召唤）
            if Duel.SpecialSummon(sc,SUMMON_TYPE_RITUAL,tp,tp,false,true,POS_FACEUP)>0 then
                sc:CompleteProcedure()
            end
        end
        
        -- 剩下的返回卡组
        if #sg>0 then
            Duel.SendtoDeck(sg,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
        end
    end
end

-- 效果②: 代价 - 从墓地除外
function s.ritcost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end
    Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end
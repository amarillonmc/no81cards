-- 武狸 小太郎 (需补充卡号)
local s,id=GetID()
function s.initial_effect(c)
    -- 怪兽属性
    c:EnableReviveLimit()
    
    -- 效果①: 丢弃并特殊召唤
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(id,0))
    e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e1:SetType(EFFECT_TYPE_QUICK_O)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetRange(LOCATION_HAND)
    e1:SetCountLimit(1,id)
    e1:SetCondition(s.spcon)
    e1:SetCost(s.spcost)
    e1:SetTarget(s.sptg)
    e1:SetOperation(s.spop)
    c:RegisterEffect(e1)
    
    -- 效果②: 代替破坏
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e2:SetCode(EFFECT_DESTROY_REPLACE)
    e2:SetRange(LOCATION_GRAVE)
    e2:SetTarget(s.reptg)
    e2:SetValue(s.repval)
    e2:SetOperation(s.repop)
    c:RegisterEffect(e2)
end

-- 效果①: 条件检查 - 自己场上没有卡
function s.spcon(e,tp,eg,ep,ev,re,r,rp)
    return Duel.GetFieldGroupCount(tp,LOCATION_ONFIELD,0)==0
end

-- 效果①: 代价 - 丢弃这张卡
function s.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():IsDiscardable() end
    Duel.SendtoGrave(e:GetHandler(),REASON_COST+REASON_DISCARD)
end

-- 效果①: 目标设置
function s.spfilter(c,e,tp)
    return c:IsLevel(2) and c:IsRace(RACE_BEAST) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_DEFENSE)
end

function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then
        local g=Duel.GetMatchingGroup(s.spfilter,tp,LOCATION_HAND,0,nil,e,tp)
        return Duel.GetLocationCount(tp,LOCATION_MZONE)>1 and not Duel.IsPlayerAffectedByEffect(tp,CARD_BLUEEYES_SPIRIT)
            and g:GetClassCount(Card.GetCode)>=2
    end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,2,tp,LOCATION_HAND)
end

-- 效果①: 操作
function s.spop(e,tp,eg,ep,ev,re,r,rp)
    if Duel.GetLocationCount(tp,LOCATION_MZONE)<2 or Duel.IsPlayerAffectedByEffect(tp,CARD_BLUEEYES_SPIRIT) then return end
    local g=Duel.GetMatchingGroup(s.spfilter,tp,LOCATION_HAND,0,nil,e,tp)
    if g:GetClassCount(Card.GetCode)<2 then return end
    
    local sg=Group.CreateGroup()
    for i=1,2 do
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
        local tc=g:Select(tp,1,1,nil):GetFirst()
        if tc then
            sg:AddCard(tc)
            g:Remove(Card.IsCode,nil,tc:GetCode())
        end
    end
    
    if #sg==2 then
        Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP_DEFENSE)
    end
end

-- 效果②: 代替破坏
function s.repfilter(c,tp)
    return c:IsFaceup() and c:IsRace(RACE_BEAST) and c:IsType(TYPE_XYZ)
        and c:IsLocation(LOCATION_MZONE) and c:IsControler(tp)
        and not c:IsReason(REASON_REPLACE) and (c:IsReason(REASON_BATTLE) or c:IsReason(REASON_EFFECT))
end

function s.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():IsAbleToRemove() and eg:IsExists(s.repfilter,1,nil,tp) end
    return Duel.SelectEffectYesNo(tp,e:GetHandler(),96)
end

function s.repval(e,c)
    return s.repfilter(c,e:GetHandlerPlayer())
end

function s.repop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_EFFECT+REASON_REPLACE)
end
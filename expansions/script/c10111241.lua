-- 新式魔厨的番薯料理学徒
local s,id=GetID()
function s.initial_effect(c)
    -- 灵摆属性
    aux.EnablePendulumAttribute(c)
    
    -- 灵摆效果
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(id,0))
    e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_ATKCHANGE)
    e1:SetType(EFFECT_TYPE_IGNITION)
    e1:SetRange(LOCATION_PZONE)
    e1:SetCountLimit(1,id)
    e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e1:SetCondition(s.pcon)
    e1:SetTarget(s.ptg)
    e1:SetOperation(s.pop)
    c:RegisterEffect(e1)
    
    -- 怪兽效果①: 召唤/特殊召唤时的效果
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(id,1))
    e2:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND+CATEGORY_SPECIAL_SUMMON+CATEGORY_TODECK)
    e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e2:SetCode(EVENT_SUMMON_SUCCESS)
    e2:SetCountLimit(1,id+1)
    e2:SetProperty(EFFECT_FLAG_DELAY)
    e2:SetTarget(s.mtg)
    e2:SetOperation(s.mop)
    c:RegisterEffect(e2)
    local e3=e2:Clone()
    e3:SetCode(EVENT_SPSUMMON_SUCCESS)
    c:RegisterEffect(e3)
    
    -- 怪兽效果②: 被解放后放置到灵摆区域
    local e4=Effect.CreateEffect(c)
    e4:SetDescription(aux.Stringid(id,2))
    e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e4:SetCode(EVENT_TO_DECK)
    e4:SetProperty(EFFECT_FLAG_DELAY)
    e4:SetCondition(s.pzcon)
    e4:SetTarget(s.pztg)
    e4:SetOperation(s.pzop)
    c:RegisterEffect(e4)
end

function s.cfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_RITUAL)
end

-- 灵摆效果条件: 自己场上有仪式怪兽存在
function s.pcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(s.cfilter,tp,LOCATION_MZONE,0,1,nil)
end

-- 灵摆效果目标: 选择场上1只怪兽
function s.ptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsFaceup() end
    local c=e:GetHandler()
    if chk==0 then return Duel.IsExistingTarget(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil)
        and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
    local g=Duel.SelectTarget(tp,Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end

-- 灵摆效果操作: 特殊召唤并提升攻击力
function s.pop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if not c:IsRelateToEffect(e) or Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)<1 then return end
    local tc=Duel.GetFirstTarget()
    if tc:IsRelateToEffect(e) and tc:IsFaceup() then
        Duel.BreakEffect()
        local e1=Effect.CreateEffect(c)
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_UPDATE_ATTACK)
        e1:SetValue(1000)
        e1:SetReset(RESET_EVENT+RESETS_STANDARD)
        tc:RegisterEffect(e1)
    end
end

-- 怪兽效果①: 目标设置
function s.thfilter(c)
    return c:IsSetCard(0x196) and c:IsType(TYPE_PENDULUM) and not c:IsCode(id) and c:IsAbleToHand()
end

function s.recipefilter(c)
    return c:IsSetCard(0x197) and c:IsAbleToDeck()
end

-- 修复ritualfilter函数，移除对e和tp的依赖
function s.ritualfilter(c,lv)
    return c:IsSetCard(0x196) and c:IsType(TYPE_RITUAL) and c:IsLevel(lv)
end

function s.mtg(e,tp,eg,ep,ev,re,r,rp,chk)
    local b1=Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_DECK,0,1,nil)
    local exg=Duel.GetMatchingGroup(s.recipefilter,tp,LOCATION_REMOVED,0,nil)
    local b2=exg:GetCount()>0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and Duel.IsExistingMatchingCard(s.ritualfilter,tp,LOCATION_DECK,0,1,nil,exg:GetCount())
    if chk==0 then return b1 or b2 end
    local op=aux.SelectFromOptions(tp,{b1,aux.Stringid(id,3)},{b2,aux.Stringid(id,4)})
    e:SetLabel(op)
    if op==1 then
        e:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
        Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
    else
        e:SetCategory(CATEGORY_TODECK+CATEGORY_SPECIAL_SUMMON)
        Duel.SetOperationInfo(0,CATEGORY_TODECK,exg,1,0,0)
        Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
    end
end

-- 怪兽效果①: 操作
function s.mop(e,tp,eg,ep,ev,re,r,rp)
    local op=e:GetLabel()
    if op==1 then
        -- 选项1: 从卡组检索
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
        local g=Duel.SelectMatchingCard(tp,s.thfilter,tp,LOCATION_DECK,0,1,1,nil)
        if #g>0 then
            Duel.SendtoHand(g,nil,REASON_EFFECT)
            Duel.ConfirmCards(1-tp,g)
        end
    else
        -- 选项2: 从除外区返回并特殊召唤
        local exg=Duel.GetMatchingGroup(s.recipefilter,tp,LOCATION_REMOVED,0,nil)
        if exg:GetCount()==0 then return end
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
        local sg=exg:Select(tp,1,exg:GetCount(),nil)
        local ct=Duel.SendtoDeck(sg,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
        if ct>0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
            -- 在操作函数中检查是否可以特殊召唤
            Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
            local rg=Duel.SelectMatchingCard(tp,function(c) return s.ritualfilter(c,ct) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,false,true) end,tp,LOCATION_DECK,0,1,1,nil)
            if #rg>0 then
                Duel.SpecialSummon(rg,SUMMON_TYPE_RITUAL,tp,tp,false,true,POS_FACEUP)
                rg:GetFirst():CompleteProcedure()
            end
        end
    end
end

-- 怪兽效果②: 条件 - 被解放以表侧加入额外卡组
function s.pzcon(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    return c:IsPreviousLocation(LOCATION_ONFIELD) and c:IsReason(REASON_RELEASE) and c:IsLocation(LOCATION_EXTRA)
        and c:IsFaceup()
end

-- 怪兽效果②: 目标 - 放置到灵摆区域
function s.pztg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1) end
end

-- 怪兽效果②: 操作 - 放置到灵摆区域
function s.pzop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if c:IsRelateToEffect(e) then
        Duel.MoveToField(c,tp,tp,LOCATION_PZONE,POS_FACEUP,true)
    end
end
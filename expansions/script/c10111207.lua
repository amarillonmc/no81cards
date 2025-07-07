function c10111207.initial_effect(c)
	--extra summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(10111207,0))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_EXTRA_SUMMON_COUNT)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(LOCATION_HAND+LOCATION_MZONE,0)
	e1:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0xac))
	c:RegisterEffect(e1)
    -- ②效果：召唤/特殊召唤时回复LP并提升攻防（自身除外）
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e2:SetCode(EVENT_SUMMON_SUCCESS)
    e2:SetRange(LOCATION_MZONE)
    e2:SetCondition(c10111207.regcon)
    e2:SetOperation(c10111207.regop)
    c:RegisterEffect(e2)
    local e3=e2:Clone()
    e3:SetCode(EVENT_SPSUMMON_SUCCESS)
    c:RegisterEffect(e3)
    --spsummon
    local e4=Effect.CreateEffect(c)
    e4:SetDescription(aux.Stringid(10111207,1))
    e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
    e4:SetCode(EVENT_BE_BATTLE_TARGET)
    e4:SetRange(LOCATION_GRAVE)
    e4:SetCondition(c10111207.spcon)
    e4:SetTarget(c10111207.sptg)
    e4:SetOperation(c10111207.spop)
    c:RegisterEffect(e4)
end
-- 检查自身是否在场上表侧表示
function c10111207.regcon(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():IsFaceup()
end

-- 处理召唤/特殊召唤事件
function c10111207.regop(e,tp,eg,ep,ev,re,r,rp)
    local c = e:GetHandler()
    -- 过滤出其他「哥布林」怪兽（排除自身）
    local g = eg:Filter(c10111207.filter, nil, tp, c)
    
    if g:GetCount() > 0 then
        -- 回复基本分（每只怪兽单独计算）
        Duel.Recover(tp, 500 * g:GetCount(), REASON_EFFECT)
        
        -- 为每只召唤的怪兽添加永久的攻防提升效果
        for tc in aux.Next(g) do
            -- 永久的攻击力提升
            local e1=Effect.CreateEffect(c)
            e1:SetType(EFFECT_TYPE_SINGLE)
            e1:SetCode(EFFECT_UPDATE_ATTACK)
            e1:SetValue(500)
            e1:SetReset(RESET_EVENT+RESETS_STANDARD)
            tc:RegisterEffect(e1)
            
            -- 永久的守备力提升
            local e2=Effect.CreateEffect(c)
            e2:SetType(EFFECT_TYPE_SINGLE)
            e2:SetCode(EFFECT_UPDATE_DEFENSE)
            e2:SetValue(500)
            e2:SetReset(RESET_EVENT+RESETS_STANDARD)
            tc:RegisterEffect(e2)
        end
    end
end

-- 过滤「哥布林」怪兽（排除自身）
function c10111207.filter(c,tp,self)
    return c:IsSetCard(0xac) and c:IsControler(tp) and c:IsLocation(LOCATION_MZONE) and c~=self
end
function c10111207.spcon(e,tp,eg,ep,ev,re,r,rp)
    local at=Duel.GetAttackTarget()
    return at and at:IsFaceup() and at:IsControler(tp) and at:IsSetCard(0xac) 
        and not at:IsCode(CARD_GOBLIN_CHEF) -- 替换为哥布林厨师长的实际卡号
end

function c10111207.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end

function c10111207.spop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP_ATTACK)~=0 then
        -- 创建离场除外的效果
        local e1=Effect.CreateEffect(c)
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
        e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
        e1:SetReset(RESET_EVENT+RESETS_REDIRECT)
        e1:SetValue(LOCATION_REMOVED)
        c:RegisterEffect(e1,true)
        
        -- 转移攻击对象
        local a=Duel.GetAttacker()
        local tc=Duel.GetAttackTarget()
        if a:IsAttackable() and not a:IsImmuneToEffect(e) and tc:IsControler(tp) then
            Duel.CalculateDamage(a,c)  -- 重新计算伤害
        end
    end
end
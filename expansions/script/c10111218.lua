local s,id,o=GetID()
function s.initial_effect(c)
    -- ①效果：手卡特召
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(id,0))
    e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e1:SetType(EFFECT_TYPE_QUICK_O)
    e1:SetCode(EVENT_LEAVE_FIELD)
    e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
    e1:SetRange(LOCATION_HAND)
    e1:SetCountLimit(1,id)
    e1:SetCondition(s.spcon)
    e1:SetTarget(s.sptg)
    e1:SetOperation(s.spop)
    c:RegisterEffect(e1)
    
    -- ②效果：特召成功时选发同列破坏（对方怪兽不能连锁）
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(id,1))
    e2:SetCategory(CATEGORY_DESTROY)
    e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
    e2:SetCode(EVENT_SPSUMMON_SUCCESS)
    e2:SetCountLimit(1,id+1)
    e2:SetCondition(s.descon)
    e2:SetTarget(s.destg)
    e2:SetOperation(s.desop)
    c:RegisterEffect(e2)

    -- ③效果：攻击力变化
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(id,2))
    e3:SetCategory(CATEGORY_ATKCHANGE)
    e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
    e3:SetCode(EVENT_ATTACK_ANNOUNCE)
    e3:SetRange(LOCATION_MZONE)
    e3:SetCondition(s.atkcon)
    e3:SetTarget(s.atktg)
    e3:SetOperation(s.atkop)
    c:RegisterEffect(e3)
end

-- ①效果条件函数保持不变
function s.cfilter(c,tp,rp)
    return c:GetPreviousControler()==tp 
        and c:IsPreviousLocation(LOCATION_MZONE)
        and rp==1-tp 
        and c:IsReason(REASON_EFFECT)
end

function s.spcon(e,tp,eg,ep,ev,re,r,rp)
    return eg:IsExists(s.cfilter,1,nil,tp,rp)
end

-- ①效果目标：手卡特召
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end

-- ①效果操作：特召+防连锁
function s.spop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)>0 then
        -- 防止对方用怪兽效果连锁①效果
        local e1=Effect.CreateEffect(c)
        e1:SetType(EFFECT_TYPE_FIELD)
        e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
        e1:SetCode(EFFECT_CANNOT_ACTIVATE)
        e1:SetTargetRange(0,1)
        e1:SetValue(s.aclimit)
        e1:SetReset(RESET_PHASE+PHASE_END)
        Duel.RegisterEffect(e1,tp)
    end
end

-- ②效果条件：从手卡特召成功
function s.descon(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():IsPreviousLocation(LOCATION_HAND)
end

-- ②效果目标：同列卡破坏（修复：使用GetColumnGroup并添加自身）
function s.destg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    local c=e:GetHandler()
    local g=c:GetColumnGroup()
    g:AddCard(c) -- 添加自身到组中
    local dg=g:Filter(Card.IsOnField, nil) -- 只取场上存在的卡
    Duel.SetOperationInfo(0,CATEGORY_DESTROY,dg,#dg,0,0)
end

-- ②效果操作：破坏同列卡+防连锁（修复：使用GetColumnGroup并添加自身）
function s.desop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    -- 防止连锁
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e1:SetCode(EFFECT_CANNOT_ACTIVATE)
    e1:SetTargetRange(0,1)
    e1:SetValue(s.aclimit)
    e1:SetReset(RESET_PHASE+PHASE_END)
    Duel.RegisterEffect(e1,tp)
    
    if not c:IsLocation(LOCATION_MZONE) then return end
    local g=c:GetColumnGroup()
    g:AddCard(c) -- 添加自身到组中
    local dg=g:Filter(Card.IsOnField, nil) -- 只取场上存在的卡
    if #dg>0 then
        Duel.Destroy(dg,REASON_EFFECT)
    end
end

-- 通用防连锁过滤器
function s.aclimit(e,re,tp)
    return re:IsActiveType(TYPE_MONSTER)
end

-- ③效果函数保持不变
function s.atkcon(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local tc=c:GetBattleTarget()
    e:SetLabelObject(tc)
    return tc and tc:IsFaceup()
end
function s.atktg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    e:GetLabelObject():CreateEffectRelation(e)
end
function s.atkop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local tc=e:GetLabelObject()
    if tc:IsRelateToEffect(e) and tc:IsFaceup() and tc:IsControler(1-tp) and not tc:IsImmuneToEffect(e) then
        local e1=Effect.CreateEffect(c)
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_UPDATE_ATTACK)
        e1:SetValue(-200)
        e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
        tc:RegisterEffect(e1)
        if c:IsRelateToEffect(e) and c:IsFaceup() and not tc:IsHasEffect(EFFECT_REVERSE_UPDATE) then
            local e3=Effect.CreateEffect(c)
            e3:SetType(EFFECT_TYPE_SINGLE)
            e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
            e3:SetCode(EFFECT_UPDATE_ATTACK)
            e3:SetValue(200)
            e3:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
            c:RegisterEffect(e3)
        end
    end
end
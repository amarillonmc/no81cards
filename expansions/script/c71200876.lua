local s,id=GetID()  -- 正确获取ID方式
function s.initial_effect(c)
    -- 效果①：超量召唤效果
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(id,0))
    e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e1:SetType(EFFECT_TYPE_QUICK_O)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetRange(LOCATION_MZONE)
    e1:SetHintTiming(0,TIMING_MAIN_END)
    e1:SetCountLimit(1,id)
    e1:SetCondition(s.xyzcon)
    e1:SetTarget(s.xyztg)
    e1:SetOperation(s.xyzop)
    c:RegisterEffect(e1)
    
    -- 效果②：取除素材时弹卡效果
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(id,1))
    e2:SetCategory(CATEGORY_TOHAND)
    e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e2:SetCode(EVENT_MOVE)  -- 使用移动事件检测素材取除
    e2:SetProperty(EFFECT_FLAG_DELAY)
    e2:SetCountLimit(1,id+1)
    e2:SetCondition(s.thcon)
    e2:SetTarget(s.thtg)
    e2:SetOperation(s.thop)
    c:RegisterEffect(e2)
end

-- 效果①条件函数：主要阶段
function s.xyzcon(e,tp,eg,ep,ev,re,r,rp)
    return Duel.IsMainPhase()
end

-- 效果①目标函数 - 修正版
function s.xyzfilter(c,e,tp,mc)
    return c:IsSetCard(0x893) 
        and c:IsType(TYPE_XYZ) 
        and mc:IsCanBeXyzMaterial(c)  -- 检查自身是否可作为素材
        and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,false,false)  -- 正确传入效果对象e
        and Duel.GetLocationCountFromEx(tp,tp,mc,c)>0  -- 位置检查
end

function s.xyztg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then
        local c=e:GetHandler()
        return Duel.GetLocationCountFromEx(tp,tp,c)>0
            -- 正确传递所有参数：e,tp,c
            and Duel.IsExistingMatchingCard(s.xyzfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp,c)
    end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end

-- 效果①操作函数：超量召唤 - 修正版
function s.xyzop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if not c:IsRelateToEffect(e) then return end
    if Duel.GetLocationCountFromEx(tp,tp,c)<=0 then return end
    
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    -- 正确传递所有参数：e,tp,c
    local g=Duel.SelectMatchingCard(tp,s.xyzfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,c)
    local sc=g:GetFirst()
    if sc then
        -- 将自身作为超量素材
        local mg=Group.FromCards(c)
        sc:SetMaterial(mg)
        Duel.Overlay(sc,mg)
        Duel.SpecialSummon(sc,SUMMON_TYPE_XYZ,tp,tp,false,false,POS_FACEUP)
        sc:CompleteProcedure()
        
        -- 注册自肃效果：只能特殊召唤炎属性额外怪兽
        local e1=Effect.CreateEffect(c)
        e1:SetType(EFFECT_TYPE_FIELD)
        e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
        e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
        e1:SetTargetRange(1,0)
        e1:SetTarget(s.splimit)
        e1:SetReset(RESET_PHASE+PHASE_END)
        Duel.RegisterEffect(e1,tp)
    end
end

-- 自肃限制函数
function s.splimit(e,c)
    return c:IsLocation(LOCATION_EXTRA) and not c:IsAttribute(ATTRIBUTE_FIRE)
end

-- 效果②条件函数：作为素材被取除
function s.thcon(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    return c:IsReason(REASON_COST) and re:IsActivated() and re:IsActiveType(TYPE_XYZ)
        and c:IsPreviousLocation(LOCATION_OVERLAY)
end

-- 效果②目标函数：选择对方场上的卡
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToHand,tp,0,LOCATION_ONFIELD,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,1-tp,LOCATION_ONFIELD)
end

-- 效果②操作函数：弹回手卡
function s.thop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
    local g=Duel.SelectMatchingCard(tp,Card.IsAbleToHand,tp,0,LOCATION_ONFIELD,1,1,nil)
    if #g>0 then
        Duel.SendtoHand(g,nil,REASON_EFFECT)
    end
end
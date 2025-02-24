-- 无敌机械王支援卡
-- 卡号：10111171
function c10111171.initial_effect(c)
	aux.AddCodeList(c,10111169)
    --① 手卡丢弃发动效果
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(10111171,0))
    e1:SetCategory(CATEGORY_ATKCHANGE)
    e1:SetType(EFFECT_TYPE_QUICK_O)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetRange(LOCATION_HAND)
    e1:SetCost(c10111171.cost)
    e1:SetTarget(c10111171.target)
    e1:SetOperation(c10111171.operation)
    e1:SetCountLimit(1,10111171)
    c:RegisterEffect(e1)
    
    --② 墓地回收
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(10111171,1))
    e2:SetCategory(CATEGORY_TOHAND)
    e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
    e2:SetCode(EVENT_PHASE+PHASE_END)
    e2:SetRange(LOCATION_GRAVE)
    e2:SetCountLimit(1,10111171+100)
    e2:SetCondition(c10111171.thcon)
    e2:SetTarget(c10111171.thtg)
    e2:SetOperation(c10111171.thop)
    c:RegisterEffect(e2)
end

--① 效果相关函数--
function c10111171.cost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():IsDiscardable() end
    Duel.SendtoGrave(e:GetHandler(),REASON_COST+REASON_DISCARD)
end

function c10111171.filter(c)
    return c:IsFaceup() and c:IsCode(10111169) --"无敌机械王"的卡号
end

function c10111171.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c10111171.filter,tp,LOCATION_MZONE,0,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
    local g=Duel.SelectMatchingCard(tp,c10111171.filter,tp,LOCATION_MZONE,0,1,1,nil)
    Duel.SetTargetCard(g:GetFirst())
end

function c10111171.operation(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetFirstTarget()
    if tc and tc:IsRelateToEffect(e) and tc:IsFaceup() then
        --允许攻击全部怪兽
        local e1=Effect.CreateEffect(e:GetHandler())
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_ATTACK_ALL)
        e1:SetValue(1)
        e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
        tc:RegisterEffect(e1)
        
        --对方怪兽变机械族
        local e2=Effect.CreateEffect(e:GetHandler())
        e2:SetType(EFFECT_TYPE_FIELD)
        e2:SetCode(EFFECT_CHANGE_RACE)
        e2:SetTargetRange(0,LOCATION_MZONE)
        e2:SetValue(RACE_MACHINE)
        e2:SetReset(RESET_PHASE+PHASE_END)
        Duel.RegisterEffect(e2,tp)
        
        --对方怪兽效果无效化（仅对效果怪兽生效）
        local e3=Effect.CreateEffect(e:GetHandler())
        e3:SetType(EFFECT_TYPE_FIELD)
        e3:SetCode(EFFECT_DISABLE)
        e3:SetTargetRange(0,LOCATION_MZONE)
        e3:SetTarget(c10111171.distg) --添加目标限制
        e3:SetReset(RESET_PHASE+PHASE_END)
        Duel.RegisterEffect(e3,tp)
    end
end

--无效化效果的目标限制函数
function c10111171.distg(e,c)
    return c:IsType(TYPE_EFFECT) --仅对效果怪兽生效
end

--② 效果相关函数--
function c10111171.thfilter(c)
    return c:IsCode(10111169) and c:IsFaceup()
end

function c10111171.thcon(e,tp,eg,ep,ev,re,r,rp)
    return Duel.IsExistingMatchingCard(c10111171.thfilter,tp,LOCATION_MZONE,0,1,nil)
end

function c10111171.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():IsAbleToHand() end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
end

function c10111171.thop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if c:IsRelateToEffect(e) then
        Duel.SendtoHand(c,nil,REASON_EFFECT)
    end
end
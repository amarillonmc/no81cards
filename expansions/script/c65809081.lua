--策略 效率提升 监工
function c65809081.initial_effect(c)
    -- 双召抽鞭
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(65809081,0))
    e1:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE)
    e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
    e1:SetCode(EVENT_SUMMON_SUCCESS)
    e1:SetProperty(EFFECT_FLAG_DELAY)
    e1:SetOperation(c65809081.op1)
    c:RegisterEffect(e1)
    local e2=e1:Clone()
    e2:SetCode(EVENT_SPSUMMON_SUCCESS)
    c:RegisterEffect(e2)
    -- 自由抽鞭
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(65809081,0))
    e3:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE)
    e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
    e3:SetRange(LOCATION_MZONE)
    e3:SetHintTiming(0,TIMINGS_CHECK_MONSTER)
    e3:SetCost(c65809081.cost2)
    e3:SetOperation(c65809081.op1)
    c:RegisterEffect(e3)
    -- 强制守备
	local e4=Effect.CreateEffect(c)
    e4:SetDescription(aux.Stringid(65809081,1))
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_SET_POSITION)
	e4:SetRange(LOCATION_MZONE)
	e4:SetTarget(c65809081.tg3)
	e4:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e4:SetValue(POS_FACEUP_DEFENSE)
	c:RegisterEffect(e4)
end
-- 1
function c65809081.filter1(c)
    return c:IsFaceup() and c:IsSetCard(0xca30) and c:IsType(TYPE_MONSTER)
end
function c65809081.op1(e,tp,eg,ep,ev,re,r,rp)
    if not e:GetHandler():IsRelateToEffect(e) then return end
    local g=Duel.GetMatchingGroup(c65809081.filter1,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
    if g:GetCount()>0 then
        Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
        local sg=g:Select(tp,1,1,nil)
        local tc=sg:GetFirst()
        if tc then
            local e1=Effect.CreateEffect(e:GetHandler())
            e1:SetType(EFFECT_TYPE_SINGLE)
            e1:SetCode(EFFECT_UPDATE_ATTACK)
            e1:SetValue(-500)
            e1:SetReset(RESET_EVENT+RESETS_STANDARD)
            tc:RegisterEffect(e1)
            local e2=e1:Clone()
            e2:SetCode(EFFECT_UPDATE_DEFENSE)
            tc:RegisterEffect(e2)
        end
    end
end
-- 2
function c65809081.filter2(c,tp)
    return c:GetOwner()~=tp and c:IsDiscardable()
end
function c65809081.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c65809081.filter2,tp,LOCATION_HAND,0,1,nil,tp) end
    Duel.DiscardHand(tp,c65809081.filter2,1,1,REASON_DISCARD+REASON_COST,nil,tp)
end
-- 3
function c65809081.tg3(e,c)
    return c:IsFaceup() and not c:IsAttack(c:GetBaseAttack())
end

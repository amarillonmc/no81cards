--真理的绝大 莱奥
function c11771320.initial_effect(c)
	c:EnableCounterPermit(0xc7f)
    --link summon
    c:EnableReviveLimit()
    aux.AddLinkProcedure(c,c11771320.filter0,3,99)
    -- 指示物
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e1:SetCode(EVENT_TOSS_DICE_NEGATE)
    e1:SetRange(LOCATION_MZONE)
    e1:SetOperation(c11771320.op1)
    c:RegisterEffect(e1)
    -- 时间删除
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(11771320,0))
    e2:SetType(EFFECT_TYPE_QUICK_O)
    e2:SetCode(EVENT_FREE_CHAIN)
    e2:SetRange(LOCATION_MZONE)
    e2:SetCountLimit(1,11771320)
    e2:SetCost(c11771320.cost2)
    e2:SetOperation(c11771320.op2)
    c:RegisterEffect(e2)
    -- 亡语
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(11771320,1))
    e3:SetCategory(CATEGORY_DICE+CATEGORY_TODECK)
    e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e3:SetCode(EVENT_REMOVE)
    e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
    e3:SetCountLimit(1,11771321)
    e3:SetCondition(c11771320.con3)
    e3:SetTarget(c11771320.tg3)
    e3:SetOperation(c11771320.op3)
    c:RegisterEffect(e3)
end
-- link
function c11771320.filter0(c,tp)
    return c:IsType(TYPE_MONSTER) and c:IsEffectProperty(aux.EffectPropertyFilter(EFFECT_FLAG_DICE))
end
-- 1
function c11771320.op1(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    c:AddCounter(0xc7f,1)
end
-- 2
function c11771320.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
    local TRUTH_COUNTER = 0xc7f
    if chk==0 then return e:GetHandler():GetCounter(TRUTH_COUNTER)>=9 end
    e:GetHandler():RemoveCounter(tp,TRUTH_COUNTER,9,REASON_COST)
end
function c11771320.op2(e,tp,eg,ep,ev,re,r,rp)
    local p=Duel.GetTurnPlayer()
    Duel.SkipPhase(p,PHASE_DRAW,RESET_PHASE+PHASE_END,1)
    Duel.SkipPhase(p,PHASE_STANDBY,RESET_PHASE+PHASE_END,1)
    Duel.SkipPhase(p,PHASE_MAIN1,RESET_PHASE+PHASE_END,1)
    Duel.SkipPhase(p,PHASE_BATTLE,RESET_PHASE+PHASE_END,1)
    Duel.SkipPhase(p,PHASE_MAIN2,RESET_PHASE+PHASE_END,1)
    local e1=Effect.CreateEffect(e:GetHandler())
    e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetCode(EFFECT_CANNOT_BP)
    e1:SetTargetRange(0,1)
    e1:SetReset(RESET_PHASE+PHASE_END)
    Duel.RegisterEffect(e1,tp)
end
-- 3
function c11771320.con3(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    return c:IsPreviousLocation(LOCATION_MZONE) and c:IsSummonType(SUMMON_TYPE_LINK) and rp~=tp
end
function c11771320.tg3(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    Duel.SetOperationInfo(0,CATEGORY_DICE,nil,0,tp,2)
    Duel.SetPossibleOperationInfo(0,CATEGORY_TODECK,nil,0,1-tp,LOCATION_ONFIELD)
end
function c11771320.op3(e,tp,eg,ep,ev,re,r,rp)
    local d1,d2=Duel.TossDice(tp,2)
    local total=d1+d2
    if total>=9 then
        local g=Duel.GetFieldGroup(1-tp,LOCATION_ONFIELD,0)
        if #g>0 then
            Duel.SendtoDeck(g,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
        end
    end
end

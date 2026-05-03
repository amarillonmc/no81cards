-- 伏匿之丝 入蜘蛛口
local COUNTER_DEATHTOUCH = 0x16fd

function c87531260.initial_effect(c)
    c:EnableCounterPermit(COUNTER_DEATHTOUCH)

    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(87531260,0))
    e1:SetCategory(CATEGORY_CONTROL+CATEGORY_COUNTER+CATEGORY_DESTROY)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
    e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e1:SetTarget(c87531260.target)
    e1:SetOperation(c87531260.operation)
    c:RegisterEffect(e1)

    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_SINGLE)
    e2:SetDescription(aux.Stringid(87531260,1))
    e2:SetCode(EFFECT_TRAP_ACT_IN_SET_TURN)
    e2:SetProperty(EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
    e2:SetCondition(c87531260.actcon)
    e2:SetCost(c87531260.actcost)
    c:RegisterEffect(e2)
end

function c87531260.actcon(e)
    local tp=e:GetHandlerPlayer()
    return Duel.IsExistingMatchingCard(function(c) return c:IsFaceup() and c:IsSetCard(0xf8a) end, tp, LOCATION_MZONE, 0, 1, nil)
end

function c87531260.actcost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil) end
    Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)
end

function c87531260.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsFaceup() end
    if chk==0 then return Duel.IsExistingTarget(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
    Duel.SelectTarget(tp,Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
end

function c87531260.operation(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local tc=Duel.GetFirstTarget()
    if not tc:IsRelateToEffect(e) or tc:IsFacedown() then return end
    if tc:IsSetCard(0xf8a) then
        if tc:IsCanAddCounter(COUNTER_DEATHTOUCH,1) then
            tc:AddCounter(COUNTER_DEATHTOUCH,1,REASON_EFFECT)
        end
        -- 死触战斗破坏效果
        local e1=Effect.CreateEffect(c)
        e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
        e1:SetCode(EVENT_BATTLED)
        e1:SetCondition(c87531260.death_battle_con)
        e1:SetOperation(c87531260.death_battle_op)
        e1:SetReset(RESET_EVENT+RESETS_STANDARD)
        e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
        tc:RegisterEffect(e1,true)
        -- 死触效果破坏
        local e2=Effect.CreateEffect(c)
        e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
        e2:SetCode(EVENT_CHAIN_SOLVED)
        e2:SetCondition(c87531260.death_effect_con)
        e2:SetOperation(c87531260.death_effect_op)
        e2:SetReset(RESET_EVENT+RESETS_STANDARD)
        e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
        tc:RegisterEffect(e2,true)
        if Duel.IsExistingMatchingCard(Card.IsFaceup,tp,0,LOCATION_MZONE,1,nil) then
            if Duel.SelectYesNo(tp,aux.Stringid(87531260,2)) then
                Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONTROL)
                local g=Duel.SelectMatchingCard(tp,Card.IsFaceup,tp,0,LOCATION_MZONE,1,1,nil)
                if #g>0 then
                    local oc=g:GetFirst()
                    if oc then
                        Duel.GetControl(oc,tp,PHASE_END,1)
                    end
                end
            end
        end
    else
        if Duel.GetControl(tc,tp,0,0)~=0 then
            tc:RegisterFlagEffect(87531260,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,2)

            local destroy_flag = 0
            if Duel.IsExistingMatchingCard(Card.IsSetCard,tp,LOCATION_MZONE,0,1,nil,0xf8a) then
                if Duel.SelectYesNo(tp,aux.Stringid(87531260,3)) then
                    destroy_flag = 1
                end
            end

            local e_return=Effect.CreateEffect(c)
            e_return:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
            e_return:SetCode(EVENT_PHASE+PHASE_END)
            e_return:SetCountLimit(1)
            e_return:SetCondition(c87531260.nextendcon)
            e_return:SetOperation(c87531260.nextendop)
            e_return:SetReset(RESET_PHASE+PHASE_END+RESET_OPPO_TURN,2)
            e_return:SetLabel(Duel.GetTurnCount(), destroy_flag)
            e_return:SetLabelObject(tc)
            Duel.RegisterEffect(e_return,tp)
        end
    end
end

function c87531260.death_battle_con(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local a=Duel.GetAttacker()
    local d=Duel.GetAttackTarget()
    return (a==c and d and d:IsControler(1-tp)) or (d==c and a and a:IsControler(1-tp))
end

function c87531260.death_battle_op(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local a=Duel.GetAttacker()
    local d=Duel.GetAttackTarget()
    local opp=nil
    if a==c then opp=d else opp=a end
    if opp and opp:IsRelateToBattle() and opp:IsControler(1-tp) then
        Duel.Destroy(opp,REASON_EFFECT)
    end
end

function c87531260.death_effect_con(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local te = Duel.GetChainInfo(ev, CHAININFO_TRIGGERING_EFFECT)
    if not te or te:GetHandler() ~= c then return false end
    if bit.band(te:GetCategory(), CATEGORY_DEFCHANGE) == 0 then return false end
    local tg = Duel.GetChainInfo(ev, CHAININFO_TARGET_CARDS)
    if not tg then return false end
    if tg:IsExists(Card.IsControler,1,nil,1-tp) then
        e:SetLabel(ev)
        return true
    end
    return false
end

function c87531260.death_effect_op(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local ev = e:GetLabel()
    local te = Duel.GetChainInfo(ev, CHAININFO_TRIGGERING_EFFECT)
    if not te or te:GetHandler() ~= c then return end
    local tg = Duel.GetChainInfo(ev, CHAININFO_TARGET_CARDS)
    if not tg then return end
    local opp_tg = tg:Filter(Card.IsControler,nil,1-tp)
    for opp in aux.Next(opp_tg) do
        if opp:IsRelateToChain(ev) then
            Duel.Destroy(opp, REASON_EFFECT)
        end
    end
end

function c87531260.nextendcon(e,tp,eg,ep,ev,re,r,rp)
    local turncount, _ = e:GetLabel()
    return Duel.GetTurnCount() ~= turncount
end

function c87531260.nextendop(e,tp,eg,ep,ev,re,r,rp)
    local tc=e:GetLabelObject()
    if not tc then return end
    local _, destroy_flag = e:GetLabel()
    if destroy_flag == 1 then
        if tc:IsLocation(LOCATION_MZONE) and tc:IsControler(tp) then
            if Duel.SendtoGrave(tc,REASON_EFFECT)~=0 and tc:IsLocation(LOCATION_GRAVE) then
                local e1=Effect.CreateEffect(e:GetOwner())
                e1:SetType(EFFECT_TYPE_SINGLE)
                e1:SetCode(EFFECT_CANNOT_TRIGGER)
                e1:SetReset(RESET_EVENT+RESETS_STANDARD)
                tc:RegisterEffect(e1,true)
            end
        end
    else
        if tc:IsLocation(LOCATION_MZONE) and tc:IsControler(tp) then
            Duel.GetControl(tc,1-tp,0,0)
        end
    end
end
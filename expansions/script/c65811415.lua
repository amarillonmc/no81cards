-- 狂野神碑的欺诳
local s,id=GetID()
local KOISHI_CHECK=false
if Card.SetCardData then KOISHI_CHECK=true end
function s.initial_effect(c)
    local e0=Effect.CreateEffect(c)
    e0:SetDescription(aux.Stringid(id,1))
    e0:SetType(EFFECT_TYPE_SINGLE)
    e0:SetCode(EFFECT_QP_ACT_IN_NTPHAND)
    c:RegisterEffect(e0)

    -- 作为速攻魔法发动
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
    c:RegisterEffect(e1)

    -- ① 只要在场上，对方没卡则胜利
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e2:SetCode(EVENT_ADJUST)
    e2:SetRange(LOCATION_SZONE)
    e2:SetOperation(s.winop)
    c:RegisterEffect(e2)

    -- ② 每次发动魔法选1张消灭
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(id,0))
    e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
    e3:SetCode(EVENT_CHAINING)
    e3:SetRange(LOCATION_SZONE)
    e3:SetCondition(s.excon)
    e3:SetTarget(s.extg)
    e3:SetOperation(s.exop)
    c:RegisterEffect(e3)

    -- ③ 不能盖放
    local e4=Effect.CreateEffect(c)
    e4:SetType(EFFECT_TYPE_FIELD)
    e4:SetCode(EFFECT_CANNOT_SSET)
    e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e4:SetRange(0xff)
    e4:SetTargetRange(1,1)
    e4:SetTarget(function(e,c) return c==e:GetHandler() end)
    c:RegisterEffect(e4)
end
function s.winop(e,tp,eg,ep,ev,re,r,rp)
    if Duel.GetFieldGroupCount(tp,0,LOCATION_DECK)==0 then
        Duel.Win(tp,0xa31)
    end
end
function s.excon(e,tp,eg,ep,ev,re,r,rp)
    return re:IsHasType(EFFECT_TYPE_ACTIVATE) and re:IsActiveType(TYPE_SPELL) and re:GetHandler()~=e:GetHandler()
end
function s.extg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
end
function s.exop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if not c:IsRelateToEffect(e) then return end
    local g=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_GRAVE+LOCATION_REMOVED,nil)
    local deck_top = Duel.GetDecktopGroup(1-tp,1)
    g:Merge(deck_top)
    if #g>0 then
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
        local sg=g:Select(tp,1,1,nil)
        local tc=sg:GetFirst()
        if tc and not tc:IsImmuneToEffect(e) then
            if tc:IsLocation(LOCATION_DECK) then
                Duel.DisableShuffleCheck()
                Duel.ConfirmCards(tp,tc)
                if KOISHI_CHECK then Duel.Exile(tc,REASON_EFFECT) else Duel.Remove(tc,POS_FACEDOWN,REASON_RULE,nil) end
            else
                Duel.HintSelection(Group.FromCards(tc))
                if KOISHI_CHECK then 
                    Duel.Exile(tc,REASON_EFFECT)
                else
                    if tc:IsLocation(LOCATION_REMOVED) then Duel.SendtoGrave(tc,REASON_RULE) end
                    Duel.Remove(tc,POS_FACEDOWN,REASON_RULE,nil)
                end
            end
        end
    end
end
local s,id=GetID()

function s.initial_effect(c)
    -- 发动条件
    local e0=Effect.CreateEffect(c)
    e0:SetType(EFFECT_TYPE_ACTIVATE)
    e0:SetCode(EVENT_FREE_CHAIN)
    c:RegisterEffect(e0)

   -- ①：对方不能把自己场上攻击力最高的怪兽作为效果的对象。
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
    e1:SetRange(LOCATION_FZONE)
    e1:SetTargetRange(LOCATION_MZONE,0)
    e1:SetTarget(s.immtg)
    e1:SetValue(aux.tgoval)
    c:RegisterEffect(e1)

    -- ②：自己场上「魔心英雄」怪兽和比那只怪兽攻击力低的对方怪兽进行战斗的伤害计算前才能发动。自己场上的暗属性怪兽的攻击力上升400。
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
    e2:SetCode(EVENT_BATTLE_CONFIRM)
    e2:SetRange(LOCATION_FZONE)
    e2:SetCondition(s.atkcon)
    e2:SetOperation(s.atkop)
    c:RegisterEffect(e2)

   -- 效果③：自己·对方的结束阶段发动。场上暗属性以外的怪兽攻击力下降500。变成0的场合那怪兽破坏。
    local e4=Effect.CreateEffect(c)
    e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
    e4:SetCode(EVENT_PHASE+PHASE_END)
    e4:SetRange(LOCATION_FZONE)
    e4:SetCountLimit(1)
    e4:SetCondition(c10111162.descon)
    e4:SetOperation(c10111162.desop)
    c:RegisterEffect(e4)
end

-- ①：对方不能把自己场上攻击力最高的怪兽作为效果的对象。
function s.immtg(e,c)
    local g=Duel.GetMatchingGroup(nil,tp,LOCATION_MZONE,0,nil)
    if #g==0 then return false end
    local maxatk=g:GetMaxGroup(Card.GetAttack):GetFirst()
    return c==maxatk and c:IsControler(tp)
end

function s.efilter(e,te)
    return te:GetOwner()~=e:GetOwner()
end

-- ②：自己场上「魔心英雄」怪兽和比那只怪兽攻击力低的对方怪兽进行战斗的伤害计算前才能发动。自己场上的暗属性怪兽的攻击力上升400。
function s.atkcon(e,tp,eg,ep,ev,re,r,rp)
    local a=Duel.GetAttacker()
    local d=Duel.GetAttackTarget()
    if not d then return false end
    if d:IsControler(tp) then a,d=d,a end
    return a:IsSetCard(0x9008) and d:IsControler(1-tp) and d:GetAttack()<a:GetAttack()
end

function s.atkop(e,tp,eg,ep,ev,re,r,rp)
    local g=Duel.GetMatchingGroup(function(c) return c:IsFaceup() and c:IsAttribute(ATTRIBUTE_DARK) end,tp,LOCATION_MZONE,0,nil)
    local tc=g:GetFirst()
    while tc do
        local e1=Effect.CreateEffect(e:GetHandler())
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_UPDATE_ATTACK)
        e1:SetValue(400)
        e1:SetReset(RESET_EVENT+RESETS_STANDARD)
        tc:RegisterEffect(e1)
        tc=g:GetNext()
    end
end

-- 效果③的处理函数
function c10111162.descon(e,tp,eg,ep,ev,re,r,rp)
    return Duel.GetTurnPlayer()==tp or Duel.GetTurnPlayer()==1-tp
end

function c10111162.desop(e,tp,eg,ep,ev,re,r,rp)
    local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
    local tc=g:GetFirst()
    while tc do
        if not tc:IsAttribute(ATTRIBUTE_DARK) then
            local e1=Effect.CreateEffect(e:GetHandler())
            e1:SetType(EFFECT_TYPE_SINGLE)
            e1:SetCode(EFFECT_UPDATE_ATTACK)
            e1:SetValue(-400)
            e1:SetReset(RESET_EVENT+RESETS_STANDARD)
            tc:RegisterEffect(e1)
            if tc:GetAttack()==0 then
                Duel.Destroy(tc,REASON_EFFECT)
            end
        end
        tc=g:GetNext()
    end
end
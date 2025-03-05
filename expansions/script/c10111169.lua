function c10111169.initial_effect(c)
	--cannot special summon
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_SINGLE_RANGE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetRange(LOCATION_DECK)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	c:RegisterEffect(e1)
	--summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(10111169,0))
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_SUMMON_PROC)
	e2:SetCondition(c10111169.ntcon)
	e2:SetOperation(c10111169.ntop)
	c:RegisterEffect(e2)
	local e5=e2:Clone()
	e5:SetCode(EFFECT_SET_PROC)
	c:RegisterEffect(e5)
    	--atkup
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetRange(LOCATION_MZONE)
	e3:SetValue(c10111169.val)
	c:RegisterEffect(e3)
	--summon success
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	e4:SetOperation(c10111169.regop)
	c:RegisterEffect(e4)
end
function c10111169.ntcon(e,c,minc)
	if c==nil then return true end
	return minc==0 and c:IsLevelAbove(5)
		and Duel.GetFieldGroupCount(c:GetControler(),LOCATION_MZONE,0)==0
		and Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
end
function c10111169.ntop(e,tp,eg,ep,ev,re,r,rp,c)
	--change base attack
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SET_BASE_ATTACK)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(2000)
	e1:SetReset(RESET_EVENT+0xff0000)
	c:RegisterEffect(e1)
end
function c10111169.val(e,c)
	return Duel.GetMatchingGroupCount(c10111169.filter,c:GetControler(),LOCATION_MZONE,LOCATION_MZONE,e:GetHandler())*500
end
function c10111169.filter(c)
	return c:IsFaceup() and c:IsRace(RACE_MACHINE)
end

-- ④效果组注册函数
function c10111169.regop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()

    -- 战斗伤害0
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetCode(EFFECT_AVOID_BATTLE_DAMAGE)
    e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e1:SetTargetRange(1,0)
    e1:SetCondition(c10111169.atkcon(3000)) -- 条件：攻击力≥3000
    e1:SetValue(1)
    e1:SetReset(RESET_EVENT+RESETS_STANDARD)
    c:RegisterEffect(e1)

    -- 不被战斗破坏
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_SINGLE)
    e2:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
    e2:SetCondition(c10111169.atkcon(3500)) -- 条件：攻击力≥3500
    e2:SetValue(1)
    e2:SetReset(RESET_EVENT+RESETS_STANDARD)
    c:RegisterEffect(e2)

    -- 穿防伤害
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_SINGLE)
    e3:SetCode(EFFECT_PIERCE)
    e3:SetCondition(c10111169.atkcon(4000)) -- 条件：攻击力≥4000
    e3:SetValue(1)
    e3:SetReset(RESET_EVENT+RESETS_STANDARD)
    c:RegisterEffect(e3)

   -- 效果无效（4500以上）
    local e4=Effect.CreateEffect(c)
    e4:SetDescription(aux.Stringid(10111169,1))
    e4:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
    e4:SetType(EFFECT_TYPE_QUICK_O)
    e4:SetCode(EVENT_CHAINING)
    e4:SetRange(LOCATION_MZONE)
    e4:SetCountLimit(1) -- 1回合1次
    e4:SetCondition(c10111169.atkcon(4500))
    e4:SetTarget(c10111169.distg)
    e4:SetOperation(c10111169.disop)
    e4:SetReset(RESET_EVENT+RESETS_STANDARD)
    c:RegisterEffect(e4)
end

-- 攻击力条件检查函数
function c10111169.atkcon(val)
    return function(e)
        local c=e:GetHandler()
        return c:IsAttackAbove(val)
    end
end

-- 共用效果函数 --
function c10111169.distg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
    if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
        Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
    end
end

function c10111169.disop(e,tp,eg,ep,ev,re,r,rp)
    if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
        Duel.Destroy(eg,REASON_EFFECT)
    end
end
--地狱黑鲨 雷斯
local s,id,o=GetID()
function s.initial_effect(c)

	-- 这张卡不能通常召唤，把对方场上1只怪兽送去墓地的场合可以从手卡特殊召唤
	c:EnableReviveLimit()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_SPSUM_PARAM)
	e1:SetRange(LOCATION_HAND)
	e1:SetTargetRange(POS_FACEUP,0)
	e1:SetCondition(s.spcon)
	e1:SetTarget(s.sptg)
	e1:SetOperation(s.spop)
	c:RegisterEffect(e1)
	
	-- 把这张卡特殊召唤的回合，自己不能把卡的效果发动
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_SPSUMMON_COST)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetCost(s.spcost)
	e2:SetOperation(s.spcop)
	c:RegisterEffect(e2)
	Duel.AddCustomActivityCounter(id,ACTIVITY_CHAIN,function(re,tp,cid) return false end)
	
	-- 「地狱黑鲨 雷斯」在自己场上只能有1张表侧表示存在
	c:SetUniqueOnField(1,0,id)
	
	-- 自己·对方的主要阶段内，场上的这张卡不受其他卡的效果影响
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_IMMUNE_EFFECT)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetValue(s.efilter)
	c:RegisterEffect(e3)
	
	-- 这张卡可以向对方怪兽全部各作1次攻击，向守备表示怪兽攻击的场合，给与对方为攻击力超过那个守备力的数值的战斗伤害
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_ATTACK_ALL)
	e4:SetValue(1)
	c:RegisterEffect(e4)
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetCode(EFFECT_PIERCE)
	c:RegisterEffect(e5)
end

-- 这张卡不能通常召唤，把对方场上1只怪兽送去墓地的场合可以从手卡特殊召唤
function s.spfilter(c,tp)
    return c:IsAbleToGraveAsCost() and Duel.GetMZoneCount(tp,c,tp)>0
end

function s.spcon(e,c)
    if c==nil then return true end
    local tp=c:GetControler()
    return Duel.IsExistingMatchingCard(s.spfilter,tp,0,LOCATION_MZONE,1,nil,tp)
end

function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk,c)
    local g=Duel.GetMatchingGroup(s.spfilter,tp,0,LOCATION_MZONE,nil,tp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
    local sg=g:Select(tp,1,1,nil)
    if #sg>0 then
        e:SetLabelObject(sg:GetFirst())
        return true
    end
    return false
end

function s.spop(e,tp,eg,ep,ev,re,r,rp,c)
    local tc=e:GetLabelObject()
    if tc then
        Duel.SendtoGrave(tc,REASON_COST+REASON_SPSUMMON)
    end
end

-- 把这张卡特殊召唤的回合，自己不能把卡的效果发动
function s.spcost(e,c,tp)
    return Duel.GetCustomActivityCount(id,tp,ACTIVITY_CHAIN)==0
end

function s.spcop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetTargetRange(1,0)
	e1:SetValue(1)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end

-- 自己·对方的主要阶段内，场上的这张卡不受其他卡的效果影响
function s.efilter(e,te)
    if Duel.IsMainPhase() then
        return te:GetOwner()~=e:GetOwner()
    end
    return false
end

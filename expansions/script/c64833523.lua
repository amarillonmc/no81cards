-- 蚀日龙 摩斯迪露姆
local s,id=GetID()

function s.initial_effect(c)
	-- 融合素材设定修正
	c:EnableReviveLimit()
	aux.AddFusionProcCodeFun(c,64833501,s.ffilter,2,true,true)
	
	-- ① 多效果处理
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(s.effcon)
	e1:SetOperation(s.effop)
	c:RegisterEffect(e1)
	
	-- 返回额外卡组效果
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_PHASE+PHASE_END)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCondition(s.retcon)
	e2:SetOperation(s.retop)
	c:RegisterEffect(e2)
end

-- 融合素材属性验证
function s.codefilter(c)
	return not c:IsCode(64833501)
end
function s.ffilter(c,fc,sub,mg,sg)
	return  (not sg or not sg:Filter(s.codefilter,nil):IsExists(Card.IsFusionAttribute,1,c,c:GetFusionAttribute()))
end

-- 原持有者检测函数（用户指定版本）
function s.ownerfilter(c,tp)
	return c:GetOwner()==tp and not c:IsCode(64833501,64833503)
end

-- 获取素材所有权情况
function s.get_owner_case(c)
	local mat=c:GetMaterial()
	local self_count=mat:FilterCount(s.ownerfilter,nil,c:GetControler())
	local oppo_count=mat:FilterCount(s.ownerfilter,nil,1-c:GetControler())
	
	if self_count>0 and oppo_count>0 then
		return 3 -- 双方
	elseif oppo_count>0 then
		return 2 -- 只有对方
	else
		return 1 -- 只有自己
	end
end

-- ① 效果条件判断
function s.effcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_FUSION)
end

function s.effop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local case=s.get_owner_case(e:GetHandler())
	
	-- Case 1: 只有自己
	if case==1 then
		-- 对方怪兽攻防半减
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_SET_ATTACK_FINAL)
		e1:SetRange(LOCATION_MZONE)
		e1:SetTargetRange(0,LOCATION_MZONE)
		e1:SetValue(function(e,c) return math.ceil(c:GetAttack()/2) end)
		c:RegisterEffect(e1)
		
		local e2=e1:Clone()
		e2:SetCode(EFFECT_SET_DEFENSE_FINAL)
		e2:SetValue(function(e,c) return math.ceil(c:GetDefense()/2) end)
		c:RegisterEffect(e2)
		
		-- 效果无效化
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_FIELD)
		e3:SetCode(EFFECT_DISABLE)
		e3:SetRange(LOCATION_MZONE)
		e3:SetTargetRange(0,LOCATION_MZONE)
		c:RegisterEffect(e3)
		
		local e4=e3:Clone()
		e4:SetCode(EFFECT_DISABLE_EFFECT)
		c:RegisterEffect(e4)
	
	-- Case 2: 只有对方
	elseif case==2 then
		-- 战斗伤害0
		local e5=Effect.CreateEffect(c)
		e5:SetType(EFFECT_TYPE_SINGLE)
		e5:SetCode(EFFECT_AVOID_BATTLE_DAMAGE)
		e5:SetValue(1)
		c:RegisterEffect(e5)
	end
end

-- 返回额外条件修正
function s.retcon(e,tp,eg,ep,ev,re,r,rp)
	return s.get_owner_case(e:GetHandler())==3
		and Duel.GetTurnCount()==e:GetHandler():GetTurnID()
end

function s.retop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.SendtoDeck(c,nil,2,REASON_EFFECT)
end
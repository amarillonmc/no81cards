-- 白夜龙 摩斯迪露姆
local s,id=GetID()

function s.initial_effect(c)
	-- 融合素材设定
	c:EnableReviveLimit()
	aux.AddFusionProcCodeFun(c,64833501,s.ffilter,2,true,true)
	
	-- 效果持续系统
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(s.effcon)
	e1:SetOperation(s.regop)
	c:RegisterEffect(e1)
	
	-- 返回系统
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_PHASE+PHASE_END)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCondition(s.retcon)
	e2:SetOperation(s.retop)
	c:RegisterEffect(e2)
end

-- 融合素材属性验证（相同属性）
function s.ffilter(c,fc,sub,mg,sg)
	return  (not sg or sg:IsExists(Card.IsFusionAttribute,1,c,c:GetFusionAttribute()))
end

-- 原持有者判断系统
function s.ownerfilter(c,tp)
	return c:GetOwner()==tp and not c:IsCode(64833501,64833503)
end

function s.get_case(c)
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

-- 效果注册主函数
function s.regop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local case=s.get_case(c)
	
	-- Case1: 只有自己素材
	if case==1 then
		-- 封锁召唤/特殊召唤/送墓时效果发动
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_SUMMON_SUCCESS)
		e1:SetRange(LOCATION_MZONE)
		e1:SetOperation(s.disop)
		c:RegisterEffect(e1)
		
		local e2=e1:Clone()
		e2:SetCode(EVENT_SPSUMMON_SUCCESS)
		c:RegisterEffect(e2)
		
		local e3=e1:Clone()
		e3:SetCode(EVENT_TO_GRAVE)
		c:RegisterEffect(e3)
	
	-- Case2: 只有对方素材
	elseif case==2 then
		-- 禁止直接攻击
		local e4=Effect.CreateEffect(c)
		e4:SetType(EFFECT_TYPE_FIELD)
		e4:SetCode(EFFECT_CANNOT_DIRECT_ATTACK)
		e4:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
		e4:SetRange(LOCATION_MZONE)
		e4:SetTargetRange(LOCATION_MZONE,0)
		c:RegisterEffect(e4)
	end
end

-- 效果封锁操作
function s.disop(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	if tc and tc:IsControler(1-tp) and tc:IsType(TYPE_MONSTER) then
		Duel.SetChainLimitTillChainEnd(s.chlimit)
	end
end
function s.chlimit(e,ep,tp)
	return tp==ep
end

-- 返回条件判断
function s.retcon(e,tp,eg,ep,ev,re,r,rp)
	return s.get_case(e:GetHandler())==3 and Duel.GetTurnCount()==e:GetHandler():GetTurnID()
end

-- 返回操作
function s.retop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.SendtoDeck(c,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
end
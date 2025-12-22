-- 连接怪兽：苦命鸳鸯
local s, id = GetID()
s.alpha_id = 95080110  -- 鸳鸯
s.beta_id = 95080120   -- 鸳鸯

function s.initial_effect(c)
	-- 连接召唤规则
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,s.matfilter,2,2)
	
	-- 效果：不能作为连接素材
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
	e0:SetValue(1)
	c:RegisterEffect(e0)
	
	-- 效果①：连接区没有鸳鸯β则破坏
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_SELF_DESTROY)
	e1:SetCondition(s.descon1)
	c:RegisterEffect(e1)
	
	-- 效果②：互相连接的怪兽攻击力上升2000
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e2:SetCondition(s.atkcon)
	e2:SetTarget(s.atktg)
	e2:SetValue(2000)
	c:RegisterEffect(e2)
	
	-- 效果③：限制特殊召唤和基本分变为0
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(1,0)
	e3:SetTarget(s.splimit)
	c:RegisterEffect(e3)
	
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_ADJUST)
	e4:SetRange(LOCATION_MZONE)
	e4:SetOperation(s.lpop)
	c:RegisterEffect(e4)
	
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e5:SetRange(LOCATION_MZONE)
	e5:SetValue(s.tglimit)
	c:RegisterEffect(e5)
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_SINGLE)
	e6:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e6:SetCode(EFFECT_SPSUMMON_CONDITION)
	e6:SetValue(aux.linklimit)
	c:RegisterEffect(e6)
end

-- 连接召唤素材检查
function s.matfilter(c)
	return c:IsCode(s.alpha_id) 
end
function s.tglimit(e,re,rp)
	local c=e:GetHandler()
	local tp=e:GetHandlerPlayer()
	-- 如果效果的发动者是这张卡的控制者（自己），则不能选为对象
	return rp==tp
end
-- 效果①：检查连接区是否有鸳鸯β
function s.descon1(e)
	local c=e:GetHandler()
	if not c:IsLocation(LOCATION_MZONE) then return false end
	
	-- 检查连接区是否有鸳鸯β
	local lg=c:GetLinkedGroup()
	if lg and lg:GetCount()>0 then
		-- 检查是否有效果没有被无效的鸳鸯β
		for tc in aux.Next(lg) do
			if tc:IsCode(s.beta_id) and s.is_effect_valid(tc) then
				return false  -- 有有效的鸳鸯β，不破坏
			end
		end
	end
	return true  -- 如果没有连接区怪兽，也没有鸳鸯β，则破坏
end

-- 效果②：攻击力上升条件
function s.atkcon(e)
	return e:GetHandler():IsLocation(LOCATION_MZONE)
end

-- 效果②：攻击力上升目标
function s.atktg(e,c)
	local tc=e:GetHandler()
	if not tc or not tc:IsLocation(LOCATION_MZONE) then return false end
	local lg=tc:GetMutualLinkedGroup()
	return lg and lg:IsContains(c)
end

-- 效果③：特殊召唤限制
function s.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return not (c:IsCode(s.alpha_id) or c:IsCode(s.beta_id) or c:IsCode(95080130) or c:IsCode(95080140))
end

-- 效果③：检查是否和对方控制的鸳鸯β互相连接
function s.lpop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsLocation(LOCATION_MZONE) then return end
	
	-- 检查是否和对方控制的鸳鸯β互相连接
	local lg=c:GetMutualLinkedGroup()
	if lg and lg:GetCount()>0 then
		local has_opponent_beta=false
		for tc in aux.Next(lg) do
			if tc:IsCode(s.beta_id) and s.is_effect_valid(tc) then --and tc:IsControler(1-tp)
				has_opponent_beta=true
				break
			end
		end
		
		-- 如果和对方控制的鸳鸯β互相连接，则基本分变为0
		if has_opponent_beta then
			Duel.SetLP(1-tp,0)
		end
	end
end
function s.is_effect_valid(c)
	-- 检查是否为表侧表示
	if not c:IsFaceup() then return false end
	
	-- 检查是否有无效状态（STATUS_DISABLED）
	if c:IsStatus(STATUS_DISABLED) then return false end
	
	-- 检查是否有其他无效效果影响（如技能抽取、效果遮蒙者等）
	-- 这里检查常见的无效效果类型
	if c:IsHasEffect(EFFECT_DISABLE) then return false end
	
	-- 检查是否为里侧表示（但上面已经检查过IsFaceup，所以不需要）
	-- 如果需要考虑暂时无效的情况，可以添加更多检查
	
	return true
end
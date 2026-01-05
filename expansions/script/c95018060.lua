--炽魂之格挡
local s, id = GetID()

-- 定义炽魂字段常量
s.soul_setcode = 0xa96c

function s.initial_effect(c)
	-- 连接召唤规则
	c:EnableCounterPermit(s.soul_setcode)
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,s.lfilter,1,1)
	--[[ 连接素材：除了自身以外的炎属性怪兽1只
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetCode(EFFECT_SPSUMMON_PROC)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetRange(LOCATION_EXTRA)
	e0:SetCondition(s.linkcon)
	e0:SetOperation(s.linkop)
	e0:SetValue(SUMMON_TYPE_LINK)
	c:RegisterEffect(e0)]]
	
	-- 一回合一次特殊召唤限制
   c:SetSPSummonOnce(id)
	
	-- 效果①：保护炽魂怪兽
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetTarget(s.protg)
	e2:SetValue(1)
	c:RegisterEffect(e2)
	
	local e3=e2:Clone()
	e3:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	c:RegisterEffect(e3)
	
	-- 效果②：成为连接素材时给予效果
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_BE_MATERIAL)
	e4:SetProperty(EFFECT_FLAG_EVENT_PLAYER)
	e4:SetCondition(s.matcon)
	e4:SetOperation(s.matop)
	c:RegisterEffect(e4)
end

-- 连接召唤条件：除了自身以外的炎属性怪兽1只
function s.lfilter(c)
	return c:IsAttribute(ATTRIBUTE_FIRE) and not c:IsCode(id)
end

function s.linkcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local mg=Duel.GetMatchingGroup(s.lfilter,tp,LOCATION_MZONE,0,nil,c,tp)
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and #mg>=1
end

function s.linkop(e,tp,eg,ep,ev,re,r,rp,c)
	local mg=Duel.SelectMatchingCard(tp,s.lfilter,tp,LOCATION_MZONE,0,1,1,nil,c,tp)
	c:SetMaterial(mg)
	Duel.SendtoGrave(mg,REASON_MATERIAL+REASON_LINK)
end

-- 效果①：保护目标（炽魂怪兽）
function s.protg(e,c)
	return c:IsSetCard(s.soul_setcode) and c~=e:GetHandler()
end

-- 效果②：成为连接素材的条件
function s.matcon(e,tp,eg,ep,ev,re,r,rp)
	return r==REASON_LINK
end

-- 效果②：给予连接怪兽效果
function s.matop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rc=c:GetReasonCard()
	
	if rc and rc:IsSetCard(s.soul_setcode) then
		-- 给予放置指示物效果
		local e1=Effect.CreateEffect(c)
		e1:SetDescription(aux.Stringid(id,1))
		e1:SetCategory(CATEGORY_COUNTER)
		e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
		e1:SetCode(EVENT_SPSUMMON_SUCCESS)
		e1:SetCondition(s.ctcon)
		e1:SetTarget(s.cttg)
		e1:SetOperation(s.ctop)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		rc:RegisterEffect(e1,true)
		
		 -- 传递效果给下一个连接怪兽
		 local e2=Effect.CreateEffect(c)
		 e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
		 e2:SetCode(EVENT_BE_MATERIAL)
		 e2:SetProperty(EFFECT_FLAG_EVENT_PLAYER)
		 e2:SetCondition(s.nextcon)
		 e2:SetOperation(s.nextop)
		 rc:RegisterEffect(e2,true)
	end
end

-- 放置指示物条件
function s.ctcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end

function s.cttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_COUNTER,nil,2,0,s.soul_setcode)
end

function s.ctop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsFaceup() and c:IsRelateToEffect(e) then
		c:AddCounter(s.soul_setcode,1)
	end
end

-- 给予属性变更和传递效果
function s.giveattribute(tc)
	if not tc then return end
	
	-- 属性变更为光属性
	local e1=Effect.CreateEffect(tc)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CHANGE_ATTRIBUTE)
	e1:SetValue(ATTRIBUTE_LIGHT)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	tc:RegisterEffect(e1,true)
	
   
end

-- 传递效果条件
function s.nextcon(e,tp,eg,ep,ev,re,r,rp)
	return r==REASON_LINK
end

-- 传递效果操作
function s.nextop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rc=c:GetReasonCard()
	if rc then
		
		s.giveattribute(rc)
	end
end
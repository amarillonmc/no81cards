-- 激流之摩斯迪露姆
local s,id=GetID()

function s.initial_effect(c)
	-- 融合素材设定
	c:EnableReviveLimit()
	aux.AddFusionProcCodeFun(c,64833501,aux.FilterBoolFunction(Card.IsFusionAttribute,ATTRIBUTE_WATER),1,true,true)
	
	-- ① 全場破坏效果
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1,id)
	e1:SetCondition(s.descon)
	e1:SetTarget(s.destg)
	e1:SetOperation(s.desop)
	c:RegisterEffect(e1)
	
	-- ② 特殊召唤限制
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(0,1)
	e2:SetCondition(s.splimcon)
	e2:SetTarget(s.splimit)
	c:RegisterEffect(e2)
end

-- 原持有者检测函数
function s.ownfilter(c,tp)
	return c:GetOwner()==tp
end

-- ① 条件判断
function s.descon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsSummonType(SUMMON_TYPE_FUSION) 
		and c:GetMaterial():FilterCount(s.ownfilter,nil,tp)==c:GetMaterial():GetCount()
end

-- ① 目标设置
function s.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local g=Duel.GetMatchingGroup(nil,tp,LOCATION_MZONE,LOCATION_MZONE,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,#g,0,0)
end

-- ① 破坏操作
function s.desop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(nil,tp,LOCATION_MZONE,LOCATION_MZONE,e:GetHandler())
	if #g>0 then
		Duel.Destroy(g,REASON_EFFECT)
	end
	local c=e:GetHandler()
	if c:GetMaterial():FilterCount(s.ownfilter,nil,e:GetHandlerPlayer())>=2 then
		c:RegisterFlagEffect(0,RESET_EVENT+0x1fe0000,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(64833501,0))
	end
end

-- ② 条件判断
function s.splimcon(e)
	local c=e:GetHandler()
	return c:IsSummonType(SUMMON_TYPE_FUSION) 
		and c:GetMaterial():FilterCount(s.ownfilter,nil,e:GetHandlerPlayer())>=2
end

-- ② 特殊召唤限制
function s.splimit(e,c,sump,sumtype,sumpos,targetp)
	return Duel.GetActivityCount(1-e:GetHandlerPlayer(),ACTIVITY_SPSUMMON)>=2
end
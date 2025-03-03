-- 爆炎之摩斯迪露姆
local s,id=GetID()

function s.initial_effect(c)
	-- 融合素材设定
	c:EnableReviveLimit()
	aux.AddFusionProcCodeFun(c,64833501,aux.FilterBoolFunction(Card.IsFusionAttribute,ATTRIBUTE_FIRE),1,true,true)
	
	-- ① 破坏+伤害效果
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_DAMAGE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1,id)
	e1:SetCondition(s.descon)
	e1:SetTarget(s.destg)
	e1:SetOperation(s.desop)
	c:RegisterEffect(e1)
	
	-- ② 对象限制
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_SET_AVAILABLE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(LOCATION_ONFIELD,LOCATION_ONFIELD)
	e2:SetCondition(s.tgcon)
	e2:SetTarget(s.tgtg)
	e2:SetValue(aux.tgoval)
	c:RegisterEffect(e2)
end

-- 共用原持有者检测函数
function s.ownfilter(c,tp)
	return c:GetOwner()==tp
end

-- ① 效果判断
function s.descon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsSummonType(SUMMON_TYPE_FUSION) 
		and c:GetMaterial():IsExists(s.ownfilter,1,nil,tp)
		and c:GetMaterial():FilterCount(s.ownfilter,nil,tp)==c:GetMaterial():GetCount()
end

function s.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local g=Duel.GetMatchingGroup(nil,tp,0,LOCATION_MZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,#g,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,0)
end

function s.desop(e,tp,eg,ep,ev,re,r,rp)
	-- 破坏处理
	local g=Duel.GetMatchingGroup(nil,tp,0,LOCATION_MZONE,nil)
	Duel.Destroy(g,REASON_EFFECT)
	
	-- 伤害计算
	local og=Duel.GetMatchingGroup(nil,tp,0,LOCATION_MZONE,nil)
	local dam=og:GetSum(Card.GetBaseAttack)
	if dam>0 then
		Duel.Damage(1-tp,dam,REASON_EFFECT)
	end
	local c=e:GetHandler()
	if c:GetMaterial():FilterCount(s.ownfilter,nil,e:GetHandlerPlayer())>=2 then
		c:RegisterFlagEffect(0,RESET_EVENT+0x1fe0000,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(64833501,0))
	end
end

-- ② 效果判断
function s.tgcon(e)
	local c=e:GetHandler()
	return c:GetMaterial():FilterCount(s.ownfilter,nil,e:GetHandlerPlayer())>=2
end

function s.tgtg(e,c)
	return c~=e:GetHandler()
end
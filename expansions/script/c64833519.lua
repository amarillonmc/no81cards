-- 飓风之摩斯迪露姆
local s,id=GetID()

function s.initial_effect(c)
	-- 融合素材设定
	c:EnableReviveLimit()
	aux.AddFusionProcCodeFun(c,64833501,aux.FilterBoolFunction(Card.IsFusionAttribute,ATTRIBUTE_WIND),1,true,true)
	
	-- ① 弹回魔法陷阱效果
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_TODECK)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1,id)
	e1:SetCondition(s.tdcon)
	e1:SetTarget(s.tdtg)
	e1:SetOperation(s.tdop)
	c:RegisterEffect(e1)
	
	-- ② 魔法发动限制系统
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_ACTIVATE)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(0,1) -- 仅影响对方
	e2:SetCondition(s.bancon)
	e2:SetValue(s.aclimit)
	c:RegisterEffect(e2)
	
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_SSET)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(s.bancon)
	e3:SetOperation(s.regop)
	c:RegisterEffect(e3)
end

-- 原持有者检测函数
function s.ownfilter(c,tp)
	return c:GetOwner()==tp
end

-- ① 弹回效果判断
function s.tdcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsSummonType(SUMMON_TYPE_FUSION) 
		and c:GetMaterial():FilterCount(s.ownfilter,nil,tp)==c:GetMaterial():GetCount()
end

function s.tdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local g=Duel.GetMatchingGroup(Card.IsType,1-tp,LOCATION_STZONE+LOCATION_FZONE,0,nil,TYPE_SPELL+TYPE_TRAP)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,#g,0,0)
end

function s.tdop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsType,1-tp,LOCATION_STZONE+LOCATION_FZONE,0,nil,TYPE_SPELL+TYPE_TRAP)
	if #g>0 then
		Duel.SendtoDeck(g,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
	end
	local c=e:GetHandler()
	if c:GetMaterial():FilterCount(s.ownfilter,nil,e:GetHandlerPlayer())>=2 then
		c:RegisterFlagEffect(0,RESET_EVENT+0x1fe0000,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(64833501,0))
	end
end

-- ② 魔法限制条件判断
function s.bancon(e)
	local c=e:GetHandler()
	return c:IsSummonType(SUMMON_TYPE_FUSION) 
		and c:GetMaterial():FilterCount(s.ownfilter,nil,e:GetHandlerPlayer())>=2
end
-- 魔法发动限制条件
function s.aclimit(e,re,tp)
	return re:IsHasType(EFFECT_TYPE_ACTIVATE) 
		and re:GetHandler():IsType(TYPE_SPELL)
		and (not re:GetHandler():IsLocation(LOCATION_SZONE) 
			or re:GetHandler():GetFlagEffect(id)==0)
end

-- 盖放标记处理
function s.regop(e,tp,eg,ep,ev,re,r,rp)
	for tc in aux.Next(eg:Filter(Card.IsControler,nil,1-tp)) do
		-- 设置下回合可用的标记
		tc:RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
	end
end
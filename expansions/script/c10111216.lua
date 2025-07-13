local s,id,o=GetID()
function s.initial_effect(c)
	c:SetSPSummonOnce(id)
	c:EnableReviveLimit()
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e1:SetCondition(s.spcon)
	c:RegisterEffect(e1)
	-- 添加全局效果监控魔法·陷阱卡发动
	local ge1=Effect.CreateEffect(c)
	ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	ge1:SetCode(EVENT_CHAINING)
	ge1:SetOperation(s.regop)
	Duel.RegisterEffect(ge1,0)
	-- 修复后的破坏效果：确保能正确响应魔法卡发动
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,0))
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_QUICK_O)  -- 快速效果
	e2:SetCode(EVENT_CHAINING)       -- 响应连锁事件
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCondition(s.descon)
	e2:SetTarget(s.destg)
	e2:SetOperation(s.desop)
	c:RegisterEffect(e2)
    	--to deck
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,1))
	e3:SetCategory(CATEGORY_TODECK)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetCondition(s.tdcon)
	e3:SetTarget(s.tdtg)
	e3:SetOperation(s.tdop)
	c:RegisterEffect(e3)
end

-- 记录对方魔法·陷阱卡发动
function s.regop(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	if re:IsHasType(TYPE_SPELL+TYPE_TRAP) then
		local p=re:GetHandlerPlayer()
		local opp=1-p
		Duel.RegisterFlagEffect(opp,id,RESET_DISABLE,0,1)
	end
end

-- 特殊召唤条件
function s.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	-- 检查自己是否有标记（表示对方发动过魔法·陷阱卡）
	return Duel.GetFlagEffect(tp,id)>0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
end

-- 记录对方魔法·陷阱卡发动
function s.regop(e,tp,eg,ep,ev,re,r,rp)
	if re:IsActiveType(TYPE_SPELL+TYPE_TRAP) then
		local p=re:GetHandlerPlayer()
		local opp=1-p
		Duel.RegisterFlagEffect(opp,id,RESET_DISABLE,0,1)
	end
end

-- 特殊召唤条件
function s.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetFlagEffect(tp,id)>0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
end

-- 修复后的破坏效果触发条件
function s.descon(e,tp,eg,ep,ev,re,r,rp)
	-- 检查是否是对方发动的魔法/陷阱卡
	return rp==1-tp and re:IsActiveType(TYPE_SPELL+TYPE_TRAP)
end

-- 破坏效果的目标设置
function s.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(nil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,1,0,LOCATION_ONFIELD)
end

-- 破坏效果的操作
function s.desop(e,tp,eg,ep,ev,re,r,rp)
	-- 防止对方连锁
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetTargetRange(0,1)
	e1:SetValue(1)
	e1:SetReset(RESET_CHAIN)  -- 只在当前连锁有效
	Duel.RegisterEffect(e1,tp)
	
	-- 让玩家选择场上任意1张卡破坏
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectMatchingCard(tp,nil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	if #g>0 then
		Duel.Destroy(g,REASON_EFFECT)
	end
end

function s.tdcon(e,tp,eg,ep,ev,re,r,rp)
	local loc=e:GetHandler():GetPreviousLocation()
	return loc&(LOCATION_HAND|LOCATION_DECK)==0
end
function s.tdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,e:GetHandler(),1,0,0)
end
function s.tdop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsRelateToEffect(e) then
		Duel.SendtoDeck(e:GetHandler(),nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
	end
end
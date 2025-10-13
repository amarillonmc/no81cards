-- 同步怪兽：鸣神将军
local s, id = GetID()

function s.initial_effect(c)
	-- 同步召唤设置
	c:EnableReviveLimit()
	aux.AddSynchroProcedure(c,aux.FilterBoolFunction(Card.IsCode,95075010),aux.NonTuner(nil),1,1)
	
	-- 效果①：卡名当作雷电将军使用
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_CHANGE_CODE)
	e1:SetValue(95075030)
	c:RegisterEffect(e1)
	
	-- 效果②：同调召唤时解放鸣神怪兽封锁对方魔陷区
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,0))
	e2:SetCategory(CATEGORY_DISABLE)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCountLimit(1,id)
	e2:SetCondition(s.lockcon)
	e2:SetCost(s.lockcost)
	e2:SetTarget(s.locktg)
	e2:SetOperation(s.lockop)
	c:RegisterEffect(e2)
end

-- 效果②：同调召唤成功条件
function s.filter1(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function s.lockcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_SYNCHRO)
end

-- 效果②：代价（解放自己场上1只表侧表示鸣神怪兽）
function s.costfilter(c,tp)
	return c:IsFaceup() and c:IsSetCard(0x396e) and c:IsReleasable()
end

function s.lockcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.costfilter,tp,LOCATION_MZONE,0,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local g=Duel.SelectMatchingCard(tp,s.costfilter,tp,LOCATION_MZONE,0,1,1,e:GetHandler())
	Duel.Release(g,REASON_COST)
end

-- 效果②：目标设定
function s.locktg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.filter1,tp,0,LOCATION_ONFIELD,1,c) end
	Duel.SetChainLimit(aux.FALSE)
end

-- 效果②：操作处理
function s.lockop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	
	-- 里侧表示的魔法·陷阱卡不能发动
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetTargetRange(0,1)
	e1:SetValue(s.aclimit1)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	
	-- 表侧表示的魔法·陷阱卡效果无效化
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_DISABLE)
	e2:SetTargetRange(0,LOCATION_SZONE)
	e2:SetTarget(s.distg)
	e2:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e2,tp)
	
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_CHAIN_SOLVING)
	e3:SetOperation(s.disop)
	e3:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e3,tp)
end

-- 里侧魔陷不能发动
function s.aclimit1(e,re,tp)
	return re:IsHasType(EFFECT_TYPE_ACTIVATE) and re:GetHandler():IsFacedown()
end

-- 表侧魔陷无效化
function s.distg(e,c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsFaceup()
end

function s.disop(e,tp,eg,ep,ev,re,r,rp)
	if rp==1-tp and re:IsActiveType(TYPE_SPELL+TYPE_TRAP) and re:GetHandler():IsFaceup() then
		Duel.NegateEffect(ev)
	end
end
local s, id = GetID()

function s.initial_effect(c)

	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
	
	-- 效果①：战斗伤害回复
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_BATTLE_DAMAGE)
	e1:SetRange(LOCATION_SZONE)
	e1:SetCondition(s.lpcon)
	e1:SetOperation(s.lpop)
	c:RegisterEffect(e1)
	
	-- 效果②：破坏时给予伤害
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,0))
	e2:SetCategory(CATEGORY_DAMAGE)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_DESTROYED)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1,id)
	e2:SetCondition(s.damcon)
	e2:SetTarget(s.damtg)
	e2:SetOperation(s.damop)
	c:RegisterEffect(e2)
end

-- ===== 效果①处理 =====
function s.lpfilter(c)
	return c:IsSetCard(0x3962) and c:IsRace(RACE_INSECT) -- 
end

function s.lpcon(e,tp,eg,ep,ev,re,r,rp)
	return ep==1-tp and eg:IsExists(s.lpfilter,1,nil)
end

function s.lpop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Recover(tp,ev,REASON_EFFECT)
end

-- ===== 效果②处理 =====
function s.cfilter(c,tp)
	return c:IsPreviousControler(tp) and c:IsReason(REASON_BATTLE+REASON_EFFECT)
		and c:IsSetCard(0x3962) and c:IsRace(RACE_INSECT)
		and c:GetPreviousAttackOnField()>0
end

function s.damcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(s.cfilter,1,nil,tp) and rp==1-tp
end

function s.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local g=eg:Filter(s.cfilter,nil,tp)
	local dam=g:GetSum(Card.GetPreviousAttackOnField)
	Duel.SetTargetPlayer(1-tp)
	Duel.SetTargetParam(dam)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,dam)
end

function s.damop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Damage(p,d,REASON_EFFECT)
end
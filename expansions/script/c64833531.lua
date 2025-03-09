-- 颂乐魔君 尘封之欧布里维斯
local s,id=GetID()
function s.initial_effect(c)
	c:EnableReviveLimit()
	-- 效果①
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DISABLE+CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,id)
	e1:SetCondition(s.discon)
	e1:SetCost(s.discost)
	e1:SetTarget(s.distg)
	e1:SetOperation(s.disop)
	c:RegisterEffect(e1)
	
	-- 效果②
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCountLimit(1,id+1)
	e2:SetCondition(s.atkcon)
	e2:SetOperation(s.atkop)
	c:RegisterEffect(e2)
end

-- 效果①辅助函数：单属性匹配检查
function s.attrcomp(c,tc)
	local count=0
	if c:GetRace()==tc:GetRace() then count=count+1 end
	if c:GetAttribute()==tc:GetAttribute() then count=count+1 end
	if c:GetLevel()==tc:GetLevel() then count=count+1 end
	if c:GetAttack()==tc:GetAttack() then count=count+1 end
	if c:GetDefense()==tc:GetDefense() then count=count+1 end
	return count==1
end
function s.disfilter(c,tc)
	return c:IsType(TYPE_MONSTER) and c:IsDiscardable() and s.attrcomp(c,tc)
end
function s.discon(e,tp,eg,ep,ev,re,r,rp)
	return re:IsActiveType(TYPE_MONSTER) and Duel.IsChainDisablable(ev)
end

function s.discost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsDiscardable() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST+REASON_DISCARD)
end

function s.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.disfilter,tp,LOCATION_HAND,0,1,nil,re:GetHandler()) end
end

function s.disop(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
	local g=Duel.SelectMatchingCard(tp,s.disfilter,tp,LOCATION_HAND,0,1,1,nil,rc)
	if #g>0 and Duel.SendtoGrave(g,REASON_EFFECT+REASON_DISCARD)>0 then
		if Duel.NegateEffect(ev) then
			Duel.Remove(rc,POS_FACEUP,REASON_EFFECT)
		end
	end
end

-- 效果②
function s.atkcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_RITUAL)
end

function s.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	-- 攻击力减半
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SET_ATTACK_FINAL)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e1:SetTarget(function(e,tc) return tc~=c end)
	e1:SetValue(function(e,c) return math.ceil(c:GetAttack()/2) end)
	e1:SetReset(RESET_PHASE+PHASE_END,2)
	Duel.RegisterEffect(e1,tp)
	-- 效果发动限制
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_ACTIVATE)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetTargetRange(0,1)
	e2:SetValue(function(e,re) return re:GetHandler():IsLocation(LOCATION_MZONE) and re:GetHandler():GetAttack()<=1200 end)
	e2:SetReset(RESET_PHASE+PHASE_END,2)
	Duel.RegisterEffect(e2,tp)
end
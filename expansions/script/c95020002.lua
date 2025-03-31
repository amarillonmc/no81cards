local s, id = GetID()
function s.initial_effect(c)
	-- 效果①：战斗伤害提升攻击力
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_ATKCHANGE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_BATTLE_DAMAGE)
	e1:SetCondition(s.atkcon)
	e1:SetOperation(s.atkop)
	c:RegisterEffect(e1)
	
	-- 效果②：抗性保护
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_CANNOT_BE_BATTLE_TARGET)
	e2:SetCondition(s.tgcon)
	e2:SetValue(1)
	c:RegisterEffect(e2)
	
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(s.tgcon)
	e3:SetValue(aux.tgoval)
	c:RegisterEffect(e3)
	
	-- 效果③：直接攻击
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_DIRECT_ATTACK)
	c:RegisterEffect(e4)
end

--===== 效果①处理 =====--
function s.atkcon(e,tp,eg,ep,ev,re,r,rp)
	return ep==1-tp
end

function s.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(100)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		c:RegisterEffect(e1)
	end
end

--===== 效果②处理 =====--
function s.ff(c)
	return c:GetAttack()>=1500 
end
function s.tgcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetMatchingGroup(s.ff,tp,0,LOCATION_MZONE,nil)
end
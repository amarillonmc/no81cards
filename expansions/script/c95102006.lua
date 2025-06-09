--馄饨剩汤 菜肉混陷
function c95102006.initial_effect(c)
	-- 融合素材
	c:EnableReviveLimit()
	aux.AddFusionProcFunRep(c,aux.FilterBoolFunction(Card.IsFusionSetCard,0xbbc),2,true)
	-- 效果抗性
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(95102006,0))
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(c95102006.con1)
	e1:SetValue(c95102006.filter1)
	c:RegisterEffect(e1)
	-- 攻击上升
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(95102006,1))
	e3:SetCategory(CATEGORY_ATKCHANGE)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_PHASE+PHASE_BATTLE_START)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetTarget(c95102006.tg2)
	e3:SetOperation(c95102006.op2)
	c:RegisterEffect(e3)
end
-- 1
function c95102006.con1(e)
	local tp=e:GetHandlerPlayer()
	return Duel.GetLP(tp)<=Duel.GetLP(1-tp) and e:GetHandler():IsSummonType(SUMMON_TYPE_FUSION)
end
function c95102006.filter1(e,re)
	return e:GetHandlerPlayer()~=re:GetOwnerPlayer() and re:IsActivated()
end
-- 2
function c95102006.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return math.abs(Duel.GetLP(tp)-Duel.GetLP(1-tp))>0 end
end
function c95102006.op2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsFaceup() and c:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e1:SetRange(LOCATION_MZONE)
		e1:SetValue(math.abs(Duel.GetLP(tp)-Duel.GetLP(1-tp)))
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
		c:RegisterEffect(e1)
	end
end

--馄饨剩汤 聚合三鲜
function c95102007.initial_effect(c)
	c:SetUniqueOnField(1,0,95102007)
	-- 融合素材
	c:EnableReviveLimit()
	aux.AddFusionProcFunRep(c,aux.FilterBoolFunction(Card.IsFusionSetCard,0xbbc),3,true)
	-- 战阶禁言
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(95102007,0))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(0,1)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(1)
	e1:SetCondition(c95102007.con1)
	c:RegisterEffect(e1)
	-- 攻击翻倍
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(95102007,1))
	e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCondition(c95102007.con2)
	e2:SetOperation(c95102007.op2)
	c:RegisterEffect(e2)
	-- 多次攻击
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(95102007,2))
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_EXTRA_ATTACK)
	e3:SetCondition(c95102007.con3)
	e3:SetValue(2)
	c:RegisterEffect(e3)
end
-- 1
function c95102007.con1(e)
	local ph=Duel.GetCurrentPhase()
	return ph>=PHASE_BATTLE_START and ph<=PHASE_BATTLE
end
-- 2
function c95102007.con2(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_FUSION)
end
function c95102007.op2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SET_ATTACK)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE+RESET_PHASE+PHASE_END)
	e1:SetValue(c:GetBaseAttack()*2)
	c:RegisterEffect(e1)
end
-- 3
function c95102007.con3(e)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_FUSION)
end

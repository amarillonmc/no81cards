--馄饨剩汤开业大酬宾
function c95102018.initial_effect(c)
	-- Activate
    local e0=Effect.CreateEffect(c)
    e0:SetType(EFFECT_TYPE_ACTIVATE)
    e0:SetCode(EVENT_FREE_CHAIN)
    c:RegisterEffect(e0)
    -- 放置场地
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_SZONE)
    e1:SetCondition(c95102018.con1)
	e1:SetTarget(c95102018.tg1)
	e1:SetOperation(c95102018.op1)
	c:RegisterEffect(e1)
	-- 强制嘲讽
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_MUST_ATTACK)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTargetRange(0,LOCATION_MZONE)
	e2:SetCondition(c95102018.con2)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_MUST_ATTACK_MONSTER)
	e3:SetValue(c95102018.limit2)
	c:RegisterEffect(e3)
	-- 战伤翻倍
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_CHANGE_BATTLE_DAMAGE)
	e4:SetRange(LOCATION_SZONE)
	e4:SetTargetRange(LOCATION_MZONE,0)
	e4:SetTarget(c95102018.tg3)
	e4:SetValue(aux.ChangeBattleDamage(1,DOUBLE_DAMAGE))
	c:RegisterEffect(e4)
end
-- 1
function c95102018.con1(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFieldCard(tp,LOCATION_FZONE,0)==nil
end
function c95102018.filter1(c,tp)
	return c:IsCode(95102017) and not c:IsForbidden() and c:CheckUniqueOnField(tp)
end
function c95102018.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c95102018.filter1,tp,LOCATION_DECK,0,1,nil,tp) end
end
function c95102018.op1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local tc=Duel.SelectMatchingCard(tp,c95102018.filter1,tp,LOCATION_DECK,0,1,1,nil,tp):GetFirst()
	if tc then Duel.MoveToField(tc,tp,tp,LOCATION_FZONE,POS_FACEUP,true) end
end
-- 2
function c95102018.filter2(c)
	return c:IsFaceup() and c:IsSetCard(0xbbc)
end
function c95102018.con2(e)
	local tp=e:GetHandlerPlayer()
	return Duel.GetLP(tp)<=Duel.GetLP(1-tp) and Duel.IsExistingMatchingCard(c95102018.filter2,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil)
end
function c95102018.limit2(e,c)
	local g=Duel.GetMatchingGroup(c95102018.filter2,e:GetHandlerPlayer(),LOCATION_MZONE,0,nil):GetMaxGroup(Card.GetAttack)
	return g and g:IsContains(c)
end
-- 3
function c95102018.tg3(e,c)
	return c:IsSetCard(0xbbc)
end

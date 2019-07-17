--黑白的异梦少女 Monoko
xpcall(function() require("expansions/script/c71400001") end,function() require("script/c71400001") end)
function c71400045.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,yume.YumeCheck(c),aux.NonTuner(yume.YumeCheck(c)),1)
	c:EnableReviveLimit()
	--summon limit
	yume.AddYumeSummonLimit(c,1)
	--act limit
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(0,1)
	e1:SetValue(c71400045.aclimit)
	c:RegisterEffect(e1)
	--multi attack
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_EXTRA_ATTACK)
	e2:SetValue(4)
	e2:SetCondition(c71400045.con2)
	c:RegisterEffect(e2)
	Duel.AddCustomActivityCounter(71400045,ACTIVITY_CHAIN,c71400045.chainfilter)
	--pos
	local e2a=Effect.CreateEffect(c)
	e2a:SetDescription(aux.Stringid(71400045,0))
	e2a:SetCategory(CATEGORY_POSITION)
	e2a:SetType(EFFECT_TYPE_TRIGGER_F+EFFECT_TYPE_FIELD)
	e2a:SetCode(EVENT_PHASE+PHASE_BATTLE)
	e2a:SetRange(LOCATION_MZONE)
	e2a:SetCountLimit(1)
	e2a:SetCondition(c71400045.con2a)
	e2a:SetOperation(c71400045.op2a)
	c:RegisterEffect(e2a)
end
function c71400045.chainfilter(re,tp,cid)
	return not (re:GetHandler():IsCode(71400047) and re:IsHasType(EFFECT_TYPE_ACTIVATE))
end
function c71400045.aclimit(e,re,tp)
	return not re:IsHasType(EFFECT_TYPE_ACTIVATE) and re:IsActiveType(TYPE_SPELL+TYPE_TRAP) and not re:GetHandler():IsImmuneToEffect(e)
end
function c71400045.con2(e)
	return Duel.GetCustomActivityCount(71400045,e:GetHandlerPlayer(),ACTIVITY_CHAIN)>0
end
function c71400045.con2a(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c71400045.con2(e) and c:IsAttackPos() and c:GetBattledGroupCount()>0
end
function c71400045.op2a(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsAttackPos() then
		Duel.ChangePosition(c,POS_FACEUP_DEFENSE)
	end
end
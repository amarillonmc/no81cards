--皇刻龙 永尊龙
function c40009490.initial_effect(c)
	c:EnableReviveLimit()
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	c:RegisterEffect(e1)	
	--special summon rule
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_EXTRA)
	e2:SetCondition(c40009490.spcon)
	e2:SetOperation(c40009490.spop)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_CANNOT_DISABLE_SPSUMMON)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	c:RegisterEffect(e3)
	--summon success
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	e4:SetOperation(c40009490.sumsuc)
	c:RegisterEffect(e4)
	--atkup
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(40009490,0))
	e5:SetCategory(CATEGORY_ATKCHANGE)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e5:SetCode(EVENT_SPSUMMON_SUCCESS)
	e5:SetProperty(EFFECT_FLAG_DELAY)
	e5:SetCountLimit(1,40009490+EFFECT_COUNT_CODE_DUEL)
	e5:SetCondition(c40009490.atkcon)
	e5:SetOperation(c40009490.atkop)
	c:RegisterEffect(e5)
end
function c40009490.cfilter(c)
	return c:IsSetCard(0xf17) and c:IsType(TYPE_MONSTER) and c:IsAbleToRemoveAsCost()
		and (not c:IsLocation(LOCATION_MZONE) or c:IsFaceup())
end
function c40009490.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.IsExistingMatchingCard(c40009490.cfilter,tp,LOCATION_MZONE,0,1,nil)
		or (Duel.IsExistingMatchingCard(c40009490.cfilter,tp,LOCATION_GRAVE,0,1,nil) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0)
end
function c40009490.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=Duel.GetMatchingGroup(c40009490.cfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,0,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c40009490.sumsuc(e,tp,eg,ep,ev,re,r,rp)
	Duel.SetChainLimitTillChainEnd(c40009490.chlimit)
end
function c40009490.chlimit(e,ep,tp)
	return tp==ep
end
function c40009490.spfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xf17) and c:IsType(TYPE_MONSTER)
end
function c40009490.atkcon(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c40009490.spfilter,tp,LOCATION_REMOVED,0,nil)
	return g:GetClassCount(Card.GetCode)>=12
end
function c40009490.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	--local ct=10
	--for i=1,ct do 
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
		e2:SetDescription(aux.Stringid(40009490,1))
		e2:SetCode(EVENT_PHASE+PHASE_END)
		e2:SetRange(LOCATION_MZONE)
		e2:SetCountLimit(1)
		e2:SetCondition(c40009490.discon)
		--e2:SetTarget(c40009490.distg)
		e2:SetOperation(c40009490.disop)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		c:RegisterEffect(e2)
	--end
end
function c40009490.discon(e,tp,eg,ep,ev,re,r,rp)
	return tp==Duel.GetTurnPlayer()
	and e:GetHandler():GetFlagEffect(40009490)<12
end
function c40009490.disop(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_SKIP_TURN)
	e1:SetTargetRange(0,1)
	e1:SetReset(RESET_PHASE+PHASE_END+RESET_OPPO_TURN)
	Duel.RegisterEffect(e1,tp)
	e:GetHandler():RegisterFlagEffect(40009490,RESET_EVENT+RESETS_STANDARD,0,1)
end


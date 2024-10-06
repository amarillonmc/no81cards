--寒霜华符 连神天照
function c12869040.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,nil,2,4,c12869040.lcheck)
	--cannot be link material
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
	e1:SetValue(1)
	c:RegisterEffect(e1)
	--link as level
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetCode(EFFECT_ALLOW_SYNCHRO_KOISHI)
	e2:SetValue(function(e,c)
		return e:GetHandler():GetLink()
	end)
	c:RegisterEffect(e2)
	--add tuner type
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_TUNER)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE) 
	e3:SetCondition(c12869040.con)
	e3:SetValue(1)
	c:RegisterEffect(e3)	
	--mat effect
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_BE_MATERIAL)
	e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e4:SetCondition(c12869040.indcon)
	e4:SetOperation(c12869040.indop)
	c:RegisterEffect(e4)		
end
function c12869040.lcheck(g)
	return g:IsExists(Card.IsLinkSetCard,1,nil,0x6a70)
end
function c12869040.q(c)
	return c:IsFaceup() and c:IsSetCard(0x6a70)
end
function c12869040.con(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c12869040.q,tp,LOCATION_ONFIELD,0,1,e:GetHandler())
end
function c12869040.indcon(e,tp,eg,ep,ev,re,r,rp)
	return r==REASON_SYNCHRO
end
function c12869040.indop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rc=c:GetReasonCard()
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(12869040,0))
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_DISABLE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetProperty(EFFECT_FLAG_CLIENT_HINT+EFFECT_FLAG_NO_TURN_RESET)
	e1:SetCode(EVENT_CHAINING)
	e1:SetRange(LOCATION_MZONE)
	e1:SetHintTiming(0,TIMING_MAIN_END+TIMING_END_PHASE+TIMING_STANDBY_PHASE+TIMINGS_CHECK_MONSTER)
	e1:SetCountLimit(1)
	e1:SetTarget(aux.nbtg)
	e1:SetCondition(c12869040.condition)
	e1:SetOperation(c12869040.op)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	rc:RegisterEffect(e1,true)
end
function c12869040.condition(e,tp,eg,ep,ev,re,r,rp)
	return rp==1-tp and not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) and Duel.IsChainNegatable(ev)
end
function c12869040.op(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
		Duel.Remove(eg,POS_FACEUP,REASON_EFFECT)
	end
end

--アブソルーター・ドラゴン
function c10105503.initial_effect(c)
	--special summon rule
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c10105503.sprcon)
	c:RegisterEffect(e1)
--cannot direct attack
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(10105503,1))
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetHintTiming(0,TIMING_ATTACK)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCondition(c10105503.grcondition)
	e3:SetCost(aux.bfgcost)
	e3:SetOperation(c10105503.groperation)
	c:RegisterEffect(e3)
end
function c10105503.sprfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x7ccd)
end
function c10105503.sprcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c10105503.sprfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c10105503.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateAttack()
end
function c10105503.grcondition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=tp and aux.bpcon()
end
function c10105503.groperation(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_ATTACK)
	e1:SetTargetRange(0,LOCATION_MZONE)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
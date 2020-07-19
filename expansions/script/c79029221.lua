--源石反噬-矿石病
function c79029221.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetOperation(c79029221.activate)
	c:RegisterEffect(e1)  
	--
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e8:SetCode(EVENT_TO_GRAVE)
	e8:SetCondition(c79029221.spcon)
	e8:SetOperation(c79029221.spop)
	c:RegisterEffect(e8)
	local e9=e8:Clone()
	e9:SetCode(EVENT_TO_DECK)
	c:RegisterEffect(e9)
	local e9=e8:Clone()
	e9:SetCode(EVENT_TO_HAND)
	c:RegisterEffect(e9)
	local e9=e8:Clone()
	e9:SetCode(EVENT_REMOVE)
	c:RegisterEffect(e9)
end
function c79029221.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetCountLimit(1)
	e1:SetOperation(c79029221.op)
	Duel.RegisterEffect(e1,tp)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCondition(c79029221.con)
	e1:SetOperation(c79029221.op1)
	Duel.RegisterEffect(e1,tp)
end
function c79029221.op(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,79029221)
	if Duel.GetTurnPlayer()==tp then
	local g=Duel.GetCounter(tp,LOCATION_ONFIELD,0,0x1099)
	Duel.SetLP(ep,Duel.GetLP(ep)-500*g)
	else
	local g=Duel.GetCounter(tp,0,LOCATION_ONFIELD,0x1099)
	Duel.SetLP(ep,Duel.GetLP(ep)-500*g)
end
end
function c79029221.egfil(c)
	return c:GetCounter(0x1099)~=0
end
function c79029221.con(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c79029221.egfil,1,nil)
end
function c79029221.op1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,79029221)   
	Duel.SetLP(ep,Duel.GetLP(ep)-500)
end
function c79029221.spcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousLocation(LOCATION_ONFIELD) and c:IsPreviousPosition(POS_FACEUP)
end
function c79029221.spop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c79029221.egfil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	Duel.SendtoGrave(g,REASON_EFFECT+REASON_RULE)
end







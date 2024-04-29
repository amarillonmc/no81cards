--永恒之光子流
local m=22348409
local cm=_G["c"..m]
function cm.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetCost(c22348409.cost)
	e1:SetCondition(c22348409.condition)
	e1:SetTarget(c22348409.target)
	e1:SetOperation(c22348409.activate)
	c:RegisterEffect(e1)
end
function c22348409.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetActivityCount(tp,ACTIVITY_BATTLE_PHASE)==0 end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_BP)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetTargetRange(1,0)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c22348409.cfilter1(c)
	return c:IsFaceup() and c:IsSetCard(0x107b)
end
function c22348409.cfilter2(c)
	return c:IsFaceup() and c:IsCode(31801517)
end
function c22348409.cfilter3(c)
	return c:IsFaceup() and (c:IsCode(31801517) or c:IsCode(48348921))
end
function c22348409.cfilter4(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToRemove()
end
function c22348409.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c22348409.cfilter1,tp,LOCATION_MZONE,0,1,nil)
		and (Duel.GetTurnPlayer()==tp or Duel.IsExistingMatchingCard(c22348409.cfilter2,tp,LOCATION_ONFIELD,0,1,nil))
end
function c22348409.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,0,LOCATION_MZONE,1,nil) and (not Duel.IsExistingMatchingCard(c22348409.cfilter3,tp,LOCATION_ONFIELD,0,1,nil)) or (Duel.IsExistingMatchingCard(c22348409.cfilter3,tp,LOCATION_ONFIELD,0,1,nil) and Duel.IsExistingMatchingCard(c22348409.cfilter4,tp,0,LOCATION_ONFIELD,1,nil)) end
	local g=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0,LOCATION_MZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,g:GetCount(),0,0)
end
function c22348409.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0,LOCATION_MZONE,nil)
	if Duel.Remove(g,POS_FACEUP,REASON_EFFECT)~=0 and Duel.IsExistingMatchingCard(c22348409.cfilter3,tp,LOCATION_ONFIELD,0,1,nil) and Duel.IsExistingMatchingCard(c22348409.cfilter4,tp,0,LOCATION_ONFIELD,1,nil) then
	local g2=Duel.GetMatchingGroup(c22348409.cfilter4,tp,0,LOCATION_ONFIELD,nil)
	if g2:GetCount()>0 then
		Duel.Remove(g2,POS_FACEUP,REASON_EFFECT)
	end
	end
end
--山菊·花信
function c16372009.initial_effect(c)
	--cost
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,16372009)
	e1:SetCondition(c16372009.con)
	e1:SetCost(c16372009.cost)
	e1:SetOperation(c16372009.operation)
	c:RegisterEffect(e1)
	--setself
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_LEAVE_FIELD)
	e2:SetCountLimit(1,16372009+100)
	e2:SetCondition(c16372009.setscon)
	e2:SetCost(c16372009.costoath)
	e2:SetTarget(c16372009.setstg)
	e2:SetOperation(c16372009.setsop)
	c:RegisterEffect(e2)
	--disable
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_DISABLE)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_CHAINING)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCountLimit(1)
	e3:SetCondition(c16372009.discon)
	e3:SetCost(c16372009.costoath)
	e3:SetTarget(c16372009.distg)
	e3:SetOperation(c16372009.disop)
	c:RegisterEffect(e3)
	Duel.AddCustomActivityCounter(16372009,ACTIVITY_SPSUMMON,c16372009.counterfilter)
end
function c16372009.counterfilter(c)
	return c:IsRace(RACE_PLANT)
end
function c16372009.costoath(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetCustomActivityCount(16372009,tp,ACTIVITY_SPSUMMON)==0 end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c16372009.splimitoath)
	Duel.RegisterEffect(e1,tp)
end
function c16372009.splimitoath(e,c)
	return not c:IsRace(RACE_PLANT)
end
function c16372009.spfilter(c)
	return c:IsFaceup() and c:IsRace(RACE_PLANT)
end
function c16372009.con(e,tp,eg,ep,ev,re,r,rp)
	local ct1=Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)
	local ct2=Duel.GetMatchingGroupCount(c16372009.spfilter,tp,LOCATION_MZONE,0,nil)
	local chk1=ct1==0
	local chk2=ct2>0 and ct1-ct2==0
	return chk1 or chk2
end
function c16372009.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsDiscardable()
		and Duel.GetCustomActivityCount(16372009,tp,ACTIVITY_SPSUMMON)==0 end
	Duel.SendtoGrave(c,REASON_COST+REASON_DISCARD)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c16372009.splimitoath)
	Duel.RegisterEffect(e1,tp)
end
function c16372009.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SUMMON_COST)
	e1:SetTargetRange(LOCATION_EXTRA,LOCATION_EXTRA)
	e1:SetTarget(c16372009.sumtg)
	e1:SetCost(c16372009.ccost)
	e1:SetOperation(c16372009.acop)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_SPSUMMON_COST)
	Duel.RegisterEffect(e2,tp)
end
function c16372009.sumtg(e,c)
	return c:GetRace()~=RACE_PLANT
end
function c16372009.ccost(e,c,tp)
	return Duel.CheckLPCost(tp,500)
end
function c16372009.acop(e,tp,eg,ep,ev,re,r,rp)
	Duel.PayLPCost(tp,500)
end
function c16372009.setscon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_MZONE)
end
function c16372009.setstg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
end
function c16372009.setsop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or Duel.GetLocationCount(tp,LOCATION_SZONE)<1 then return end
	if Duel.MoveToField(c,tp,tp,LOCATION_SZONE,POS_FACEUP,true) then
		local e1=Effect.CreateEffect(c)
		e1:SetCode(EFFECT_CHANGE_TYPE)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET)
		e1:SetValue(TYPE_SPELL+TYPE_CONTINUOUS)
		c:RegisterEffect(e1)
	end
end
function c16372009.disfilter(c)
	return c:IsRace(RACE_PLANT)
end
function c16372009.discon(e,tp,eg,ep,ev,re,r,rp)
	if not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return false end
	local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	return g and g:IsExists(c16372009.disfilter,1,nil) and Duel.IsChainDisablable(ev)
		and re:IsActiveType(TYPE_MONSTER) and not re:GetHandler():IsRace(RACE_PLANT)
		and e:GetHandler():GetType()==TYPE_SPELL+TYPE_CONTINUOUS
end
function c16372009.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,eg,1,0,0)
end
function c16372009.disop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateEffect(ev)
end
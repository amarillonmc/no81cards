--迷影厨师 依然
function c88100307.initial_effect(c)
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsRace,RACE_SPELLCASTER),5,3)
	c:EnableReviveLimit()
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(88100307,0))
	e1:SetCategory(CATEGORY_ATKCHANGE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCondition(c88100307.atkcon)
	e1:SetTarget(c88100307.atktg)
	e1:SetOperation(c88100307.atkop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetCondition(c88100307.recon)
	e2:SetValue(LOCATION_REMOVED)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_QP_ACT_IN_NTPHAND)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x5590))
	e3:SetTargetRange(LOCATION_HAND,0)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	c:RegisterEffect(e4)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(88100307,1))
	e3:SetCategory(CATEGORY_REMOVE)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e3:SetCondition(c88100307.rmcon)
	e3:SetCost(c88100307.rmcost)
	e3:SetTarget(c88100307.rmtg)
	e3:SetOperation(c88100307.rmop)
	c:RegisterEffect(e3)
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e6:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e6:SetCode(EVENT_SPSUMMON_SUCCESS)
	e6:SetOperation(c88100307.zcop)
	c:RegisterEffect(e6)
end
function c88100307.recon(e)
	return e:GetHandler():IsFaceup()
end
function c88100307.atkcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_XYZ) and not Duel.IsExistingMatchingCard(Card.IsType,tp,LOCATION_GRAVE,0,1,nil,TYPE_MONSTER)
end
function c88100307.filter(c,e,tp)
	return c:IsSetCard(0x5590) and c:IsFaceup()
end
function c88100307.atktg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c88100307.filter,tp,LOCATION_REMOVED,0,1,nil) end
	local g=Duel.GetMatchingGroup(c88100307.filter,tp,LOCATION_REMOVED,0,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,1,0,0)
end
function c88100307.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.SelectMatchingCard(tp,c88100307.filter,tp,LOCATION_REMOVED,0,1,1,nil)
	local tc=g:GetFirst()
	local rs=0
	if tc:IsAbleToDeck() and Duel.SelectYesNo(tp,aux.Stringid(88100307,3)) then
		rs=Duel.SendtoDeck(tc,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
	else
		rs=Duel.SendtoGrave(g,REASON_EFFECT+REASON_RETURN)
	end
	if rs~=0 then
		local atk=Duel.GetMatchingGroupCount(Card.IsType,tp,0,LOCATION_MZONE+LOCATION_GRAVE,nil,TYPE_MONSTER)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetValue(atk*500)
		c:RegisterEffect(e1)
	end
end
function c88100307.rmcon(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsExistingMatchingCard(Card.IsType,tp,LOCATION_GRAVE,0,1,nil,TYPE_MONSTER)
end
function c88100307.rmcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=e:GetHandler():GetOverlayGroup()
	if chk==0 then return g:IsExists(Card.IsAbleToRemoveAsCost,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local rg=g:FilterSelect(tp,Card.IsAbleToRemoveAsCost,1,1,nil,POS_FACEUP)
	Duel.Remove(rg,POS_FACEUP,REASON_COST)
end
function c88100307.dfilter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsFaceup() and aux.NegateAnyFilter(c)
end
function c88100307.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c88100307.dfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
end
function c88100307.xfilter(c)
	return c:IsRace(RACE_SPELLCASTER) and c:IsType(TYPE_XYZ)
end
function c88100307.rmfilter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToRemove()
end
function c88100307.atkfilter(c)
	return c:IsLocation(LOCATION_REMOVED) and not c:IsReason(REASON_REDIRECT)
end
function c88100307.rmop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ng=Duel.GetMatchingGroup(c88100307.dfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	for nc in aux.Next(ng) do
		Duel.NegateRelatedChain(nc,RESET_TURN_SET)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		nc:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetValue(RESET_TURN_SET)
		nc:RegisterEffect(e2)
		if nc:IsType(TYPE_TRAPMONSTER) then
			local e3=e1:Clone()
			e3:SetCode(EFFECT_DISABLE_TRAPMONSTER)
			nc:RegisterEffect(e3)
		end
	end
	if ng:GetCount()>0 and c:GetOverlayGroup():IsExists(c88100307.xfilter,1,nil)
		and c:GetOverlayGroup():IsExists(Card.IsAbleToRemove,1,nil)
		and Duel.IsExistingMatchingCard(c88100307.rmfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil)
		and Duel.SelectYesNo(tp,aux.Stringid(88100307,2)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local rg=c:GetOverlayGroup():FilterSelect(tp,Card.IsAbleToRemove,1,1,nil,POS_FACEUP)
		Duel.Remove(rg,POS_FACEUP,REASON_EFFECT)
		local rmg=Duel.GetMatchingGroup(c88100307.rmfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
		if Duel.Remove(rmg,0,REASON_EFFECT)~=0 then
			local og=Duel.GetOperatedGroup():Filter(c88100307.atkfilter,nil)
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UPDATE_ATTACK)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			e1:SetValue(og:GetCount()*500)
			c:RegisterEffect(e1)
		end
	end
end
function c88100307.zcop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_MUSIC,0,aux.Stringid(88100307,9))
	Duel.Hint(24,0,aux.Stringid(88100307,4))
	Duel.Hint(24,0,aux.Stringid(88100307,5))
	Duel.Hint(24,0,aux.Stringid(88100307,6))
	Duel.Hint(24,0,aux.Stringid(88100307,7))
	Duel.Hint(24,0,aux.Stringid(88100307,8))
end
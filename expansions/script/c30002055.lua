--PSY骨架王・λ
function c30002055.initial_effect(c)
	--link summon
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkRace,RACE_PSYCHO),2,2)
	--search
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_END_PHASE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCost(c30002055.cost1)
	e1:SetTarget(c30002055.target1)
	e1:SetOperation(c30002055.operation1)
	c:RegisterEffect(e1)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetRange(LOCATION_EXTRA)
	e2:SetCondition(c30002055.condition2)
	e2:SetCost(c30002055.cost2)
	e2:SetTarget(c30002055.target2)
	e2:SetOperation(c30002055.operation2)
	c:RegisterEffect(e2)
end
function c30002055.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsReleasable() end
	Duel.Release(e:GetHandler(),REASON_COST)
end
function c30002055.filter1(c,tp)
	local res=false
	if c:IsType(TYPE_FIELD) then res=c:IsSSetable() or c:GetActivateEffect():IsActivatable(tp,true,true)
	elseif c:GetType()==0x20004 then res=c:IsSSetable() or c:GetActivateEffect():IsActivatable(tp)
	elseif c:IsType(TYPE_TRAP) then res=c:IsSSetable() end
	return c:IsSetCard(0xc1) and res
end
function c30002055.target1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c30002055.filter1,tp,LOCATION_DECK,0,1,nil,tp) end
end
function c30002055.operation1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
	local g=Duel.SelectMatchingCard(tp,c30002055.filter1,tp,LOCATION_DECK,0,1,1,nil,tp)
	local tc=g:GetFirst()
	if tc then
		local b1=tc:IsSSetable()
		local b2=tc:IsType(TYPE_FIELD) and tc:GetActivateEffect():IsActivatable(tp,true,true)
		local b3=tc:GetType()==0x20004 and tc:GetActivateEffect():IsActivatable(tp)
		if b1 and (not (b2 or b3) or Duel.SelectOption(tp,1153,1150)==0) then
			if Duel.SSet(tp,tc)~=0 then
				local e1=Effect.CreateEffect(e:GetHandler())
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_TRAP_ACT_IN_SET_TURN)
				e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
				e1:SetReset(RESET_EVENT+RESETS_STANDARD)
				tc:RegisterEffect(e1)
			end
		elseif b2 then
			local fc=Duel.GetFieldCard(tp,LOCATION_FZONE,0)
			if fc then
				Duel.SendtoGrave(fc,REASON_RULE)
				Duel.BreakEffect()
			end
			if not Duel.MoveToField(tc,tp,tp,LOCATION_FZONE,POS_FACEUP,true) then return end
			local te=tc:GetActivateEffect()
			te:UseCountLimit(tp,1,true)
			local tep=tc:GetControler()
			local cost=te:GetCost()
			if cost then cost(te,tep,eg,ep,ev,re,r,rp,1) end
			Duel.RaiseEvent(tc,4179255,te,0,tp,tp,Duel.GetCurrentChain())
		else
			if not Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true) then return end
			local te=tc:GetActivateEffect()
			local tep=tc:GetControler()
			local cost=te:GetCost()
			if cost then cost(te,tep,eg,ep,ev,re,r,rp,1) end
		end
	end
end
function c30002055.cfilter(c,tp)
	return c:IsFaceup() and c:IsCode(49036338)
end
function c30002055.condition2(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c30002055.cfilter,1,nil,tp)
end
function c30002055.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.ConfirmCards(1-tp,e:GetHandler())
end
function c30002055.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsLinkSummonable(nil) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c30002055.operation2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsLinkSummonable(nil) then
		Duel.LinkSummon(tp,c,nil)
	end
end

--抽象天皇
function c9980716.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,9980716)
	e1:SetCondition(c9980716.condition)
	e1:SetTarget(c9980716.target)
	e1:SetOperation(c9980716.operation)
	c:RegisterEffect(e1)
	--spsummon bgm
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e8:SetCode(EVENT_SPSUMMON_SUCCESS)
	e8:SetOperation(c9980716.sumsuc)
	c:RegisterEffect(e8)
end
function c9980716.sumsuc(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_MUSIC,0,aux.Stringid(9980716,0))
end 
function c9980716.condition(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	return Duel.GetTurnPlayer()~=tp and (ph==PHASE_MAIN1 or ph==PHASE_MAIN2) and Duel.GetFieldGroupCount(e:GetHandlerPlayer(),LOCATION_ONFIELD,0)==0
end
function c9980716.filter(c,tp)
	return c:IsType(TYPE_FIELD) and c:GetActivateEffect():IsActivatable(tp,true,true)
end
function c9980716.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9980716.filter,tp,LOCATION_GRAVE+LOCATION_HAND+LOCATION_REMOVED,0,1,nil,tp) end
	if not Duel.CheckPhaseActivity() then e:SetLabel(1) else e:SetLabel(0) end
end
function c9980716.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(9980716,0))
	if e:GetLabel()==1 then Duel.RegisterFlagEffect(tp,9980716,RESET_CHAIN,0,1) end
	local tc=Duel.SelectMatchingCard(tp,c9980716.filter,tp,LOCATION_GRAVE+LOCATION_HAND+LOCATION_REMOVED,0,1,1,nil,tp):GetFirst()
	Duel.ResetFlagEffect(tp,9980716)
	if tc then
		local fc=Duel.GetFieldCard(tp,LOCATION_SZONE,5)
		if fc then
			Duel.SendtoGrave(fc,REASON_RULE)
			Duel.BreakEffect()
		end
		Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
		local te=tc:GetActivateEffect()
		te:UseCountLimit(tp,1,true)
		local tep=tc:GetControler()
		local cost=te:GetCost()
		if cost then cost(te,tep,eg,ep,ev,re,r,rp,1) end
		Duel.RaiseEvent(tc,4179255,te,0,tp,tp,Duel.GetCurrentChain())
	end
end


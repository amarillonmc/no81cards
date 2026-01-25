--破灭召唤之剑
function c1234568.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(1234568,0))
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(TIMING_STANDBY_PHASE,TIMING_STANDBY_PHASE+TIMINGS_CHECK_MONSTER)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,1234568)
	e1:SetCost(c1234568.cost)
	e1:SetOperation(c1234568.operation)
	c:RegisterEffect(e1)
	
end
function c1234568.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToGraveAsCost() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST)
end
function c1234568.spfilter(c)
	return c:IsCode(1234567) and c:IsFaceup()
end
function c1234568.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	--act limit
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetReset(RESET_PHASE+PHASE_END,2)
	if Duel.IsExistingMatchingCard(c1234568.spfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) then
		--Debug.Message('1')
		e1:SetLabel(1,Duel.GetTurnPlayer())
	else
		--Debug.Message('2')
		e1:SetLabel(0,Duel.GetTurnPlayer())
	end
	e1:SetCondition(c1234568.limcon)
	e1:SetOperation(c1234568.limop)
	Duel.RegisterEffect(e1,tp)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	Duel.RegisterEffect(e2,tp)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_CHAIN_END)
	e3:SetReset(RESET_PHASE+PHASE_END,2)
	e3:SetOperation(c1234568.limop2)
	Duel.RegisterEffect(e3,tp)
end

function c1234568.limcon(e,tp,eg,ep,ev,re,r,rp)
	return true
end
function c1234568.limop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local num1,num2=e:GetLabel()
	if (num1==1 or Duel.GetFlagEffect(tp,1234569+num2)<=1) 
		and Duel.SelectYesNo(tp,aux.Stringid(1234568,1)) then
		Duel.RegisterFlagEffect(tp,1234569+num2,RESET_PHASE+PHASE_END,0,2)
	else
		if (num1==1 or Duel.GetFlagEffect(1-tp,1234569+num2)<=1) 
			and Duel.SelectYesNo(1-tp,aux.Stringid(1234568,1)) then
		Duel.RegisterFlagEffect(1-tp,1234569+num2,RESET_PHASE+PHASE_END,0,2)
		else return end
	end
	
	Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(1234568,2))
	Duel.Hint(HINT_OPSELECTED,tp,aux.Stringid(1234568,2))
	if Duel.GetCurrentChain()==0 then
		Duel.SetChainLimitTillChainEnd(aux.FALSE)
	elseif Duel.GetCurrentChain()>=1 then
		c:RegisterFlagEffect(1234568,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_CHAINING)
		e1:SetOperation(c1234568.resetop)
		Duel.RegisterEffect(e1,tp)
		--local e2=e1:Clone()
		--e2:SetCode(EVENT_BREAK_EFFECT)
		--e2:SetReset(RESET_CHAIN)
		--Duel.RegisterEffect(e2,tp)
	end
end
function c1234568.resetop(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():ResetFlagEffect(1234568)
	e:Reset()
end
function c1234568.limop2(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():GetFlagEffect(1234568)~=0 then
		Duel.SetChainLimitTillChainEnd(aux.FALSE)
	end
	e:GetHandler():ResetFlagEffect(1234568)
end
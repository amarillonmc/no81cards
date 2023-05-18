--暴食之星渡使
function c67200812.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--maintain
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetRange(LOCATION_PZONE)
	e0:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e0:SetCountLimit(1)
	e0:SetOperation(c67200812.desop)
	c:RegisterEffect(e0)
	--act limit
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetRange(LOCATION_PZONE)
	e1:SetTargetRange(1,1)
	e1:SetCondition(c67200812.limcon)
	e1:SetValue(c67200812.limval)
	c:RegisterEffect(e1)
	--change effect
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(67200812,4))
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e2:SetCondition(c67200812.stcon)
	e2:SetTarget(c67200812.sttg)
	e2:SetOperation(c67200812.stop)
	c:RegisterEffect(e2)
end
function c67200812.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.HintSelection(Group.FromCards(c))
	local g1=Duel.GetMatchingGroup(Card.IsAbleToGrave,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	local g3=Duel.GetMatchingGroup(Card.IsAbleToGrave,tp,LOCATION_HAND,LOCATION_HAND,nil)
	local sg=Group.CreateGroup()
	if g1:GetCount()>0 and g3:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(67200812,0)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local sg1=g1:Select(tp,1,1,nil)
		Duel.HintSelection(sg1)
		sg:Merge(sg1)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local sg3=g3:RandomSelect(tp,1)
		sg:Merge(sg3)
		Duel.SendtoGrave(sg,REASON_COST)
	else Duel.Destroy(c,REASON_COST) end
end
--
function c67200812.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x67b)
end
function c67200812.limcon(e)
	return Duel.IsExistingMatchingCard(c67200812.cfilter,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil)
end
function c67200812.limval(e,re,rp)
	local rc=re:GetHandler()
	return re:IsActiveType(TYPE_MONSTER) and not rc:IsSetCard(0x67b)
end
--
function c67200812.stcon(e)
	return e:GetHandler():GetFlagEffect(67200812)==0
end
function c67200812.sttg(e,tp,eg,ep,ev,re,r,rp,chk)  
	local c=e:GetHandler()
	local b1=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local b2=Duel.GetLocationCount(tp,LOCATION_PZONE,0)
	local b3=Duel.GetLocationCount(tp,LOCATION_PZONE,1)
	if chk==0 then return b1>0 or (Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1)) end
	c:RegisterFlagEffect(67200812,RESET_CHAIN,0,1)
	local off=1
	local ops,opval={},{}
	if b1>0 then
		ops[off]=aux.Stringid(67200812,1)
		opval[off]=0
		off=off+1
	end
	if (Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1)) then
		ops[off]=aux.Stringid(67200812,2)
		opval[off]=1
		off=off+1
	end
	local op=Duel.SelectOption(tp,table.unpack(ops))+1
	local sel=opval[op]
	e:SetLabel(sel)
end
function c67200812.stop(e,tp,eg,ep,ev,re,r,rp)  
	local c=e:GetHandler()
	local sel=e:GetLabel()
	if c:IsRelateToEffect(e) then
		if sel==0 then
			Duel.MoveToField(e:GetHandler(),tp,tp,LOCATION_MZONE,POS_FACEUP,true)
		else
			Duel.MoveToField(e:GetHandler(),tp,tp,LOCATION_PZONE,POS_FACEUP,true)
		end
		local e1=Effect.CreateEffect(c)
		e1:SetDescription(aux.Stringid(67200812,5))
		e1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
		e1:SetCode(EVENT_SPSUMMON)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CLIENT_HINT)
		e1:SetOperation(c67200812.disop)
		e1:SetTargetRange(1,1)
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
		local e2=e1:Clone()
		e2:SetCode(EVENT_SUMMON)
		Duel.RegisterEffect(e2,tp)
	end
end
function c67200812.pcfilter(c)
	return c:IsSetCard(0x67b) and c:IsType(TYPE_PENDULUM) and not c:IsForbidden()
end
function c67200812.disop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not Duel.IsExistingMatchingCard(c67200812.pcfilter,tp,LOCATION_DECK+LOCATION_EXTRA,0,1,nil) then return end
	if Duel.GetFlagEffect(tp,67200812)==0 and Duel.SelectYesNo(tp,aux.Stringid(67200812,3)) then
		Duel.RegisterFlagEffect(tp,67200812,RESET_PHASE+PHASE_END,0,1)
		Duel.NegateSummon(eg)
		if Duel.Destroy(eg,REASON_EFFECT)~=0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
			local g=Duel.SelectMatchingCard(tp,c67200812.pcfilter,tp,LOCATION_DECK+LOCATION_EXTRA,0,1,1,nil)
			local g1=Duel.GetLocationCount(tp,LOCATION_MZONE)
			local opt=0
			if g1>0 and ((Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1))) then
				opt=Duel.SelectOption(tp,aux.Stringid(67200812,1),aux.Stringid(67200812,2))
			elseif g1>0 then
				opt=Duel.SelectOption(tp,aux.Stringid(67200812,1))
			elseif (Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1)) then
				opt=Duel.SelectOption(tp,aux.Stringid(67200812,2))+1
			else return end
			if opt==0 then
				Duel.MoveToField(g:GetFirst(),tp,tp,LOCATION_MZONE,POS_FACEUP,true)
			else
				Duel.MoveToField(g:GetFirst(),tp,tp,LOCATION_PZONE,POS_FACEUP,true)
			end
		end
	end
end

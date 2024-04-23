--虚饰之星渡使
function c67200810.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--maintain
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetRange(LOCATION_PZONE)
	e0:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e0:SetCountLimit(1)
	e0:SetOperation(c67200810.desop)
	c:RegisterEffect(e0)
	--remove
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_IGNORE_RANGE+EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetCode(EFFECT_TO_GRAVE_REDIRECT)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCondition(c67200810.rmcon)
	e1:SetTarget(c67200810.rmtarget)
	e1:SetTargetRange(0xff,0xff)
	e1:SetValue(LOCATION_DECK)
	c:RegisterEffect(e1)
	--change effect
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(67200810,4))
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e2:SetCondition(c67200810.stcon)
	e2:SetTarget(c67200810.sttg)
	e2:SetOperation(c67200810.stop)
	c:RegisterEffect(e2)
end
function c67200810.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.HintSelection(Group.FromCards(c))
	local g1=Duel.GetMatchingGroup(Card.IsAbleToGrave,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	local g3=Duel.GetMatchingGroup(Card.IsAbleToGrave,tp,LOCATION_HAND,LOCATION_HAND,nil)
	local sg=Group.CreateGroup()
	if g1:GetCount()>0 and g3:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(67200810,0)) then
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
function c67200810.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x367b)
end
function c67200810.rmcon(e)
	return Duel.IsExistingMatchingCard(c67200810.cfilter,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil)
end
function c67200810.rmtarget(e,c)
	return not c:IsSetCard(0x367b)
end
--
function c67200810.stcon(e)
	return e:GetHandler():GetFlagEffect(67200810)==0
end
function c67200810.sttg(e,tp,eg,ep,ev,re,r,rp,chk)  
	local c=e:GetHandler()
	local b1=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local b2=Duel.GetLocationCount(tp,LOCATION_PZONE,0)
	local b3=Duel.GetLocationCount(tp,LOCATION_PZONE,1)
	if chk==0 then return b1>0 or (Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1)) end
	c:RegisterFlagEffect(67200810,RESET_CHAIN,0,1)
	local off=1
	local ops,opval={},{}
	if b1>0 then
		ops[off]=aux.Stringid(67200810,1)
		opval[off]=0
		off=off+1
	end
	if (Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1)) then
		ops[off]=aux.Stringid(67200810,2)
		opval[off]=1
		off=off+1
	end
	local op=Duel.SelectOption(tp,table.unpack(ops))+1
	local sel=opval[op]
	e:SetLabel(sel)
end
function c67200810.stop(e,tp,eg,ep,ev,re,r,rp)  
	local c=e:GetHandler()
	local sel=e:GetLabel()
	if c:IsRelateToEffect(e) then
		if sel==0 then
			Duel.MoveToField(e:GetHandler(),tp,tp,LOCATION_MZONE,POS_FACEUP,true)
		else
			Duel.MoveToField(e:GetHandler(),tp,tp,LOCATION_PZONE,POS_FACEUP,true)
		end
		local e1=Effect.CreateEffect(c)
		e1:SetDescription(aux.Stringid(67200810,5))
		e1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
		e1:SetCode(EVENT_CHAIN_SOLVING)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CLIENT_HINT)
		e1:SetOperation(c67200810.disop)
		e1:SetTargetRange(1,1)
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
	end
end
function c67200810.pcfilter(c)
	return c:IsSetCard(0x367b) and c:IsType(TYPE_PENDULUM) and not c:IsForbidden()
end
function c67200810.disop(e,tp,eg,ep,ev,re,r,rp)
	if ep==tp or not Duel.IsExistingMatchingCard(c67200810.pcfilter,tp,LOCATION_DECK+LOCATION_EXTRA,0,1,nil) then return end
	if Duel.GetFlagEffect(tp,67200810)==0 and Duel.SelectYesNo(tp,aux.Stringid(67200810,3)) then
		Duel.RegisterFlagEffect(tp,67200810,RESET_PHASE+PHASE_END,0,1)
		local g=Group.CreateGroup()
		Duel.ChangeTargetCard(ev,g)
		Duel.ChangeChainOperation(ev,c67200810.repop)
	end
end
function c67200810.repop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local g=Duel.SelectMatchingCard(1-tp,c67200810.pcfilter,tp,0,LOCATION_DECK+LOCATION_EXTRA,1,1,nil)
	local g1=Duel.GetLocationCount(1-tp,LOCATION_MZONE)
	local g2=Duel.GetLocationCount(1-tp,LOCATION_PZONE,0)
	local g3=Duel.GetLocationCount(1-tp,LOCATION_PZONE,1)
	local opt=0
	if g1>0 and ((Duel.CheckLocation(1-tp,LOCATION_PZONE,0) or Duel.CheckLocation(1-tp,LOCATION_PZONE,1))) then
		opt=Duel.SelectOption(1-tp,aux.Stringid(67200810,1),aux.Stringid(67200810,2))
	elseif g1>0 then
		opt=Duel.SelectOption(1-tp,aux.Stringid(67200810,1))
	elseif (Duel.CheckLocation(1-tp,LOCATION_PZONE,0) or Duel.CheckLocation(1-tp,LOCATION_PZONE,1)) then
		opt=Duel.SelectOption(1-tp,aux.Stringid(67200810,2))+1
	else return end
	if opt==0 then
		Duel.MoveToField(g:GetFirst(),1-tp,1-tp,LOCATION_MZONE,POS_FACEUP,true)
	else
		Duel.MoveToField(g:GetFirst(),1-tp,1-tp,LOCATION_PZONE,POS_FACEUP,true)
	end
end
--色欲之星渡使
function c67200816.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--maintain
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetRange(LOCATION_PZONE)
	e0:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e0:SetCountLimit(1)
	e0:SetOperation(c67200816.desop)
	c:RegisterEffect(e0)
	--act limit
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_CANNOT_ACTIVATE)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetRange(LOCATION_PZONE)
	e4:SetTargetRange(1,1)
	e4:SetCondition(c67200816.limcon)
	e4:SetValue(c67200816.limval)
	c:RegisterEffect(e4)
	--change effect
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(67200816,4))
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e2:SetCondition(c67200816.stcon)
	e2:SetTarget(c67200816.sttg)
	e2:SetOperation(c67200816.stop)
	c:RegisterEffect(e2)
end
function c67200816.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.HintSelection(Group.FromCards(c))
	local g1=Duel.GetMatchingGroup(Card.IsAbleToGrave,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	local g3=Duel.GetMatchingGroup(Card.IsAbleToGrave,tp,LOCATION_HAND,LOCATION_HAND,nil)
	local sg=Group.CreateGroup()
	if g1:GetCount()>0 and g3:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(67200816,0)) then
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
function c67200816.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x367b)
end
function c67200816.limcon(e)
	return Duel.IsExistingMatchingCard(c67200816.cfilter,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil)
end
function c67200816.limval(e,re,rp)
	local rc=re:GetHandler()
	return re:IsActiveType(TYPE_SPELL) and not rc:IsSetCard(0x367b)
end
--
function c67200816.stcon(e)
	return e:GetHandler():GetFlagEffect(67200816)==0
end
function c67200816.sttg(e,tp,eg,ep,ev,re,r,rp,chk)  
	local c=e:GetHandler()
	local b1=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local b2=Duel.GetLocationCount(tp,LOCATION_PZONE,0)
	local b3=Duel.GetLocationCount(tp,LOCATION_PZONE,1)
	if chk==0 then return b1>0 or (Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1)) end
	c:RegisterFlagEffect(67200816,RESET_CHAIN,0,1)
	local off=1
	local ops,opval={},{}
	if b1>0 then
		ops[off]=aux.Stringid(67200816,1)
		opval[off]=0
		off=off+1
	end
	if (Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1)) then
		ops[off]=aux.Stringid(67200816,2)
		opval[off]=1
		off=off+1
	end
	local op=Duel.SelectOption(tp,table.unpack(ops))+1
	local sel=opval[op]
	e:SetLabel(sel)
end
function c67200816.stop(e,tp,eg,ep,ev,re,r,rp)  
	local c=e:GetHandler()
	local sel=e:GetLabel()
	if c:IsRelateToEffect(e) then
		if sel==0 then
			Duel.MoveToField(e:GetHandler(),tp,tp,LOCATION_MZONE,POS_FACEUP,true)
		else
			Duel.MoveToField(e:GetHandler(),tp,tp,LOCATION_PZONE,POS_FACEUP,true)
		end
		local e1=Effect.CreateEffect(c)
		e1:SetDescription(aux.Stringid(67200816,5))
		e1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
		e1:SetCode(EVENT_CHAIN_SOLVING)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CLIENT_HINT)
		e1:SetOperation(c67200816.disop)
		e1:SetTargetRange(1,1)
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
	end
end
function c67200816.pcfilter(c)
	return c:IsSetCard(0x367b) and c:IsType(TYPE_PENDULUM) and not c:IsForbidden()
end
function c67200816.disop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c67200816.spfilter,tp,LOCATION_DECK+LOCATION_EXTRA,0,nil,e,tp)
	if ep==tp then return end
	if Duel.GetFlagEffect(tp,67200816)==0 and Duel.IsPlayerCanSpecialSummonCount(tp,2)
		and not Duel.IsPlayerAffectedByEffect(tp,59822133)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>=1
		and Duel.GetUsableMZoneCount(tp)>=2
		and g:CheckSubGroup(c67200816.fselect,2,2,tp) and Duel.SelectYesNo(tp,aux.Stringid(67200816,3)) then
		Duel.RegisterFlagEffect(tp,67200816,RESET_PHASE+PHASE_END,0,1)
		local g=Group.CreateGroup()
		Duel.ChangeTargetCard(ev,g)
		Duel.ChangeChainOperation(ev,c67200816.repop)
	end
end
--
function c67200816.spfilter(c,e,tp)
	return c:IsLevelAbove(1) and c:IsSetCard(0x367b) and c:IsType(TYPE_PENDULUM) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0
end
function c67200816.fselect(g,tp)
	return g:GetClassCount(Card.GetLocation)==g:GetCount() and g:GetClassCount(Card.GetLevel)==1
		and Duel.IsExistingMatchingCard(Card.IsXyzSummonable,tp,LOCATION_EXTRA,0,1,nil,g,2,2)
end

function c67200816.repop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(aux.NecroValleyFilter(c67200816.spfilter),1-tp,LOCATION_DECK+LOCATION_EXTRA,0,nil,e,tp)
	if Duel.IsPlayerAffectedByEffect(tp,59822133) or Duel.GetLocationCount(1-tp,LOCATION_MZONE)<=0 or g:GetCount()==0 then return end
	Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_SPSUMMON)
	local sg=g:SelectSubGroup(1-tp,c67200816.fselect,false,2,2,tp)
	if sg and sg:GetCount()==2 then
		local tc1=sg:GetFirst()
		local tc2=sg:GetNext()
		Duel.SpecialSummonStep(tc1,0,1-tp,1-tp,false,false,POS_FACEUP)
		Duel.SpecialSummonStep(tc2,0,1-tp,1-tp,false,false,POS_FACEUP)

		Duel.SpecialSummonComplete()
		Duel.AdjustAll()
		--if sg:FilterCount(Card.IsLocation,nil,LOCATION_MZONE)<2 then return end
		local xyzg=Duel.GetMatchingGroup(Card.IsXyzSummonable,1-tp,LOCATION_EXTRA,0,nil,sg,2,2)
		if xyzg:GetCount()>0 then
			Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_SPSUMMON)
			local xyz=xyzg:Select(1-tp,1,1,nil):GetFirst()
			Duel.XyzSummon(1-tp,xyz,sg)
		end
	end
end

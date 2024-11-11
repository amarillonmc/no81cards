local s,id,o=GetID()
function s.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DISABLE+CATEGORY_CONTROL)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_CUSTOM+id)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e1:SetCountLimit(1,EFFECT_COUNT_CODE_CHAIN)
	e1:SetTarget(s.sptg)
	e1:SetOperation(s.spop)
	c:RegisterEffect(e1)
	if not s.global_check then
		s.global_check=true
		s.count=0
		local g=Group.CreateGroup()
		g:KeepAlive()
		s.group=g
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_ADD_COUNTER+0x100e)
		ge1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		ge1:SetOperation(s.regop)
		local ge2=Effect.CreateEffect(c)
		ge2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
		ge2:SetTargetRange(LOCATION_ONFIELD,LOCATION_ONFIELD)
		ge2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
		ge2:SetLabelObject(ge1)
		Duel.RegisterEffect(ge2,0)
		local ge3=Effect.CreateEffect(c)
		ge3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge3:SetCode(EVENT_CHAIN_END)
		ge3:SetOperation(s.MergedDelayEventCheck)
		Duel.RegisterEffect(ge3,0)
	end
end
function s.regop(e,tp,eg,ep,ev,re,r,rp)
	local g=s.group
	if not g:IsContains(e:GetHandler()) then
		g:Merge(e:GetHandler())
		s.count=s.count+ev
	end
	if Duel.GetCurrentChain()==0 and not Duel.CheckEvent(EVENT_CHAIN_END) then
		local _eg=g:Clone()
		Duel.RaiseEvent(_eg,EVENT_CUSTOM+id,re,r,rp,ep,s.count)
		g:Clear()
		s.count=0
	end
end
function s.MergedDelayEventCheck(e,tp,eg,ep,ev,re,r,rp)
	local g=s.group
	if #g>0 then
		local _eg=g:Clone()
		Duel.RaiseEvent(_eg,EVENT_CUSTOM+id,re,r,rp,ep,s.count)
		g:Clear()
		s.count=0
	end
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsCanRemoveCounter(tp,1,1,0x100e,1,REASON_EFFECT) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function s.spfilter(c,e,tp)
	return c:IsCode(68319538) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_SYNCHRO,tp,false,false) and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local lvt={}
	for i=Duel.GetCounter(tp,1,1,0x100e),1,-1 do
		if Duel.IsCanRemoveCounter(tp,1,1,0x100e,i,REASON_EFFECT) then
			table.insert(lvt,i)
		end
	end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(id,1))
	local ct=Duel.AnnounceNumber(tp,table.unpack(lvt))
	if not Duel.RemoveCounter(tp,1,1,0x100e,ct,REASON_EFFECT) then return end
	local c=e:GetHandler()
	s.check=true
	if not c:IsRelateToEffect(e) or Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)<=0 then return end
	if ct<6 then
		Duel.BreakEffect()
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetTargetRange(1,0)
		e1:SetTarget(s.splimit)
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
	end
	if ct>1 then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISABLE)
		local g=Duel.SelectMatchingCard(tp,aux.NegateEffectMonsterFilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
		local tc=g:GetFirst()
		if tc then
			Duel.HintSelection(g)
			Duel.NegateRelatedChain(tc,RESET_TURN_SET)
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_DISABLE)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e1)
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_DISABLE_EFFECT)
			e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e2:SetValue(RESET_TURN_SET)
			e2:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e2)
		end
	end
	if ct>3 then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONTROL)
		local cc=Duel.SelectMatchingCard(tp,Card.IsControlerCanBeChanged,tp,0,LOCATION_MZONE,1,1,nil):GetFirst()
		if cc then Duel.GetControl(cc,tp) end
	end
	if ct>5 then
		Duel.BreakEffect()
		if Duel.SendtoGrave(c,REASON_EFFECT)>0 and c:IsLocation(LOCATION_GRAVE) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local sc=Duel.SelectMatchingCard(tp,s.spfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp):GetFirst()
			if sc and Duel.SpecialSummon(sc,SUMMON_TYPE_SYNCHRO,tp,tp,false,false,POS_FACEUP)~=0 then
				sc:CompleteProcedure()
				local cp={}
				local f=Card.RegisterEffect
				Card.RegisterEffect=function(tc,te,bool)
					if te:GetType()&EFFECT_TYPE_IGNITION~=0 and te:GetRange()&0x4~=0 then table.insert(cp,te:Clone()) end
					return f(tc,te,bool)
				end
				Duel.CreateToken(tp,sc:GetOriginalCode())
				for i,v in ipairs(cp) do
					local e1=v:Clone()
					e1:SetType(EFFECT_TYPE_QUICK_O)
					e1:SetCode(EVENT_FREE_CHAIN)
					e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
					e1:SetReset(RESET_EVENT+RESETS_STANDARD)
					sc:RegisterEffect(e1)
				end
				Card.RegisterEffect=f
				local e2=Effect.CreateEffect(sc)
				e2:SetType(EFFECT_TYPE_FIELD)
				e2:SetCode(EFFECT_CANNOT_ACTIVATE)
				e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
				e2:SetRange(LOCATION_MZONE)
				e2:SetTargetRange(1,1)
				e2:SetValue(s.aclimit)
				e2:SetReset(RESET_EVENT+RESETS_STANDARD)
				sc:RegisterEffect(e2)
			end
		end
	end
end
function s.splimit(e,c)
	return c:IsCode(id)
end
function s.aclimit(e,re,tp)
	return re:GetHandler()==e:GetHandler() and re:GetType()&0x40==0x40
end

--悬丝协律·忘却
local s,id,o=GetID()
function s.initial_effect(c)
	aux.AddCodeList(c,id)
	--
	local e0=Effect.CreateEffect(c)
	e0:SetDescription(aux.Stringid(id,1))
	e0:SetCategory(CATEGORY_DESTROY)
	e0:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e0:SetCode(EVENT_SUMMON_SUCCESS)
	e0:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e0:SetCountLimit(1,EFFECT_COUNT_CODE_CHAIN)
	e0:SetTarget(s.seqtg)
	e0:SetOperation(s.seqop)
	c:RegisterEffect(e0)
	local e1=e0:Clone()
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e1)
	--
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(1118)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_SUMMON)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_DESTROYED)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetTarget(s.sptg)
	e2:SetOperation(s.spop)
	c:RegisterEffect(e2)
	if not s.check_global then
		s.check_global=true
		s.field_record={{{-1,-1,-1,-1,-1,5,6},{-1,-1,-1,-1,-1,5,6}},{{-1,-1,-1,-1,-1,5,6},{-1,-1,-1,-1,-1,5,6}}}
		s.exist_record={{0},{0}}
		s.mapping={[0]=3,[1]=4,[2]=5,[3]=6,[4]=7,[8]=8,[9]=9,[10]=10,[11]=11,[12]=12,
		[16]=3,[17]=4,[18]=5,[19]=6,[20]=7,[24]=8,[25]=9,[26]=10,[27]=11,[28]=12}
		s.record_tab={}
		local ce=Effect.CreateEffect(c)
		ce:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
		ce:SetCode(EVENT_MOVE)
		ce:SetCondition(s.checkcon)
		ce:SetOperation(s.checkop)
		Duel.RegisterEffect(ce,0)
		local ce2=Effect.CreateEffect(c)
		ce2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ce2:SetCode(EVENT_PHASE_START+PHASE_DRAW)
		ce2:SetOperation(s.clear)
		Duel.RegisterEffect(ce2,0)
	end
end
function s.faceup_check(c)
	return c:IsFaceup() and c:IsSetCard(0x5a7d)
end
function s.checkcon(e,tp)
	for p=0,1 do
		local g=Duel.GetMatchingGroup(s.faceup_check,p,LOCATION_ONFIELD,0,nil)
		if g:GetCount()>0 then
			for tc in aux.Next(g) do
				local code=tc:GetCode()
				if not s.checkin(s.exist_record[p+1],code) then
					return true
				end
			end
		end
	end
	return false
end
function s.onfieldcheck(c,tp)
	return c:IsOnField() and c:IsControler(tp)
end
function s.checkop(e,tp,eg)
	for p=0,1 do
		local g=eg:Filter(s.onfieldcheck,nil,p)
		if g:GetCount()>0 then
			for tc in aux.Next(g) do
				local code=tc:GetCode()
				if not s.checkin(s.exist_record[p+1],code) then
					table.insert(s.exist_record[p+1],code)
				end
			end
		end
	end
end
function s.clear(e,tp)
	s.exist_record={{0},{0}}
end
function s.seqtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return (s.checkin(s.field_record[1][1],-1) or s.checkin(s.field_record[2][1],-1) or s.checkin(s.field_record[1][2],-1) or s.checkin(s.field_record[2][2],-1)) end
	local val=0
	local c=e:GetHandler()
	for i=0,6 do
		if s.checkin(s.field_record[1][1],i) then
			if i~=5 and i~=6 then
			end
			val=val|aux.SequenceToGlobal(tp,LOCATION_MZONE,i)
		end
		if s.checkin(s.field_record[2][1],i) then
			if i~=5 and i~=6 then
			end
			val=val|aux.SequenceToGlobal(1-tp,LOCATION_MZONE,i)
		end
	end
	for i=0,4 do
		if s.checkin(s.field_record[1][2],i) then
			val=val|aux.SequenceToGlobal(tp,LOCATION_SZONE,i)
		end
		if s.checkin(s.field_record[2][2],i) then
			val=val|aux.SequenceToGlobal(1-tp,LOCATION_SZONE,i)
		end
	end
	val=val|0x2000
	val=val|0x20000000
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local flag=Duel.SelectField(tp,1,LOCATION_ONFIELD,LOCATION_ONFIELD,val)
	local seq=math.log(flag,2)
	if tp==1 then
		if seq<16 then
			seq=16+seq
		elseif seq<29 then
			seq=seq-16
		end
	end
	e:SetLabel(seq)
	Duel.Hint(HINT_ZONE,tp,flag)
end
function s.checkin(tab,val)
	for _,v in ipairs(tab) do
		if v==val then
			return true
		end
	end
	return false
end
function s.map_seq_to_ct(seq)
	local ct=s.mapping[seq]
	if ct then
		return ct
	else
		return nil
	end
end
function s.seqop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local seq=e:GetLabel()
	if seq<5 then
		s.field_record[1][1][seq+1]=seq
	elseif seq<13 then
		s.field_record[1][2][seq-7]=seq-8
	elseif seq<21 then
		s.field_record[2][1][seq-15]=seq-16
	elseif seq<29 then
		s.field_record[2][2][seq-23]=seq-24
	end
	local ct=s.map_seq_to_ct(seq)
	local e0=Effect.CreateEffect(c)
	e0:SetDescription(aux.Stringid(id,ct))
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CLIENT_HINT)
	if not ((Duel.GetTurnPlayer()==tp and Duel.GetTurnCount()%2==0) or (Duel.GetTurnPlayer()==1-tp and Duel.GetTurnCount()%2==1)) then
		if seq<13 then
			e0:SetTargetRange(1,0)
		else
			e0:SetTargetRange(0,1)
		end
	else
		if seq<13 then
			e0:SetTargetRange(0,1)
		else
			e0:SetTargetRange(1,0)
		end
	end
	Duel.RegisterEffect(e0,tp)
	local tc=nil
	local cid=-1
	if seq<5 then
		tc=Duel.GetFieldCard(0,LOCATION_MZONE,seq)
	elseif seq<16 then
		tc=Duel.GetFieldCard(0,LOCATION_SZONE,seq-8)
	elseif seq<21 then
		tc=Duel.GetFieldCard(1,LOCATION_MZONE,seq-16)
	else
		tc=Duel.GetFieldCard(1,LOCATION_SZONE,seq-24)
	end
	if tc~=nil then
		cid=tc:GetFieldID()
		tc:RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD,0,0)
		local ce=Effect.CreateEffect(c)
		ce:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
		ce:SetCode(EVENT_MOVE)
		ce:SetReset(RESET_EVENT+RESETS_STANDARD)
		ce:SetOperation(function(...) tc:ResetFlagEffect(id) end)
		tc:RegisterEffect(ce,true)
	end
	local ge=Effect.CreateEffect(c)
	ge:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	ge:SetCode(EVENT_ADJUST)
	ge:SetCountLimit(1)
	ge:SetLabel(seq,cid)
	ge:SetCondition(s.descon)
	ge:SetOperation(s.desop)
	ge:SetLabelObject(e0)
	Duel.RegisterEffect(ge,tp)
end
function s.descon(e,tp,eg)
	local seq,cid=e:GetLabel()
	local target_player=2
	local loc=0
	if seq<5 then
		loc=LOCATION_MZONE
		seq=seq
		target_player=0
	elseif seq<13 then
		loc=LOCATION_SZONE
		seq=seq-8
		target_player=0
	elseif seq<21 then
		loc=LOCATION_MZONE
		seq=seq-16
		target_player=1
	elseif seq<29 then
		loc=LOCATION_SZONE
		seq=seq-24
		target_player=1
	end
	return Duel.IsExistingMatchingCard(s.descheck,target_player,loc,0,1,nil,seq,cid)
end
function s.descheck(c,seq,cid)
	if not c:IsStatus(STATUS_EFFECT_ENABLED) and not c:IsLocation(LOCATION_SZONE) then return false end
	return c:GetSequence()==seq and (c:GetFieldID()~=cid or c:GetFlagEffect(id)==0)
end
function s.desop(e,tp,eg)
	local seq,cid=e:GetLabel()
	local seq_clone=seq
	local target_player=2
	local loc=0
	if seq<5 then
		loc=LOCATION_MZONE
		seq=seq
		target_player=0
	elseif seq<13 then
		loc=LOCATION_SZONE
		seq=seq-8
		target_player=0
	elseif seq<21 then
		loc=LOCATION_MZONE
		seq=seq-16
		target_player=1
	elseif seq<29 then
		loc=LOCATION_SZONE
		seq=seq-24
		target_player=1
	end
	local g=Duel.GetMatchingGroup(s.descheck,target_player,loc,0,nil,seq,cid)
	if g:GetCount()>0 then
		Duel.Hint(HINT_CARD,0,id)
		Duel.HintSelection(g)
		Duel.Destroy(g,REASON_EFFECT)
		if seq_clone<5 then
			s.field_record[1][1][seq_clone+1]=-1
		elseif seq_clone<13 then
			s.field_record[1][2][seq_clone-7]=-1
		elseif seq_clone<21 then
			s.field_record[2][1][seq_clone-15]=-1
		elseif seq_clone<29 then
			s.field_record[2][2][seq_clone-23]=-1
		end
		local e0=e:GetLabelObject()
		e0:Reset()
		e:Reset()
	end
end
function s.spfilter(c,e,tp)
	if not c:IsSetCard(0x5a7d) then return false end
	local code=c:GetCode()
	return not s.checkin(s.exist_record[tp+1],code) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil,e,tp) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(s.spfilter),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,e,tp)
	if #g>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
		local tc=g:GetFirst()
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_LEAVE_FIELD)
		e1:SetReset(RESET_EVENT+RESET_TURN_SET+RESET_TOFIELD+RESET_OVERLAY)
		e1:SetCondition(s.spcon2)
		e1:SetOperation(s.spop2)
		tc:RegisterEffect(e1,true)
		tc:RegisterFlagEffect(id+o,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(id,0))
	end
end
function s.spcon2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousLocation(LOCATION_MZONE) and c:IsPreviousPosition(POS_FACEUP)
end
function s.spfilter2(c,e,tp)
	return c:IsCode(id) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.spop2(e,tp,eg,ep,ev,re,r,rp)
	if Duel.IsExistingMatchingCard(s.spfilter2,tp,LOCATION_HAND,0,1,nil,e,tp) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 
	and Duel.SelectYesNo(tp,aux.Stringid(id,2)) then
		Duel.Hint(HINT_CARD,0,id)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,s.spfilter2,tp,LOCATION_HAND,0,1,1,nil,e,tp)
		if #g>0 then
			Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end
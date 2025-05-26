--追忆的自动人形
local s,id,o=GetID()
function s.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetRange(LOCATION_HAND)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_SPSUM_PARAM)
	e1:SetTargetRange(POS_FACEUP,1)
	e1:SetCondition(s.con)
	c:RegisterEffect(e1)  
	--tograve
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_ADJUST)
	e2:SetRange(LOCATION_MZONE)
	e2:SetOperation(s.adjustop)
	c:RegisterEffect(e2)
	--special summon
	local custom_code=s.RegisterMergedEvent_ToSingleCard(c,id,EVENT_TO_GRAVE)
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(custom_code)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCondition(s.spcon)
	e3:SetCost(s.spcost)
	e3:SetTarget(s.sptg)
	e3:SetOperation(s.spop)
	c:RegisterEffect(e3)
end
function s.con(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(1-tp,LOCATION_MZONE)>0
end
function s.tgfilter(c,g)
	return g:IsContains(c)
end
function s.adjustop(e,tp,eg,ep,ev,re,r,rp)
	local phase=Duel.GetCurrentPhase()
	if (phase==PHASE_DAMAGE and not Duel.IsDamageCalculated()) or phase==PHASE_DAMAGE_CAL then return end
	local cg=e:GetHandler():GetColumnGroup()
	cg:AddCard(e:GetHandler())
	local g=Duel.GetMatchingGroup(s.tgfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil,cg)
	if Duel.SendtoGrave(g,REASON_EFFECT)>0 then
		Duel.Readjust()
	end
end
function s.RegisterMergedEvent_ToSingleCard(c,code,events)
	local g=Group.CreateGroup()
	g:KeepAlive()
	local mt=getmetatable(c)
	local seed=0
	if type(events) == "table" then
		for _, event in ipairs(events) do
			seed = seed + event
		end
	else
		seed = events
	end
	while(mt[seed]==true) do
		seed = seed + 1
	end
	mt[seed]=true
	local event_code_single = (code ~ (seed << 16)) | EVENT_CUSTOM
	if type(events) == "table" then
		for _, event in ipairs(events) do
			s.RegisterMergedEvent_ToSingleCard_AddOperation(c,g,event,event_code_single)
		end
	else
		s.RegisterMergedEvent_ToSingleCard_AddOperation(c,g,events,event_code_single)
	end
	return event_code_single
end
function s.RegisterMergedEvent_ToSingleCard_AddOperation(c,g,event,event_code_single)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(event)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_SET_AVAILABLE)
	e1:SetRange(0xff)
	e1:SetLabel(event_code_single)
	e1:SetLabelObject(g)
	e1:SetOperation(s.MergedDelayEventCheck1_ToSingleCard)
	c:RegisterEffect(e1)
	local ec={
		EVENT_CHAIN_ACTIVATING,
		EVENT_CHAINING,
		EVENT_ATTACK_ANNOUNCE,
		EVENT_BREAK_EFFECT,
		EVENT_CHAIN_SOLVING,
		EVENT_CHAIN_SOLVED,
		EVENT_CHAIN_END,
		EVENT_SUMMON,
		EVENT_SPSUMMON,
		EVENT_MSET,
		EVENT_BATTLE_DESTROYED
	}
	for _,code in ipairs(ec) do
		local ce=e1:Clone()
		ce:SetCode(code)
		ce:SetOperation(s.MergedDelayEventCheck2_ToSingleCard)
		c:RegisterEffect(ce)
	end
end
function s.MergedDelayEventCheck1_ToSingleCard(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetLabelObject()
	local c=e:GetOwner()
	g:Merge(eg)
	if Duel.GetCurrentChain()==0 and #g>0 and g:IsExists(Card.IsReason,1,nil,REASON_ADJUST|REASON_EFFECT) then
		local _eg=g:Clone()
		Duel.RaiseEvent(_eg,e:GetLabel(),re,r,rp,ep,ev)
		g:Clear()
	end
end
function s.MergedDelayEventCheck2_ToSingleCard(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetLabelObject()
	if #g>0 then
		local _eg=g:Clone()
		Duel.RaiseEvent(_eg,e:GetLabel(),re,r,rp,ep,ev)
		g:Clear()
	end
end
function s.spfilter(c,spcard)
	return c:IsOriginalCodeRule(spcard:GetOriginalCodeRule())
end
function s.spcon(e,tp,eg,ep,ev,re,r,rp)
	return #eg>=3 and eg:IsContains(e:GetHandler())
end
function s.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.Remove(eg,POS_FACEUP,REASON_COST)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,1-tp,LOCATION_DECK)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.IsPlayerCanSpecialSummon(tp) then return end
	local g=Duel.GetMatchingGroup(Card.IsSummonableCard,1-tp,LOCATION_DECK,0,nil)
	local dcount=Duel.GetFieldGroupCount(1-tp,LOCATION_DECK,0)
	local seq=-1
	local tc=g:GetFirst()
	local spcard=nil
	while tc do
		if tc:GetSequence()>seq then
			seq=tc:GetSequence()
			spcard=tc
		end
		tc=g:GetNext()
	end
	if seq==-1 then
		Duel.ConfirmDecktop(1-tp,dcount)
		Duel.ShuffleDeck(1-tp)
		return
	end
	Duel.ConfirmDecktop(1-tp,dcount-seq)
	if Duel.GetLocationCount(1-tp,LOCATION_MZONE)>0 and spcard:IsCanBeSpecialSummoned(e,0,tp,false,false) then
		Duel.DisableShuffleCheck()
		if dcount-seq==1 then Duel.SpecialSummon(spcard,0,tp,1-tp,false,false,POS_FACEUP)
		local g=Duel.GetMatchingGroup(s.spfilter,tp,0x7f,0x7f,nil,spcard)
		local tc=g:GetFirst()
		while tc do
			local e0=Effect.CreateEffect(e:GetHandler())
			e0:SetType(EFFECT_TYPE_SINGLE)
			e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e0:SetCode(EFFECT_CHANGE_CODE)
			e0:SetValue(91300044)
			tc:RegisterEffect(e0)
			--special summon
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_FIELD)
			e1:SetCode(EFFECT_SPSUMMON_PROC)
			e1:SetRange(LOCATION_HAND)
			e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_SPSUM_PARAM)
			e1:SetTargetRange(POS_FACEUP,1)
			e1:SetCondition(s.con)
			tc:RegisterEffect(e1)  
			--tograve
			local e2=Effect.CreateEffect(e:GetHandler())
			e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			e2:SetCode(EVENT_ADJUST)
			e2:SetRange(LOCATION_MZONE)
			e2:SetOperation(s.adjustop)
			tc:RegisterEffect(e2)
			--special summon
			local custom_code=s.RegisterMergedEvent_ToSingleCard(e:GetHandler(),id,EVENT_TO_GRAVE)
			local e3=Effect.CreateEffect(e:GetHandler())
			e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
			e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
			e3:SetCode(custom_code)
			e3:SetRange(LOCATION_GRAVE)
			e3:SetProperty(EFFECT_FLAG_DELAY)
			e3:SetCondition(s.spcon)
			e3:SetCost(s.spcost)
			e3:SetTarget(s.sptg)
			e3:SetOperation(s.spop)
			tc:RegisterEffect(e3)
			if not tc:IsType(TYPE_EFFECT) then
				local e4=Effect.CreateEffect(e:GetHandler())
				e4:SetType(EFFECT_TYPE_SINGLE)
				e4:SetCode(EFFECT_ADD_TYPE)
				e4:SetValue(TYPE_EFFECT)
				tc:RegisterEffect(e4)
			end
			tc=g:GetNext()
		end
		else
			Duel.SpecialSummonStep(spcard,0,tp,1-tp,false,false,POS_FACEUP)
			Duel.ShuffleDeck(1-tp)
			Duel.SpecialSummonComplete()
			local g=Duel.GetMatchingGroup(s.spfilter,tp,0x7f,0x7f,nil,spcard)
			local tc=g:GetFirst()
			while tc do
				local e0=Effect.CreateEffect(e:GetHandler())
				e0:SetType(EFFECT_TYPE_SINGLE)
				e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
				e0:SetCode(EFFECT_CHANGE_CODE)
				e0:SetValue(91300044)
				tc:RegisterEffect(e0)
				--special summon
				local e1=Effect.CreateEffect(e:GetHandler())
				e1:SetType(EFFECT_TYPE_FIELD)
				e1:SetCode(EFFECT_SPSUMMON_PROC)
				e1:SetRange(LOCATION_HAND)
				e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_SPSUM_PARAM)
				e1:SetTargetRange(POS_FACEUP,1)
				e1:SetCondition(s.con)
				tc:RegisterEffect(e1)  
				--tograve
				local e2=Effect.CreateEffect(e:GetHandler())
				e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
				e2:SetCode(EVENT_ADJUST)
				e2:SetRange(LOCATION_MZONE)
				e2:SetOperation(s.adjustop)
				tc:RegisterEffect(e2)
				--special summon
				local custom_code=s.RegisterMergedEvent_ToSingleCard(e:GetHandler(),id,EVENT_TO_GRAVE)
				local e3=Effect.CreateEffect(e:GetHandler())
				e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
				e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
				e3:SetCode(custom_code)
				e3:SetRange(LOCATION_GRAVE)
				e3:SetProperty(EFFECT_FLAG_DELAY)
				e3:SetCondition(s.spcon)
				e3:SetCost(s.spcost)
				e3:SetTarget(s.sptg)
				e3:SetOperation(s.spop)
				tc:RegisterEffect(e3)
				if not tc:IsType(TYPE_EFFECT) then
					local e4=Effect.CreateEffect(e:GetHandler())
					e4:SetType(EFFECT_TYPE_SINGLE)
					e4:SetCode(EFFECT_ADD_TYPE)
					e4:SetValue(TYPE_EFFECT)
					tc:RegisterEffect(e4)
				end
				tc=g:GetNext()
			end
		end
	else
		Duel.ShuffleDeck(1-tp)
	end
end

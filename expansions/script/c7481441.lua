--守墓的祭祀
local s,id,o=GetID()
function s.initial_effect(c)
	--set
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_HAND+LOCATION_MZONE)
	e1:SetCountLimit(1,id)
	e1:SetHintTiming(TIMING_DRAW_PHASE+TIMING_END_PHASE,TIMING_DRAW_PHASE+TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetCost(s.setcost)
	e1:SetTarget(s.settg)
	e1:SetOperation(s.setop)
	c:RegisterEffect(e1)
	if not s.global_effect then
		s.global_effect=true
		--Activate to field
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD)
		ge1:SetCode(EFFECT_ACTIVATE_COST)
		ge1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_SET_AVAILABLE)
		ge1:SetTargetRange(1,0)
		ge1:SetTarget(s.actarget)
		ge1:SetOperation(s.costop)
		Duel.RegisterEffect(ge1,0)
		local ge2=ge1:Clone()
		Duel.RegisterEffect(ge2,1)
	end
end
function s.actarget(e,te,tp)
	local tc=te:GetHandler()
	e:SetLabelObject(te)
	return (te:GetValue()==id or te:GetValue()==id+1) and tc and tc:IsPosition(POS_FACEDOWN) and tc:IsLocation(LOCATION_MZONE)
end
function s.costop(e,tp,eg,ep,ev,re,r,rp)
	local te=e:GetLabelObject()
	local tc=te:GetHandler()
	Duel.ChangePosition(tc,POS_FACEUP_DEFENSE)
end
function s.setcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsReleasable() end
	Duel.Release(e:GetHandler(),REASON_COST)
end
function s.setfilter(c,e,tp)
	local type=bit.band(c:GetType(),0x7)
	return (c:IsSetCard(0x2e) or c:IsSetCard(0x91)) and Duel.IsExistingMatchingCard(Card.IsType,1-tp,LOCATION_GRAVE,0,1,nil,type) and 
		   ((c:IsType(TYPE_MONSTER) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
			and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEDOWN_DEFENSE)) or ((c:IsType(TYPE_FIELD) or Duel.GetLocationCount(tp,LOCATION_SZONE)>0)
			and c:IsSSetable()))
end
function s.setfilter2(c,e,tp,type)
	return c:IsType(type) and ((c:IsType(TYPE_MONSTER) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
			and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEDOWN_DEFENSE,tp)) or ((c:IsType(TYPE_FIELD) or Duel.GetLocationCount(tp,LOCATION_SZONE)>0)
			and c:IsSSetable()))
end
function s.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.setfilter,tp,LOCATION_DECK,0,1,nil,e,tp) end
end
function s.gcheck(g,mft,sft)
	return g:FilterCount(Card.IsType,nil,TYPE_MONSTER)<=mft
		and (g:FilterCount(Card.IsType,nil,TYPE_TRAP+TYPE_SPELL)-g:FilterCount(Card.IsType,nil,TYPE_FIELD)<=sft)
		and g:FilterCount(Card.IsType,nil,TYPE_SPELL)<=1
		and g:FilterCount(Card.IsType,nil,TYPE_TRAP)<=1
end
function s.gcheck2(g,mft,sft,sct,tct)
	return g:FilterCount(Card.IsType,nil,TYPE_MONSTER)<=mft
		and (g:FilterCount(Card.IsType,nil,TYPE_TRAP+TYPE_SPELL)-g:FilterCount(Card.IsType,nil,TYPE_FIELD)<=sft)
		and g:FilterCount(Card.IsType,nil,TYPE_SPELL)<=sct
		and g:FilterCount(Card.IsType,nil,TYPE_TRAP)<=tct
end
function s.setop(e,tp,eg,ep,ev,re,r,rp)
	local mft,sft=Duel.GetLocationCount(tp,LOCATION_MZONE),Duel.GetLocationCount(tp,LOCATION_SZONE)
	local g=Duel.GetMatchingGroup(s.setfilter,tp,LOCATION_DECK,0,nil,e,tp)
	if #g<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local tg=g:SelectSubGroup(tp,s.gcheck,false,1,3,math.min(1,mft),sft)
	if not tg then return end
	local sg=tg:Filter(aux.NOT(Card.IsType),nil,TYPE_MONSTER)
	if #sg>0 then
		Duel.SSet(tp,sg)
		local tc=sg:GetFirst()
		while tc do
			if tc:IsType(TYPE_TRAP) then
				local e1=Effect.CreateEffect(e:GetHandler())
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_TRAP_ACT_IN_SET_TURN)
				e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
				e1:SetReset(RESET_EVENT+RESETS_STANDARD)
				tc:RegisterEffect(e1)
			end
			tc=sg:GetNext()
		end
	end
	Duel.ResetFlagEffect(0,id)
	local mg=tg:Filter(Card.IsType,nil,TYPE_MONSTER)
	if #mg>0 then
		local tc=mg:GetFirst()
		--Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEDOWN_DEFENSE)
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEDOWN_DEFENSE)
		local cregister=Card.RegisterEffect
		Card.RegisterEffect=function(card,effect,flag)
			if effect and (effect:IsHasType(EFFECT_TYPE_IGNITION) or effect:IsHasType(EFFECT_TYPE_TRIGGER_F) or effect:IsHasType(EFFECT_TYPE_TRIGGER_O) or effect:IsHasType(EFFECT_TYPE_QUICK_F) or effect:IsHasType(EFFECT_TYPE_QUICK_O)) then
				local type=effect:GetType()
				local prop=effect:GetProperty()
				if effect:IsHasType(EFFECT_TYPE_TRIGGER_O) then
					effect:SetType(EFFECT_TYPE_QUICK_O)
					effect:SetRange(LOCATION_MZONE)
					local con=effect:GetCondition()
					effect:SetCondition(
					function(e,tp,eg,ep,ev,re,r,rp)
						if not eg:IsContains(e:GetHandler()) then return false end
						return not con or con(e,tp,eg,ep,ev,re,r,rp)
					end)
				end
				if effect:IsHasType(EFFECT_TYPE_TRIGGER_F) then
					effect:SetType(EFFECT_TYPE_QUICK_F)
					effect:SetRange(LOCATION_MZONE)
					local con=effect:GetCondition()
					effect:SetCondition(
					function(e,tp,eg,ep,ev,re,r,rp)
						if not eg:IsContains(e:GetHandler()) then return false end
						return not con or con(e,tp,eg,ep,ev,re,r,rp)
					end)
				end
				--
				--prop=prop&(~EFFECT_FLAG_DELAY)
				if bit.band(prop,EFFECT_FLAG_DELAY)==EFFECT_FLAG_DELAY then
					prop=bit.bxor(prop,EFFECT_FLAG_DELAY)
					if Duel.GetFlagEffect(0,id)==0 then
						Duel.RegisterFlagEffect(0,id,0,0,1)
						--raise event
						local e3=Effect.CreateEffect(card)
						e3:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
						e3:SetCode(EVENT_CHAIN_END)
						e3:SetLabelObject(card)
						e3:SetOperation(s.op)
						Duel.RegisterEffect(e3,card:GetControler())
					end
				end
				--prop=prop|EFFECT_FLAG_SET_AVAILABLE 
				if bit.band(prop,EFFECT_FLAG_SET_AVAILABLE)==0 then
					prop=prop+EFFECT_FLAG_SET_AVAILABLE 
				end
				effect:SetProperty(prop)
				--Debug.Message(effect:GetType())
				--Debug.Message(effect:GetProperty())
				--Debug.Message("--------")
				effect:SetValue(id)
			end
			return cregister(card,effect,flag)
		end
		local cid=tc:CopyEffect(tc:GetOriginalCode(),RESET_EVENT+RESETS_STANDARD,1)
		Card.RegisterEffect=cregister
		--flip
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
		e2:SetCode(EVENT_FLIP)
		e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		e2:SetRange(LOCATION_MZONE)
		e2:SetLabel(cid)
		e2:SetOperation(s.rstop)
		tc:RegisterEffect(e2)
		Duel.SpecialSummonComplete()
		Duel.ConfirmCards(1-tp,tc)
	end
  --[[if tc:IsType(TYPE_MONSTER) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
	   and (not tc:IsLocation(LOCATION_EXTRA) or Duel.GetLocationCountFromEx(tp)>0)
	   and tc:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEDOWN_DEFENSE) 
	   and Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEDOWN_DEFENSE) 
	   then
		local cregister=Card.RegisterEffect
		Card.RegisterEffect=function(card,effect,flag)
			if effect and (effect:IsHasType(EFFECT_TYPE_IGNITION) or effect:IsHasType(EFFECT_TYPE_TRIGGER_F) or effect:IsHasType(EFFECT_TYPE_TRIGGER_O) or effect:IsHasType(EFFECT_TYPE_QUICK_F) or effect:IsHasType(EFFECT_TYPE_QUICK_O)) then
				local type=effect:GetType()
				local prop=effect:GetProperty()
				if effect:IsHasType(EFFECT_TYPE_TRIGGER_O) then
					effect:SetType(EFFECT_TYPE_QUICK_O)
					effect:SetRange(LOCATION_MZONE)
				end
				if effect:IsHasType(EFFECT_TYPE_TRIGGER_F) then
					effect:SetType(EFFECT_TYPE_QUICK_F)
					effect:SetRange(LOCATION_MZONE)
				end
				--
				if bit.band(prop,EFFECT_FLAG_DELAY)==EFFECT_FLAG_DELAY then
					prop=bit.bxor(prop,EFFECT_FLAG_DELAY)
				end
				if bit.band(prop,EFFECT_FLAG_SET_AVAILABLE)==0 then
					prop=prop+EFFECT_FLAG_SET_AVAILABLE 
				end
				effect:SetProperty(prop)
				effect:SetValue(id)
			end
			return cregister(card,effect,flag)
		end
		local cid=tc:CopyEffect(tc:GetOriginalCode(),RESET_EVENT+RESETS_STANDARD,1)
		Card.RegisterEffect=cregister
		--flip
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
		e2:SetCode(EVENT_FLIP)
		e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		e2:SetRange(LOCATION_MZONE)
		e2:SetLabel(cid)
		e2:SetOperation(s.rstop)
		tc:RegisterEffect(e2)
		Duel.SpecialSummonComplete()
		--Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEDOWN_DEFENSE)
		--Duel.RaiseEvent(Group.FromCards(tc),EVENT_SPSUMMON_SUCCESS,e,REASON_EFFECT,tp,tp,Duel.GetCurrentChain())
		--Duel.RaiseSingleEvent(tc,EVENT_SPSUMMON_SUCCESS,e,REASON_EFFECT,tp,tp,Duel.GetCurrentChain())
		Duel.ConfirmCards(1-tp,tc)
	elseif (tc:IsType(TYPE_FIELD) or Duel.GetLocationCount(tp,LOCATION_SZONE)>0)
		and tc:IsSSetable() then
		Duel.SSet(tp,tc)
		if tc:IsType(TYPE_TRAP) then
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_TRAP_ACT_IN_SET_TURN)
			e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e1)
		end
	end]]
	--
	local stype=0
	if tg:FilterCount(Card.IsType,nil,TYPE_MONSTER)>0 then stype=stype|TYPE_MONSTER end
	if tg:FilterCount(Card.IsType,nil,TYPE_SPELL)>0 then stype=stype|TYPE_SPELL end
	if tg:FilterCount(Card.IsType,nil,TYPE_TRAP)>0 then stype=stype|TYPE_TRAP end
	local mft2,sft2=Duel.GetLocationCount(1-tp,LOCATION_MZONE),Duel.GetLocationCount(1-tp,LOCATION_SZONE)
	local g2=Duel.GetMatchingGroup(aux.NecroValleyFilter(s.setfilter2),1-tp,LOCATION_GRAVE,0,nil,e,1-tp,stype)
	if #g2<=0 or not Duel.SelectYesNo(1-tp,aux.Stringid(id,2)) then return end
	Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_SET)
	local tg2=g2:SelectSubGroup(1-tp,s.gcheck,false,1,3,math.min(tg:FilterCount(Card.IsType,nil,TYPE_MONSTER),mft2),sft2,tg:FilterCount(Card.IsType,nil,TYPE_SPELL),tg:FilterCount(Card.IsType,nil,TYPE_TRAP))
	if not tg2 then return end
	Duel.BreakEffect()
	local sg2=tg2:Filter(aux.NOT(Card.IsType),nil,TYPE_MONSTER)
	if #sg2>0 then
		Duel.SSet(1-tp,sg2)
		local tc=sg2:GetFirst()
		while tc do
			if tc:IsType(TYPE_TRAP) then
				local e1=Effect.CreateEffect(e:GetHandler())
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_TRAP_ACT_IN_SET_TURN)
				e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
				e1:SetReset(RESET_EVENT+RESETS_STANDARD)
				tc:RegisterEffect(e1)
			end
			tc=sg2:GetNext()
		end
	end
	local mg2=tg2:Filter(Card.IsType,nil,TYPE_MONSTER)
	if #mg2>0 then
		local tc=mg2:GetFirst()
		--Duel.SpecialSummonStep(tc,0,1-tp,1-tp,false,false,POS_FACEDOWN_DEFENSE)
		Duel.SpecialSummon(tc,0,1-tp,1-tp,false,false,POS_FACEDOWN_DEFENSE)
		if tc:IsSetCard(0x2e) then
			local cregister=Card.RegisterEffect
			Card.RegisterEffect=function(card,effect,flag)
				if effect and (effect:IsHasType(EFFECT_TYPE_IGNITION) or effect:IsHasType(EFFECT_TYPE_TRIGGER_F) or effect:IsHasType(EFFECT_TYPE_TRIGGER_O) or effect:IsHasType(EFFECT_TYPE_QUICK_F) or effect:IsHasType(EFFECT_TYPE_QUICK_O)) then
					local type=effect:GetType()
					local prop=effect:GetProperty()
					if effect:IsHasType(EFFECT_TYPE_TRIGGER_O) then
						effect:SetType(EFFECT_TYPE_QUICK_O)
						effect:SetRange(LOCATION_MZONE)
						local con=effect:GetCondition()
						effect:SetCondition(
						function(e,tp,eg,ep,ev,re,r,rp)
							if not eg:IsContains(e:GetHandler()) then return false end
							return not con or con(e,tp,eg,ep,ev,re,r,rp)
						end)
					end
					if effect:IsHasType(EFFECT_TYPE_TRIGGER_F) then
						effect:SetType(EFFECT_TYPE_QUICK_F)
						effect:SetRange(LOCATION_MZONE)
						local con=effect:GetCondition()
						effect:SetCondition(
						function(e,tp,eg,ep,ev,re,r,rp)
							if not eg:IsContains(e:GetHandler()) then return false end
							return not con or con(e,tp,eg,ep,ev,re,r,rp)
						end)
					end
					--
					if bit.band(prop,EFFECT_FLAG_DELAY)==EFFECT_FLAG_DELAY then
						prop=bit.bxor(prop,EFFECT_FLAG_DELAY)
						if Duel.GetFlagEffect(0,id)==0 then
							Duel.RegisterFlagEffect(0,id,0,0,1)
							--raise event
							local e3=Effect.CreateEffect(card)
							e3:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
							e3:SetCode(EVENT_CHAIN_END)
							e3:SetLabelObject(card)
							e3:SetOperation(s.op)
							Duel.RegisterEffect(e3,card:GetControler())
						end
					end
					if bit.band(prop,EFFECT_FLAG_SET_AVAILABLE)==0 then
						prop=prop+EFFECT_FLAG_SET_AVAILABLE 
					end
					effect:SetProperty(prop)
					effect:SetValue(id)
				end
				return cregister(card,effect,flag)
			end
			local cid=tc:CopyEffect(tc:GetOriginalCode(),RESET_EVENT+RESETS_STANDARD,1)
			Card.RegisterEffect=cregister
			--flip
			local e2=Effect.CreateEffect(e:GetHandler())
			e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
			e2:SetCode(EVENT_FLIP)
			e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
			e2:SetReset(RESET_EVENT+RESETS_STANDARD)
			e2:SetRange(LOCATION_MZONE)
			e2:SetLabel(cid)
			e2:SetOperation(s.rstop)
			tc:RegisterEffect(e2)
		end
		--Duel.SpecialSummonComplete()
		Duel.ConfirmCards(1-tp,tc)
	end
end
function s.rstop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local cid=e:GetLabel()
	c:ResetEffect(cid,RESET_COPY)
	c:ResetEffect(RESET_DISABLE,RESET_EVENT)
	e:Reset()
end
function s.op(e,tp,eg,ep,ev,re,r,rp)
	Debug.Message("0")
	local c=e:GetLabelObject()
	Duel.RaiseEvent(c,EVENT_SPSUMMON_SUCCESS,e,REASON_EFFECT,e:GetHandlerPlayer(),0,0)
	--[[
	--reset&RaiseSingleEvent
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_ACTIVATE_COST)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_SET_AVAILABLE)
	e2:SetTargetRange(1,1)
	e2:SetTarget(s.actarget2)
	e2:SetOperation(s.costop2)
	Duel.RegisterEffect(e2,0)
	--reset
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e1:SetCode(EVENT_ADJUST)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetOperation(s.rstop2)
	Duel.RegisterEffect(e1,c:GetControler())
	--
	e1:SetLabelObject(e2)
	e2:SetLabelObject(e1)]]
	e:Reset()
end
function s.rstop2(e,tp,eg,ep,ev,re,r,rp)
	Debug.Message("1")
	if e:GetLabel()~=1 then e:SetLabel(1) return end
	e:GetLabelObject():Reset()
	e:Reset()
end
function s.actarget2(e,te,tp)
	if not te then return end
	return te:IsHasType(EFFECT_TYPE_TRIGGER_O) or te:IsHasType(EFFECT_TYPE_TRIGGER_F)
end
function s.costop2(e,tp,eg,ep,ev,re,r,rp)
	local c=re:GetOwner()
	Duel.RaiseEvent(c,EVENT_SPSUMMON_SUCCESS,e,REASON_EFFECT,e:GetHandlerPlayer(),0,0)
	--reset&RaiseSingleEvent
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_CHAINING)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_SET_AVAILABLE)
	e2:SetTargetRange(1,1)
	e2:SetReset(RESET_CHAIN)
	e2:SetTarget(s.actarget2)
	e2:SetOperation(s.costop3)
	Duel.RegisterEffect(e2,c:GetControler())
	--
	Debug.Message("2")
	e:GetLabelObject():Reset()
	e:Reset()
end
function s.costop3(e,tp,eg,ep,ev,re,r,rp)
	local c=re:GetOwner()
	Duel.RaiseSingleEvent(c,EVENT_SPSUMMON_SUCCESS,e,REASON_EFFECT,e:GetHandlerPlayer(),0,0)
end

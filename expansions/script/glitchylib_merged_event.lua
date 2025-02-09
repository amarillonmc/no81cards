--MERGED EVENT GROUP HANDLER
Duel.LoadScript("glitchylib_vsnemo.lua")

local _rmde = Auxiliary.RegisterMergedDelayedEvent

Auxiliary.RegisterMergedDelayedEvent = function(c,code,event,g)
	if c:IsStatus(STATUS_COPYING_EFFECT) then return end
	return _rmde(c,code,event,g)
end

EVENT_COUNTER_ID = 0
aux.EventCounter = {}
EVENT_ID = 0
MERGED_ID = 1
aux.MustUpdateEventID = {}
aux.MergedDelayedEventInfotable = {}
aux.DelayedEventRaiserTable = {}

--[[Raises custom event with a compound Event Group containing all cards that raised the specified event at different times during a Chain.
Handles correct interactions with Trigger Effects whose resolution depends on the specific card that raised the event (eg. Union Hangar)
c 								= The card that needs to check for the event
code 							= The code of the custom event that will be raised.
event							= The event that must be checked. You can specify multiple events by passing a table
f								= Filter for the cards that are involved in the "event(s)"
flag							= Specify the id for the flag effect that is used internally by this function
range							= If specified, these checks will only be performed while "c" is in the "range". Otherwise, the checks are always performed during the Duel
								 (the latter case applies for private-location Trigger Effects)
evgcheck						= You can specify an additional check for the compound Event Group before raising the custom event. If this check is not passed, the custom event is not raised.
check_if_already_in_location	= If a location is specified, the respective AddThisCardInLocationAlreadyCheck will be performed
operation						= You can invoke a function before raising the custom event. The function must return the Event Value of the custom event.
simult_check					= You can specify an id for an additional flag that separately keeps track of cards that were simultaneously involved in an instance of the specified event.
forced							= Raises the custom event even if the final group is empty (required for mandatory Trigger Effects)
customevgop						= Allows to call a custom function when the cards involved in the local Event Groups are receiving the flag
								(useful for effects that must keep track of certain properties the cards had in a previous location)
raiseOnlyOneEvent				= If true, only 1 custom event will be raised, independently from how many times the input event was detected
]]
function Auxiliary.RegisterMergedDelayedEventGlitchy(c,code,event,f,flag,range,evgcheck,check_if_already_in_location,operation,simult_check,forced,customevgop,raiseOnlyOneEvent)
	if type(event)~="table" then event={event} end
	if not f then f=aux.TRUE end
	if not flag then flag=c:GetOriginalCode() end
	local se
	if check_if_already_in_location then
		if check_if_already_in_location&LOCATION_GRAVE>0 then
			se=aux.AddThisCardInGraveAlreadyCheck(c)
		elseif check_if_already_in_location&LOCATION_FZONE>0 then
			se=aux.AddThisCardInFZoneAlreadyCheck(c)
		elseif check_if_already_in_location&LOCATION_MZONE>0 then
			se=aux.AddThisCardInMZoneAlreadyCheck(c)
		elseif check_if_already_in_location&LOCATION_SZONE>0 then
			se=aux.AddThisCardInSZoneAlreadyCheck(c)
		elseif check_if_already_in_location&LOCATION_PZONE>0 then
			se=aux.AddThisCardInPZoneAlreadyCheck(c)
		end
	end
	
	local g=Group.CreateGroup()
	g:KeepAlive()
	
	if forced then
		EVENT_COUNTER_ID = EVENT_COUNTER_ID + 1
		aux.EventCounter[EVENT_COUNTER_ID]=0
	end
	
	local updateflag=false
	local private_range=not range and 1 or range&LOCATIONS_PRIVATE
	local public_range=not range and 0 or range&(~private_range)
	
	if private_range>0 then
		updateflag=true
		local mt=getmetatable(c)
		local ge1
		for _,ev in ipairs(event) do
			if mt[ev]~=true then
				mt[ev]=true
				ge1=Effect.CreateEffect(c)
				ge1:SetType(EFFECT_TYPE_FIELD|EFFECT_TYPE_CONTINUOUS)
				ge1:SetCode(ev)
				ge1:SetLabel(code)
				ge1:SetLabelObject(g)
				ge1:SetOperation(Auxiliary.MergedDelayEventCheckGlitchy1(ev,flag,f,nil,evgcheck,nil,operation,simult_check,forced,customevgop,EVENT_COUNTER_ID,raiseOnlyOneEvent))
				Duel.RegisterEffect(ge1,0)
			end
		end
		if ge1 then
			local ge2=ge1:Clone()
			ge2:SetCode(EVENT_CHAIN_END)
			ge2:SetCondition(aux.TRUE)
			ge2:SetOperation(Auxiliary.MergedDelayEventCheckGlitchy2(flag,nil,evgcheck,nil,operation,forced,EVENT_COUNTER_ID,raiseOnlyOneEvent))
			Duel.RegisterEffect(ge2,0)
		end
		if simult_check then
			aux.MustUpdateEventID[c]=false
			local ge3=Effect.CreateEffect(c)
			ge3:SetType(EFFECT_TYPE_FIELD|EFFECT_TYPE_CONTINUOUS)
			ge3:SetCode(EVENT_BREAK_EFFECT)
			ge3:SetOperation(aux.SignalEventIDUpdate)
			Duel.RegisterEffect(ge3,0)
			local ge4=ge3:Clone()
			ge4:SetCode(EVENT_CHAIN_SOLVED)
			Duel.RegisterEffect(ge4,0)
			local ge5=ge3:Clone()
			ge5:SetCode(EVENT_CHAINING)
			Duel.RegisterEffect(ge5,0)
		end
	end
		
	if public_range>0 then
		if updateflag then code=code+100 flag=flag+100 end
		local ge1
		for _,ev in ipairs(event) do
			ge1=Effect.CreateEffect(c)
			ge1:SetType(EFFECT_TYPE_FIELD|EFFECT_TYPE_CONTINUOUS)
			ge1:SetCode(ev)
			--ge1:SetRange(range)
			ge1:SetLabel(code)
			ge1:SetLabelObject(g)
			ge1:SetOperation(Auxiliary.MergedDelayEventCheckGlitchy1(ev,flag,f,public_range,evgcheck,se,operation,simult_check,forced,customevgop,EVENT_COUNTER_ID,raiseOnlyOneEvent))
			Duel.RegisterEffect(ge1,0)
		end
		local ge2=ge1:Clone()
		ge2:SetCode(EVENT_CHAIN_END)
		ge2:SetCondition(aux.TRUE)
		ge2:SetOperation(Auxiliary.MergedDelayEventCheckGlitchy2(flag,public_range,evgcheck,se,operation,forced,EVENT_COUNTER_ID,raiseOnlyOneEvent))
		Duel.RegisterEffect(ge2,0)
		if simult_check then
			aux.MustUpdateEventID[c]=false
			local ge3=Effect.CreateEffect(c)
			ge3:SetType(EFFECT_TYPE_FIELD|EFFECT_TYPE_CONTINUOUS)
			ge3:SetCode(EVENT_BREAK_EFFECT)
			ge3:SetOperation(aux.SignalEventIDUpdate)
			Duel.RegisterEffect(ge3,0)
			local ge4=ge3:Clone()
			ge4:SetCode(EVENT_CHAIN_SOLVED)
			Duel.RegisterEffect(ge4,0)
			local ge5=ge3:Clone()
			ge5:SetCode(EVENT_CHAINING)
			Duel.RegisterEffect(ge5,0)
		end
	end
	
end
function Auxiliary.SignalEventIDUpdate(e,tp,eg,ep,ev,re,r,rp)
	aux.MustUpdateEventID[e:GetOwner()] = true
end
function Auxiliary.MergedDelayEventCheckGlitchy1(event,id,f,range,evgcheck,se,operation,simult_check,forced,customevgop,eid,raiseOnlyOneEvent)
	return	function(e,tp,eg,ep,ev,re,r,rp)
				local c=e:GetOwner()
				local tp=c:GetControler()
				
				if range then
					if not c:IsLocation(range) or eg:IsContains(c) then
						return
					end
					if c:IsLocation(LOCATION_SZONE) and not c:IsHasEffect(EFFECT_CARD_HAS_RESOLVED) then
						return
					end
				end
				local label = (range) and c:GetFieldID() or 0
				local g=e:GetLabelObject()
				if aux.GetValueType(g)~="Group" then return end
				local obj = aux.GetValueType(se)=="Effect" and se:GetLabelObject() or nil
				local evg=eg:Filter(f,nil,e,tp,eg,ep,ev,re,r,rp,obj,event):Filter(aux.SimultaneousEventCheck,nil,obj)
				--Debug.Message(#evg)
				local flagID=id
				
				local updatedEventID=false
				if aux.MustUpdateEventID[c]==true then
					updatedEventID=true
					if forced and type(aux.EventCounter[eid])=="number" and #evg>0 then
						aux.EventCounter[eid] = aux.EventCounter[eid] + 1
					end
					EVENT_ID = EVENT_ID + 1
					aux.MustUpdateEventID[c]=false
				end
				
				for tc in aux.Next(evg) do
					if type(id)=="function" then
						flagID=id(event,tc,e,tp,eg,ep,ev,re,r,rp)
					end
					tc:RegisterFlagEffect(flagID,RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET,EFFECT_FLAG_SET_AVAILABLE,1,label)
					--Debug.Message('Card '..label..' has registered flag: '..tostring(tc:HasFlagEffectLabel(flagID,label)))
					if simult_check then
						tc:RegisterFlagEffect(simult_check,RESET_PHASE+PHASE_END,EFFECT_FLAG_SET_AVAILABLE,1,EVENT_ID)
					end
					if customevgop then
						customevgop(tc,e,tp,eg,ep,ev,re,r,rp,evg)
					end
				end
				
				g:Merge(evg)
				--Debug.Message('gsize '..tostring(#g))
				
				if Duel.GetCurrentChain()==0 and not Duel.CheckEvent(EVENT_CHAIN_SOLVED) and not Duel.CheckEvent(EVENT_CHAIN_END) then
					--Debug.Message('nochain')
					local flags	
					if type(id)=="function" then
						flags={id()}
					else
						flags={id}
					end
					local G=Group.CreateGroup()
					for _,cid in ipairs(flags) do
						local _eg=g:Clone()
						_eg=_eg:Filter(Card.HasFlagEffectLabel,nil,cid,label)
						--Debug.Message("NOCHAIN_FILTERED_COUNT "..tostring(cid)..": "..tostring(#_eg))
						G:Merge(_eg)
					end
					
					if g and #g>0 and (#G>0 or forced) then
						if not evgcheck or evgcheck(G,e,tp,ep,ev,re,r,rp) then
							--Debug.Message('a')
							local customev=ev
							if operation then
								customev=operation(e,tp,G,ep,ev,re,r,rp,obj,event,updatedEventID)
							end
							aux.DelayedEventRaiserTable[MERGED_ID]=c
							local counter=(type(aux.EventCounter[eid])=="number" and aux.EventCounter[eid]>0 and not raiseOnlyOneEvent) and aux.EventCounter[eid] or 1
							for i=1,counter do
								Duel.RaiseEvent(G,EVENT_CUSTOM+e:GetLabel(),re,r,rp,ep,customev)
							end
						end
						for tc in aux.Next(G) do
							for _,cid in ipairs(flags) do
								--tc:ResetFlagEffect(cid)
								tc:GetFlagEffectWithSpecificLabel(cid,label,true)
							end
						end
						MERGED_ID = MERGED_ID + 1
					end
					if type(aux.EventCounter[eid])=="number" then
						aux.EventCounter[eid]=0
					end
					g:Clear()
				end
			end
end
function Auxiliary.MergedDelayEventCheckGlitchy2(id,range,evgcheck,se,operation,forced,eid,raiseOnlyOneEvent)
	return	function(e,tp,eg,ep,ev,re,r,rp)
				local c=e:GetOwner()
				local tp=c:GetControler()
				if range then					
					if not c:IsLocation(range) then
						return
					end
					if c:IsLocation(LOCATION_SZONE) and not c:IsHasEffect(EFFECT_CARD_HAS_RESOLVED) then
						return
					end
				end
				local label = (range) and c:GetFieldID() or 0
				local g=e:GetLabelObject()
				if aux.GetValueType(g)~="Group" then return end
				--Debug.Message('test '..tostring(label).." "..tostring(#g))
				if #g>0 then
					local flags
					if type(id)=="function" then
						flags={id()}
					else
						flags={id}
					end
					local G=Group.CreateGroup()
					for _,cid in ipairs(flags) do
						local _eg=g:Clone()
						--Debug.Message(#_eg)
						--Debug.Message("FLAG: "..tostring(cid))
						_eg=_eg:Filter(Card.HasFlagEffectLabel,nil,cid,label)
						--Debug.Message("FILTERED GROUP COUNT: "..tostring(#_eg))
						G:Merge(_eg)
					end
				    if g and #g>0 and (#G>0 or forced) then
						--Debug.Message('b')
						if not evgcheck or evgcheck(G,e,tp,ep,ev,re,r,rp) then
							local customev=ev
							if operation then
								local obj = aux.GetValueType(se)=="Effect" and se:GetLabelObject() or nil
								customev=operation(e,tp,G,ep,ev,re,r,rp,obj)
							end
							aux.DelayedEventRaiserTable[MERGED_ID]=c
							local counter=(type(aux.EventCounter[eid])=="number" and aux.EventCounter[eid]>0 and not raiseOnlyOneEvent) and aux.EventCounter[eid] or 1
							for i=1,counter do
								--Debug.Message(i)
								Duel.RaiseEvent(G,EVENT_CUSTOM+e:GetLabel(),re,r,rp,ep,customev)
							end
						end
						for tc in aux.Next(G) do
							for _,cid in ipairs(flags) do
								--Debug.Message("RESETTED: "..tostring(cid))
								--tc:ResetFlagEffect(cid)
								tc:GetFlagEffectWithSpecificLabel(cid,label,true)
							end
						end
						MERGED_ID = MERGED_ID + 1
					end
					if type(aux.EventCounter[eid])=="number" then
						aux.EventCounter[eid]=0
					end
					g:Clear()
				end
			end
end

function Auxiliary.ReturnMergedID()
	return MERGED_ID
end
function Auxiliary.MergedDelayedEventCondition(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return aux.DelayedEventRaiserTable[ev]==c
end

function Auxiliary.SimultaneousEventGroupCheck(simult_check,og,check)
	return function(g,e,tp)
		local sg=g:Filter(Card.HasFlagEffect,nil,simult_check)
		if #sg~=#g or sg:GetClassCount(Card.GetFlagEffectLabel,simult_check)>1 then return false end
		local val=sg:GetFirst():GetFlagEffectLabel(simult_check)
		if g:FilterCount(Card.HasFlagEffectLabel,nil,simult_check,val)~=og:FilterCount(Card.HasFlagEffectLabel,nil,simult_check,val) then
			return false
		end
		return not gcheck or gcheck(g)
	end
end
function Auxiliary.SelectSimultaneousEventGroup(g,tp,flag,ct,e,excflag,gcheck,nohint)
	local ct=ct and ct or 1
	local fid=e and e:GetHandler():GetFieldID() or 0
	if excflag then
		g=g:Filter(aux.NOT(Card.HasFlagEffectLabel),nil,excflag,fid)
	end
	if #g==0 then return end
	if #g==1 then
		if not nohint then Duel.HintSelection(g) end
		if excflag then
			g:GetFirst():RegisterFlagEffect(excflag,RESET_CHAIN,0,1,fid)
		end
		return g
	else
		local tg=aux.SelectUnselectGroup(g,e,tp,ct,#g,aux.SimultaneousEventGroupCheck(flag,g,gcheck),1,tp,HINTMSG_RESOLVEEFFECT,aux.SimultaneousEventGroupCheck(flag,g,gcheck),false,false)
		if not nohint then Duel.HintSelection(tg) end
		if excflag then
			for tc in aux.Next(tg) do
				tc:RegisterFlagEffect(excflag,RESET_CHAIN,0,1,fid)
			end
		end
		return tg
	end
end

function Auxiliary.SimultaneousEventCheck(c,se)
	return se==nil or c:GetReasonEffect()~=se
end

--Location Check
EFFECT_CARD_HAS_RESOLVED = 47987298

function Auxiliary.AlreadyInRangeCondition(e,re,se)
	local se=e and e:GetLabelObject():GetLabelObject() or se
	return	function(c,...)
				return se==nil or re~=se
			end
end
function Auxiliary.AlreadyInRangeEventCondition(f)
	return	function(e,tp,eg,ep,ev,re,r,rp)
				return not eg:IsContains(e:GetHandler()) and eg:IsExists(aux.AlreadyInRangeFilter(e,f),1,nil,e,tp,eg,ep,ev,re,r,rp)
			end
end
function Auxiliary.AlreadyInRangePlayerEventCondition(e,tp,eg,ep,ev,re,r,rp)
	local se=e and e:GetLabelObject():GetLabelObject() or nil
	return se==nil or re~=se
end
function Auxiliary.AlreadyInRangeFilter(e,f,se)
	local se=e and e:GetLabelObject():GetLabelObject() or se
	return	function(c,...)
				return (se==nil or c:GetReasonEffect()~=se) and (not f or f(c,...))
			end
end

function Auxiliary.AddThisCardBanishedAlreadyCheck(c,setf,getf)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE|EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_REMOVE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetOperation(Auxiliary.ThisCardInLocationAlreadyCheckReg(setf,getf))
	c:RegisterEffect(e1)
	return e1
end
function Auxiliary.AddThisCardInBackrowAlreadyCheck(c,pos,setf,getf)
	if pos==POS_FACEDOWN then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD|EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_SSET)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCondition(function(e) return (not e:GetHandler():IsPreviousLocation(LOCATION_SZONE) or e:GetHandler():GetPreviousSequence()<5) and e:GetHandler():IsInBackrow(pos) end)
		e1:SetOperation(Auxiliary.ThisCardInLocationAlreadyCheckReg(setf,getf,true))
		Duel.RegisterEffect(e1,0)
		return e1
	end
end
function Auxiliary.AddThisCardInExtraAlreadyCheck(c,pos,setf,getf)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE|EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_TO_DECK)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetCondition(function(e) return e:GetHandler():IsInExtra(pos) end)
	e1:SetOperation(Auxiliary.ThisCardInLocationAlreadyCheckReg(setf,getf))
	c:RegisterEffect(e1)
	return e1
end
function Auxiliary.AddThisCardInFZoneAlreadyCheck(c,setf,getf,skip)
	if not skip then
		local e0=Effect.CreateEffect(c)
		e0:SetType(EFFECT_TYPE_SINGLE)
		e0:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e0:SetRange(LOCATION_FZONE)
		e0:SetCode(EFFECT_CARD_HAS_RESOLVED)
		c:RegisterEffect(e0)
	end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE|EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_MOVE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetCondition(function(e) return not e:GetHandler():IsPreviousLocation(LOCATION_FZONE) and e:GetHandler():IsLocation(LOCATION_FZONE) end)
	e1:SetOperation(Auxiliary.ThisCardInLocationAlreadyCheckReg(setf,getf,true))
	c:RegisterEffect(e1)
	return e1
end
function Auxiliary.AddThisCardInMZoneAlreadyCheck(c,setf,getf)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE|EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_MOVE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetCondition(function(e) return not e:GetHandler():IsPreviousLocation(LOCATION_MZONE) and e:GetHandler():IsLocation(LOCATION_MZONE) end)
	e1:SetOperation(Auxiliary.ThisCardInLocationAlreadyCheckReg(setf,getf,true))
	c:RegisterEffect(e1)
	return e1
end
function Auxiliary.AddThisCardInSZoneAlreadyCheck(c,setf,getf)
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e0:SetRange(LOCATION_SZONE)
	e0:SetCode(EFFECT_CARD_HAS_RESOLVED)
	c:RegisterEffect(e0)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE|EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_MOVE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetCondition(function(e)
		local h=e:GetHandler()
		return (not h:IsPreviousLocation(LOCATION_SZONE) or c:GetPreviousSequence()>=5) and h:IsLocation(LOCATION_SZONE) and h:GetSequence()<5
	end)
	e1:SetOperation(Auxiliary.ThisCardInLocationAlreadyCheckReg(setf,getf,true))
	c:RegisterEffect(e1)
	return e1
end
function Auxiliary.AddThisCardInPZoneAlreadyCheck(c,setf,getf)
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e0:SetRange(LOCATION_PZONE)
	e0:SetCode(EFFECT_CARD_HAS_RESOLVED)
	c:RegisterEffect(e0)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE|EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_MOVE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetCondition(function(e) return not e:GetHandler():IsPreviousLocation(LOCATION_PZONE) and e:GetHandler():IsLocation(LOCATION_PZONE) end)
	e1:SetOperation(Auxiliary.ThisCardInLocationAlreadyCheckReg(setf,getf))
	c:RegisterEffect(e1)
	return e1
end
function Effect.SetLabelObjectObject(e,obj)
	return e:GetLabelObject():SetLabelObject(obj)
end
function Effect.GetLabelObjectObject(e)
	return e:GetLabelObject():GetLabelObject()
end
function Auxiliary.ThisCardInLocationAlreadyCheckReg(setf,getf,ignore_reason)
	if not setf then setf=Effect.SetLabelObject end
	if not getf then getf=Effect.GetLabelObject end
	return	function(e,tp,eg,ep,ev,re,r,rp)
				--condition of continous effect will be checked before other effects
				--Debug.Message("RE: "..tostring(re))
				--Debug.Message("GETF: "..tostring(getf(e)))
				if re==nil then return false end
				if getf(e)~=nil then return false end
				--Debug.Message("r: "..tostring(r))
				if (r&REASON_EFFECT)>0 or ignore_reason then
					setf(e,re)
					--e:SetLabelObject(re)
					local e1=Effect.CreateEffect(e:GetHandler())
					e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
					e1:SetCode(EVENT_CHAIN_END)
					e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
					e1:SetOperation(Auxiliary.ThisCardInLocationAlreadyReset1(getf))
					e1:SetLabelObject(e)
					Duel.RegisterEffect(e1,tp)
					local e2=e1:Clone()
					e2:SetCode(EVENT_BREAK_EFFECT)
					e2:SetOperation(Auxiliary.ThisCardInLocationAlreadyReset2(getf))
					e2:SetReset(RESET_CHAIN)
					e2:SetLabelObject(e1)
					Duel.RegisterEffect(e2,tp)
				elseif (r&REASON_MATERIAL)>0 or not re:IsActivated() and (r&REASON_COST)>0 then
					setf(e,re)
					--e:SetLabelObject(re)
					local reset_event=EVENT_SPSUMMON
					if re:GetCode()~=EFFECT_SPSUMMON_PROC then reset_event=EVENT_SUMMON end
					local e1=Effect.CreateEffect(e:GetHandler())
					e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
					e1:SetCode(reset_event)
					e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
					e1:SetOperation(Auxiliary.ThisCardInLocationAlreadyReset1(getf))
					e1:SetLabelObject(e)
					Duel.RegisterEffect(e1,tp)
				end
			
				return false
			end
end
function Auxiliary.ThisCardInLocationAlreadyReset1(getf)
	return	function(e)
				--this will run after EVENT_SPSUMMON_SUCCESS
				getf(e):SetLabelObject(nil)
				e:Reset()
			end
end
function Auxiliary.ThisCardInLocationAlreadyReset2(getf)
	return	function(e)
				local e1=e:GetLabelObject()
				getf(e1):SetLabelObject(nil)
				e1:Reset()
				e:Reset()
			end
end
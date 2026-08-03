--死灵之书
--1202505
local s,id,o=GetID()
s.KeSuLu=true
s.loc={{LOCATION_HAND+LOCATION_ONFIELD+LOCATION_GRAVE,LOCATION_REMOVED},{LOCATION_REMOVED,LOCATION_SZONE}}
--通用效果去/来的位置
local KSLid=1202500	--克苏鲁公用id1
function s.initial_effect(c)
	--Activate
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
	--remove
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetRange(LOCATION_HAND+LOCATION_ONFIELD+LOCATION_REMOVED)
	e1:SetCode(EVENT_CHAIN_ACTIVATING)
	e1:SetCondition(s.rmcon)
	e1:SetOperation(s.rmop)
	c:RegisterEffect(e1)
	--remove
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCode(EVENT_CHAINING)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetOperation(s.regop)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCode(EVENT_CHAIN_SOLVED)
	e3:SetCondition(s.remcon)
	e3:SetOperation(s.remop)
	c:RegisterEffect(e3)
	--accumulate
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_FLAG_EFFECT+id)
	e4:SetRange(LOCATION_SZONE+LOCATION_HAND+LOCATION_REMOVED+LOCATION_GRAVE)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetCondition(s.accon)
	e4:SetTargetRange(1,0)
	c:RegisterEffect(e4)

	if not s.global_check then
		s.global_check=true
		s.willreturn=Group.CreateGroup()
		s.willreturn:KeepAlive()
	end
end

function s.accon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsLocation(LOCATION_GRAVE) or (c:IsLocation(LOCATION_HAND) and c:IsPublic())
		or c:IsFaceup()
end
--开始
function s.rmcon(e,tp,eg,ep,ev,re,r,rp)
	return (Duel.IsExistingMatchingCard(s.rmfilter1,tp,0x1f,0,1,nil) 
		or Duel.IsExistingMatchingCard(s.rmfilter2,tp,LOCATION_REMOVED,0,1,nil))
end
function s.rmfilter1(c)	--去
	if not c.KeSuLu or c.KeSuLu==false then return false end
	if not c.loc or not c.loc[1] or c.loc[1][2]~=LOCATION_REMOVED then return false end
	local nowloc=c:GetLocation()
	return bit.band(nowloc,c.loc[1][1])==nowloc and c:IsAbleToRemove()
end
function s.rmfilter2(c,tp)	--回
	if not c.KeSuLu or c.KeSuLu==false then return false end
	if not c.loc or not c.loc[2] or c.loc[2][1]~=LOCATION_REMOVED then return false end
	if c:IsType(TYPE_SPELL) then
		if c:IsType(TYPE_CONTINUOUS) then return c:GetFlagEffect(KSLid-1)~=0 and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 end
		return c:GetFlagEffect(KSLid-1)~=0
	elseif c:IsType(TYPE_MONSTER) then
		return c:GetFlagEffect(KSLid-1)~=0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 
	end
	return false
end
function s.rtgfilter(c,loc)
	if not c.loc or not c.loc[2] or c.loc[2][1]~=LOCATION_REMOVED then return false end
	return c.loc[2][2]==loc
end

function s.rmcheck(g,tp)
	return g:Filter(Card.IsType,nil,TYPE_CONTINUOUS):GetCount()<=Duel.GetLocationCount(tp,LOCATION_SZONE) 
		and g:Filter(Card.IsType,nil,TYPE_MONSTER):GetCount()<=Duel.GetLocationCount(tp,LOCATION_MZONE)
		and g:Filter(Card.IsType,nil,TYPE_FIELD):GetCount()<=1
end

function s.rmop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetFlagEffect(tp,KSLid)==0 then
		local htg=Group.CreateGroup()
		if Duel.IsExistingMatchingCard(s.rmfilter1,tp,0x1f,0,1,nil) and Duel.SelectEffectYesNo(tp,e:GetHandler(),aux.Stringid(id,2)) then
			local g=Duel.GetMatchingGroup(s.rmfilter1,tp,0x1f,0,nil)
			if not g or g:GetCount()==0 then return end
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
			local tg=g:Select(tp,1,g:GetCount(),nil)
			if not tg then return end
			Duel.Hint(HINT_CARD,0,id)
			htg=tg:Filter(Card.IsLocation,nil,0x1f)
			--Duel.Remove(htg,POS_FACEUP,REASON_EFFECT)
			local num1=Duel.Remove(htg,POS_FACEUP,REASON_EFFECT)
			local og=Duel.GetOperatedGroup():Filter(Card.IsLocation,nil,LOCATION_REMOVED)
			if og:GetCount()>0 then
				for tc in aux.Next(og) do
					if tc.KeSuLu and tc.KeSuLu==true then
						tc:RegisterFlagEffect(KSLid-1,RESET_EVENT+RESETS_STANDARD,0,0)		
					end
				end
			end
			if num1~=0 then
				Duel.HintSelection(htg)
			end
		end
		--Debug.Message(2)
		if Duel.IsExistingMatchingCard(s.rmfilter2,tp,LOCATION_REMOVED,0,1,htg,tp) and Duel.SelectEffectYesNo(tp,e:GetHandler(),aux.Stringid(id,3)) then
			local g=Duel.GetMatchingGroup(s.rmfilter2,tp,LOCATION_REMOVED,0,htg,tp)
			if not g or g:GetCount()==0 then return end
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
			local tg=g:SelectSubGroup(tp,s.rmcheck,true,1,math.min(g:GetCount(),Duel.GetLocationCount(tp,LOCATION_SZONE)+Duel.GetLocationCount(tp,LOCATION_MZONE)+1),tp)
			if not tg then return end
			Duel.Hint(HINT_CARD,0,id)
			--local tg=g:Select(tp,1,math.min(g:GetCount()),nil)
			local rtg=tg:Filter(Card.IsLocation,nil,LOCATION_REMOVED)
			if rtg and rtg:GetCount()>0 then 
				Duel.HintSelection(rtg)
				local srtg=rtg:Filter(s.rtgfilter,nil,LOCATION_SZONE)
				local frtg=rtg:Filter(s.rtgfilter,nil,LOCATION_FZONE)
				local mrtg=rtg:Filter(s.rtgfilter,nil,LOCATION_MZONE)
				if srtg:GetCount()>0 then
					for tc in aux.Next(srtg) do
						Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
					end
				end		
				if mrtg:GetCount()>0 then
					for tc in aux.Next(mrtg) do
						Duel.MoveToField(tc,tp,tp,LOCATION_MZONE,POS_FACEUP_ATTACK,true)
					end
				end		
				if frtg:GetCount()>0 then
					local frtc=frtg:GetFirst()
					local fc=Duel.GetFieldCard(tp,LOCATION_FZONE,0)
					if fc then
						Duel.SendtoGrave(fc,REASON_RULE)
						Duel.BreakEffect()
					end
					Duel.MoveToField(frtc,tp,tp,LOCATION_FZONE,POS_FACEUP,true)
				end
			end
		end
		Duel.RegisterFlagEffect(tp,KSLid,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+RESET_CHAIN,0,1)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_CHAIN_SOLVED)
		e1:SetReset(RESET_PHASE+RESET_CHAIN)
		e1:SetLabel(tp)
		e1:SetCountLimit(1)
		e1:SetCondition(s.retcon)
		e1:SetOperation(s.retop)
		Duel.RegisterEffect(e1,tp)
	end
end
function s.retcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(tp,KSLid)~=0
end
function s.retop(e,tp,eg,ep,ev,re,r,rp)
	Duel.ResetFlagEffect(e:GetLabel(),KSLid)
end
--结束
function s.regop(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET-RESET_REMOVE+RESET_CHAIN,0,1)
end
function s.remcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return rp==1-tp and c:GetFlagEffect(id)~=0 and c:IsFaceup()
end
function s.remfilter(c,e)
	return c:IsFaceup() and not c:IsImmuneToEffect(e)
end
function s.remop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)<2 or Duel.GetDecktopGroup(tp,2):FilterCount(Card.IsAbleToRemove,nil)<2 then return end
	local g=Duel.GetDecktopGroup(tp,2)
	Duel.DisableShuffleCheck()
	if Duel.Remove(g,POS_FACEUP,REASON_COST+REASON_TEMPORARY)>0 then
		local og=Duel.GetOperatedGroup():Filter(Card.IsLocation,nil,LOCATION_REMOVED)
		for tc in aux.Next(og) do
			--tc:RegisterFlagEffect(id+1,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
			tc:RegisterFlagEffect(id+1,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(id,1))
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_FIELD)
			e1:SetCode(EFFECT_CANNOT_ACTIVATE)
			e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
			e1:SetTargetRange(1,1)
			e1:SetLabel(tc:GetCode())
			e1:SetValue(s.aclimit)
			e1:SetReset(RESET_PHASE+PHASE_END)
			Duel.RegisterEffect(e1,tp)
			local e2=Effect.CreateEffect(e:GetHandler())
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_CANNOT_TRIGGER)
			e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			tc:RegisterEffect(e2,true)
			if tc.KeSuLu and tc.KeSuLu==true then
				tc:RegisterFlagEffect(KSLid-1,RESET_EVENT+RESETS_STANDARD,0,0)		
			end
		end
		s.willreturn:Merge(og)
		if Duel.GetFlagEffect(tp,id+2)==0 then
			local ge1=Effect.CreateEffect(c)
			ge1:SetDescription(aux.Stringid(id,0))
			ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			ge1:SetCode(EVENT_PHASE+PHASE_END)
			ge1:SetReset(RESET_PHASE+PHASE_END)
			--ge1:SetLabelObject(s.willreturn)
			ge1:SetCountLimit(1)
			ge1:SetCondition(s.retcon2)
			ge1:SetOperation(s.retop2)
			Duel.RegisterEffect(ge1,tp)
			Duel.RegisterFlagEffect(tp,id+2,RESET_PHASE+PHASE_END,0,1)
		end
	end
end

function s.retfilter2(c)
	return c:GetFlagEffect(id+1)~=0
end
function s.retcon2(e,tp,eg,ep,ev,re,r,rp)
	if s.willreturn:IsExists(s.retfilter2,1,nil) then
		return true
	else
		s.willreturn:Clear()
		return false
	end
end
function s.retop2(e,tp,eg,ep,ev,re,r,rp)
	if s.willreturn:IsExists(s.retfilter2,1,nil) then
		local g=s.willreturn:Filter(s.retfilter2,nil)
		Duel.SendtoDeck(g,nil,0,REASON_RULE)
	end
	s.willreturn:Clear()
	--for tc in aux.Next(g) do
	--	Duel.ReturnToField(tc)
	--end
end

function s.aclimit(e,re,tp)
	return re:GetHandler():IsCode(e:GetLabel())
end
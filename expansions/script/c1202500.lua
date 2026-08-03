--克苏鲁的呼唤
--1202500
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
	e1:SetRange(LOCATION_ONFIELD+LOCATION_REMOVED)
	e1:SetCode(EVENT_CHAIN_ACTIVATING)
	e1:SetCondition(s.rmcon)
	e1:SetOperation(s.rmop)
	c:RegisterEffect(e1)
	--disable effect
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_CHAIN_SOLVING)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCondition(s.discon)
	e2:SetOperation(s.disop)
	c:RegisterEffect(e2)


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
		if Duel.IsExistingMatchingCard(s.rmfilter1,tp,0x1f,0,1,nil) and Duel.SelectEffectYesNo(tp,e:GetHandler(),aux.Stringid(id,6)) then
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
function s.discon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	--if Duel.GetFlagEffect(tp,id+1)~=0 then return false end
	return Duel.GetFlagEffect(tp,id+1)==0 and c:IsFaceup()
end
function s.disop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFlagEffect(tp,id+1)~=0 then return end
	
	Duel.RegisterFlagEffect(tp,id+1,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+RESET_CHAIN,0,1)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_CHAIN_SOLVED)
	e1:SetReset(RESET_PHASE+RESET_CHAIN)
	e1:SetLabel(tp)
	e1:SetCountLimit(1)
	e1:SetCondition(s.retcon2)
	e1:SetOperation(s.retop2)
	Duel.RegisterEffect(e1,tp)
	
	local num=math.random(4)
	local num2,num3=0,0
	if num==1 then 
		if Duel.SelectEffectYesNo(ep,e:GetHandler(),aux.Stringid(id,4)) then return end
	elseif num==2 then
		if not Duel.SelectEffectYesNo(ep,e:GetHandler(),aux.Stringid(id,5)) then return end
	elseif num==3 then
		num2=math.random(2)
		num3=aux.SelectFromOptions(ep,
			{true,aux.Stringid(id,num2-1),1},
			{true,aux.Stringid(id,2-num2),2})
		if num3-num2==0 then return end
	else
		num2=math.random(3)
		num3=aux.SelectFromOptions(ep,
			{true,aux.Stringid(id,(4-num2)%3),1},
			{true,aux.Stringid(id,(5-num2)%3),2},
			{true,aux.Stringid(id,(6-num2)%3),3})
		if num3-num2==0 then return end
	end
	
	Duel.Hint(HINT_CARD,0,id)
	local g=Group.CreateGroup()
	Duel.ChangeTargetCard(ev,g)
	Duel.ChangeChainOperation(ev,s.repop)
end
function s.repop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
end
function s.retcon2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(tp,id+1)~=0
end
function s.retop2(e,tp,eg,ep,ev,re,r,rp)
	Duel.ResetFlagEffect(e:GetLabel(),id+1)
end
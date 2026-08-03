--疯狂山脉
--1202510
local s,id,o=GetID()
s.KeSuLu=true
s.loc={{LOCATION_HAND+LOCATION_ONFIELD+LOCATION_GRAVE,LOCATION_REMOVED},{LOCATION_REMOVED,LOCATION_FZONE}}
--通用效果去/来的位置
local KSLid=1202500	--克苏鲁公用id1
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--remove
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetRange(LOCATION_ONFIELD+LOCATION_GRAVE+LOCATION_REMOVED)
	e1:SetCode(EVENT_CHAIN_ACTIVATING)
	e1:SetCondition(s.rmcon)
	e1:SetOperation(s.rmop)
	c:RegisterEffect(e1)

	if not s.global_check then
		s.global_check=true
		s.Stringnum=11
		s.Stringtable={}
		s.Stringtable_bool={}
		s.start()
		_Stringid=aux.Stringid	
		function aux.Stringid(code0,id0)
			if not s.Stringtable_bool[code0] then s.Stringtable_bool[code0]={} end
			if not s.Stringtable_bool[code0][id0] then
				s.Stringtable_bool[code0][id0]=true
				table.insert(s.Stringtable,{code0,id0})
				--Debug.Message("写入："..code0..","..id0)
			end
			if Duel.IsExistingMatchingCard(s.hintfiler,0,LOCATION_FZONE,LOCATION_FZONE,1,nil1) then
				local randomnum=math.random(#s.Stringtable)
				--randomnum=#s.Stringtable
				code0,id0=s.Stringtable[randomnum][1],s.Stringtable[randomnum][2]
				--if s.Stringtable_bool[code1][id1] then Debug.Message("随机结果："..code1..","..id1) end
			end
			return _Stringid(code0,id0)
		end
		_Hint=Duel.Hint
		function Duel.Hint(hint_type,player,desc)
			if Duel.IsExistingMatchingCard(s.hintfiler,0,LOCATION_FZONE,LOCATION_FZONE,1,nil1) then
				if hint_type==10 then
					return _Hint(hint_type,player,desc)
				else
					local desc2=math.random(75)+499
					if desc2>=desc then desc2=desc2+1 end
					return _Hint(hint_type,player,desc2)
				end
			else return _Hint(hint_type,player,desc) end
		end
	end
end

function s.start()
	s.Stringtable_bool[id]={}
	for i=4,9 do
		table.insert(s.Stringtable,{id,i})
		s.Stringtable_bool[id][i]=true
	end
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
function s.hintfiler(c)
	return c:IsCode(id) and c:IsFaceup()
end
if not require and dofile then function require(str) return dofile(str..".lua") end end
if not pcall(function() require("expansions/script/c53702500") end) then require("script/c53702500") end
local s,id,o=GetID()
function s.initial_effect(c)
	SNNM.LostLink(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetCode(EFFECT_EXTRA_LINK_MATERIAL)
	e1:SetRange(LOCATION_HAND)
	e1:SetValue(s.matval)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,0))
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e2:SetTarget(s.tg)
	e2:SetOperation(s.op)
	c:RegisterEffect(e2)
	if not s.global_check then
		s.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_CHAIN_SOLVING)
		ge1:SetOperation(s.count)
		Duel.RegisterEffect(ge1,0)
		local ge2=Effect.CreateEffect(c)
		ge2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge2:SetCode(EVENT_CHAIN_SOLVED)
		ge2:SetOperation(s.reset)
		Duel.RegisterEffect(ge2,0)
		local ge3=Effect.CreateEffect(c)
		ge3:SetType(EFFECT_TYPE_FIELD)
		ge3:SetCode(EFFECT_IMMUNE_EFFECT)
		ge3:SetProperty(EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_IGNORE_IMMUNE)
		ge3:SetTargetRange(0xfd,0xfd)
		ge3:SetValue(s.efilter)
		Duel.RegisterEffect(ge3,0)
		s.trcheck=nil
		local f1=Effect.SetTargetRange
		Effect.SetTargetRange=function(e,...)
			s.trcheck=e
			return f1(e,...)
		end
		local f2=Card.RegisterEffect
		Card.RegisterEffect=function(sc,se,bool)
			if s.trcheck and se and s.trcheck==se then
				local code=se:GetCode()
				local pro1,pro2=se:GetProperty()
				if code>0 and (not pro1 or pro1&0x100000==0) and not SNNM.IsInTable(code,s.effcodetable) then
					table.insert(s.effcodetable,code)
				end
			end
			s.trcheck=nil
			return s.checking or f2(sc,se,bool)
		end
		local f3=Duel.RegisterEffect
		Duel.RegisterEffect=function(se,sp)
			if s.trcheck and se and s.trcheck==se then
				local code=se:GetCode()
				local pro1,pro2=se:GetProperty()
				if code>0 and (not pro1 or pro1&0x100000==0) and not SNNM.IsInTable(code,s.effcodetable) then
					table.insert(s.effcodetable,code)
				end
			end
			s.trcheck=nil
			return s.checking or f3(se,sp)
		end
	end
end
s.imucheck=nil
s.codetable={}
s.effcodetable={}
function s.count(e,tp,eg,ep,ev,re,r,rp)
	s.chain_solving=true
end
function s.reset(e,tp,eg,ep,ev,re,r,rp)
	s.chain_solving=false
end
function s.efilter(e,te,c)
	if not s.imucheck or s.imucheck~=c then return false end
	local tc=te:GetHandler()
	if not tc:IsLocation(LOCATION_MZONE) or c:IsControler(tc:GetControler()) then return false end
	c:RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD,0,1,tc:GetFieldID())
	return false
end
function s.mfilter(c)
	return c:IsLocation(LOCATION_MZONE) and c:IsRace(RACE_CYBERSE)
end
function s.matval(e,lc,mg,c,tp)
	return true,not mg or mg:IsExists(s.mfilter,1,nil)
end
function s.thfilter(c,fid)
	s.imucheck=c
	for _,v in ipairs(s.effcodetable) do c:IsHasEffect(v) end
	local labels={c:GetFlagEffectLabel(id)}
	c:ResetFlagEffect(id)
	s.imucheck=nil
	for _,v in ipairs(labels) do if v==fid then return true end end
	return false
end
function s.filter(c,e,tp)
	if not (c:IsType(TYPE_LINK) and c:IsSetCard(0x186) and c:IsLinkAbove(2) and c:IsFaceup()) then return false end
	if not SNNM.IsInTable(c:GetOriginalCode(),s.codetable) then
		--Duel.DisableActionCheck(true)
		--Duel.CreateToken(tp,c:GetOriginalCode())
		--Duel.DisableActionCheck(false)
		s.checking=true
		if c.initial_effect then c.initial_effect(c) end
		s.checking=false
		--c:ReplaceEffect(c:GetOriginalCode(),RESET_EVENT+RESETS_STANDARD)
		table.insert(s.codetable,c:GetOriginalCode())
		--c:ResetEffect(cid,RESET_COPY)
	end
	local g=Group.__add(e:GetHandler(),Duel.GetMatchingGroup(s.thfilter,tp,0,0xfd,nil,c:GetFieldID()))
	return g:IsExists(Card.IsAbleToHand,1,nil)
end
function s.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_MZONE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SELECT)
	local tc=Duel.SelectMatchingCard(tp,s.filter,tp,LOCATION_MZONE,0,1,1,nil,e,tp):GetFirst()
	if not EFFECT_REMOVE_LINK_MARKER_KOISHI and not Duel.Exile then
		EFFECT_REMOVE_LINK_MARKER_KOISHI=id+1000
		local _GetLink=Card.GetLink
		local _GetLinkCount=aux.GetLinkCount
		Card.GetLink=function(c) if c:IsHasEffect(id+1000) then return math.max(0,_GetLink(c)) else return _GetLink(c) end end
		aux.GetLinkCount=function(c) if c:IsHasEffect(id+1000) then if c:IsLinkType(TYPE_LINK) and _GetLink(c)>1 then return 1+0x10000*math.max(0,_GetLink(c)) else return 1 end else return _GetLinkCount(c) end end
		---#{c:IsHasEffect(id+1000)}
		Card.GetLinkMarker=function(c)
								local res=0
								for i=0,8 do
									if i~=4 and c:IsLinkMarker(1<<i) then
										local add=true
										for _,te in pairs({c:IsHasEffect(id+1000)}) do
											if 1<<i==te:GetValue() then add=false end
										end
										if add then res=res|(1<<i) end
									end
								end
								return res
							end
	end
	local mark=tc:GetLinkMarker()
	local t1,t2={},{}
	for i=0,8 do
		local lk=0x001*(2^i)
		if mark&lk==lk then table.insert(t1,i) end
	end
	for i=1,#t1 do table.insert(t2,aux.Stringid(id,t1[i]+1)) end
	local op=Duel.SelectOption(tp,table.unpack(t2))+1
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_REMOVE_LINK_MARKER_KOISHI)
	e1:SetValue(0x001*(2^t1[op]))
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	tc:RegisterEffect(e1,true)
	--Debug.Message(#{tc:IsHasEffect(id+1000)})
	--Debug.Message(tc:GetLink())
	--Debug.Message(aux.GetLinkCount(tc))
	Duel.SetTargetCard(tc)
	local g=Group.__add(e:GetHandler(),Duel.GetMatchingGroup(s.thfilter,tp,0,0xfd,nil,tc:GetFieldID())):Filter(Card.IsAbleToHand,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,g:GetCount(),0,0)
end
function s.op(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	local g=Group.CreateGroup()
	if tc:IsRelateToEffect(e) then g=Duel.GetMatchingGroup(s.thfilter,tp,0,0xfd,nil,tc:GetFieldID()):Filter(Card.IsAbleToHand,nil) end
	if e:GetHandler():IsRelateToEffect(e) then g:AddCard(e:GetHandler()) end
	if g:GetCount()>0 then Duel.SendtoHand(g,nil,REASON_EFFECT) end
	if not tc:IsRelateToEffect(e) or tc:GetFlagEffect(id+500)>0 then return end
	tc:RegisterFlagEffect(id+500,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e1:SetValue(s.immval)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
	tc:RegisterEffect(e1)
end
function s.tgfilter(c)
	return c:IsSetCard(0x186) and c:IsAbleToGraveAsCost()
end
function s.immval(e,te)
	local c=e:GetHandler()
	if not c:IsLocation(LOCATION_MZONE) or not te:IsActivated() or not s.chain_solving or te:GetOwner()==c then return false end
	local tp=c:GetControler()
	local res=Duel.IsExistingMatchingCard(s.tgfilter,tp,LOCATION_DECK,0,1,nil)
	if res then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_ADJUST)
		e1:SetOperation(s.imcop)
		Duel.RegisterEffect(e1,tp)
	end
	return res
end
function s.imcop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,id)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,s.tgfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then Duel.SendtoGrave(g,REASON_COST) end
	e:Reset()
end 

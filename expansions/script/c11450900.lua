--天演
local cm,m=GetID()
function cm.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,1))
	e1:SetCategory(CATEGORY_SEARCH+CATEGORY_SPECIAL_SUMMON+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_CUSTOM+m)
	e1:SetRange(LOCATION_HAND)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
	--act in hand
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	c:RegisterEffect(e2)
	if not cm.global_check then
		cm.global_check=true
		local _Equip=Duel.Equip
		Duel.Equip=function(p,c,...)
			c:RegisterFlagEffect(m,RESET_CHAIN,0,1)
			local res=_Equip(p,c,...)
			c:ResetFlagEffect(m)
			return res
		end
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_SUMMON_SUCCESS)
		e1:SetProperty(EFFECT_FLAG_DELAY)
		e1:SetCondition(cm.descon)
		e1:SetOperation(cm.desop2)
		Duel.RegisterEffect(e1,0)
		local e2=e1:Clone()
		e2:SetCode(EVENT_SPSUMMON_SUCCESS)
		Duel.RegisterEffect(e2,0)
		local e3=e1:Clone()
		e3:SetCode(EVENT_MOVE)
		Duel.RegisterEffect(e3,0)
		local e4=e1:Clone()
		e4:SetCode(EVENT_CHAINING)
		e4:SetCondition(cm.descon3)
		e4:SetOperation(cm.desop3)
		Duel.RegisterEffect(e4,0)
		local e5=Effect.CreateEffect(c)
		e5:SetType(EFFECT_TYPE_FIELD)
		e5:SetCode(EFFECT_CANNOT_SUMMON)
		e5:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e5:SetTargetRange(1,1)
		e5:SetTarget(cm.costchk)
		Duel.RegisterEffect(e5,0)
	end
end
function cm.costchk(e,c,tp,st)
	if bit.band(st,SUMMON_TYPE_DUAL)~=SUMMON_TYPE_DUAL then return false end
	if c:GetFlagEffect(m)==0 then c:RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD,0,1) end
	return false
end
function cm.filter(c,e)
	if not (c:IsOnField() and (c:IsFacedown() or c:IsStatus(STATUS_EFFECT_ENABLED) or c:GetFlagEffect(m)>0)) then return false end
	if e:GetCode()==EVENT_MOVE then
		local b1,g1=Duel.CheckEvent(EVENT_SUMMON_SUCCESS,true)
		local b2,g2=Duel.CheckEvent(EVENT_SPSUMMON_SUCCESS,true)
		return not c:IsPreviousLocation(LOCATION_ONFIELD) and (not b1 or not g1:IsContains(c)) and (not b2 or not g2:IsContains(c))
	end
	return not (e:GetCode()==EVENT_SUMMON_SUCCESS and c:GetFlagEffect(m)>0)
end
function cm.descon(e,tp,eg,ep,ev,re,r,rp)
	if cm.mv then cm.mv=nil return false end
	return eg:IsExists(cm.filter,1,nil,e)
end
function cm.desop2(e,tp,eg,ep,ev,re,r,rp)
	if (re and re:GetHandler():GetOriginalCode()==m) then return end
	Duel.RaiseEvent(eg,EVENT_CUSTOM+m,re,r,rp,ep,ev)
end
function cm.descon3(e,tp,eg,ep,ev,re,r,rp)
	return re:IsHasType(EFFECT_TYPE_ACTIVATE) and re:GetHandler():GetFieldID()==re:GetHandler():GetRealFieldID()
end
function cm.desop3(e,tp,eg,ep,ev,re,r,rp)
	Duel.RaiseEvent(eg,EVENT_CUSTOM+m,re,r,rp,ep,ev)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	--if EVO_GAME then return end
	--EVO_GAME=true
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_CUSTOM+m)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetOperation(cm.evoperation)
	Duel.RegisterEffect(e1,tp)
	c:SetTurnCounter(0)
end
function cm.spfilter(c,e,p,zone)
	return c:IsCanBeSpecialSummoned(e,0,p,false,false,POS_FACEUP+POS_FACEDOWN_DEFENSE,p,zone)
end
function cm.ssfilter(c)
	return c:IsSSetable() and not c:IsType(TYPE_FIELD)
end
function cm.ntfilter(c,p)
	return c:IsControler(p) and not c:IsType(TYPE_TOKEN)
end
local A=1103515245
local B=12345
local M=32767
function cm.roll(min,max)
	min=tonumber(min)
	max=tonumber(max)
	cm.r=((cm.r*A+B)%M)/M
	if min~=nil then
		if max==nil then
			return math.floor(cm.r*min)+1
		else
			max=max-min+1
			return math.floor(cm.r*max+min)
		end
	end
	return cm.r
end
--if Duel.GetRandomNumber then cm.roll=Duel.GetRandomNumber end
function cm.evoperation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ct=c:GetTurnCounter()
	ct=ct+1
	c:SetTurnCounter(ct)
	if ct<3 then return end
	c:SetTurnCounter(0)
	local g=Duel.GetFieldGroup(tp,LOCATION_ONFIELD,LOCATION_ONFIELD)-Duel.GetFieldGroup(tp,LOCATION_FZONE,LOCATION_FZONE)
	for i=-1,5 do
		cm[i]={}
		for j=-1,5 do
			cm[i][j]=0
		end
	end
	for tc in aux.Next(g) do
		local x,y=cm.xylabel(tc,tp)
		cm[x+1][y]=cm[x+1][y]+1
		cm[x][y+1]=cm[x][y+1]+1
		cm[x-1][y]=cm[x-1][y]+1
		cm[x][y-1]=cm[x][y-1]+1
	end
	local g0=Group.CreateGroup()
	local g1=Group.CreateGroup()
	local g2=Group.CreateGroup()
	local g3=Group.CreateGroup()
	for i=0,4 do
		for j=0,4 do
			if j~=2 and cm[i][j]==0 then
				local zone=cm.xytozone(i,j)
				local tc=cm.GetCardsInZone(tp,zone)
				if tc and tc:GetOriginalType()&TYPE_TOKEN>0 then g0:AddCard(tc) end
				if zone>=1<<16 then zone=zone>>16 else zone=zone<<16 end
			elseif j~=2 and cm[i][j]==1 then
				local zone=cm.xytozone(i,j)
				local tc=cm.GetCardsInZone(tp,zone)
				if tc then --and tc:GetOriginalType()&TYPE_TOKEN==0 then
					g1:AddCard(tc)
					if tc:GetOriginalType()&TYPE_TOKEN>0 then cm[m+zone]=true end
				end
				if zone>=1<<16 then zone=zone>>16 else zone=zone<<16 end
			elseif j~=2 and cm[i][j]==2 then
				local zone=cm.xytozone(i,j)
				local tc=cm.GetCardsInZone(tp,zone)
				if tc then --and tc:GetOriginalType()&TYPE_TOKEN==0 then
					g2:AddCard(tc)
					if tc:GetOriginalType()&TYPE_TOKEN>0 then cm[m+zone]=true end
				end
				if zone>=1<<16 then zone=zone>>16 else zone=zone<<16 end
			elseif j~=2 and cm[i][j]>=3 then
				local zone=cm.xytozone(i,j)
				local tc=cm.GetCardsInZone(tp,zone)
				if tc then
					g3:AddCard(tc)
				end
				if zone>=1<<16 then zone=zone>>16 else zone=zone<<16 end
				--Duel.Hint(HINT_ZONE,1-tp,zone)
			end
		end
	end
	local g12=g1+g2
	local g123=g1+g2+g3
	--if #g1>0 then Duel.Destroy(g1,REASON_RULE) end
	if #g123>0 then Duel.Destroy(g123,REASON_RULE) end
	local ct={}
	ct[0]=g3:FilterCount(Card.IsControler,nil,0)+g12:FilterCount(cm.ntfilter,nil,0)
	ct[1]=g3:FilterCount(Card.IsControler,nil,1)+g12:FilterCount(cm.ntfilter,nil,1)
	for i=0,4 do
		for j=0,4 do
			--sequence?
			if j~=2 and (cm[i][j]==1 or cm[i][j]==2) then
				local zone=cm.xytozone(i,j)
				local p,loc,seq=cm.zone2seq(tp,zone)
				local tc=cm.GetCardsInZone(tp,zone)
				if Duel.CheckLocation(p,loc,seq) and not cm[m+zone] then
					if not cm.r then
						cm.r=Duel.GetFieldGroup(0,LOCATION_DECK+LOCATION_HAND,LOCATION_DECK+LOCATION_EXTRA):GetSum(Card.GetCode)
					end
					local tokenid=m+cm.roll(1,5)
					if j==0 or j==4 then
						local token=Duel.CreateToken(tp,tokenid)
						--if tc then Duel.Destroy(tc,REASON_RULE) end
						cm.mv=true
						if p==tp then
							Duel.MoveToField(token,tp,p,LOCATION_SZONE,POS_FACEUP,true,zone>>8)
						else
							Duel.MoveToField(token,tp,p,LOCATION_SZONE,POS_FACEUP,true,zone>>24)
						end
						local e1=Effect.CreateEffect(c)
						e1:SetCode(EFFECT_CHANGE_TYPE)
						e1:SetType(EFFECT_TYPE_SINGLE)
						e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
						e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET)
						e1:SetValue(TYPE_SPELL+TYPE_CONTINUOUS)
						token:RegisterEffect(e1,true)
					elseif (j==1 or j==3) and Duel.IsPlayerCanSpecialSummonMonster(tp,tokenid,nil,0x4011,0,0,1,RACE_AQUA,ATTRIBUTE_WATER,POS_FACEUP_ATTACK,p) and (not Duel.IsPlayerAffectedByEffect(tp,59822133) or ct[tp]<=1) then
						local token=Duel.CreateToken(tp,tokenid)
						--if tc then Duel.Destroy(tc,REASON_RULE) end
						if p==tp then
							Duel.SpecialSummonStep(token,0,tp,p,false,false,POS_FACEUP_ATTACK,zone)
						else
							Duel.SpecialSummonStep(token,0,tp,p,false,false,POS_FACEUP_ATTACK,zone>>16)
						end
					end
				end
			end
		end
	end
	--if #g2>0 then Duel.Destroy(g2,REASON_EFFECT) end
	--Duel.SpecialSummonComplete()
	for i=0,4 do
		for j=0,4 do
			if j~=2 and cm[i][j]>=3 then
				local zone=cm.xytozone(i,j)
				local p,loc,seq=cm.zone2seq(tp,zone)
				local tc=cm.GetCardsInZone(tp,zone)
				local g=Group.CreateGroup()
				if Duel.CheckLocation(p,loc,seq) then
					if loc==LOCATION_MZONE then
						local zone2=zone
						if zone>=1<<16 then zone2=zone>>16 end
						g=Duel.GetMatchingGroup(cm.spfilter,p,LOCATION_DECK,0,g123,e,p,zone2)
						if #g>0 and (not Duel.IsPlayerAffectedByEffect(tp,59822133) or ct[tp]<=1) then
							if p==tp then
								local zone2=zone
								if zone>=1<<16 then zone2=zone>>16 else zone2=zone<<16 end
								Duel.Hint(HINT_ZONE,1-tp,zone2)
							else
								Duel.Hint(HINT_ZONE,tp,zone)
							end
							Duel.Hint(HINT_SELECTMSG,p,aux.Stringid(m,2))
							local tg=g:Select(p,1,1,nil)
							--if tc then Duel.Destroy(tc,REASON_RULE) end
							if p==tp then
								Duel.SpecialSummonStep(tg:GetFirst(),0,p,p,false,false,POS_FACEUP+POS_FACEDOWN_DEFENSE,zone)
								if tg:GetFirst():IsFacedown() then Duel.ConfirmCards(1-p,tg) end
							else
								Duel.SpecialSummonStep(tg:GetFirst(),0,p,p,false,false,POS_FACEUP+POS_FACEDOWN_DEFENSE,zone>>16)
								if tg:GetFirst():IsFacedown() then Duel.ConfirmCards(1-p,tg) end
							end
						end
					elseif loc==LOCATION_SZONE then
						g=Duel.GetMatchingGroup(cm.ssfilter,p,LOCATION_DECK,0,g123)
						if #g>0 then
							if p==tp then
								local zone2=zone
								if zone>=1<<16 then zone2=zone>>16 else zone2=zone<<16 end
								Duel.Hint(HINT_ZONE,1-tp,zone2)
							else
								Duel.Hint(HINT_ZONE,tp,zone)
							end
							Duel.Hint(HINT_SELECTMSG,p,aux.Stringid(m,3))
							local tg=g:Select(p,1,1,nil)
							--if tc then Duel.Destroy(tc,REASON_RULE) end
							cm.mv=true
							if p==tp then
								Duel.MoveToField(tg:GetFirst(),p,p,LOCATION_SZONE,POS_FACEDOWN,false,zone>>8)
								--Duel.SSet(p,tg:GetFirst())
								Duel.RaiseEvent(tg:GetFirst(),EVENT_SSET,e,REASON_EFFECT,p,p,0)
								Duel.ConfirmCards(1-p,tg)
							else
								Duel.MoveToField(tg:GetFirst(),p,p,LOCATION_SZONE,POS_FACEDOWN,false,zone>>24)
								--Duel.SSet(p,tg:GetFirst())
								Duel.RaiseEvent(tg:GetFirst(),EVENT_SSET,e,REASON_EFFECT,p,p,0)
								Duel.ConfirmCards(1-p,tg)
							end
						end
					end
				end
			end
		end
	end
	Duel.SpecialSummonComplete()
	for i=-1,5 do
		for j=-1,5 do
			local zone=cm.xytozone(i,j)
			if zone then cm[m+zone]=nil end
		end
	end
end
--card->从tp来看的(x,y).11451530.
function cm.xylabel(c,tp)
	local x=c:GetSequence()
	local y=0
	if c:GetControler()==tp then
		if c:IsLocation(LOCATION_MZONE) and x<=4 then y=1
		elseif c:IsLocation(LOCATION_MZONE) and x==5 then x,y=1,2
		elseif c:IsLocation(LOCATION_MZONE) and x==6 then x,y=3,2
		elseif c:IsLocation(LOCATION_SZONE) and x<=4 then y=0
		else x,y=-1,0.5 end
	elseif c:GetControler()==1-tp then
		if c:IsLocation(LOCATION_MZONE) and x<=4 then x,y=4-x,3
		elseif c:IsLocation(LOCATION_MZONE) and x==5 then x,y=3,2
		elseif c:IsLocation(LOCATION_MZONE) and x==6 then x,y=1,2
		elseif c:IsLocation(LOCATION_SZONE) and x<=4 then x,y=4-x,4
		else x,y=5,3.5 end
	end
	return x,y
end
--(x,y)->zone.11451650.
function cm.xytozone(x,y)
	if x==-1 and y==0.5 then return 1<<13
	elseif x==5 and y==3.5 then return 1<<29
	elseif x>=0 and x<=4 then
		if y==0 then return 1<<(x+8)
		elseif y==1 then return 1<<x
		elseif y==3 then return 1<<(20-x)
		elseif y==4 then return 1<<(28-x)
		elseif y==2 and x==1 then return 0x400020
		elseif y==2 and x==3 then return 0x200040 end
	end
	return nil
end
--从tp来看的zone->card.11451566.
function cm.GetCardsInZone(tp,fd)
	if fd==0x400020 then return Duel.GetFieldCard(tp,LOCATION_MZONE,5) or Duel.GetFieldCard(1-tp,LOCATION_MZONE,6) end
	if fd==0x200040 then return Duel.GetFieldCard(tp,LOCATION_MZONE,6) or Duel.GetFieldCard(1-tp,LOCATION_MZONE,5) end
	local seq=math.log(fd,2)
	local p=tp
	if seq>=16 then
		p=1-tp
		seq=seq-16
	end
	local loc=LOCATION_MZONE
	if seq>=8 then
		loc=LOCATION_SZONE
		seq=seq-8
	end
	return Duel.GetFieldCard(p,loc,math.floor(seq+0.5))
end
--从tp来看的zone->(p,loc,seq).11450996.
function cm.zone2seq(tp,zone)
	if zone&0x20>0 or zone&0x400000>0 then return tp,5,LOCATION_MZONE end
	if zone&0x40>0 or zone&0x200000>0 then return tp,6,LOCATION_MZONE end
	local seq=math.log(zone,2)
	local p=tp
	if seq>=16 then
		p=1-tp
		seq=seq-16
	end
	local loc=LOCATION_MZONE
	if seq>=8 then
		loc=LOCATION_SZONE
		seq=seq-8
	end
	return p,loc,seq
end
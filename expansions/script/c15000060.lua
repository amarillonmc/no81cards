local m=15000060
local cm=_G["c"..m]
cm.name="色带神的呼唤"
function cm.initial_effect(c)
	--immune
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_FZONE)
	e1:SetValue(1)
	c:RegisterEffect(e1)
	--Activate  
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_COUNTER)  
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetCode(EVENT_FREE_CHAIN) 
	e2:SetOperation(cm.ctop)
	c:RegisterEffect(e2)
	--counter  
	local e3=Effect.CreateEffect(c) 
	e3:SetCategory(CATEGORY_COUNTER) 
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)  
	e3:SetRange(LOCATION_FZONE)  
	e3:SetCode(EVENT_SPSUMMON_SUCCESS) 
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY) 
	e3:SetOperation(cm.ct2op)  
	c:RegisterEffect(e3)
	local e4=Effect.Clone(e3)
	e4:SetCode(EVENT_SUMMON_SUCCESS)
	c:RegisterEffect(e4)
	local e5=Effect.Clone(e3)
	e5:SetCode(EVENT_FLIP)
	c:RegisterEffect(e5)
	--san Check
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e6:SetRange(LOCATION_FZONE)
	e6:SetCode(EVENT_SPSUMMON_SUCCESS) 
	e6:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e6:SetCondition(cm.sccon)
	e6:SetOperation(cm.scop)  
	c:RegisterEffect(e6)
	local e7=Effect.Clone(e6)
	e7:SetCode(EVENT_SUMMON_SUCCESS)
	c:RegisterEffect(e7)
	local e8=Effect.Clone(e6)
	e8:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
	c:RegisterEffect(e8)
end
function cm.roll(min,max)
	local A=1103515245
	local B=12345
	local M=32767
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
function cm.ctfilter(c)  
	return c:IsFaceup()
end
function cm.ctcount(c)
	local count=0
	count=c:GetLevel()*10
	if c:IsType(TYPE_XYZ) then
		count=c:GetRank()*10
	end
	if c:IsType(TYPE_LINK) then
		count=c:GetLink()*20
	end
	if count>=60 then count=60 end
	return count
end
function cm.ctop(e,tp,eg,ep,ev,re,r,rp)  
	local c=e:GetHandler()  
	if not c:IsRelateToEffect(e) then return end  
	local g=Duel.GetMatchingGroup(cm.ctfilter,tp,0,LOCATION_MZONE,nil)  
	local tc=g:GetFirst()  
	while tc do 
		if tc:GetCounter(0x1f33)==0 then
			local count=cm.ctcount(tc)
			tc:AddCounter(0x1f33,count)
		end
		tc=g:GetNext()  
	end
	local e1=Effect.CreateEffect(e:GetHandler())  
	e1:SetType(EFFECT_TYPE_FIELD)  
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)  
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)  
	e1:SetTargetRange(1,1)  
	e1:SetCondition(cm.con)  
	e1:SetValue(cm.actlimit)  
	Duel.RegisterEffect(e1,tp)  
	local e2=Effect.CreateEffect(e:GetHandler())  
	e2:SetType(EFFECT_TYPE_FIELD)  
	e2:SetCode(EFFECT_CANNOT_SSET)  
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)  
	e2:SetTargetRange(1,1)  
	e2:SetCondition(cm.con)  
	e2:SetTarget(cm.setlimit)  
	Duel.RegisterEffect(e2,tp)
	if not cm.r then
		local result=0
		local g=Duel.GetFieldGroup(0,0xff,0xff):RandomSelect(2,8)
		local ct={}
		local c=g:GetFirst()
		for i=0,7 do
			ct[c]=i
			c=g:GetNext()
		end
		for i=0,10 do
			result=result+(ct[g:RandomSelect(2,1):GetFirst()]<<(3*i))
		end
		g:DeleteGroup()
		cm.r=result&0xffffffff
	end
	Duel.RegisterFlagEffect(tp,15000060,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
end
function cm.con(e)  
	return e:GetHandler():IsLocation(LOCATION_FZONE) and e:GetHandler():IsFaceup()
end  
function cm.actlimit(e,re,tp)  
	return re:IsActiveType(TYPE_FIELD) and re:IsHasType(EFFECT_TYPE_ACTIVATE) and re:GetHandler():GetOwner()==e:GetHandler():GetOwner()
end  
function cm.setlimit(e,c,tp)  
	return c:IsType(TYPE_FIELD) and c:GetOwner()==e:GetHandler():GetOwner()
end
function cm.ct2op(e,tp,eg,ep,ev,re,r,rp) 
	local tp=e:GetHandlerPlayer() 
	local tc=eg:GetFirst()  
	while tc do  
		if tc:IsFaceup() and tc:IsControler(1-tp) then
			local count=cm.ctcount(tc)
			tc:AddCounter(0x1f33,count)
		end  
		tc=eg:GetNext()  
	end  
	Duel.RegisterFlagEffect(tp,15000060,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
end
function cm.scfilter(c,tp)  
	return c:IsFaceup() and c:IsSetCard(0xf33) and c:IsControler(tp)
end 
function cm.sc2filter(c,tp)  
	return c:IsFaceup() and c:IsSetCard(0x1f33) and c:IsControler(tp)
end 
function cm.sccon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(cm.scfilter,1,nil,tp)
end

function cm.scopop(e,c,tc)
	local z=cm.ctcount(tc)
	local sc=tc:GetCounter(0x1f33)
	if sc<=z*4/5 then
		local atk=tc:GetBaseAttack()  
		local e1=Effect.CreateEffect(c)  
		e1:SetType(EFFECT_TYPE_SINGLE)  
		e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)  
		e1:SetCode(EFFECT_SET_ATTACK_FINAL)  
		e1:SetValue(math.ceil(atk/2))  
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)  
		tc:RegisterEffect(e1,true)
	end
	if sc<=z*3/5 then
		local e2=Effect.CreateEffect(c)  
		e2:SetType(EFFECT_TYPE_SINGLE) 
		e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)  
		e2:SetCode(EFFECT_DISABLE)  
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)  
		tc:RegisterEffect(e2)
	end
	if sc<=z*1/5 then
		Duel.Remove(tc,POS_FACEDOWN,REASON_EFFECT)
	end
end
function cm.scop(e,tp,eg,ep,ev,re,r,rp)
	local tp=e:GetHandlerPlayer()
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(cm.ctfilter,tp,0,LOCATION_MZONE,nil)
	local tc=g:GetFirst()
	if tc then Duel.Hint(HINT_CARD,0,15000060) end
	while tc do
		if tc:GetCounter(0x1f33)~=0 then
			Duel.HintSelection(Group.FromCards(tc))
			local sc=tc:GetCounter(0x1f33)
			local dice1=cm.roll(1,10)
			e:GetHandler():SetTurnCounter(dice1)
			local dice2=cm.roll(1,10)
			e:GetHandler():SetTurnCounter(dice2)
			if dice1==10 and dice2~=10 then dice1=0 end
			if dice1~=10 and dice2==10 then dice2=0 end
			local x=(dice1*10)+dice2
			if dice1==10 and dice2==10 then x=100 end
			if x>=sc or eg:IsExists(cm.sc2filter,1,nil,tp) then
				if x<95 then
					Duel.Hint(HINT_CARD,0,15000062)
					local d1=Duel.TossDice(1-tp,1)
					local d2=Duel.TossDice(1-tp,1)
					local d3=d1+d2
					if d3>=tc:GetCounter(0x1f33) then d3=tc:GetCounter(0x1f33)-1 end
					tc:RemoveCounter(tp,0x1f33,d3,REASON_EFFECT)
				end
				if x>=95 then
					Duel.Hint(HINT_CARD,0,15000063)
					local d4=12
					if d4>=tc:GetCounter(0x1f33) then d4=tc:GetCounter(0x1f33)-1 end
					tc:RemoveCounter(tp,0x1f33,d4,REASON_EFFECT)
				end
				cm.scopop(e,c,tc)
			end
			if x<sc and not eg:IsExists(cm.sc2filter,1,nil,tp) then
				Duel.Hint(HINT_CARD,0,15000061)
			end
		end
		tc=g:GetNext()
	end
	e:GetHandler():SetTurnCounter(0)
	Duel.RegisterFlagEffect(tp,15000060,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)   
end
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
	e2:SetOperation(c15000060.ctop)
	c:RegisterEffect(e2)
	--counter  
	local e3=Effect.CreateEffect(c) 
	e3:SetCategory(CATEGORY_COUNTER) 
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)  
	e3:SetRange(LOCATION_FZONE)  
	e3:SetCode(EVENT_SPSUMMON_SUCCESS) 
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY) 
	e3:SetOperation(c15000060.ct2op)  
	c:RegisterEffect(e3)
	local e4=Effect.Clone(e3)
	e4:SetCode(EVENT_SUMMON_SUCCESS)
	c:RegisterEffect(e4)
	local e5=Effect.Clone(e3)
	e5:SetCode(EVENT_FLIP)
	c:RegisterEffect(e5)
	--san Check
	local e6=Effect.CreateEffect(c)  
	e6:SetCategory(CATEGORY_COUNTER)
	e6:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e6:SetRange(LOCATION_FZONE)
	e6:SetCode(EVENT_SPSUMMON_SUCCESS) 
	e6:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e6:SetCondition(c15000060.sccon)
	e6:SetOperation(c15000060.scop)  
	c:RegisterEffect(e6)
	local e7=Effect.Clone(e6)
	e7:SetCode(EVENT_SUMMON_SUCCESS)
	c:RegisterEffect(e7)
	local e8=Effect.Clone(e6)
	e8:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
	c:RegisterEffect(e8)
end
function c15000060.ctfilter(c)  
	return c:IsFaceup()
end 
function c15000060.ctop(e,tp,eg,ep,ev,re,r,rp)  
	local c=e:GetHandler()  
	if not c:IsRelateToEffect(e) then return end  
	local g=Duel.GetMatchingGroup(c15000060.ctfilter,tp,0,LOCATION_MZONE,nil)  
	local tc=g:GetFirst()  
	while tc do 
		if tc:GetCounter(0x1f33)==0 then
			if tc:GetLevel()~=nil then
				local x=tc:GetLevel()*10
				if x>=60 then x=60 end
				tc:AddCounter(0x1f33,x)
			end
			if tc:IsType(TYPE_XYZ) then
				local y=tc:GetRank()*10
				if y>=60 then y=60 end
				tc:AddCounter(0x1f33,y)
			end
			if tc:IsType(TYPE_LINK) then
				local z=tc:GetLink()*20
				if z>=60 then z=60 end
				tc:AddCounter(0x1f33,z)
			end
		end
		tc=g:GetNext()  
	end
	local e1=Effect.CreateEffect(e:GetHandler())  
	e1:SetType(EFFECT_TYPE_FIELD)  
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)  
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)  
	e1:SetTargetRange(1,1)  
	e1:SetCondition(c15000060.con)  
	e1:SetValue(c15000060.actlimit)  
	Duel.RegisterEffect(e1,tp)  
	local e2=Effect.CreateEffect(e:GetHandler())  
	e2:SetType(EFFECT_TYPE_FIELD)  
	e2:SetCode(EFFECT_CANNOT_SSET)  
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)  
	e2:SetTargetRange(1,1)  
	e2:SetCondition(c15000060.con)  
	e2:SetTarget(c15000060.setlimit)  
	Duel.RegisterEffect(e2,tp)
	Duel.RegisterFlagEffect(tp,15000060,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
end
function c15000060.con(e)  
	return e:GetHandler():IsLocation(LOCATION_FZONE) and e:GetHandler():IsFaceup()
end  
function c15000060.actlimit(e,re,tp)  
	return re:IsActiveType(TYPE_FIELD) and re:IsHasType(EFFECT_TYPE_ACTIVATE) and re:GetHandler():GetOwner()==e:GetHandler():GetOwner()
end  
function c15000060.setlimit(e,c,tp)  
	return c:IsType(TYPE_FIELD) and c:GetOwner()==e:GetHandler():GetOwner()
end
function c15000060.ct2op(e,tp,eg,ep,ev,re,r,rp) 
	local tp=e:GetHandlerPlayer() 
	local tc=eg:GetFirst()  
	while tc do  
		if tc:IsFaceup() and tc:IsControler(1-tp) then  
			if tc:GetCounter(0x1f33)==0 then
				if tc:GetLevel()~=nil then
					local x=tc:GetLevel()*10
					if x>=60 then x=60 end
					tc:AddCounter(0x1f33,x)
				end
				if tc:IsType(TYPE_XYZ) then
					local y=tc:GetRank()*10
					if y>=60 then y=60 end
					tc:AddCounter(0x1f33,y)
				end
				if tc:IsType(TYPE_LINK) then
					local z=tc:GetLink()*20
					if z>=60 then z=60 end
					tc:AddCounter(0x1f33,z)
				end
			end
		end  
		tc=eg:GetNext()  
	end  
	Duel.RegisterFlagEffect(tp,15000060,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
end
function c15000060.scfilter(c,tp)  
	return c:IsFaceup() and c:IsSetCard(0xf33) and c:IsControler(tp)
end 
function c15000060.sc2filter(c,tp)  
	return c:IsFaceup() and c:IsSetCard(0x1f33) and c:IsControler(tp)
end 
function c15000060.sccon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c15000060.scfilter,1,nil,tp)
end
function c15000060.scop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,15000060)
	local tp=e:GetHandlerPlayer()
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(c15000060.ctfilter,tp,0,LOCATION_MZONE,nil)
	local tc=g:GetFirst()  
	while tc do
		if tc:GetCounter(0x1f33)~=0 then
			local tg=Group.FromCards(tc)
			Duel.HintSelection(tg)
			local sc=tc:GetCounter(0x1f33)
			local aag=Duel.GetMatchingGroup(nil,tp,0xff,0xff,nil)
			local ccg=Group.RandomSelect(aag,tp,10)
			local bc=ccg:GetFirst()
			local y=1
			while bc do
				bc:RegisterFlagEffect(15000061,RESET_PHASE+PHASE_END,0,99,y)
				y=y+1
				bc=ccg:GetNext()
			end
			local bac=Group.RandomSelect(ccg,tp,1):GetFirst()
			local x1=bac:GetFlagEffectLabel(15000061)
			e:GetHandler():SetTurnCounter(x1)
			local bbc=Group.RandomSelect(ccg,tp,1):GetFirst()
			local x2=bbc:GetFlagEffectLabel(15000061)
			e:GetHandler():SetTurnCounter(x2)
			local bc=ccg:GetFirst()
			while bc do
				bc:ResetFlagEffect(15000061)
				bc=ccg:GetNext()
			end
			if x1==10 and x2==10 then x2=0 end
			if x1==10 and not x2==10 then x1=0 end
			if x2==10 and not x1==10 then x2=0 end
			local x=(x1*10)+x2
			if x>=sc or eg:IsExists(c15000060.sc2filter,1,nil,tp) then
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
				if tc:IsType(TYPE_LINK) then
					local z=tc:GetLink()*20
					if z>=60 then z=60 end
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
				if tc:IsType(TYPE_XYZ) then
					local y=tc:GetRank()*10
					if y>=60 then y=60 end
					local sc=tc:GetCounter(0x1f33)
					if sc<=y*4/5 then
						local atk=tc:GetBaseAttack()  
						local e1=Effect.CreateEffect(c)  
						e1:SetType(EFFECT_TYPE_SINGLE)  
						e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)  
						e1:SetCode(EFFECT_SET_ATTACK_FINAL)  
						e1:SetValue(math.ceil(atk/2))  
						e1:SetReset(RESET_EVENT+RESETS_STANDARD)  
						tc:RegisterEffect(e1,true)
					end
					if sc<=y*3/5 then
						local e2=Effect.CreateEffect(c)  
						e2:SetType(EFFECT_TYPE_SINGLE) 
						e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)  
						e2:SetCode(EFFECT_DISABLE)  
						e2:SetReset(RESET_EVENT+RESETS_STANDARD)  
						tc:RegisterEffect(e2)
					end
					if sc<=y*1/5 then
						Duel.Remove(tc,POS_FACEDOWN,REASON_EFFECT)
					end
				end
				 if (not tc:IsType(TYPE_LINK) and not tc:IsType(TYPE_XYZ)) then
					local x=tc:GetLevel()*10
					if x>=60 then x=60 end
					local sc=tc:GetCounter(0x1f33)
					if sc<=x*4/5 then
						local atk=tc:GetBaseAttack()  
						local e1=Effect.CreateEffect(c)  
						e1:SetType(EFFECT_TYPE_SINGLE)  
						e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)  
						e1:SetCode(EFFECT_SET_ATTACK_FINAL)  
						e1:SetValue(math.ceil(atk/2))  
						e1:SetReset(RESET_EVENT+RESETS_STANDARD)  
						tc:RegisterEffect(e1,true)
					end
					if sc<=x*3/5 then
						local e2=Effect.CreateEffect(c)  
						e2:SetType(EFFECT_TYPE_SINGLE) 
						e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)  
						e2:SetCode(EFFECT_DISABLE)  
						e2:SetReset(RESET_EVENT+RESETS_STANDARD)  
						tc:RegisterEffect(e2)
					end
					if sc<=x*1/5 then
						Duel.Remove(tc,POS_FACEDOWN,REASON_EFFECT)
					end
				end
			end
			if x<sc and not eg:IsExists(c15000060.sc2filter,1,nil,tp) then
				Duel.Hint(HINT_CARD,0,15000061)
			end
		end
		tc=g:GetNext()
	end
	e:GetHandler():SetTurnCounter(0)
	Duel.RegisterFlagEffect(tp,15000060,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)   
end
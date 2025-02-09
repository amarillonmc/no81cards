--[[
铁虹重压
Rainblo Pressure
Card Author: nemoma
Scripted by: XGlitchy30
]]

local s,id=GetID()

local FLAG_PREVIOUS_COUNTER_COUNT	= id
local FLAG_CHAIN_COUNTER			= id+100
local FLAG_EFFECT_ID				= id+200
local FLAG_ALREADY_NEGATED			= id+300

local PFLAG_INVOLVED_IN_EVENT		= id

Duel.LoadScript("glitchylib_vsnemo.lua")
Duel.LoadScript("glitchylib_lprecover.lua")
function s.initial_effect(c)
	c:EnableCounterPermit(COUNTER_BLOOD)
	c:Activation()
	--[[While your opponent's LP is lower than yours, your opponent cannot target this card with card effects.]]
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e1:SetRange(LOCATION_SZONE)
	e1:SetCondition(s.tgcond)
	e1:SetValue(aux.tgoval)
	c:RegisterEffect(e1)
	--Each time your opponent pays LP, takes damage or loses LP: Place 1 Blood Counter on this card for every 100 LP decreased.
	local SZChk=aux.AddThisCardInSZoneAlreadyCheck(c)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD|EFFECT_TYPE_CONTINUOUS)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetCode(EVENT_DAMAGE)
	e2:SetRange(LOCATION_SZONE)
	e2:SetLabelObject(aux.AddThisCardInSZoneAlreadyCheck(c))
	e2:SetCondition(s.regcon)
	e2:SetOperation(s.regop)
	c:RegisterEffect(e2)
	local e2b=e2:Clone()
	e2b:SetCode(EVENT_PAY_LPCOST)
	e2b:SetOperation(s.regop)
	c:RegisterEffect(e2b)
	local e2c=e2:Clone()
	e2c:SetCode(EVENT_LP_CHANGE)
	e2c:SetCondition(s.regcon)
	e2c:SetOperation(s.regop)
	c:RegisterEffect(e2c)
	local e2d=e2:Clone()
	e2d:SetCode(EVENT_CHAIN_END)
	e2d:SetCondition(s.regcon2)
	e2d:SetOperation(s.regop2)
	c:RegisterEffect(e2d)
	local e3=Effect.CreateEffect(c)
	e3:Desc(0,id)
	e3:SetCategory(CATEGORY_COUNTER)
	e3:SetType(EFFECT_TYPE_FIELD|EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(EVENT_CUSTOM+id+1)
	e3:SetRange(LOCATION_SZONE)
	e3:SetLabelObject(SZChk)
	e3:SetFunctions(aux.AlreadyInRangePlayerEventCondition,nil,s.cttg,s.ctop)
	c:RegisterEffect(e3)
	--[[Monsters your opponent controls lose 100 ATK/DEF for each Blood Counter on this card.]]
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD|EFFECT_TYPE_CONTINUOUS)
	e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE|EFFECT_FLAG_CAN_FORBIDDEN)
	e4:SetCode(EVENT_ADJUST)
	e4:SetRange(LOCATION_SZONE)
	e4:SetOperation(s.statsreg)
	c:RegisterEffect(e4)
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetCode(EFFECT_DISABLE)
	e5:SetRange(LOCATION_SZONE)
	e5:SetTargetRange(0,LOCATION_MZONE)
	e5:SetTarget(s.disable)
	c:RegisterEffect(e5)
	--[[While there are 60 or more Blood Counters on this card, the following effects apply:
	● Your opponent cannot Special Summon monsters.
	● During their Main Phase: Your opponent can activate this effect; they remove all Blood Counters from this card, and if they do, you gain LP equal to the number of counters removed this way
	x100.]]
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_FIELD)
	e6:SetRange(LOCATION_SZONE)
	e6:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e6:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e6:SetTargetRange(0,1)
	e6:SetCondition(s.ctcon)
	c:RegisterEffect(e6)
	local e7=Effect.CreateEffect(c)
	e7:Desc(1,id)
	e7:SetCategory(CATEGORY_RECOVER)
	e7:SetType(EFFECT_TYPE_IGNITION)
	e7:SetProperty(EFFECT_FLAG_BOTH_SIDE)
	e7:SetRange(LOCATION_SZONE)
	e7:SetCondition(s.ctcon)
	e7:SetTarget(s.efftg)
	e7:SetOperation(s.effop)
	c:RegisterEffect(e7)
	if not s.global_check then
		s.global_check=true
		s.MustUpdateEventID=false
		s.EventID=0
		s.EventValueRanges={}
		
		local ge1=Effect.GlobalEffect()
		ge1:SetType(EFFECT_TYPE_FIELD|EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_TURN_END)
		ge1:OPT()
		ge1:SetOperation(s.resetRanges)
		Duel.RegisterEffect(ge1,0)
		local ge3=Effect.CreateEffect(c)
		ge3:SetType(EFFECT_TYPE_FIELD|EFFECT_TYPE_CONTINUOUS)
		ge3:SetCode(EVENT_BREAK_EFFECT)
		ge3:SetOperation(s.SignalEventIDUpdate)
		Duel.RegisterEffect(ge3,0)
		local ge4=ge3:Clone()
		ge4:SetCode(EVENT_CHAIN_SOLVED)
		Duel.RegisterEffect(ge4,0)
		local ge5=ge3:Clone()
		ge5:SetCode(EVENT_CHAINING)
		Duel.RegisterEffect(ge5,0)
	end
end
function s.resetRanges(e,tp,eg,ep,ev,re,r,rp)
	aux.ClearTableRecursive(s.EventValueRanges)
end
function s.SignalEventIDUpdate(e,tp,eg,ep,ev,re,r,rp)
	s.MustUpdateEventID=true
end

--E1
function s.tgcond(e)
	local tp=e:GetHandlerPlayer()
	return Duel.GetLP(1-tp)<Duel.GetLP(tp)
end

--E2
function s.regcon(e,tp,eg,ep,ev,re,r,rp)
	return s.regcon2(e,tp,eg,ep,ev,re,r,rp) and ep==1-tp and (e:GetCode()~=EVENT_LP_CHANGE or ev<0)
end
function s.regcon2(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsHasEffect(EFFECT_CARD_HAS_RESOLVED) and aux.AlreadyInRangePlayerEventCondition(e,tp,eg,ep,ev,re,r,rp)
end
function s.regop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if s.MustUpdateEventID then
		if not c:HasFlagEffect(FLAG_CHAIN_COUNTER) then
			c:RegisterFlagEffect(FLAG_CHAIN_COUNTER,RESET_EVENT|RESETS_STANDARD,0,0,0)
		end
		c:UpdateFlagEffectLabel(FLAG_CHAIN_COUNTER)

		for p=0,1 do
			Duel.ResetFlagEffect(p,PFLAG_INVOLVED_IN_EVENT)
		end
		
		s.EventID = s.EventID + 1 
		s.MustUpdateEventID=false
	end
	
	Duel.RegisterFlagEffect(ep,PFLAG_INVOLVED_IN_EVENT,0,0,0,math.abs(ev))
	
	local val1,val2=0,0
	for p=0,1 do
		for _,v in ipairs({Duel.GetFlagEffectLabel(p,PFLAG_INVOLVED_IN_EVENT)}) do
			if p==0 then
				val1=val1+v
			else
				val2=val2+v
			end
		end
	end
	
	s.EventValueRanges[s.EventID]={val1,val2}
	
	if Duel.GetCurrentChain()==0 and not Duel.CheckEvent(EVENT_CHAIN_SOLVED) and not Duel.CheckEvent(EVENT_CHAIN_END) then
		s.regop2(e,tp,eg,ep,ev,re,r,rp)
	end
end
function s.regop2(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.PlayerHasFlagEffect(0,PFLAG_INVOLVED_IN_EVENT) and not Duel.PlayerHasFlagEffect(1,PFLAG_INVOLVED_IN_EVENT) then return end
	local c=e:GetHandler()
	local counter=1
	local EventID=s.EventID
	if c:HasFlagEffect(FLAG_CHAIN_COUNTER) then
		counter=c:GetFlagEffectLabel(FLAG_CHAIN_COUNTER)
	end
	s.EventIDMin=EventID-counter+1
	s.EventIDMax=EventID
	for i=1,counter do
		Duel.RaiseEvent(Group.CreateGroup(),EVENT_CUSTOM+id+1,re,r,rp,ep,EventID-counter+1)
	end
	c:ResetFlagEffect(FLAG_CHAIN_COUNTER)
	for p=0,1 do
		Duel.ResetFlagEffect(p,PFLAG_INVOLVED_IN_EVENT)
	end
end

--E3
function s.cttg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local tab={}
	for i=s.EventIDMin,s.EventIDMax do
		if s.EventValueRanges[i]~=nil then
			local v=s.EventValueRanges[i][2-tp]
			if v>=100 then
				if chk==0 then
					return true
				end
				table.insert(tab,v)
			end
		end
	end
	
	local v=0
	if #tab>1 then
		v=Duel.AnnounceNumber(tp,table.unpack(tab))
	else
		v=tab[1]
	end
	
	for i=s.EventIDMin,s.EventIDMax do
		if s.EventValueRanges[i]~=nil then
			local ref=s.EventValueRanges[i][2-tp]
			if v==ref then
				s.EventValueRanges[i]=nil
				break
			end
		end
	end
	
	local val=v//100
	Duel.SetTargetParam(val)
	Duel.SetOperationInfo(0,CATEGORY_COUNTER,c,1,tp,val)
end
function s.ctop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ct=Duel.GetTargetParam()
	if c:IsRelateToChain() and c:IsCanAddCounter(COUNTER_BLOOD,ct,true) then
		c:AddCounter(COUNTER_BLOOD,ct,true)
	end
end

--E4
function s.chkfilter(c,e1,e2,preatk,predef)
	return c:IsFaceup()
		and ((preatk>0 and c:IsAttack(0) and not c:IsImmuneToEffect(e1))
		or (predef>0 and c:IsDefense(0) and not c:IsImmuneToEffect(e2)))
end
function s.statsreg(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local eid=c:GetFieldID()
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_MZONE,nil)
	local ct=c:GetCounter(COUNTER_BLOOD)
	if ct==0 then return end
	local diff=ct
	if c:HasFlagEffect(FLAG_PREVIOUS_COUNTER_COUNT) then
		diff=diff-c:GetFlagEffectLabel(FLAG_PREVIOUS_COUNTER_COUNT)
		c:SetFlagEffectLabel(FLAG_PREVIOUS_COUNTER_COUNT,ct)
	else
		c:RegisterFlagEffect(FLAG_PREVIOUS_COUNTER_COUNT,RESET_EVENT|RESETS_STANDARD,0,0,ct)
	end
	
	if not c:HasFlagEffectLabel(FLAG_EFFECT_ID,eid) then
		c:RegisterFlagEffect(FLAG_EFFECT_ID,RESET_EVENT|RESETS_STANDARD,0,0,eid)
	end
	local tg=Group.CreateGroup()
	for tc in aux.Next(g) do
		local flagchk=tc:HasFlagEffectLabel(FLAG_EFFECT_ID,eid)
		local phchk=false
		if diff~=0 or not flagchk then
			local val=diff*-100
			if not flagchk then
				val=ct*-100
				tc:RegisterFlagEffect(FLAG_EFFECT_ID,RESET_EVENT|RESETS_STANDARD,0,0,eid)
			end
			local preatk,predef=tc:GetStats()
			local ph=Effect.CreateEffect(c)
			ph:SetType(EFFECT_TYPE_SINGLE)
			ph:SetProperty(EFFECT_FLAG_OWNER_RELATE)
			ph:SetCode(EFFECT_UPDATE_ATTACK)
			ph:SetLabel(val,eid)
			ph:SetCondition(s.eqcon)
			ph:SetValue(s.eqval)
			ph:SetReset(RESET_EVENT|RESETS_STANDARD)
			tc:RegisterEffect(ph)
			local ph2=ph:UpdateDefenseClone(tc)
			if s.chkfilter(tc,ph,ph2,preatk,predef) then
				phchk=true
			end
		end
		Duel.AdjustInstantly(tc)
		if phchk and (diff>0 or not flagchk) then
			tg:AddCard(tc)
		end
	end
	for tc in aux.Next(tg) do
		if not tc:HasFlagEffectLabel(FLAG_ALREADY_NEGATED,eid) then
			tc:RegisterFlagEffect(FLAG_ALREADY_NEGATED,RESET_EVENT|RESETS_STANDARD,0,1,eid)
		end
	end
end
function s.eqcon(e)
	local c=e:GetOwner()
	local _,eid=e:GetLabel()
	return c:HasCounter(COUNTER_BLOOD) and c:HasFlagEffectLabel(FLAG_EFFECT_ID,eid)
end
function s.eqval(e,c)
	local val,_=e:GetLabel()
	return val
end

--E5
function s.disable(e,c)
	return c:HasFlagEffectLabel(FLAG_ALREADY_NEGATED,e:GetHandler():GetFieldID()) and (c:IsType(TYPE_EFFECT) or (c:GetOriginalType()&TYPE_EFFECT)==TYPE_EFFECT)
end

--E6
function s.ctcon(e)
	return e:GetHandler():GetCounter(COUNTER_BLOOD)>=60
end

--E7
function s.efftg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return tp==1-c:GetControler() and c:IsCanRemoveCounter(tp,COUNTER_BLOOD,1,REASON_EFFECT)
	end
	local val=c:GetCounter(COUNTER_BLOOD)*100
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,1-tp,val)
end
function s.effop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToChain() and c:IsCanRemoveCounter(tp,COUNTER_BLOOD,1,REASON_EFFECT) then
		local a=c:GetCounter(COUNTER_BLOOD)
		if not c:RemoveCounter(tp,COUNTER_BLOOD,a,REASON_EFFECT) then return end
		local diff=a-c:GetCounter(COUNTER_BEHIND_GLASS_IN_DREAM)
		if diff>0 then
			Duel.Recover(1-tp,diff*100,REASON_EFFECT)
		end
	end
end
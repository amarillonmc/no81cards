--[[
双相13综合征
The Bipolar 13
Card Author: nemoma
Scripted by: XGlitchy30
]]

local s,id=GetID()

local FLAG_DELAYED_EVENT			= id
local FLAG_SIMULT_CHECK				= id+100
local FLAG_SIMULT_EXCLUDE			= id+200
local FLAG_APPLIED_EFFECT			= id+300
local FLAG_CHAIN_COUNTER			= id+400

local PFLAG_INVOLVED_IN_EVENT		= id

Duel.LoadScript("glitchylib_vsnemo.lua")
function s.initial_effect(c)
	c:EnableCounterPermit(COUNTER_CARD_SPECIFIC)
	--Must be activated from your hand while you control no cards.
	c:Activation(nil,s.actcon)
	--[[If a monster(s) is Summoned: Apply these effects in sequence (skip over any that do not apply)
	● If a player controls monsters whose combined Level/Rank/Link Rating is exactly 13, place 1 counter on this card.
	● If that monster's ATK/DEF can be divided by 1300, place 1 counter on this card for each 1300 ATK/DEF that monster has.]]
	aux.RegisterMergedDelayedEventGlitchy(c,id,{EVENT_SUMMON_SUCCESS,EVENT_SPSUMMON_SUCCESS,EVENT_FLIP_SUMMON_SUCCESS},aux.TRUE,FLAG_DELAYED_EVENT,LOCATION_SZONE,nil,LOCATION_SZONE,nil,FLAG_SIMULT_CHECK,true)
	local e1=Effect.CreateEffect(c)
	e1:Desc(0,id)
	e1:SetCategory(CATEGORY_COUNTER)
	e1:SetType(EFFECT_TYPE_FIELD|EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_CUSTOM+id)
	e1:SetRange(LOCATION_SZONE)
	e1:SetFunctions(nil,nil,s.target,s.operation)
	c:RegisterEffect(e1)
	--If a player(s) takes damage that can be divided by 1300: Place 1 counter on this card for each 1300 damage that player(s) took.
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
	local e2a=e2:Clone()
	e2a:SetCode(EVENT_CHAIN_END)
	e2a:SetOperation(s.regop2)
	c:RegisterEffect(e2a)
	local e3=Effect.CreateEffect(c)
	e3:Desc(2,id)
	e3:SetCategory(CATEGORY_COUNTER)
	e3:SetType(EFFECT_TYPE_FIELD|EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(EVENT_CUSTOM+id+100)
	e3:SetRange(LOCATION_SZONE)
	e3:SetLabelObject(SZChk)
	e3:SetFunctions(aux.AlreadyInRangePlayerEventCondition,nil,s.cttg,s.ctop)
	c:RegisterEffect(e3)
	--[[During either player's turn: You can send this card with exactly 13 counters to the GY; send all cards on the field and in both player's hands to the GY, also, if exactly 13 cards are sent to
	the GY this way, inflict 1300 damage to your opponent for each.]]
	local e4=Effect.CreateEffect(c)
	e4:Desc(3,id)
	e4:SetCategory(CATEGORY_TOGRAVE|CATEGORY_DAMAGE)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetRange(LOCATION_SZONE)
	e4:SetRelevantTimings()
	e4:SetFunctions(s.tgcon,aux.ToGraveSelfCost,s.tgtg,s.tgop)
	c:RegisterEffect(e4)
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

function s.actcon(e,tp)
	local c=e:GetHandler()
	return c:IsLocation(LOCATION_HAND) and Duel.GetFieldGroupCount(tp,LOCATION_ONFIELD,0)==0
end

--E1
function s.cfilter(c)
	if not c:IsFaceup() then return false end
	local atk,def=c:GetStats()
	return (atk>0 and atk%1300==0) or (def>0 and def%1300==0)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local b1=not c:HasFlagEffectLabel(FLAG_APPLIED_EFFECT,1)
		and (Duel.Group(Card.IsFaceup,tp,LOCATION_MZONE,0,nil):GetSum(Card.GetRatingAuto)==13 or Duel.Group(Card.IsFaceup,tp,0,LOCATION_MZONE,nil):GetSum(Card.GetRatingAuto)==13)
	local b2=not c:HasFlagEffectLabel(FLAG_APPLIED_EFFECT,2) and eg:IsExists(s.cfilter,1,nil)
	if chk==0 then return b1 or b2 end
	local sg=aux.SelectSimultaneousEventGroup(eg,tp,FLAG_SIMULT_CHECK,1,e,FLAG_SIMULT_EXCLUDE)
	if sg then
		Duel.SetTargetCard(sg)
	end
	Duel.SetOperationInfo(0,CATEGORY_COUNTER,c,1,tp,1)
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tg=Duel.GetTargetCards()
	local b1=not c:HasFlagEffectLabel(FLAG_APPLIED_EFFECT,1)
		and (Duel.Group(Card.IsFaceup,tp,LOCATION_MZONE,0,nil):GetSum(Card.GetRatingAuto)==13 or Duel.Group(Card.IsFaceup,tp,0,LOCATION_MZONE,nil):GetSum(Card.GetRatingAuto)==13)
	local b2=not c:HasFlagEffectLabel(FLAG_APPLIED_EFFECT,2) and tg and tg:IsExists(s.cfilter,1,nil)
	if not b1 and not b2 then return end
	local brk=false
	if b1 and c:IsCanAddCounter(COUNTER_CARD_SPECIFIC,1) then
		if c:AddCounter(COUNTER_CARD_SPECIFIC,1) then
			brk=true
			if c:IsRelateToChain() and c:IsFaceup() then
				c:RegisterFlagEffect(FLAG_APPLIED_EFFECT,RESET_EVENT|RESETS_STANDARD|RESET_PHASE|PHASE_END,0,1,1)
			end
		end
	end
	if b2 then
		local ct=0
		for tc in aux.Next(tg) do
			local atk,def=tc:GetStats()
			ct=ct+(atk//1300)+(def//1300)
		end
		if ct>0 and c:IsCanAddCounter(COUNTER_CARD_SPECIFIC,ct) then
			if brk then Duel.BreakEffect() end
			if c:AddCounter(COUNTER_CARD_SPECIFIC,ct) and c:IsRelateToChain() and c:IsFaceup() then
				c:RegisterFlagEffect(FLAG_APPLIED_EFFECT,RESET_EVENT|RESETS_STANDARD|RESET_PHASE|PHASE_END,0,1,2)
			end
		end
	end
end

--E2
function s.regcon(e,tp,eg,ep,ev,re,r,rp)
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
	
	Duel.RegisterFlagEffect(ep,PFLAG_INVOLVED_IN_EVENT,0,0,0,ev)
	
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
		Duel.RaiseEvent(Group.CreateGroup(),EVENT_CUSTOM+id+100,re,r,rp,ep,EventID-counter+1)
	end
	c:ResetFlagEffect(FLAG_CHAIN_COUNTER)
	for p=0,1 do
		Duel.ResetFlagEffect(p,PFLAG_INVOLVED_IN_EVENT)
	end
end

--E3
function s.cttg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local res=false
	local tab1,tab2={},{}
	for i=s.EventIDMin,s.EventIDMax do
		if s.EventValueRanges[i]~=nil then
			local dam1,dam2=s.EventValueRanges[i][1],s.EventValueRanges[i][2]
			if dam1%1300==0 or dam2%1300==0 then
				if chk==0 then
					res=true
					break
				end
				table.insert(tab1,dam1)
				if not tab2[dam1] then
					tab2[dam1]={}
				end
				table.insert(tab2[dam1],dam2)
			end
		end
	end
	if chk==0 then
		return not c:HasFlagEffectLabel(FLAG_APPLIED_EFFECT,3) and res
	end
	
	local val1,val2=0,0
	if #tab1>1 then
		val1=Duel.AnnounceNumber(tp,table.unpack(tab1))
	else
		val1=tab1[1]
	end
	if #tab2[val1]>1 then
		val2=Duel.AnnounceNumber(tp,table.unpack(tab2[val1]))
	else
		val2=tab2[val1][1]
	end
	for i=s.EventIDMin,s.EventIDMax do
		if s.EventValueRanges[i]~=nil then
			local dam1,dam2=s.EventValueRanges[i][1],s.EventValueRanges[i][2]
			if dam1==val1 and dam2==val2 then
				s.EventValueRanges[i]=nil
				break
			end
		end
	end
	local v=0
	if val1%1300==0 then
		v=v+val1
	end
	if val2%1300==0 then
		v=v+val2
	end
	Duel.SetTargetParam(v)
	Duel.SetOperationInfo(0,CATEGORY_COUNTER,c,1,tp,v//1300)
end

function s.ctop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:HasFlagEffectLabel(FLAG_APPLIED_EFFECT,3) then return end
	local ct=Duel.GetTargetParam()//1300
	if c:IsRelateToChain() and c:IsCanAddCounter(COUNTER_CARD_SPECIFIC,ct) and c:AddCounter(COUNTER_CARD_SPECIFIC,ct) then
		c:RegisterFlagEffect(FLAG_APPLIED_EFFECT,RESET_EVENT|RESETS_STANDARD|RESET_PHASE|PHASE_END,0,1,3)
	end
end

--E4
function s.tgcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetCounter(COUNTER_CARD_SPECIFIC)==13
end
function s.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local g=Duel.GetFieldGroup(tp,LOCATION_ONFIELD|LOCATION_HAND,LOCATION_ONFIELD|LOCATION_HAND):Filter(Card.IsAbleToGrave,nil)
	if chk==0 then return not c:HasFlagEffectLabel(FLAG_APPLIED_EFFECT,4) and #g>0 end
	Duel.SetCardOperationInfo(g,CATEGORY_TOGRAVE)
	Duel.SetConditionalOperationInfo(#g==13,0,CATEGORY_DAMAGE,nil,0,1-tp,13*1300)
end
function s.tgop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToChain() then
		if c:HasFlagEffectLabel(FLAG_APPLIED_EFFECT,4) then return end
		c:RegisterFlagEffect(FLAG_APPLIED_EFFECT,RESET_EVENT|RESETS_STANDARD|RESET_PHASE|PHASE_END,0,1,4)
	end
	local g=Duel.GetFieldGroup(tp,LOCATION_ONFIELD|LOCATION_HAND,LOCATION_ONFIELD|LOCATION_HAND):Filter(Card.IsAbleToGrave,nil)
	if #g>0 and Duel.SendtoGrave(g,REASON_EFFECT)>0 then
		local ct=Duel.GetGroupOperatedByThisEffect(e):FilterCount(Card.IsLocation,nil,LOCATION_GRAVE)
		if ct==13 then
			Duel.Damage(1-tp,13*1300,REASON_EFFECT)
		end
	end
end
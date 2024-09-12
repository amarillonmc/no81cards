--[[
本能的惊惧
Natural Fear
Card Author: nemoma
Scripted by: XGlitchy30
]]

local s,id=GetID()
if not GLITCHYLIB_LOADED then
	Duel.LoadScript("glitchylib_vsnemo.lua")
end

local FLAG_INVOLVED_IN_EVENT = id
local FLAG_CHAIN_COUNTER = id+100
local EVENT_NATURAL_FEAR = EVENT_CUSTOM+FLAG_INVOLVED_IN_EVENT
local EVENT_RAISE_REVEALED = EVENT_CUSTOM+200

function s.initial_effect(c)
	c:Activation()
	--You can only control 1 "Natural Fear".
	c:SetUniqueOnField(1,0,id)
	--
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD|EFFECT_TYPE_CONTINUOUS)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e0:SetCode(EVENT_TO_HAND)
	e0:SetRange(LOCATION_SZONE)
	e0:SetLabelObject(aux.AddThisCardInSZoneAlreadyCheck(c))
	e0:SetCondition(s.regcon)
	e0:SetOperation(s.registerToHand)
	c:RegisterEffect(e0)
	local e1=e0:Clone()
	e1:SetCode(EVENT_CHAIN_END)
	e1:SetOperation(s.registerToHand2)
	Duel.RegisterEffect(e1,0)
	local e2=e0:Clone()
	e2:SetCode(EVENT_RAISE_REVEALED)
	c:RegisterEffect(e2)
	local e3=e0:Clone()
	e3:SetCode(EVENT_EXCAVATED)
	c:RegisterEffect(e3)
	--[[If a player(s) reveals or excavates a card(s), or if a player(s) adds a card(s) from their Deck to their hand: That player(s) takes 100 damage for each card they revealed,
	excavated and/or added.]]
	local e4=Effect.CreateEffect(c)
	e4:Desc(0,id)
	e4:SetCategory(CATEGORY_DAMAGE)
	e4:SetType(EFFECT_TYPE_FIELD|EFFECT_TYPE_TRIGGER_F)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetCode(EVENT_NATURAL_FEAR)
	e4:SetRange(LOCATION_SZONE)
	e4:SetFunctions(nil,nil,s.target,s.operation)
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
		
		local _ConfirmCards, _ConfirmExtratop = Duel.ConfirmCards, Duel.ConfirmExtratop
		
		function Duel.ConfirmCards(p,g)
			if aux.GetValueType(g)=="Card" then g=Group.FromCards(g) end
			local rg=g:Filter(Card.IsControler,nil,1-p)
			if #rg>0 then
				Duel.RaiseEvent(rg,EVENT_RAISE_REVEALED,nil,0,PLAYER_NONE,1-p,0)
			end
			return _ConfirmCards(p,g)
		end
		
		function Duel.ConfirmExtratop(p,ct)
			local rg=Duel.GetExtraTopGroup(p,ct)
			if #rg>0 then
				Duel.RaiseEvent(rg,EVENT_RAISE_REVEALED,nil,0,PLAYER_NONE,p,0)
			end
			return _ConfirmExtratop(p,ct)
		end
	end
end
function s.resetRanges(e,tp,eg,ep,ev,re,r,rp)
	for k,v in pairs(s.EventValueRanges) do
		s.EventValueRanges[k]=nil
	end
end
function s.SignalEventIDUpdate(e,tp,eg,ep,ev,re,r,rp)
	s.MustUpdateEventID=true
end

function s.thfilter(c)
	return c:IsPreviousLocation(LOCATION_DECK) and c:IsPreviousControler(c:GetControler())
end
function s.regcon(e)
	return e:GetHandler():IsHasEffect(EFFECT_CARD_HAS_RESOLVED)
end
function s.registerToHand(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if s.MustUpdateEventID then
		if not c:HasFlagEffect(FLAG_CHAIN_COUNTER) then
			c:RegisterFlagEffect(FLAG_CHAIN_COUNTER,RESET_EVENT|RESETS_STANDARD,0,0,0)
		end
		c:UpdateFlagEffectLabel(FLAG_CHAIN_COUNTER)

		for p=0,1 do
			Duel.ResetFlagEffect(p,FLAG_INVOLVED_IN_EVENT)
		end
		
		s.EventID = s.EventID + 1 
		s.MustUpdateEventID=false
	end
	
	local g=e:GetCode()~=EVENT_TO_HAND and eg:Filter(aux.AlreadyInRangeFilter(e),nil) or eg:Filter(aux.AlreadyInRangeFilter(e,s.thfilter),nil)
	for tc in aux.Next(g) do
		local p=tc:GetControler()
		Duel.RegisterFlagEffect(p,FLAG_INVOLVED_IN_EVENT,0,0,0)
	end
	local val1,val2=Duel.GetFlagEffect(0,FLAG_INVOLVED_IN_EVENT),Duel.GetFlagEffect(1,FLAG_INVOLVED_IN_EVENT)
	s.EventValueRanges[s.EventID]={val1,val2}
	
	if Duel.GetCurrentChain()==0 and not Duel.CheckEvent(EVENT_CHAIN_SOLVED) and not Duel.CheckEvent(EVENT_CHAIN_END) then
		s.registerToHand2(e,tp,eg,ep,ev,re,r,rp)
	end
end
function s.registerToHand2(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.PlayerHasFlagEffect(0,FLAG_INVOLVED_IN_EVENT) and not Duel.PlayerHasFlagEffect(1,FLAG_INVOLVED_IN_EVENT) then return end
	local c=e:GetHandler()
	local counter=1
	local EventID=s.EventID
	if c:HasFlagEffect(FLAG_CHAIN_COUNTER) then
		counter=c:GetFlagEffectLabel(FLAG_CHAIN_COUNTER)
	end
	s.EventIDMin=EventID-counter+1
	s.EventIDMax=EventID
	for i=1,counter do
		Duel.RaiseEvent(Group.CreateGroup(),EVENT_NATURAL_FEAR,re,r,rp,ep,EventID-counter+1)
	end
	c:ResetFlagEffect(FLAG_CHAIN_COUNTER)
	for p=0,1 do
		Duel.ResetFlagEffect(p,FLAG_INVOLVED_IN_EVENT)
	end
end

function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return true
	end
	local tab1,tab2={},{}
	for i=s.EventIDMin,s.EventIDMax do
		if s.EventValueRanges[i]~=nil then
			local dam1,dam2=s.EventValueRanges[i][1]*100,s.EventValueRanges[i][2]*100
			table.insert(tab1,dam1)
			if not tab2[dam1] then
				tab2[dam1]={}
			end
			table.insert(tab2[dam1],dam2)
		end
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
			local dam1,dam2=s.EventValueRanges[i][1]*100,s.EventValueRanges[i][2]*100
			if dam1==val1 and dam2==val2 then
				s.EventValueRanges[i]=nil
				break
			end
		end
	end
	if val1~=0 and val2~=0 then
		Duel.SetTargetPlayer(PLAYER_ALL)
		e:SetLabel(val1,val2)
		Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,PLAYER_ALL,0)
	else
		local p=val1~=0 and 0 or 1
		Duel.SetTargetPlayer(p)
		local val=val1~=0 and val1 or val2
		Duel.SetTargetParam(val)
		Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,p,val)
	end
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	if p~=PLAYER_ALL then
		Duel.Damage(p,d,REASON_EFFECT)
	else
		local dtab={e:GetLabel()}
		for i=0,1 do
			Duel.Damage(i,dtab[i+1],REASON_EFFECT,true)
		end
		Duel.RDComplete()
	end
end
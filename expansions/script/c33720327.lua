--[[
至点之旅 ～标准程序之外～
Solstice - Out Of Protocol -
Card Author: nemoma
Scripted by: XGlitchy30
]]

local s,id=GetID()
Duel.LoadScript("glitchylib_vsnemo.lua")
function s.initial_effect(c)
	aux.EnabledRegisteredEffectMods[EVENT_EFFECTS_DISABLED]=true
	--[[When this card is activated: Banish all other cards you control, and if you do, banish all cards in your hand.]]
	local e0=Effect.CreateEffect(c)
	e0:SetCategory(CATEGORY_REMOVE)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	e0:SetHintTiming(0,TIMINGS_CHECK_MONSTER|TIMING_END_PHASE)
	e0:SetFunctions(nil,nil,s.target,s.operation)
	c:RegisterEffect(e0)
	--[[If your opponent has negated the activation and/or the effect(s) of a card(s) you controlled this turn, you can activate this card from your hand.]]
	c:TrapCanBeActivatedFromHand(s.handactcon,aux.Stringid(id,3))
	--[[If this card leaves the field: Return to your hand all cards banished by this card's effect that were originally in your hand (if any), and if you do, return all cards banished by this card's
	effect that were originally on the field to their original zones (if any) (If a card(s) cannot be returned this way, add it to your hand instead).]]
	local e1=Effect.CreateEffect(c)
	e1:Desc(0,id)
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_SINGLE|EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_LEAVE_FIELD)
	e1:SetFunctions(nil,nil,s.rttg,s.rtop)
	c:RegisterEffect(e1)
	e0:SetLabelObject(e1)
	--[[You can pay 1000 LP; send this card to the GY.]]
	local e2=Effect.CreateEffect(c)
	e2:Desc(1,id)
	e2:SetCategory(CATEGORY_TOGRAVE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_SZONE)
	e2:SetFunctions(nil,aux.PayLPCost(1000),s.tgtg,s.tgop)
	c:RegisterEffect(e2)
	if not s.global_check then
		s.global_check=true
		local ge1=Effect.GlobalEffect()
		ge1:SetType(EFFECT_TYPE_FIELD|EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_CHAIN_NEGATED)
		ge1:SetOperation(s.regop)
		Duel.RegisterEffect(ge1,0)
		local ge3=Effect.GlobalEffect()
		ge3:SetType(EFFECT_TYPE_FIELD|EFFECT_TYPE_CONTINUOUS)
		ge3:SetCode(EVENT_CHAIN_DISABLED)
		ge3:SetOperation(s.regop)
		Duel.RegisterEffect(ge3,0)
		local ge3=Effect.GlobalEffect()
		ge3:SetType(EFFECT_TYPE_FIELD|EFFECT_TYPE_CONTINUOUS)
		ge3:SetCode(EVENT_EFFECTS_DISABLED)
		ge3:SetOperation(s.regop2)
		Duel.RegisterEffect(ge3,0)
		local ge4=Effect.GlobalEffect()
		ge4:SetType(EFFECT_TYPE_FIELD|EFFECT_TYPE_CONTINUOUS)
		ge4:SetCode(EVENT_ADJUST)
		ge4:SetOperation(s.regop3)
		Duel.RegisterEffect(ge4,0)
		local ge5=Effect.GlobalEffect()
		ge5:SetType(EFFECT_TYPE_FIELD|EFFECT_TYPE_CONTINUOUS)
		ge5:SetCode(EVENT_MOVE)
		ge5:SetOperation(s.regop4)
		Duel.RegisterEffect(ge5,0)
	end
end

local FLAG_IS_NOT_DISABLED 			= id
local FLAG_HAS_JUST_ENTERED_FIELD 	= id+100
local FLAG_IS_DISABLED_BY_OPPONENT 	= id+200
local FLAG_EFFECT_WAS_APPLIED		= id+300
local FLAG_WAS_IN_HAND				= id+300
local FLAG_WAS_ON_FIELD				= id+400
local FLAG_WAS_IN_PZONE				= id+500

local PFLAG_HAS_DISABLED_SOMETHING	= id

function s.regop(e,tp,eg,ep,ev,re,r,rp)
	local dp,trp=Duel.GetChainInfo(ev,CHAININFO_DISABLE_PLAYER,CHAININFO_TRIGGERING_CONTROLER)
    if dp and math.abs(dp)<=1 and trp==1-dp then
		Duel.RegisterFlagEffect(dp,PFLAG_HAS_DISABLED_SOMETHING,RESET_PHASE|PHASE_END,0,1)
	end
end
function s.regop2(e,tp,eg,ep,ev,re,r,rp)
	local ec=eg:GetFirst()
	if rp and math.abs(rp)<=1 and ep==1-rp then
		Duel.RegisterFlagEffect(rp,PFLAG_HAS_DISABLED_SOMETHING,RESET_PHASE|PHASE_END,0,1)
	end
end
function s.regop3(e,tp,eg,ep,ev,re,r,rp)
	for p=0,1 do
		if not Duel.PlayerHasFlagEffect(1-p,PFLAG_HAS_DISABLED_SOMETHING) then
			local g0=Duel.Group(s.unmarkedfilter,tp,LOCATION_ONFIELD,0,nil)
			for tc in aux.Next(g0) do
				tc:ResetFlagEffect(FLAG_HAS_JUST_ENTERED_FIELD)
				tc:RegisterFlagEffect(FLAG_IS_NOT_DISABLED,RESET_EVENT|RESETS_STANDARD|RESET_PHASE|PHASE_END,0,1,p)
			end

			local g1=Duel.Group(Card.IsDisabled,tp,LOCATION_ONFIELD,0,nil)
			local res=false
			for tc in aux.Next(g1) do
				if not res then
					local eset={tc:IsHasEffect(EFFECT_DISABLE)}
					table.sort(eset, function(a,b) return a:GetFieldID() < b:GetFieldID() end)
	
					local ce=eset[1]
					local eid=ce:GetFieldID()
					local op=ce:GetOwnerPlayer()
					if op and op==1-tc:GetControler() and (tc:HasFlagEffect(FLAG_IS_NOT_DISABLED) or not tc:HasFlagEffectLabel(FLAG_IS_DISABLED_BY_OPPONENT,eid)) then
						res=true
						tc:RegisterFlagEffect(FLAG_IS_DISABLED_BY_OPPONENT,RESET_EVENT|RESETS_STANDARD|RESET_PHASE|PHASE_END,0,1,eid)
						Debug.Message(eid)
					end
				end
				tc:ResetFlagEffect(FLAG_IS_NOT_DISABLED)
			end
			
			if res then
				Duel.RegisterFlagEffect(1-p,PFLAG_HAS_DISABLED_SOMETHING,RESET_PHASE|PHASE_END,0,1)
			end
		end
	end
end
function s.regop4(e,tp,eg,ep,ev,re,r,rp)
	if not eg then return end
	local g=eg:Filter(s.justmoved,nil,LOCATION_ONFIELD)
	for tc in aux.Next(g) do
		tc:RegisterFlagEffect(FLAG_HAS_JUST_ENTERED_FIELD,RESET_EVENT|RESETS_STANDARD|RESET_PHASE|PHASE_END,0,1)
	end
end
function s.unmarkedfilter(c,p)
	return (not c:IsDisabled() or c:HasFlagEffect(FLAG_HAS_JUST_ENTERED_FIELD)) and not c:HasFlagEffectLabel(FLAG_IS_NOT_DISABLED,p)
end
function s.justdisabled(c)
	return c:IsDisabled() and c:HasFlagEffect(FLAG_IS_NOT_DISABLED)
end
function s.justmoved(c)
	return not c:IsPreviousLocation(LOCATION_ONFIELD) or not c:IsPreviousControler(c:GetControler())
end

function s.handactcon(e)
	return Duel.PlayerHasFlagEffect(1-e:GetHandlerPlayer(),PFLAG_HAS_DISABLED_SOMETHING)
end

--E0
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local g1=Duel.Group(Card.IsAbleToRemoveTemp,tp,LOCATION_ONFIELD|LOCATION_HAND,0,c,tp)
	if chk==0 then return #g1>0 end
	e:GetLabelObject():SetLabel(0)
	c:ResetFlagEffect(FLAG_EFFECT_WAS_APPLIED)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g1,#g1,0,0)
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g1=Duel.Group(Card.IsAbleToRemoveTemp,tp,LOCATION_ONFIELD|LOCATION_HAND,0,aux.ExceptThis(c),tp)
	local pg=g1:Filter(Card.IsLocation,nil,LOCATION_PZONE)
	if #g1>0 and Duel.Remove(g1,POS_FACEUP,REASON_EFFECT|REASON_TEMPORARY)>0 then
		local og1=Duel.GetGroupOperatedByThisEffect(e):Filter(Card.IsLocation,nil,LOCATION_REMOVED)
		local fid=c:GetFieldID()
		e:GetLabelObject():SetLabel(fid)
		c:RegisterFlagEffect(FLAG_EFFECT_WAS_APPLIED,RESET_EVENT|RESET_TURN_SET|RESET_TOFIELD|RESET_MSCHANGE|RESET_OVERLAY,0,1,fid)
		for tc in aux.Next(og1) do
			local flag=tc:IsPreviousLocation(LOCATION_HAND) and FLAG_WAS_IN_HAND or FLAG_WAS_ON_FIELD
			tc:RegisterFlagEffect(flag,RESET_EVENT|RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,fid,aux.Stringid(id,2))
			if pg:IsContains(tc) then
				tc:RegisterFlagEffect(FLAG_WAS_IN_PZONE,RESET_EVENT|RESETS_STANDARD,0,1,fid)
			end
		end
	end
end

--E1
function s.rttg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local fid=e:GetLabel()
	if chk==0 then return fid~=0 and c:HasFlagEffectLabel(FLAG_EFFECT_WAS_APPLIED,fid) and c:IsPreviousPosition(POS_FACEUP) end
	Duel.SetTargetParam(fid)
	local hg=Duel.Group(Card.HasFlagEffectLabel,tp,LOCATION_REMOVED,LOCATION_REMOVED,nil,FLAG_WAS_IN_HAND,fid)
	if #hg>0 then
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,hg,#hg,0,0)
	else
		local p
		for player=0,1 do
			if Duel.IsExists(Card.HasFlagEffectLabel,player,LOCATION_REMOVED,0,nil,FLAG_WAS_IN_HAND,fid) or Duel.IsExists(Card.HasFlagEffectLabel,player,LOCATION_REMOVED,0,nil,FLAG_WAS_ON_FIELD,fid) then
				if not p then
					p=player
				else
					p=PLAYER_ALL
				end
			end
		end
		Duel.SetPossibleOperationInfo(0,CATEGORY_TOHAND,nil,1,p,LOCATION_REMOVED)
	end
end
function s.rtop(e,tp,eg,ep,ev,re,r,rp)
	local fid=Duel.GetTargetParam()
	local hg=Duel.Group(Card.HasFlagEffectLabel,tp,LOCATION_REMOVED,LOCATION_REMOVED,nil,FLAG_WAS_IN_HAND,fid):Filter(Card.IsAbleToHand,nil,tp)
	if #hg>0 then
		Duel.SendtoHand(hg,tp,REASON_EFFECT)
	end
	local tg=Group.CreateGroup()
	local fg=Duel.Group(Card.HasFlagEffectLabel,tp,LOCATION_REMOVED,LOCATION_REMOVED,nil,FLAG_WAS_ON_FIELD,fid)
	for tc in aux.Next(fg) do
		local loc=tc:GetPreviousLocation()
		local pos=tc:GetPreviousPosition()
		local seq=tc:GetPreviousSequence()
		local zone=1<<seq
		local e1
		if tc:HasFlagEffectLabel(FLAG_WAS_IN_PZONE,fid) and Duel.CheckLocation(tp,LOCATION_PZONE,seq==0 and 1 or 0) then
			e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_FIELD)
			e1:SetCode(EFFECT_DISABLE_FIELD)
			e1:SetLabel(1<<(12-seq))
			e1:SetOperation(function(_e) return _e:GetLabel() end)
			Duel.RegisterEffect(e1,tp)
			Duel.AdjustAll()
		end
		local res
		if loc==LOCATION_MZONE and seq>4 then
			Duel.SendtoDeck(tc,nil,SEQ_DECKTOP,REASON_RULE)
			res=Duel.MoveToField(tc,tp,tp,loc,pos,true,zone)
		else
			res=Duel.ReturnToField(tc,pos,zone)
			if tc:IsLocation(LOCATION_SZONE) and tc:IsFaceup() and not tc:IsType(TYPE_CONTINUOUS|TYPE_FIELD) and not tc:HasFlagEffectLabel(FLAG_WAS_IN_PZONE,fid) and not tc:IsHasEffect(EFFECT_REMAIN_FIELD) then
				Duel.SendtoGrave(tc,REASON_RULE)
			end
		end
		if e1 then e1:Reset() end
		if not res and tc:IsAbleToHand(tp) then
			tg:AddCard(tc)
		end
		tc:ResetFlagEffect(FLAG_WAS_ON_FIELD)
		tc:ResetFlagEffect(FLAG_WAS_IN_PZONE)
	end
	if #tg>0 then
		Duel.SendtoHand(tg,tp,REASON_EFFECT)
	end
end

--E2
function s.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToGrave() end
	Duel.SetCardOperationInfo(c,CATEGORY_TOGRAVE)
end
function s.tgop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToChain() then
		Duel.SendtoGrave(c,REASON_EFFECT)
	end
end
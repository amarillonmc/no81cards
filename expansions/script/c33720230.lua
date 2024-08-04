--[[
知·音
Fan-Dom
Card Author: nemoma
Scripted by: XGlitchy30
]]

local s,id=GetID()
if not GLITCHYLIB_LOADED then
	Duel.LoadScript("glitchylib_vsnemo.lua")
end
function s.initial_effect(c)
	--[[Apply 1 of these effects.
	● Banish cards from your GY until all cards in your GY have different names, then take 2000 damage for each card banished this way.
	● Until the end of this Chain, if a card(s), whose effect was activated in the same Chain as this card, would be banished or sent to the GY, you can add it to your hand instead,
	but if you do, take 2000 damage for each card added to your hand this way, also that card(s), and cards with the same name, cannot be used until the start of your next turn.]]
	local e1=Effect.CreateEffect(c)
	e1:Desc(0,id)
	e1:SetCategory(CATEGORY_REMOVE|CATEGORY_TOHAND|CATEGORY_DAMAGE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetFunctions(nil,nil,s.target,s.activate)
	c:RegisterEffect(e1)
end

local FLAG_ALREADY_APPLIED_SECOND_EFFECT = id
local FLAG_REGISTERED_IN_CHAIN			 = id+100
local FLAG_APPLYING_CHAIN_END_REDIRECT	 = id+200

--E1
function s.rmfilter(c,g)
	return g:IsExists(Card.IsCode,1,c,c:GetCode())
end
function s.rescon(og)
	return	function(g,e,tp,mg,c)
				local cg=og:Filter(aux.TRUE,g)
				if c and not cg:IsExists(Card.IsCode,1,nil,c:GetCode()) then
					return false,true
				end
				return true
			end
end
function s.finishcon(ct,og)
	return	function(g,e,tp,mg)
				local cg=og:Filter(aux.TRUE,g)
				local dnct=g:GetClassCount(Card.GetCode)
				local cdnct=cg:GetClassCount(Card.GetCode)
				return dnct==ct and cdnct==ct
			end
end
function s.hasSameCodeButNotOtherOnes(c,code)
	local codes={c:GetCode()}
	if #codes>1 then return false end
	return codes[1]==code
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		if Duel.GetCurrentChain()>0 and not Duel.PlayerHasFlagEffect(tp,FLAG_ALREADY_APPLIED_SECOND_EFFECT) then return true end
		local gy=Duel.GetGY(tp)
		local g=gy:Filter(s.rmfilter,nil,gy)
		local ct=#g
		if ct<=0 then return false end
		local tc=g:GetFirst()
		while tc do
			local sg=g:Filter(s.hasSameCodeButNotOtherOnes,nil,tc:GetCode())
			if not sg:IsContains(tc) then
				sg:AddCard(tc)
			end
			local nrg=sg:Filter(aux.NOT(Card.IsAbleToRemove),nil)
			if #nrg>=2 then
				return false
			end
			g:Sub(sg)
			tc=g:GetFirst()
		end
		return true
	end
	Duel.SetPossibleOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_GRAVE)
	Duel.SetPossibleOperationInfo(0,CATEGORY_DAMAGE,nil,0,tp,2000)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local b1=true
	local gy=Duel.GetGY(tp)
	local g=gy:Filter(s.rmfilter,nil,gy)
	local ct=#g
	if ct<=0 then b1=false end
	if b1 then
		local tc=g:GetFirst()
		while tc do
			local sg=g:Filter(s.hasSameCodeButNotOtherOnes,nil,tc:GetCode())
			if not sg:IsContains(tc) then
				sg:AddCard(tc)
			end
			local nrg=sg:Filter(aux.NOT(Card.IsAbleToRemove),nil)
			if #nrg>0 then
				if #nrg>=2 then
					b1=false
					break
				end
				g:Sub(nrg)
				tc=g:GetFirst()
			else
				tc=g:GetNext()
			end
		end
	end
	local b2=Duel.GetCurrentChain()>1 and not Duel.PlayerHasFlagEffect(tp,FLAG_ALREADY_APPLIED_SECOND_EFFECT)
	local opt=aux.Option(tp,id,1,b1,b2)
	if not opt then return end
	
	if opt==0 then
		local dnct=g:GetClassCount(Card.GetCode)
		local rescon=s.rescon(g)
		local rg=aux.SelectUnselectGroup(g,e,tp,ct-dnct,ct-1,rescon,1,tp,HINTMSG_REMOVE,s.finishcon(dnct,g))
		if #rg>0 and Duel.Remove(rg,POS_FACEUP,REASON_EFFECT)>0 then
			local og=Duel.GetGroupOperatedByThisEffect(e):Filter(Card.IsLocation,nil,LOCATION_REMOVED)
			local ct2=#og
			if ct2>0 then
				Duel.BreakEffect()
				Duel.Damage(tp,ct2*2000,REASON_EFFECT)
			end
		end
	elseif opt==1 then
		Duel.RegisterFlagEffect(tp,FLAG_ALREADY_APPLIED_SECOND_EFFECT,RESET_CHAIN,0,1)
		local c=e:GetHandler()
		--Redirect while Chain is still resolving
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD|EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EFFECT_SEND_REPLACE)
		e1:SetLabel(Duel.GetCurrentChain())
		e1:SetTarget(s.reptg)
		e1:SetValue(s.repval)
		e1:SetOperation(s.repop)
		e1:SetReset(RESET_CHAIN)
		Duel.RegisterEffect(e1,tp)
		--Register flag for cards/effects activated during the Chain
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_FIELD|EFFECT_TYPE_CONTINUOUS)
		e3:SetCode(EVENT_CHAIN_SOLVED)
		e3:SetLabel(Duel.GetCurrentChain())
		e3:SetCondition(s.repcon2)
		e3:SetOperation(s.chainreg)
		e3:SetReset(RESET_CHAIN)
		Duel.RegisterEffect(e3,tp)
		--Redirect at the end of Chain for Spells/Traps
		local e4=Effect.CreateEffect(c)
		e4:SetType(EFFECT_TYPE_FIELD|EFFECT_TYPE_CONTINUOUS)
		e4:SetCode(EVENT_LEAVE_FIELD_P)
		e4:SetCondition(s.repcon3)
		e4:SetOperation(s.repop2)
		e4:SetReset(RESET_CHAIN)
		Duel.RegisterEffect(e4,tp)
	end
end
function s.repfilter(c,ch,tp)
	if c:GetDestination()&(LOCATION_GRAVE|LOCATION_REMOVED)==0 then return false end
	for i=1,ch do
		local te=Duel.GetChainInfo(i,CHAININFO_TRIGGERING_EFFECT)
		local tc=te:GetHandler()
		if c==tc then
			local reset=false
			if tc:IsStatus(STATUS_LEAVE_CONFIRMED) then
				reset=true
				tc:CancelToGrave(true)
			end
			local res=tc:IsRelateToEffect(te) and tc:IsAbleToHand(tp)
			if reset then
				tc:CancelToGrave(false)
			end
			return res
		end
	end
	return false
end
function s.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local ch=e:GetLabel()
	if chk==0 then
		return eg:IsExists(s.repfilter,1,nil,ch,tp)
	end
	if Duel.SelectYesNo(tp,aux.Stringid(id,3)) then
		local g=eg:Filter(s.repfilter,nil,ch,tp)
		g:KeepAlive()
		e:SetLabelObject(g)
		return true
	else
		return false
	end
end
function s.repval(e,c)
	return e:GetLabelObject():IsContains(c)
end
function s.repop(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetLabelObject()
	for tc in aux.Next(g) do
		if tc:IsStatus(STATUS_LEAVE_CONFIRMED) then
			tc:CancelToGrave(true)
		end
	end
	if Duel.SendtoHand(g,tp,REASON_EFFECT)>0 then
		local og=Duel.GetGroupOperatedByThisEffect(e):Filter(aux.PLChk,nil,tp,LOCATION_HAND)
		if #og>0 then
			g:Sub(og)
			Duel.Damage(tp,#og*2000,REASON_EFFECT)
			local c=e:GetHandler()
			for oc in aux.Next(og) do
				local e1=Effect.CreateEffect(c)
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE|EFFECT_FLAG_IGNORE_IMMUNE)
				e1:SetCode(EFFECT_FORBIDDEN)
				e1:SetReset(RESET_EVENT|RESETS_STANDARD|RESET_PHASE|PHASE_END|RESET_OPPO_TURN)
				oc:RegisterEffect(e1,true)
				local e2=Effect.CreateEffect(c)
				e2:SetType(EFFECT_TYPE_FIELD)
				e2:SetProperty(EFFECT_FLAG_SET_AVAILABLE|EFFECT_FLAG_IGNORE_IMMUNE)
				e2:SetCode(EFFECT_FORBIDDEN)
				e2:SetLabel(oc:GetCode())
				e2:SetTargetRange(LOCATION_ALL,LOCATION_ALL)
				e2:SetTarget(s.bantg)
				e2:SetReset(RESET_PHASE|PHASE_END|RESET_OPPO_TURN)
				Duel.RegisterEffect(e2,tp)
			end
		end
	end
	if #g>0 then
		for tc in aux.Next(g) do
			tc:CancelToGrave(false)
		end
	end
	g:DeleteGroup()
end
function s.bantg(e,c)
	return c:IsCode(e:GetLabel())
end

function s.repcon2(e)
	local ch=e:GetLabel()
	return Duel.GetCurrentChain()<ch
end
function s.chainreg(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	if rc and rc:IsRelateToEffect(re) then
		rc:RegisterFlagEffect(FLAG_REGISTERED_IN_CHAIN,RESET_EVENT|RESETS_STANDARD|RESET_CHAIN,0,1)
	end
end
function s.repcon3(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentChain()==0 and r==REASON_RULE and not Duel.PlayerHasFlagEffect(tp,FLAG_APPLYING_CHAIN_END_REDIRECT)
end
function s.repop2(e,tp,eg,ep,ev,re,r,rp)
	local g=eg:Filter(Card.HasFlagEffect,nil,FLAG_REGISTERED_IN_CHAIN)
	local tg=Group.CreateGroup()
	local rg=Group.CreateGroup()
	for tc in aux.Next(g) do
		if tc:IsStatus(STATUS_LEAVE_CONFIRMED) and tc:GetDestination()&(LOCATION_GRAVE|LOCATION_REMOVED)>0 then
			rg:AddCard(tc)
			tc:CancelToGrave(true)
			if tc:IsAbleToHand(tp) then
				tg:AddCard(tc)
			end
		end
	end

	if #tg>0 then
		if Duel.SelectYesNo(tp,aux.Stringid(id,3)) then
			Duel.RegisterFlagEffect(tp,FLAG_APPLYING_CHAIN_END_REDIRECT,RESET_CHAIN,0,1)
			if Duel.SendtoHand(tg,tp,REASON_EFFECT)>0 then
				local og=Duel.GetGroupOperatedByThisEffect(e):Filter(aux.PLChk,nil,tp,LOCATION_HAND)
				if #og>0 then
					rg:Sub(og)
					Duel.Damage(tp,#og*2000,REASON_EFFECT)
					local c=e:GetHandler()
					for oc in aux.Next(og) do
						local e1=Effect.CreateEffect(c)
						e1:SetType(EFFECT_TYPE_SINGLE)
						e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE|EFFECT_FLAG_IGNORE_IMMUNE)
						e1:SetCode(EFFECT_FORBIDDEN)
						e1:SetReset(RESET_EVENT|RESETS_STANDARD|RESET_PHASE|PHASE_END|RESET_OPPO_TURN)
						oc:RegisterEffect(e1,true)
						local e2=Effect.CreateEffect(c)
						e2:SetType(EFFECT_TYPE_FIELD)
						e2:SetProperty(EFFECT_FLAG_SET_AVAILABLE|EFFECT_FLAG_IGNORE_IMMUNE)
						e2:SetCode(EFFECT_FORBIDDEN)
						e2:SetLabel(oc:GetCode())
						e2:SetTargetRange(LOCATION_ALL,LOCATION_ALL)
						e2:SetTarget(s.bantg)
						e2:SetReset(RESET_PHASE|PHASE_END|RESET_OPPO_TURN)
						Duel.RegisterEffect(e2,tp)
					end
				end
			end
			Duel.ResetFlagEffect(tp,FLAG_APPLYING_CHAIN_END_REDIRECT)
		end
	end
	if #rg>0 then
		for tc in aux.Next(rg) do
			tc:CancelToGrave(false)
		end
	end
end
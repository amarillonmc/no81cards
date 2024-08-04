--[[
只是个理论而已！
Just. A. Theory!
Card Author: nemoma
Scripted by: XGlitchy30
]]

local s,id=GetID()
if not GLITCHYLIB_LOADED then
	Duel.LoadScript("glitchylib_vsnemo.lua")
end
function s.initial_effect(c)
	--[[Declare 1 card name, and if you do, until the end of your next turn, if a card(s) with the same as the declared one would be sent to the GY, add it to your hand instead,
	and if you do that, until the end of your next turn, you cannot activate the effects of cards with the same name as the declared card,
	also you cannot Special Summon monsters with the same name as the declared card.]]
	local e1=Effect.CreateEffect(c)
	e1:Desc(0,id)
	e1:SetCategory(CATEGORY_ANNOUNCE|CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetFunctions(nil,nil,nil,s.activate)
	c:RegisterEffect(e1)
end

local FLAG_REGISTERED_IN_CHAIN			 = id
local FLAG_APPLYING_CHAIN_END_REDIRECT	 = id+100

function s.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CODE)
	local code=Duel.AnnounceCard(tp)
	local c=e:GetHandler()
	local rct=Duel.GetNextPhaseCount(nil,tp)
	--Redirect while Chain is still resolving, or outside of a Chain
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD|EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EFFECT_SEND_REPLACE)
	e1:SetLabel(code,rct)
	e1:SetTarget(s.reptg)
	e1:SetValue(s.repval)
	e1:SetOperation(s.repop)
	e1:SetReset(RESET_PHASE|PHASE_END|RESET_SELF_TURN,rct)
	Duel.RegisterEffect(e1,tp)
	--Register flag for cards/effects activated during the Chain
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD|EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_CHAIN_SOLVED)
	e3:SetOperation(s.chainreg)
	e3:SetReset(RESET_PHASE|PHASE_END|RESET_SELF_TURN,rct)
	Duel.RegisterEffect(e3,tp)
	--Redirect at the end of Chain for Spells/Traps
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD|EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_LEAVE_FIELD_P)
	e4:SetLabel(code,rct)
	e4:SetCondition(s.repcon3)
	e4:SetOperation(s.repop2)
	e4:SetReset(RESET_PHASE|PHASE_END|RESET_SELF_TURN,rct)
	Duel.RegisterEffect(e4,tp)
end
function s.repfilter(c,tp,code)
	if c:GetDestination()&LOCATION_GRAVE==0 or not c:IsCode(code) then return false end
	local reset=false
	if c:IsStatus(STATUS_LEAVE_CONFIRMED) then
		reset=true
		c:CancelToGrave(true)
	end
	local res=c:IsAbleToHand(tp)
	if reset then
		c:CancelToGrave(false)
	end
	return res
end
function s.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local code,rct=e:GetLabel()
	if chk==0 then
		return eg:IsExists(s.repfilter,1,nil,tp,code)
	end
	local g=eg:Filter(s.repfilter,nil,tp,code)
	if #g>0 then
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
			Duel.ConfirmCards(1-tp,og)
			local c=e:GetHandler()
			local code,rct=e:GetLabel()
			for oc in aux.Next(og) do
				local e1=Effect.CreateEffect(c)
				e1:SetType(EFFECT_TYPE_FIELD)
				e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
				e1:SetCode(EFFECT_CANNOT_ACTIVATE)
				e1:SetLabel(code)
				e1:SetTargetRange(1,0)
				e1:SetValue(s.bantg)
				e1:SetReset(RESET_PHASE|PHASE_END|RESET_SELF_TURN,rct)
				Duel.RegisterEffect(e1,tp)
				local e2=e1:Clone(c)
				e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
				e2:SetTarget(s.bantg2)
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
function s.bantg(e,re,tp)
	return re:GetHandler():IsCode(e:GetLabel())
end
function s.bantg2(e,c)
	return c:IsCode(e:GetLabel())
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
	local code,rct=e:GetLabel()
	local g=eg:Filter(Card.HasFlagEffect,nil,FLAG_REGISTERED_IN_CHAIN)
	local tg=Group.CreateGroup()
	local rg=Group.CreateGroup()
	for tc in aux.Next(g) do
		if tc:IsStatus(STATUS_LEAVE_CONFIRMED) and tc:IsCode(code) and tc:GetDestination()&LOCATION_GRAVE>0 then
			rg:AddCard(tc)
			tc:CancelToGrave(true)
			if tc:IsAbleToHand(tp) then
				tg:AddCard(tc)
			end
		end
	end

	if #tg>0 then
		Duel.RegisterFlagEffect(tp,FLAG_APPLYING_CHAIN_END_REDIRECT,RESET_CHAIN,0,1)
		if Duel.SendtoHand(tg,tp,REASON_EFFECT)>0 then
			local og=Duel.GetGroupOperatedByThisEffect(e):Filter(aux.PLChk,nil,tp,LOCATION_HAND)
			if #og>0 then
				rg:Sub(og)
				local c=e:GetHandler()
				local code,rct=e:GetLabel()
				for oc in aux.Next(og) do
					local e1=Effect.CreateEffect(c)
					e1:SetType(EFFECT_TYPE_FIELD)
					e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
					e1:SetCode(EFFECT_CANNOT_ACTIVATE)
					e1:SetLabel(code)
					e1:SetTargetRange(1,0)
					e1:SetValue(s.bantg)
					e1:SetReset(RESET_PHASE|PHASE_END|RESET_SELF_TURN,rct)
					Duel.RegisterEffect(e1,tp)
					local e2=e1:Clone(c)
					e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
					e2:SetTarget(s.bantg2)
					Duel.RegisterEffect(e2,tp)
				end
			end
		end
		Duel.ResetFlagEffect(tp,FLAG_APPLYING_CHAIN_END_REDIRECT)
	end
	if #rg>0 then
		for tc in aux.Next(rg) do
			tc:CancelToGrave(false)
		end
	end
end
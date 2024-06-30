--[[
动物朋友的道标
Anifriends' Beacon
Card Author: nemoma
Scripted by: XGlitchy30
]]

local s,id=GetID()
if not GLITCHYLIB_LOADED then
	Duel.LoadScript("glitchylib_vsnemo.lua")
end
function s.initial_effect(c)
	local e0=c:Activation(false,s.actcon,nil,nil,nil,true)
	e0:SetHintTiming(TIMING_END_PHASE)
	c:RegisterEffect(e0)
	--If you control exactly 1 monster, this card is unaffected by your opponent's card effects.
	c:Unaffected(UNAFFECTED_OPPO,s.imcon)
	--During the End Phase, apply the following effects in sequence, based on the number of cards with different names that were sent to the GY during this turn:
	if not s.global_group then
		s.global_group=Group.CreateGroup()
		s.global_group:KeepAlive()
		local ge=Effect.GlobalEffect()
		ge:SetType(EFFECT_TYPE_FIELD|EFFECT_TYPE_CONTINUOUS)
		ge:SetCode(EVENT_TO_GRAVE)
		ge:SetOperation(s.regop)
		Duel.RegisterEffect(ge,0)
		local ge1=Effect.GlobalEffect()
		ge1:SetType(EFFECT_TYPE_FIELD|EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_MOVE)
		ge1:SetOperation(s.regop2)
		Duel.RegisterEffect(ge1,0)
		local ge2=Effect.GlobalEffect()
		ge2:SetType(EFFECT_TYPE_FIELD|EFFECT_TYPE_CONTINUOUS)
		ge2:SetCode(EVENT_TURN_END)
		ge2:OPT()
		ge2:SetOperation(s.resetop)
		Duel.RegisterEffect(ge2,0)
	end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD|EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PHASE|PHASE_END)
	e1:SetRange(LOCATION_SZONE)
	e1:OPT()
	e1:SetOperation(s.operation)
	c:RegisterEffect(e1)
end
function s.actcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)==0
end

function s.imcon(e)
	return Duel.GetFieldGroupCount(e:GetHandlerPlayer(),LOCATION_MZONE,0)==1
end

function s.regop(e,tp,eg,ep,ev,re,r,rp)
	s.global_group:Merge(eg)
end
function s.regop2(e,tp,eg,ep,ev,re,r,rp)
	local g=eg:Filter(s.retfilter,nil)
	s.global_group:Merge(g)
end
function s.retfilter(c)
	return c:IsLocation(LOCATION_GRAVE) and c:IsReason(REASON_RETURN)
end
function s.resetop(e,tp,eg,ep,ev,re,r,rp)
	s.global_group:Clear()
end

--E1
function s.thfilter(c)
	return Duel.GetTurnCount()==c:GetTurnID() and c:IsAbleToHand()
end
function s.gcheck(g,gy)
	return g:GetClassCount(Card.GetCode)==#g and not g:IsExists(s.gyfilter,1,nil,gy)
end
function s.gyfilter(c,gy)
	return gy:IsExists(Card.IsCode,1,nil,c:GetCode())
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local ct=s.global_group:GetClassCount(Card.GetCode)
	local brk=false
	if ct==0 then
		local g=Duel.GetBanishment(tp)
		if #g>0 then
			Duel.Hint(HINT_CARD,tp,id)
			if Duel.SendtoGrave(g,REASON_EFFECT|REASON_RETURN)>0 and g:IsExists(Card.IsLocation,1,nil,LOCATION_GRAVE) then
				brk=true
			end
		end
	end
	ct=s.global_group:GetClassCount(Card.GetCode)
	if ct>=5 then
		Duel.Hint(HINT_CARD,tp,id)
		local g=Duel.Select(HINTMSG_ATOHAND,false,tp,aux.Necro(s.thfilter),tp,LOCATION_GRAVE,0,1,1,nil)
		if #g>0 then
			if brk then
				Duel.BreakEffect()
				brk=false
			end
			if Duel.SearchAndCheck(g,tp) then
				brk=true
			end
		end
	end
	ct=s.global_group:GetClassCount(Card.GetCode)
	if ct>=7 then
		if Duel.IsPlayerCanDraw(tp,1) and brk then
			Duel.BreakEffect()
			brk=false
		end
		local draw=Duel.Draw(tp,1,REASON_EFFECT)
		local rec=Duel.Recover(tp,2000,REASON_EFFECT)
		if draw>0 or rec>0 then
			brk=true
		end
	end
	ct=s.global_group:GetClassCount(Card.GetCode)
	if ct>=15 then
		local gy=Duel.GetGY(tp)
		local g=Duel.Group(Card.IsAbleToHand,tp,LOCATION_DECK,0,nil)
		Duel.HintMessage(tp,HINTMSG_ATOHAND)
		local sg=g:SelectSubGroup(tp,s.gcheck,false,1,2,gy)
		if sg and #sg>0 then
			if brk then Duel.BreakEffect() end
			Duel.Search(sg,tp)
		end
	end
end
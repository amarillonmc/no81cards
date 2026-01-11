--散幻叙敛
local s,id,o=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)

	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_SZONE)
	e2:SetOperation(s.chop)
	c:RegisterEffect(e2)
	
	--Global check for tracking moves
	if not s.global_check then
		s.global_check=true
		s.move_map={}	
		
	end
end

--Global: Reset tracking for current chain
function s.resetop(e,tp,eg,ep,ev,re,r,rp)
	local chain_id=Duel.GetCurrentChain()
	if chain_id>0 then
		s.move_map[chain_id]={
			enter=Group.CreateGroup(),
			leave=Group.CreateGroup()
		}
		s.move_map[chain_id].enter:KeepAlive()
		s.move_map[chain_id].leave:KeepAlive()
	end
end
function s.chcon(e,tp,eg,ep,ev,re,r,rp)
	return re:GetHandler():IsSetCard(0x838)
end
function s.chop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not re or not re:GetHandler():IsSetCard(0x838) then return end
	local last_choice=c:GetFlagEffectLabel(id)
	if not last_choice then
		last_choice=Duel.SelectOption(tp,aux.Stringid(id,0),aux.Stringid(id,1))
	else
		last_choice=1-last_choice
	end
	--Register Choice
	c:ResetFlagEffect(id)
	c:RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,last_choice,aux.Stringid(id,last_choice))
	
	--Process
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_CHAIN_SOLVED)
	e2:SetRange(LOCATION_SZONE)
	e2:SetLabel(last_choice)
	e2:SetOperation(s.processop)
	e2:SetReset(RESET_CHAIN)
	Duel.RegisterEffect(e2,tp)
	--Track moves
	local ge2=Effect.CreateEffect(c)
	ge2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	ge2:SetCode(EVENT_MOVE)
	ge2:SetOperation(s.trackop)
	ge2:SetReset(RESET_CHAIN)
	ge2:SetLabelObject(e2)
	Duel.RegisterEffect(ge2,tp)
	local ge3=ge2:Clone()
	ge3:SetCode(EVENT_LEAVE_DECK)
	--Duel.RegisterEffect(ge3,tp)
	local ge4=ge2:Clone()
	ge4:SetCode(EVENT_LEAVE_GRAVE)
	--Duel.RegisterEffect(ge4,tp)
end
--Global: Track cards entering/leaving due to Talespace effects
function s.trackop(e,tp,eg,ep,ev,re,r,rp)
	if not re or not re:GetHandler():IsSetCard(0x838) then return end
	local enter_g=Group.CreateGroup()
	local leave_g=Group.CreateGroup()
	for tc in aux.Next(eg) do
		if tc:IsLocation(LOCATION_ONFIELD) and not tc:IsPreviousLocation(LOCATION_ONFIELD) then
			--Debug.Message("e")
			--Debug.Message(tc:GetCode())
			enter_g:AddCard(tc)
		end
		if not tc:IsLocation(LOCATION_ONFIELD) and tc:IsPreviousLocation(LOCATION_ONFIELD) then
			leave_g:AddCard(tc)
			--Debug.Message("l")
			--Debug.Message(tc:GetCode())
		end
	end
	local ce=e:GetLabelObject()
	local g=enter_g+leave_g
	local og=ce:GetLabelObject()
	if g and og then g=og+g end
	g:KeepAlive()	
	ce:SetLabelObject(g)
end
function s.processop(e,tp,eg,ep,ev,re,r,rp)
	local selected_opt=e:GetLabel()
	local g=e:GetLabelObject()
	if not g or #g==0 then return end
	Duel.Hint(HINT_CARD,0,id)
	local g_enter=g:Filter(Card.IsLocation,nil,LOCATION_ONFIELD)
	local g_leave=g-g_enter
	--Execute
	if selected_opt==0 then
		--Apply double effect for Enter group
		s.do_double_effect(e,tp,g_enter)
		--Ban effects for Leave group
		if #g_leave > 0 then
			s.apply_ban(e,g_leave)
		end
	else
		Duel.Hint(HINT_CARD,0,id)
		--Apply double effect for Leave group
		s.do_double_effect(e,tp,g_leave)
		--Ban effects for Enter group
		if #g_enter > 0 then
			s.apply_ban(e,g_enter)
		end
	end
	
	--Cleanup (Optional, but good for memory)
	--data.enter:DeleteGroup()
	--data.leave:DeleteGroup()
	--s.move_map[ev] = nil
end

function s.apply_ban(e,g)
	for tc in aux.Next(g) do
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetDescription(aux.Stringid(id,3))
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CANNOT_TRIGGER)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CLIENT_HINT)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
	end
end
function s.filter3(c,ct)
	return c:GetFlagEffect(id)>ct
end
function s.do_double_effect(e,tp,g)
	for tc in aux.Next(g) do		
		local e1=Effect.CreateEffect(e:GetHandler())
		local fid=e1:GetFieldID()
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_CHAIN_SOLVING)
		e1:SetRange(0xff)
		e1:SetLabel(fid)
		e1:SetCondition(s.dscon)
		e1:SetOperation(s.dsop)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		tc:RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,EFFECT_FLAG_CLIENT_HINT,1,fid,aux.Stringid(id,2))
	end
end
function s.dscon(e,tp,eg,ep,ev,re,r,rp)
	local fid=e:GetLabel()
	return re:GetHandler()==e:GetHandler() and re:GetHandler():GetFlagEffect(id)>0 and re:GetHandler():GetFlagEffectLabel(id)==e:GetLabel()
end
function s.dsop(e,tp,eg,ep,ev,re,r,rp)
	local op=re:GetOperation() or aux.TRUE
	local op2=function(e,...) e:SetOperation(op)  op(e,...) op(e,...) end
	re:SetOperation(op2)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetCode(EVENT_CHAIN_SOLVED)
	e1:SetCountLimit(1)
	e1:SetLabel(ev)
	e1:SetCondition(function(e,tp,eg,ep,ev,re,r,rp) return ev==e:GetLabel() end)
	e1:SetOperation(function(e,tp,eg,ep,ev,re,r,rp) re:SetOperation(op) end)
	e1:SetReset(RESET_CHAIN)
	Duel.RegisterEffect(e1,tp)
end
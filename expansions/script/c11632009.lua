--智慧泉牌凝炼的智慧
local s,id,o=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
	if not s.global_check then
		s.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_DRAW)
		ge1:SetCondition(s.checkcon)
		ge1:SetOperation(s.checkop)
		Duel.RegisterEffect(ge1,0)
		local ge2=Effect.CreateEffect(c)
		ge2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge2:SetCode(EVENT_PHASE+PHASE_END)
		ge2:SetCondition(s.ctcon)
		ge2:SetOperation(s.ctop)
		ge2:SetCountLimit(1)
		Duel.RegisterEffect(ge2,0)
	end
end
s.toss_dice=true
function s.rfilter(c)   
	return c:IsReason(REASON_EFFECT) and not c:IsReason(REASON_DESTROY) and c:IsPreviousControler(1-c:GetReasonPlayer())
end
function s.checkcon(e,tp,eg,ep,ev,re,r,rp)
	return re and re:GetHandler():IsType(TYPE_SPELL)
end
function s.checkop(e,tp,eg,ep,ev,re,r,rp)
	local p=rp
	if Duel.GetFlagEffect(p,id)>0 and Duel.GetFlagEffect(p,id+1)==0 then
		Duel.RegisterFlagEffect(p,id+1,RESET_PHASE+PHASE_END,0,1)
		local g=Duel.GetFieldGroup(p,LOCATION_DECK,0)
		local last=g:GetFirst()
		local tc=g:GetNext()
		while tc do
			if tc:GetSequence()<last:GetSequence() then last=tc end
			tc=g:GetNext()
		end
		if last then
			Duel.DisableShuffleCheck()
			Duel.SendtoGrave(last,REASON_EFFECT)
		end
	end
end

function s.ctcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(0,id)>0 or Duel.GetFlagEffect(1,id)>0
end
function s.ctop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	for p=0,1 do
		local ct=Duel.GetFlagEffect(p,id)
		if ct==0 or Duel.GetTurnPlayer()==p then return end
		Duel.ResetFlagEffect(p,id)
		for i=1,ct-1 do
			Duel.RegisterFlagEffect(p,id,nil,0,1)
		end
		c:SetHint(CHINT_TURN,Duel.GetFlagEffect(p,id))
		local st=ct
		if st>7 then st=7 end
		local e1=Effect.CreateEffect(c) 
		e1:SetDescription(aux.Stringid(id,st))
		e1:SetType(EFFECT_TYPE_FIELD) 
		e1:SetCode(id) 
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CLIENT_HINT)
		e1:SetReset(RESET_PHASE+PHASE_END,3)
		e1:SetTargetRange(1,0) 
		Duel.RegisterEffect(e1,p) 
	end
end

function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ct=Duel.GetFlagEffect(p,id)
	local d=Duel.TossDice(tp,1)
	Duel.ResetFlagEffect(tp,id)
	for i=1,ct+d do
		Duel.RegisterFlagEffect(tp,id,nil,0,1)
	end
	c:SetHint(CHINT_TURN,Duel.GetFlagEffect(p,id))
	local st=ct+d
	if st>7 then st=7 end
	local e1=Effect.CreateEffect(c) 
	e1:SetDescription(aux.Stringid(id,st))
	e1:SetType(EFFECT_TYPE_FIELD) 
	e1:SetCode(id) 
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CLIENT_HINT)
	e1:SetReset(RESET_PHASE+PHASE_END,2)
	e1:SetTargetRange(1,0) 
	Duel.RegisterEffect(e1,tp)
end
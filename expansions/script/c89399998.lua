--一闪即永恒
local s,id,o=GetID()
function s.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,id+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
	local e3=e1:Clone()
	e3:SetRange(LOCATION_DECK)
	e3:SetCondition(s.condition2)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_ACTIVATE_COST)
	e4:SetRange(LOCATION_DECK)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetTargetRange(1,0)
	e4:SetTarget(s.actarget)
	e4:SetOperation(s.costop)
	c:RegisterEffect(e4)
	if not s.global_check then
		s.global_check=true
		s.regcheck(c,TYPE_MONSTER)
		s.regcheck(c,TYPE_SPELL)
		s.regcheck(c,TYPE_TRAP)
	end
end
s[0]=true
s[1]=true
function s.regcheck(c,t)
	local ge1=Effect.CreateEffect(c)
	ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	ge1:SetCode(EVENT_CHAINING)
	ge1:SetCondition(s.fcon(t))
	ge1:SetOperation(s.fop(t))
	Duel.RegisterEffect(ge1,0)
end
function s.fcon(t)
	return function(e,tp,eg,ep,ev,re,r,rp)
		local rc=re:GetHandler()
		return rc:IsType(t) and rc:IsSetCard(0x838)
	end
end
function s.fop(t)
	return function(e,tp,eg,ep,ev,re,r,rp)
		if Duel.GetFlagEffect(rp,id+t)==0 then
			Duel.RegisterFlagEffect(rp,id+t,0,0,0)
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			e1:SetCode(EVENT_CHAIN_NEGATED)
			e1:SetOperation(s.frsop(t))
			e1:SetLabelObject(re)
			e1:SetReset(RESET_CHAIN)
			Duel.RegisterEffect(e1,rp)
		end
	end
end
function s.frsop(t)
	return function(e,tp,eg,ep,ev,re,r,rp)
		if e:GetLabelObject()==re then
			Duel.ResetFlagEffect(tp,id+t)
		end
	end
end
function s.rmfilter(c)
	return c:IsCode(id) and c:IsAbleToRemove() and (c:IsFaceup() or not c:IsOnField())
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(s.rmfilter,tp,LOCATION_HAND+LOCATION_ONFIELD+LOCATION_GRAVE+LOCATION_DECK,0,nil)
	g:AddCard(e:GetHandler())
	if chk==0 then return g:GetCount()>0 end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,g:GetCount(),tp,LOCATION_HAND+LOCATION_ONFIELD+LOCATION_GRAVE+LOCATION_DECK)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local g=Duel.GetMatchingGroup(s.rmfilter,tp,LOCATION_HAND+LOCATION_ONFIELD+LOCATION_GRAVE+LOCATION_DECK,0,nil)
	if Duel.Remove(g,POS_FACEUP,REASON_EFFECT)>0 then
		local sg=Duel.GetOperatedGroup()
		for tc in aux.Next(sg) do
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_FIELD)
			e1:SetCode(EFFECT_CANNOT_DRAW)
			e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
			e1:SetRange(LOCATION_REMOVED)
			e1:SetTargetRange(1,0)
			e1:SetCondition(s.dcon)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e1)
		end
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_PHASE+PHASE_STANDBY)
		e1:SetCountLimit(1)
		e1:SetLabel(id)
		e1:SetOperation(s.thop)
		Duel.RegisterEffect(e1,tp)
	end
end
function s.dcon(e)
	return s[e:GetHandlerPlayer()]
end
function s.rtfilter(c)
	return c:IsCode(id) and c:IsAbleToDeck() and c:IsFaceup()
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
	local tg=Duel.GetMatchingGroup(s.rtfilter,tp,LOCATION_REMOVED,0,nil)
	if #tg>0 then
		Duel.SendtoDeck(tg:GetFirst(),nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
		local g=Duel.GetOperatedGroup()
		if g:IsExists(Card.IsLocation,1,nil,LOCATION_DECK) then
			Duel.ShuffleDeck(tp)
			Duel.BreakEffect()
			s[tp]=false
			Duel.Draw(tp,1,REASON_EFFECT)
			s[tp]=true
		end
	end
end
function s.actarget(e,te,tp)
	e:SetLabelObject(te)
	return te:GetHandler()==e:GetHandler()
end
function s.costop(e,tp,eg,ep,ev,re,r,rp)
	local te=e:GetLabelObject()
	local c=e:GetHandler()
	Duel.MoveToField(c,tp,tp,LOCATION_SZONE,POS_FACEUP,false)
	c:CreateEffectRelation(te)
	local ev0=Duel.GetCurrentChain()+1
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetCode(EVENT_CHAIN_SOLVED)
	e1:SetCountLimit(1)
	e1:SetCondition(function(e,tp,eg,ep,ev,re,r,rp) return ev==ev0 end)
	e1:SetOperation(s.rsop)
	e1:SetReset(RESET_CHAIN)
	Duel.RegisterEffect(e1,tp)
	local e2=e1:Clone()
	e2:SetCode(EVENT_CHAIN_NEGATED)
	Duel.RegisterEffect(e2,tp)
end
function s.rsop(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	if e:GetCode()==EVENT_CHAIN_SOLVED and rc:IsRelateToEffect(re) then
		rc:SetStatus(STATUS_EFFECT_ENABLED,true)
	end
	if e:GetCode()==EVENT_CHAIN_NEGATED and rc:IsRelateToEffect(re) and not (rc:IsOnField() and rc:IsFacedown()) then
		rc:SetStatus(STATUS_ACTIVATE_DISABLED,true)
	end
end
function s.condition2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(tp,id+TYPE_MONSTER)>0 and Duel.GetFlagEffect(tp,id+TYPE_SPELL)>0 and Duel.GetFlagEffect(tp,id+TYPE_TRAP)>0
end

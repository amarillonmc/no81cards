local s,id,o=GetID()
function s.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	s.sanarara=e1
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
	if not s.global_check then
		s.global_check=true
		s[1]=Card.ReplaceEffect
		Card.ReplaceEffect=function(sc,code,...)
			if SANARARA then return s[1](sc,0,...) else return s[1](sc,code,...) end
		end
		s[2]=Card.CopyEffect
		Card.CopyEffect=function(sc,code,...)
			if SANARARA then return s[2](sc,0,...) else return s[2](sc,code,...) end
		end
		s[3]=Card.RegisterEffect
		Card.RegisterEffect=function(sc,se,...)
			if SANARARA and sc.sanarara and sc.sanarara==se then return 0 else return s[3](sc,se,...) end
		end
	end
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	c:CancelToGrave()
	if Duel.SendtoHand(c,1-tp,REASON_EFFECT)==0 then c:CancelToGrave(false) return end
	if not c:IsLocation(LOCATION_HAND) or c:IsControler(tp) then return end
	SANARARA=true
	s.initial_effect=function()end
	for tc in aux.Next(Duel.GetMatchingGroup(Card.IsOriginalCodeRule,0,0xff,0xff,nil,id)) do
		local te=tc.sanarara
		if te then te:Reset() end
	end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_PUBLIC)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_DIRECT_ATTACK)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetRange(LOCATION_HAND)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetReset(RESET_EVENT+RESETS_STANDARD)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_MOVE)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e3:SetRange(LOCATION_HAND)
	e3:SetOperation(s.regop)
	e3:SetReset(RESET_EVENT+RESETS_STANDARD)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_MOVE)
	e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e4:SetOperation(s.tdop)
	c:RegisterEffect(e4)
	local e5=Effect.CreateEffect(e:GetHandler())
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e5:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e5:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e5:SetCountLimit(1)
	e5:SetRange(LOCATION_HAND)
	e5:SetCondition(s.descon)
	e5:SetOperation(s.desop)
	e5:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_STANDBY+RESET_SELF_TURN,7)
	c:RegisterEffect(e5)
	c:RegisterFlagEffect(1082946,RESET_PHASE+PHASE_END+RESET_OPPO_TURN,0,3)
	s[c]=e5
	local ng=Group.CreateGroup()
	ng:KeepAlive()
	e3:SetLabelObject(e4)
	e4:SetLabelObject(ng)
end
function s.regop(e,tp,eg,ep,ev,re,r,rp)
	local e4=e:GetLabelObject()
	local sg=e4:GetLabelObject()
	local g=eg:Filter(function(c)return c:IsOnField() and not c:IsPreviousLocation(LOCATION_ONFIELD)end,nil)
	for tc in aux.Next(g) do
		tc:RegisterFlagEffect(id,RESET_EVENT+0x1fc0000,0,1)
		sg:AddCard(tc)
	end
end
function s.tdop(e,tp,eg,ep,ev,re,r,rp)
	local sg=e:GetLabelObject()
	local g=sg:Filter(function(c)return c:GetFlagEffect(id)>0 end,nil)
	Duel.SendtoDeck(g,nil,SEQ_DECKSHUFFLE,REASON_RULE)
	e:Reset()
end
function s.descon(e,tp,eg,ep,ev,re,r,rp)
	return tp==Duel.GetTurnPlayer()
end
function s.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ct=c:GetTurnCounter()
	ct=ct+1
	c:SetTurnCounter(ct)
	if ct==7 then
		if Duel.Destroy(c,REASON_EFFECT)~=0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			local g=Duel.SelectMatchingCard(tp,Card.IsAbleToHand,tp,LOCATION_DECK,0,1,114514,nil)
			if g:GetCount()>0 then
				Duel.SendtoHand(g,nil,REASON_EFFECT)
				Duel.ConfirmCards(1-tp,g)
			end
		end
		c:ResetFlagEffect(1082946)
	end
end

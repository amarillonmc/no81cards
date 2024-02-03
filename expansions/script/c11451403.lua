--traveler saga stray
--21.04.10
local cm,m=GetID()
function cm.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
end
cm.traveler_saga=true
function cm.filter(c,sp)
	return c:IsLocation(LOCATION_MZONE) and c:IsControler(sp)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCondition(cm.recon1)
	e1:SetOperation(cm.reop1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetLabel(5,5)
	e2:SetCondition(cm.regcon)
	e2:SetOperation(cm.regop)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e3:SetCode(EVENT_CHAIN_SOLVED)
	e3:SetLabel(0,0)
	e3:SetCondition(cm.recon2)
	e3:SetOperation(cm.reop2)
	e1:SetLabelObject(e2)
	e3:SetLabelObject(e2)
	e2:SetLabelObject(e3)
	if Duel.GetTurnPlayer()==tp then
		e1:SetReset(RESET_PHASE+PHASE_END+RESET_SELF_TURN,2)
		e2:SetReset(RESET_PHASE+PHASE_END+RESET_SELF_TURN,2)
		e3:SetReset(RESET_PHASE+PHASE_END+RESET_SELF_TURN,2)
	else
		e1:SetReset(RESET_PHASE+PHASE_END+RESET_SELF_TURN)
		e2:SetReset(RESET_PHASE+PHASE_END+RESET_SELF_TURN)
		e3:SetReset(RESET_PHASE+PHASE_END+RESET_SELF_TURN)
	end
	Duel.RegisterEffect(e1,tp)
	Duel.RegisterEffect(e2,tp)
	Duel.RegisterEffect(e3,tp)
end
function cm.recon1(e,tp,eg,ep,ev,re,r,rp)
	local g1=eg:Filter(cm.filter,nil,tp)
	local g2=eg:Filter(cm.filter,nil,1-tp)
	local b1,b2=math.min(#g1,1),math.min(#g2,1)
	e:SetLabel(b1,b2)
	return (not re:IsHasType(EFFECT_TYPE_ACTIONS) or re:IsHasType(EFFECT_TYPE_CONTINUOUS)) and (b1>0 or b2>0)
end
function cm.reop1(e,tp,eg,ep,ev,re,r,rp)
	local g1=eg:Filter(cm.filter,nil,tp)
	local c=e:GetOwner()
	local ne=e:GetLabelObject()
	local n1,n2=ne:GetLabel()
	local b1,b2=e:GetLabel()
	if b1>0 and n1>0 then
		local g=Duel.GetMatchingGroup(nil,tp,LOCATION_MZONE+LOCATION_HAND,0,nil)
		g=g:Filter(Card.IsAbleToRemove,nil,tp)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local tg=g:Select(tp,1,1,nil)
		local tc=tg:GetFirst()
		Duel.HintSelection(tg)
		if tc:IsLocation(LOCATION_MZONE) then
			Duel.Hint(HINT_CARD,0,m)
			if Duel.Remove(tc,0,REASON_RULE+REASON_TEMPORARY)>0 and not tc:IsReason(REASON_REDIRECT) then
				n1=n1-1
				local e1=Effect.CreateEffect(e:GetHandler())
				e1:SetDescription(aux.Stringid(m,0))
				e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
				e1:SetCode(EVENT_PHASE+PHASE_END)
				e1:SetReset(RESET_PHASE+PHASE_END)
				e1:SetLabelObject(tc)
				e1:SetCountLimit(1)
				e1:SetOperation(cm.retop1)
				Duel.RegisterEffect(e1,tp)
			end
		elseif tc:IsLocation(LOCATION_HAND) then
			Duel.Hint(HINT_CARD,0,m)
			if Duel.Remove(tc,POS_FACEUP,REASON_RULE)>0 then n1=n1-1 end
			Duel.ShuffleHand(tp)
			local fid=c:GetFieldID()
			tc:RegisterFlagEffect(m+1,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1,fid)
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetDescription(aux.Stringid(m,1))
			e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			e1:SetCode(EVENT_PHASE+PHASE_END)
			e1:SetCountLimit(1)
			e1:SetLabel(fid)
			e1:SetLabelObject(tc)
			e1:SetReset(RESET_PHASE+PHASE_END)
			e1:SetCondition(cm.retcon)
			e1:SetOperation(cm.retop2)
			Duel.RegisterEffect(e1,tp)
		end
	end
	local g2=eg:Filter(cm.filter,nil,1-tp)
	if b2>0 and n2>0 then
		local g=Duel.GetMatchingGroup(nil,1-tp,LOCATION_MZONE+LOCATION_HAND,0,nil)
		g=g:Filter(Card.IsAbleToRemove,nil,1-tp,POS_FACEUP,REASON_RULE)
		Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_REMOVE)
		local tg=g:Select(1-tp,1,1,nil)
		local tc=tg:GetFirst()
		Duel.HintSelection(tg)
		if tc:IsLocation(LOCATION_MZONE) then
			Duel.Hint(HINT_CARD,0,m)
			if Duel.Remove(tc,0,REASON_RULE+REASON_TEMPORARY)>0 and not tc:IsReason(REASON_REDIRECT) then
				n2=n2-1
				local e1=Effect.CreateEffect(e:GetHandler())
				e1:SetDescription(aux.Stringid(m,0))
				e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
				e1:SetCode(EVENT_PHASE+PHASE_END)
				e1:SetReset(RESET_PHASE+PHASE_END)
				e1:SetLabelObject(tc)
				e1:SetCountLimit(1)
				e1:SetOperation(cm.retop1)
				Duel.RegisterEffect(e1,1-tp)
			end
		elseif tc:IsLocation(LOCATION_HAND) then
			Duel.Hint(HINT_CARD,0,m)
			if Duel.Remove(tc,POS_FACEUP,REASON_RULE)>0 then n2=n2-1 end
			Duel.ShuffleHand(1-tp)
			local fid=c:GetFieldID()
			tc:RegisterFlagEffect(m+1,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1,fid)
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetDescription(aux.Stringid(m,1))
			e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			e1:SetCode(EVENT_PHASE+PHASE_END)
			e1:SetCountLimit(1)
			e1:SetLabel(fid)
			e1:SetLabelObject(tc)
			e1:SetReset(RESET_PHASE+PHASE_END)
			e1:SetCondition(cm.retcon)
			e1:SetOperation(cm.retop2)
			Duel.RegisterEffect(e1,1-tp)
		end
	end
	ne:SetLabel(n1,n2)
end
function cm.regcon(e,tp,eg,ep,ev,re,r,rp)
	return re:IsHasType(EFFECT_TYPE_ACTIONS) and not re:IsHasType(EFFECT_TYPE_CONTINUOUS)
end
function cm.regop(e,tp,eg,ep,ev,re,r,rp)
	local g1=eg:Filter(cm.filter,nil,tp)
	local g2=eg:Filter(cm.filter,nil,1-tp)
	local b1,b2=math.min(#g1,1),math.min(#g2,1)
	local a,b=e:GetLabelObject():GetLabel()
	e:GetLabelObject():SetLabel(a+b1,b+b2)
	g1:ForEach(Card.RegisterFlagEffect,m,RESET_EVENT+RESETS_STANDARD,0,1)
	g2:ForEach(Card.RegisterFlagEffect,m,RESET_EVENT+RESETS_STANDARD,0,1)
	Duel.RegisterFlagEffect(tp,m,RESET_CHAIN,0,1)
end
function cm.recon2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(tp,m)>0
end
function cm.flfilter(c)
	return c:GetFlagEffect(m)>0
end
function cm.reop2(e,tp,eg,ep,ev,re,r,rp)
	Duel.ResetFlagEffect(tp,m)
	local a,b=e:GetLabel()
	local c=e:GetOwner()
	local ne=e:GetLabelObject()
	local n1,n2=ne:GetLabel()
	local fg1=Duel.GetMatchingGroup(cm.flfilter,tp,LOCATION_MZONE,0,nil)
	local fg2=Duel.GetMatchingGroup(cm.flfilter,tp,0,LOCATION_MZONE,nil)
	if a>0 and n1>0 then
		local g=Duel.GetMatchingGroup(nil,tp,LOCATION_MZONE+LOCATION_HAND,0,nil)
		g=g:Filter(Card.IsAbleToRemove,nil,tp)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local ct=math.min(a,#g)
		local tg=g:Select(tp,ct,ct,nil)
		Duel.Hint(HINT_CARD,0,m)
		Duel.HintSelection(tg)
		for tc in aux.Next(tg) do
			if tc:IsLocation(LOCATION_MZONE) then
				if Duel.Remove(tc,0,REASON_RULE+REASON_TEMPORARY)>0 then
					n1=n1-1
					local e1=Effect.CreateEffect(e:GetHandler())
					e1:SetDescription(aux.Stringid(m,0))
					e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
					e1:SetCode(EVENT_PHASE+PHASE_END)
					e1:SetReset(RESET_PHASE+PHASE_END)
					e1:SetLabelObject(tc)
					e1:SetCountLimit(1)
					e1:SetOperation(cm.retop1)
					Duel.RegisterEffect(e1,tp)
				end
			elseif tc:IsLocation(LOCATION_HAND) then
				if Duel.Remove(tc,POS_FACEUP,REASON_RULE)>0 then n1=n1-1 end
				Duel.ShuffleHand(tp)
				local fid=c:GetFieldID()
				tc:RegisterFlagEffect(m+1,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1,fid)
				local e1=Effect.CreateEffect(e:GetHandler())
				e1:SetDescription(aux.Stringid(m,1))
				e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
				e1:SetCode(EVENT_PHASE+PHASE_END)
				e1:SetCountLimit(1)
				e1:SetLabel(fid)
				e1:SetLabelObject(tc)
				e1:SetReset(RESET_PHASE+PHASE_END)
				e1:SetCondition(cm.retcon)
				e1:SetOperation(cm.retop2)
				Duel.RegisterEffect(e1,tp)
			end
		end
	end
	if b>0 and n2>0 then
		local g=Duel.GetMatchingGroup(nil,1-tp,LOCATION_MZONE+LOCATION_HAND,0,nil)
		g=g:Filter(Card.IsAbleToRemove,nil,1-tp,POS_FACEUP,REASON_RULE)
		Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_REMOVE)
		local ct=math.min(b,#g)
		local tg=g:Select(1-tp,ct,ct,nil)
		Duel.Hint(HINT_CARD,0,m)
		Duel.HintSelection(tg)
		for tc in aux.Next(tg) do
			if tc:IsLocation(LOCATION_MZONE) then
				if Duel.Remove(tc,0,REASON_RULE+REASON_TEMPORARY)>0 then
					n2=n2-1
					local e1=Effect.CreateEffect(e:GetHandler())
					e1:SetDescription(aux.Stringid(m,0))
					e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
					e1:SetCode(EVENT_PHASE+PHASE_END)
					e1:SetReset(RESET_PHASE+PHASE_END)
					e1:SetLabelObject(tc)
					e1:SetCountLimit(1)
					e1:SetOperation(cm.retop1)
					Duel.RegisterEffect(e1,1-tp)
				end
			elseif tc:IsLocation(LOCATION_HAND) then
				if Duel.Remove(tc,POS_FACEUP,REASON_RULE)>0 then n2=n2-1 end
				Duel.ShuffleHand(1-tp)
				local fid=c:GetFieldID()
				tc:RegisterFlagEffect(m+1,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1,fid)
				local e1=Effect.CreateEffect(e:GetHandler())
				e1:SetDescription(aux.Stringid(m,1))
				e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
				e1:SetCode(EVENT_PHASE+PHASE_END)
				e1:SetCountLimit(1)
				e1:SetLabel(fid)
				e1:SetLabelObject(tc)
				e1:SetReset(RESET_PHASE+PHASE_END)
				e1:SetCondition(cm.retcon)
				e1:SetOperation(cm.retop2)
				Duel.RegisterEffect(e1,1-tp)
			end
		end
	end
	e:SetLabel(0,0)
	ne:SetLabel(n1,n2)
end
function cm.retop1(e,tp,eg,ep,ev,re,r,rp)
	Duel.ReturnToField(e:GetLabelObject())
end
function cm.retcon(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	if tc:GetFlagEffectLabel(m+1)==e:GetLabel() then
		return true
	else
		e:Reset()
		return false
	end
end
function cm.retop2(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	Duel.SendtoHand(tc,nil,REASON_EFFECT)
end
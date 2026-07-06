--幻叙游移
local s,id,o=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local ct=Duel.GetTurnCount()+1
	if chk==0 then return ct<=24 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOZONE)
	local zone=Duel.SelectField(tp,ct,LOCATION_ONFIELD,LOCATION_ONFIELD,0)
	e:SetLabel(zone)
	Duel.Hint(HINT_ZONE,tp,zone)
	Duel.Hint(HINT_ZONE,1-tp,zone<<16)
end
function s.get_zone_bit(c,tp)
	local seq=c:GetSequence()
	if c:IsControler(1-tp) then seq=seq+16 end
	if c:IsLocation(LOCATION_MZONE) then
		return 1<<seq
	elseif c:IsLocation(LOCATION_SZONE) then
		if seq<5 then
			return 1<<(seq+8)
		elseif c:IsLocation(LOCATION_FZONE) then
			return 1<<24
		end
	end
	return 0
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local zone=e:GetLabel()
	local c=e:GetHandler()
	--Effect 1: Banish when opponent's chain starts solving
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_CHAIN_SOLVING)
	e1:SetLabel(zone)
	e1:SetOperation(s.banop)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)  
end
function s.filter(c,zone,tp)
	local b=s.get_zone_bit(c,tp)
	return bit.band(zone,b)~=0 and (c:IsFacedown() or c:IsStatus(STATUS_EFFECT_ENABLED))
end
function s.rffilter(c)
	return c:IsLocation(LOCATION_REMOVED) and not c:IsReason(REASON_REDIRECT)
end
function s.banop(e,tp,eg,ep,ev,re,r,rp)
	if rp==tp then return end
	local c=e:GetHandler()
	local zone=e:GetLabel()
	local sg=e:GetLabelObject()
	--Check cards in the selected zones
	local g=Duel.GetMatchingGroup(s.filter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil,zone,tp)
	if #g>0 and Duel.Remove(g,POS_FACEUP,REASON_EFFECT+REASON_TEMPORARY)~=0 then
		local og=Duel.GetOperatedGroup():Filter(s.rffilter,nil)
		for oc in aux.Next(og) do
			oc:RegisterFlagEffect(m-1,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END-RESET_TURN_SET,0,1,fid)
		end
		og:KeepAlive()
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e2:SetCode(EVENT_CHAIN_SOLVED)
		e2:SetLabelObject(og)
		e2:SetOperation(s.retop)
		e2:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e2,tp)
	end
end
function s.retop(e,tp,eg,ep,ev,re,r,rp)
	local sg=e:GetLabelObject()
	if #sg>0 then
		for tc in aux.Next(sg) do
			s.returntofield(tc)
		end
		sg:Clear()
	end
end
function s.returntofield(tc)
	if tc:GetPreviousTypeOnField()&TYPE_EQUIP>0 or tc:GetFlagEffectLabel(m-1)>m then
		Duel.SendtoGrave(tc,REASON_RULE+REASON_RETURN)
	else
		if tc:IsPreviousLocation(LOCATION_FZONE) then
			local p=tc:GetPreviousControler()
			local gc=Duel.GetFieldCard(p,LOCATION_FZONE,0)
			if gc then
				Duel.SendtoGrave(gc,REASON_RULE)
				Duel.BreakEffect()
			end
			Duel.MoveToField(tc,p,p,LOCATION_FZONE,tc:GetPreviousPosition(),true)
			return
		end
		Duel.ReturnToField(tc)
	end
end
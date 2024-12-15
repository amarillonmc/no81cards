--领域突破
local s,id,o=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(s.condition)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
end
function s.condition(e,tp,eg,ep,ev,re,r,rp)
	local ct1=Duel.GetFieldGroupCount(tp,0,LOCATION_ONFIELD)
	local ct2=Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)
	return ct1>ct2 and Duel.GetCurrentPhase()==PHASE_MAIN1 and not Duel.CheckPhaseActivity()
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetFieldGroup(tp,0,LOCATION_HAND)
	if chk==0 then return g:FilterCount(Card.IsAbleToRemove,nil) end
	if e:IsHasType(EFFECT_TYPE_ACTIVATE) then
		Duel.SetChainLimit(aux.FALSE)
	end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(24,0,aux.Stringid(id,1))
	local g=Duel.GetFieldGroup(1-tp,LOCATION_HAND,0)
		if Duel.Remove(g,POS_FACEUP,REASON_EFFECT+REASON_TEMPORARY)~=0 then
			local og=Duel.GetOperatedGroup()
			local fid=og:GetFirst():GetFieldID()
			for tc in aux.Next(og) do
				tc:RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1,fid)
			end
			og:KeepAlive()
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
			e1:SetCode(EVENT_PHASE+PHASE_END)
			e1:SetCountLimit(1)
			e1:SetLabel(fid)
			e1:SetLabelObject(og)
			e1:SetCondition(s.retcon)
			e1:SetOperation(s.retop)
			e1:SetReset(RESET_PHASE+PHASE_END)
			Duel.RegisterEffect(e1,tp)
	end
end
function s.retfilter(c,fid)
	return c:GetFlagEffectLabel(id)==fid
end
function s.retcon(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetLabelObject()
	if not g:IsExists(s.retfilter,1,nil,e:GetLabel()) then
		g:DeleteGroup()
		e:Reset()
		return false
	else return true end
end
function s.retop(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetLabelObject()
	local sg=g:Filter(s.retfilter,nil,e:GetLabel())
	g:DeleteGroup()
	for tc in aux.Next(sg) do
		Duel.SendtoHand(tc,tc:GetPreviousControler(),REASON_EFFECT)
	end
end
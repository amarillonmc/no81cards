local s,id,o=GetID()
function s.initial_effect(c)
	aux.AddXyzProcedure(c,nil,7,3)
	c:EnableReviveLimit()
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_NEGATE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(s.negcon)
	e1:SetCost(s.negcost)
	e1:SetTarget(s.negtg)
	e1:SetOperation(s.negop)
	c:RegisterEffect(e1)
end
function s.negcon(e,tp,eg,ep,ev,re,r,rp)
	--local loc=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION)bit.band(loc,LOCATION_ONFIELD)~=0
	return Duel.IsChainNegatable(ev) and ((rp==tp and not re:GetHandler():IsCode(id)) or (rp~=tp and e:GetHandler():GetFlagEffect(id)>0))
end
function s.negcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local g=c:GetOverlayGroup()
	if chk==0 then return g:IsExists(Card.IsAbleToRemoveAsCost,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local rc=g:FilterSelect(tp,Card.IsAbleToRemoveAsCost,1,1,nil):GetFirst()
	if Duel.Remove(rc,0,REASON_COST)~=0 then
		if c:GetOverlayCount()==0 then e:SetLabel(1) else e:SetLabel(0) end
		if rc:IsType(TYPE_TOKEN) then return end
		local e1=Effect.CreateEffect(c)
		e1:SetDescription(aux.Stringid(id,1))
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_PHASE+PHASE_END)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetRange(LOCATION_MZONE)
		e1:SetLabelObject(rc)
		e1:SetCountLimit(1)
		e1:SetOperation(s.retop)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e1,true)
		rc:CreateRelation(c,RESET_EVENT+0x1fc0000)
	end
end
function s.negtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
end
function s.negop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateActivation(ev)
	if e:GetLabel()==0 then return end
	local tct=1
	if Duel.GetTurnPlayer()==tp and Duel.GetCurrentPhase()==PHASE_STANDBY then tct=2 end
	e:GetHandler():RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_STANDBY+RESET_SELF_TURN,EFFECT_FLAG_CLIENT_HINT,tct,0,aux.Stringid(id,2))
end
function s.retop(e,tp,eg,ep,ev,re,r,rp)
	local c,rc=e:GetHandler(),e:GetLabelObject()
	if not rc:IsRelateToCard(c) or not rc:IsCanOverlay() then return end
	Duel.Overlay(c,rc)
end

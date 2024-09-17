--traveler saga tribute
--23.02.23
local cm,m=GetID()
function cm.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--activate cost
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_ACTIVATE_COST)
	e2:SetRange(LOCATION_FZONE)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetTargetRange(1,1)
	e2:SetCondition(cm.costcon)
	e2:SetCost(cm.costchk)
	e2:SetTarget(cm.costtg)
	e2:SetOperation(cm.costop)
	c:RegisterEffect(e2)
	--Duel.AddCustomActivityCounter(m,ACTIVITY_CHAIN,cm.chainfilter)
	if not cm.global_check then
		cm.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_CHAINING)
		ge1:SetOperation(cm.checkop)
		Duel.RegisterEffect(ge1,0)
	end
end
cm.traveler_saga=true
function cm.chainfilter(re,tp,cid)
	local loc=re:GetActivateLocation()
	return loc&LOCATION_ONFIELD==0
end
function cm.checkop(e,tp,eg,ep,ev,re,r,rp)
	local loc=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION)
	if bit.band(loc,LOCATION_ONFIELD)~=0 then
		Duel.RegisterFlagEffect(ep,m,RESET_PHASE+PHASE_END,0,1)
	end
end
function cm.costcon(e)
	cm[0]=false
	return true
end
function cm.costchk(e,te,tp)
	return Duel.IsExistingMatchingCard(Card.IsReleasable,tp,LOCATION_MZONE,0,1,nil,REASON_RULE)
end
function cm.costtg(e,te,tp)
	e:SetLabelObject(te)
	--Duel.GetCustomActivityCount(m,tp,ACTIVITY_CHAIN)~=0
	return te:GetHandler() and Duel.GetFlagEffect(tp,m)~=0 and not te:GetHandler():IsOnField() and not te:IsHasType(EFFECT_TYPE_ACTIVATE) --and te:GetActivateLocation()&LOCATION_ONFIELD==0
end
function cm.costop(e,tp,eg,ep,ev,re,r,rp)
	if cm[0] then return end
	local te=e:GetLabelObject()
	Duel.ConfirmCards(1-tp,te:GetHandler())
	Duel.Hint(HINT_CARD,0,m)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local sg=Duel.SelectMatchingCard(1-tp,cm.refilter,tp,LOCATION_MZONE,0,1,1,nil,te)
	if Duel.Release(sg,REASON_COST)>0 then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_CANNOT_INACTIVATE)
		e1:SetValue(cm.efilter)
		e1:SetReset(RESET_CHAIN)
		e1:SetLabel(Duel.GetCurrentChain()+1)
		Duel.RegisterEffect(e1,tp)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_CANNOT_DISEFFECT)
		Duel.RegisterEffect(e2,tp)
	end
	cm[0]=true
end
function cm.efilter(e,ct)
	return e:GetLabel()==ct
end
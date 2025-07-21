function c4875167.initial_effect(c)
	local e1=Effect.CreateEffect(c)
  e3:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	 e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER)
	e1:SetCountLimit(1,4875167)
	e1:SetCost(c4875167.cost)
	e1:SetTarget(c4875167.tg)
	e1:SetOperation(c4875167.operation)
	c:RegisterEffect(e1)
end
function c4875167.spcon(e,tp,eg,ep,ev,re,r,rp)
	return not (Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2)
end
function c4875167.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsDiscardable() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST+REASON_DISCARD)
end
function c4875167.tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return true end
	Duel.Hint(HINT_SELECTMSG,tp,HINGMSG_LVRANK)
	local lv=Duel.AnnounceLevel(tp,1,12)
	e:SetLabel(lv)
end
function c4875167.operation(e,tp,eg,ep,ev,re,r,rp,chk)
	local lv=e:GetLabel()
		local e3=Effect.CreateEffect(e:GetHandler())
		e3:SetType(EFFECT_TYPE_FIELD)
		e3:SetCode(EFFECT_CANNOT_INACTIVATE)
		e3:SetLabel(e:GetLabel())
		e3:SetValue(c4875167.efilter)
		e3:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e3,tp)
		local e5=e3:Clone()
		e5:SetCode(EFFECT_CANNOT_DISEFFECT)
		Duel.RegisterEffect(e5,tp)
end
function c4875167.efilter(e,ct)
local p=e:GetHandlerPlayer()
	local te,tp=Duel.GetChainInfo(ct,CHAININFO_TRIGGERING_EFFECT,CHAININFO_TRIGGERING_PLAYER)
	local tc=te:GetHandler()
	return p==tp and te:IsActiveType(TYPE_MONSTER) and tc:IsLevel(e:GetLabel())
end
function c4875167.effectfilter(e,re,tp)
	local c=re:GetHandler()
	return re:IsActiveType(TYPE_MONSTER) and c:IsLevel(e:GetLabel())
end
function c4875167.filter(c)
	return c:IsType(TYPE_MONSTER) and c:IsLevel(lv)
end
function c4875167.sumcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c4875167.filter,1,nil,lv)
end
function c4875167.sumsuc(e,tp,eg,ep,ev,re,r,rp)
	Duel.SetChainLimitTillChainEnd(c4875167.efun)
end
function c4875167.efun(e,ep,tp)
	return ep==tp
end
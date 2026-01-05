--星之落 银羽
function c62500000.initial_effect(c)
	--limit
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(62500000,0))
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,62500000)
	e1:SetCondition(c62500000.condition)
	e1:SetCost(c62500000.cost)
	e1:SetOperation(c62500000.activate)
	c:RegisterEffect(e1)
end
function c62500000.condition(e,tp,eg,ep,ev,re,r,rp)
	return rp==1-tp
end
function c62500000.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsDiscardable() end
	local code=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_CODE)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CODE)
	local ac=Duel.AnnounceCard(tp,code)
	e:SetLabel(ac)
	Duel.SendtoGrave(e:GetHandler(),REASON_COST+REASON_DISCARD)
end
function c62500000.activate(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(0,1)
	e1:SetValue(c62500000.aclimit)
	e1:SetLabel(e:GetLabel())
	e1:SetReset(RESET_PHASE+PHASE_END,2)
	Duel.RegisterEffect(e1,tp)
end
function c62500000.aclimit(e,re,tp)
	local rc=re:GetHandler()
	return rc:IsOriginalCodeRule(e:GetLabel())
end

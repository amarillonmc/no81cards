--折纸使的守护
function c9910042.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCondition(c9910042.condition)
	e1:SetCost(c9910042.cost)
	e1:SetOperation(c9910042.activate)
	c:RegisterEffect(e1)
	--act in hand
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	c:RegisterEffect(e2)
end
function c9910042.confilter(c)
	return c:IsFaceup() and c:IsSummonLocation(LOCATION_DECK+LOCATION_EXTRA) and c:IsSetCard(0x3950)
end
function c9910042.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c9910042.confilter,tp,LOCATION_MZONE,0,1,nil)
		and rp==1-tp
end
function c9910042.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	if e:GetHandler():IsStatus(STATUS_ACT_FROM_HAND) then
		Duel.PayLPCost(tp,math.floor(Duel.GetLP(tp)/2))
	end
end
function c9910042.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,c)
	local tc=g:GetFirst()
	while tc do
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_IMMUNE_EFFECT)
		e1:SetValue(c9910042.efilter)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_CHAIN)
		tc:RegisterEffect(e1)
		tc=g:GetNext()
	end
	if re:IsHasCategory(CATEGORY_NEGATE)
		and Duel.GetChainInfo(ev-1,CHAININFO_TRIGGERING_EFFECT):IsHasType(EFFECT_TYPE_ACTIVATE) then return false end
	local rc=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):GetFirst()
	local ex,tg,tc=Duel.GetOperationInfo(ev,CATEGORY_DESTROY)
	if ex and tg~=nil and tc+tg:FilterCount(Card.IsOnField,nil)-tg:GetCount()>0
		and rc and rc:IsRelateToEffect(e) and rc:IsControler(1-tp)
		and rc:IsLocation(LOCATION_ONFIELD+LOCATION_HAND) then
		Duel.HintSelection(Group.FromCards(rc))
		Duel.SendtoGrave(rc,REASON_RULE)
	end
end
function c9910042.efilter(e,re)
	return e:GetHandler()~=re:GetOwner() and e:GetOwnerPlayer()~=re:GetOwnerPlayer() and re:IsActivated()
end

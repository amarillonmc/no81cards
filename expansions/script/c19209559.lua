--心象风景 谎言
function c19209559.initial_effect(c)
	aux.AddCodeList(c,19209531)
	--Activate
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	e0:SetCondition(c19209559.condition)
	c:RegisterEffect(e0)
	--effect change
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_BECOME_TARGET)
	e1:SetRange(LOCATION_SZONE)
	e1:SetCountLimit(1,19209559)
	e1:SetCondition(c19209559.chcon)
	e1:SetTarget(c19209559.chtg)
	e1:SetOperation(c19209559.chop)
	c:RegisterEffect(e1)
	--immune
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_IMMUNE_EFFECT)
	e2:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTargetRange(LOCATION_SZONE,0)
	e2:SetValue(c19209559.efilter)
	c:RegisterEffect(e2)
end
function c19209559.chkfilter(c)
	return c:IsCode(19209531) and c:IsFaceup()
end
function c19209559.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c19209559.chkfilter,tp,LOCATION_ONFIELD+LOCATION_REMOVED,0,1,nil)
end
function c19209559.cfilter(c,tp)
	return c:IsControler(tp) and c:IsOnField()
end
function c19209559.chcon(e,tp,eg,ep,ev,re,r,rp)
	if not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return false end
	return rp==1-tp and not eg:IsContains(e:GetHandler()) and eg:IsExists(c19209559.cfilter,1,nil,tp)
end
function c19209559.thfilter(c)
	return c:IsSetCard(0xb51) and not c:IsCode(19209559) and c:IsFaceupEx() and c:IsAbleToHand()
end
function c19209559.chtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c19209559.thfilter,rp,0,LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED,1,nil) end
end
function c19209559.chop(e,tp,eg,ep,ev,re,r,rp)
	local g=Group.CreateGroup()
	--Duel.ChangeTargetCard(ev,g)
	Duel.ChangeChainOperation(ev,c19209559.repop)
end
function c19209559.repop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_ATOHAND)
	local tc=Duel.SelectMatchingCard(1-tp,aux.NecroValleyFilter(c19209559.thfilter),1-tp,LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil):GetFirst()
	if tc then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc)
		local g=Duel.GetTargetsRelateToChain()
		local c=e:GetHandler()
		if c:IsRelateToEffect(e) then g:AddCard(c) end
		if tc:IsLocation(LOCATION_HAND) and #g>0 then
			Duel.BreakEffect()
			Duel.Destroy(g,REASON_EFFECT)
		end
	end
end
function c19209559.efilter(e,te,c)
	if te:GetOwnerPlayer()==e:GetHandlerPlayer() or not te:IsActivated() then return false end
	if not te:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return true end
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	return not g or not g:IsContains(c)
end

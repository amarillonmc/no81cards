--默墟天使·王之号令
function c43990996.initial_effect(c)
	aux.AddCodeList(c,43990999)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c43990996.target)
	e1:SetOperation(c43990996.activate)
	c:RegisterEffect(e1)
	--destroy
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(43990996,2))
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_PLAYER_TARGET)
	e2:SetRange(LOCATION_GRAVE+LOCATION_REMOVED)
	e2:SetCondition(c43990996.descon)
	e2:SetCost(c43990996.descost)
	e2:SetTarget(c43990996.destg)
	e2:SetOperation(c43990996.desop)
	c:RegisterEffect(e2)
end
function c43990996.thfilter(c,chk)
	return c:IsSetCard(0x9510) and not c:IsCode(43990996) and c:IsAbleToHand() and (chk==0 or aux.NecroValleyFilter()(c))
end
function c43990996.cfilter(c)
	return c:IsCode(43990999,43990992) and c:IsFaceup()
end
function c43990996.ctfilter(c)
	return c:IsControlerCanBeChanged() and c:IsFaceup()
end
function c43990996.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local b1=Duel.IsExistingMatchingCard(c43990996.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil,0) and (Duel.GetFlagEffect(tp,43990996)==0 or not e:IsCostChecked())
	local b2=Duel.IsExistingMatchingCard(c43990996.cfilter,tp,LOCATION_ONFIELD,0,1,nil) and Duel.IsExistingMatchingCard(c43990996.ctfilter,tp,0,LOCATION_MZONE,1,nil) and (Duel.GetFlagEffect(tp,43990996-10)==0 or not e:IsCostChecked())
	if chk==0 then return b1 or b2 end
	local op=aux.SelectFromOptions(tp,
		{b1,aux.Stringid(43990996,0)},
		{b2,aux.Stringid(43990996,1)})
	e:SetLabel(op)
	if op==1 then
		if e:IsCostChecked() then
			e:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
			Duel.RegisterFlagEffect(tp,43990996,RESET_PHASE+PHASE_END,0,1)
		end
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED)
	elseif op==2 then
		if e:IsCostChecked() then
			e:SetCategory(CATEGORY_CONTROL)
			Duel.RegisterFlagEffect(tp,43990996-10,RESET_PHASE+PHASE_END,0,1)
		end
	end
	--
	if e:IsCostChecked() then
		local ct=Duel.GetFlagEffectLabel(tp,43990996) or 0
		ct=ct|op
		if ct==op then
			Duel.RegisterFlagEffect(tp,43990996,RESET_PHASE+PHASE_END,0,1,ct)
		else
			Duel.SetFlagEffectLabel(tp,43990996,ct)
		end
		Duel.RaiseEvent(e:GetHandler(),EVENT_CUSTOM+43990999,e,0,tp,0,0)
	end
end
function c43990996.activate(e,tp,eg,ep,ev,re,r,rp)
	local op=e:GetLabel()
	if op==1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local tc=Duel.SelectMatchingCard(tp,c43990996.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil,1):GetFirst()
		if not tc then return end
		--Duel.HintSelection(Group.FromCards(tc))
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc)
	elseif op==2 then
		local ct=math.min(Duel.GetMatchingGroupCount(c43990996.cfilter,tp,LOCATION_ONFIELD,0,nil),(Duel.GetLocationCount(tp,LOCATION_MZONE,tp,LOCATION_REASON_CONTROL)))
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONTROL)
		local g=Duel.SelectMatchingCard(tp,c43990996.ctfilter,tp,0,LOCATION_MZONE,1,ct,nil)
		Duel.HintSelection(g)
		Duel.GetControl(g,tp)
		local og=Duel.GetOperatedGroup()
		for tc in aux.Next(og) do
			Duel.NegateRelatedChain(tc,RESET_TURN_SET)
			local e2=Effect.CreateEffect(e:GetHandler())
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_DISABLE)
			e2:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e2,true)
			local e3=Effect.CreateEffect(e:GetHandler())
			e3:SetType(EFFECT_TYPE_SINGLE)
			e3:SetCode(EFFECT_DISABLE_EFFECT)
			e3:SetValue(RESET_TURN_SET)
			e3:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e3,true)
			local e5=Effect.CreateEffect(e:GetHandler())
			e5:SetType(EFFECT_TYPE_SINGLE)
			e5:SetCode(EFFECT_CHANGE_CODE)
			e5:SetValue(43990992)
			e5:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e5,true)
		end
	end
end
function c43990996.descon(e,tp,eg,ep,ev,re,r,rp)
	return re:GetHandler():IsSetCard(0x9510) and re:IsActiveType(TYPE_MONSTER) and e:GetHandler():GetReasonEffect()~=re
end
function c43990996.descost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToDeckAsCost() end
	Duel.HintSelection(Group.FromCards(e:GetHandler()))
	Duel.SendtoDeck(e:GetHandler(),nil,SEQ_DECKSHUFFLE,REASON_COST)
end
function c43990996.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	if chk==0 then return g:GetCount()>0 end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c43990996.desop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectMatchingCard(tp,aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	if g:GetCount()>0 then
		Duel.HintSelection(g)
		Duel.Destroy(g,REASON_EFFECT)
	end
end

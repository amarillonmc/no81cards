--播火巨人
function c9910624.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkType,TYPE_EFFECT),4)
	c:EnableReviveLimit()
	--negate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DISABLE+CATEGORY_DESTROY+CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_CHAIN_SOLVING)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(c9910624.negcon)
	e1:SetOperation(c9910624.negop)
	c:RegisterEffect(e1)
	--destroy
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCode(EVENT_PHASE+PHASE_BATTLE_START)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCondition(c9910624.descon)
	e2:SetTarget(c9910624.destg)
	e2:SetOperation(c9910624.desop)
	c:RegisterEffect(e2)
end
function c9910624.negcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=tp and rp==1-tp and Duel.IsChainDisablable(ev)
		and e:GetHandler():GetFlagEffect(9910624)<=0
end
function c9910624.negop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rc=re:GetHandler()
	if Duel.GetChainInfo(ev,CHAININFO_DISABLE_REASON) then return end
	if not Duel.SelectYesNo(tp,aux.Stringid(9910624,0)) then return end
	Duel.Hint(HINT_CARD,0,9910624)
	if Duel.NegateEffect(ev) then
		local g1=Duel.GetFieldGroup(tp,0,LOCATION_ONFIELD)
		local g2=Duel.GetFieldGroup(tp,0,LOCATION_HAND)
		local sg=Group.CreateGroup()
		if #g1+#g2>0 and Duel.SelectYesNo(tp,aux.Stringid(9910624,1)) then
			Duel.BreakEffect()
			if #g1>0 and (#g2==0 or Duel.SelectYesNo(tp,aux.Stringid(9910624,2))) then
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
				local sg1=g1:Select(tp,1,1,nil)
				Duel.HintSelection(sg1)
				sg:Merge(sg1)
			end
			if #g2>0 and (#sg==0 or Duel.SelectYesNo(tp,aux.Stringid(9910624,3))) then
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
				local sg2=g2:RandomSelect(tp,1)
				sg:Merge(sg2)
			end
			Duel.Destroy(sg,REASON_EFFECT)
		end
		c:RegisterFlagEffect(9910625,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_PHASE+PHASE_END)
		e1:SetCountLimit(1)
		e1:SetLabelObject(c)
		e1:SetCondition(c9910624.tgcon)
		e1:SetOperation(c9910624.tgop)
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
	end
	c:RegisterFlagEffect(9910624,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e2:SetValue(1)
	e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e3:SetValue(1)
	e3:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_IMMUNE_EFFECT)
	e4:SetValue(c9910624.imfilter)
	e4:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
	c:RegisterEffect(e4)
end
function c9910624.imfilter(e,te)
	return te:GetOwnerPlayer()~=e:GetHandlerPlayer()
end
function c9910624.tgcon(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	if tc:GetFlagEffect(9910625)~=0 then
		return true
	else
		e:Reset()
		return false
	end
end
function c9910624.tgop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	Duel.SendtoGrave(tc,REASON_EFFECT)
end
function c9910624.descon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end
function c9910624.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsOnField() end
	if chk==0 then return Duel.IsExistingTarget(nil,tp,LOCATION_ONFIELD,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g1=Duel.SelectTarget(tp,nil,tp,LOCATION_ONFIELD,0,1,2,nil)
	local g2=Group.CreateGroup()
	for tc in aux.Next(g1) do
		g2:Merge(tc:GetColumnGroup())
	end
	g1:Merge(g2)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g1,g1:GetCount(),0,0)
end
function c9910624.desop(e,tp,eg,ep,ev,re,r,rp)
	local g1=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	local g2=Group.CreateGroup()
	for tc in aux.Next(g1) do
		g2:Merge(tc:GetColumnGroup())
	end
	g1:Merge(g2)
	if g1:GetCount()>0 then
		Duel.Destroy(g1,REASON_EFFECT)
	end
end

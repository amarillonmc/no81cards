--刻刻帝 「七之弹」
function c33400107.initial_effect(c)
	 --Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,33400107+EFFECT_COUNT_CODE_OATH)
	e1:SetLabel(2)
	e1:SetCost(c33400107.cost)
	e1:SetTarget(c33400107.target)
	e1:SetOperation(c33400107.activate)
	c:RegisterEffect(e1)
end
function c33400107.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local ct=e:GetLabel()
	if chk==0 then return Duel.IsCanRemoveCounter(tp,1,0,0x34f,ct,REASON_COST) end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	Duel.RemoveCounter(tp,1,0,0x34f,ct,REASON_COST)
end
function c33400107.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_ONFIELD)   end
	if chk==0 then return Duel.IsExistingTarget(nil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectTarget(tp,nil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,1,0,0)
end
function c33400107.activate(e,tp,eg,ep,ev,re,r,rp)
	 local ac=Duel.GetChainInfo(0,CHAININFO_TARGET_PARAM)
	 local tc=Duel.GetFirstTarget()
	 if  tc:IsRelateToEffect(e) then   
		Duel.SendtoGrave(tc,REASON_EFFECT)
		if Duel.IsExistingMatchingCard(c33400107.filter1,tp,LOCATION_GRAVE,0,3,nil) and Duel.SelectYesNo(tp,aux.Stringid(33400107,0)) then
		local c=e:GetHandler()
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetTargetRange(LOCATION_ONFIELD,LOCATION_ONFIELD)
		e1:SetTarget(c33400107.distg)
		e1:SetLabelObject(tc)
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e2:SetCode(EVENT_CHAIN_SOLVING)
		e2:SetCondition(c33400107.discon)
		e2:SetOperation(c33400107.disop)
		e2:SetLabelObject(tc)
		e2:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e2,tp)
		end
	end
end
function c33400107.filter1(c)
	return c:IsSetCard(0x3341) or c:IsSetCard(0x3340)
end
function c33400107.distg(e,c)
	local tc=e:GetLabelObject()
	return c:IsOriginalCodeRule(tc:GetOriginalCodeRule())
end
function c33400107.discon(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	return re:GetHandler():IsOriginalCodeRule(tc:GetOriginalCodeRule())
end
function c33400107.disop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateEffect(ev)
end

--刻刻帝 「九之弹」
function c33400109.initial_effect(c)
	--confirm
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,33400109+EFFECT_COUNT_CODE_OATH)
	e1:SetLabel(2)
	e1:SetCost(c33400109.cost)
	e1:SetOperation(c33400109.operation)
	c:RegisterEffect(e1)
end
function c33400109.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local ct=e:GetLabel()
	if chk==0 then return Duel.IsCanRemoveCounter(tp,1,0,0x34f,ct,REASON_COST) end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	Duel.RemoveCounter(tp,1,0,0x34f,ct,REASON_COST)
end
function c33400109.operation(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetFieldGroup(tp,0,LOCATION_SZONE+LOCATION_MZONE):Filter(Card.IsFacedown,nil)
	local g1=Duel.GetFieldGroup(tp,0,LOCATION_HAND)
		g1:Merge(g)
		Duel.ConfirmCards(tp,g1)
		Duel.ShuffleHand(1-tp)
	if #g>0 then
	Duel.ConfirmCards(tp,g)
	end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e1:SetCode(EFFECT_CANNOT_TRIGGER)
	e1:SetTargetRange(0,LOCATION_SZONE)
	e1:SetReset(RESET_PHASE+PHASE_END)   
	e1:SetTarget(c33400109.distg)
	e1:SetCondition(c33400109.effcon)
	Duel.RegisterEffect(e1,tp)
		local dg=Duel.GetMatchingGroup(nil,tp,LOCATION_SZONE,LOCATION_SZONE,nil)
		if dg:GetCount()>0 and Duel.GetMatchingGroupCount(c33400109.ss,tp,LOCATION_GRAVE,0,nil)>=3 and Duel.SelectYesNo(tp,aux.Stringid(33400109,0)) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
			local sg1=dg:Select(tp,1,1,nil)
			Duel.HintSelection(sg1)
			Duel.Destroy(sg1,REASON_EFFECT)
		end
   Duel.RegisterFlagEffect(tp,33400101,RESET_EVENT+RESET_PHASE+PHASE_END,0,0)
end
function c33400109.effcon(e)
	return not Duel.IsExistingMatchingCard(Card.IsFacedown,e:GetHandlerPlayer(),LOCATION_SZONE,0,1,nil)
end
function c33400109.distg(e,c)
	return c:IsFacedown()
end
function c33400109.ss(c)
	return c:IsSetCard(0x3341) or c:IsSetCard(0x3340)
end


--虚拟YouTuber 猫宫Hinita II
function c33700372.initial_effect(c)
	--synchro summon
	aux.AddSynchroMixProcedure(c,aux.Tuner(nil),aux.Tuner(nil),nil,aux.NonTuner(nil),1,1)
	c:EnableReviveLimit()  
	--destroy
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(33700372,0))
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_DISABLE)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCost(c33700372.descost)
	e1:SetTarget(c33700372.destg)
	e1:SetOperation(c33700372.desop)
	c:RegisterEffect(e1)  
end
function c33700372.disfilter(c)
	return aux.disfilter1(c)
end
function c33700372.rfilter(c)
	return Duel.IsPlayerCanRelease(c:GetControler(),c)
end
function c33700372.cfilter(c)
	return c:IsLocation(LOCATION_GRAVE) and c:IsPreviousLocation(LOCATION_HAND)
end
function c33700372.descost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(c33700372.disfilter,tp,0,LOCATION_ONFIELD,nil)
	local rg1=Duel.GetReleaseGroup(tp,true)
	local rg2=Duel.GetMatchingGroup(c33700372.rfilter,tp,LOCATION_ONFIELD+LOCATION_HAND,0,rg1)
	rg1:Merge(rg2)
	rg1:RemoveCard(c)
	local ct=math.min(#rg1,#g)
	if chk==0 then return #rg1>=#g and #g>0 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local rg3=rg1:Select(tp,1,ct,nil)
	local ct2=Duel.SendtoGrave(rg3,REASON_COST+REASON_RELEASE)
	e:SetLabel(ct2)
end
function c33700372.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,1,0,0)
end
function c33700372.desop(e,tp,eg,ep,ev,re,r,rp)
	local ct=e:GetLabel()
	local c=e:GetHandler()
	if Duel.GetFieldGroupCount(tp,0,LOCATION_ONFIELD)>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local dg=Duel.SelectMatchingCard(tp,c33700372.disfilter,tp,0,LOCATION_ONFIELD,ct,ct,nil)
		if #dg<=0 then return end
		Duel.HintSelection(dg)
		for tc in aux.Next(dg) do
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_DISABLE)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e1)
			Duel.AdjustInstantly()
			Duel.NegateRelatedChain(tc,RESET_TURN_SET)
		end
		Duel.Destroy(dg,REASON_EFFECT)
	else
		local g=Duel.GetMatchingGroup(Card.IsAbleToGrave,tp,0,LOCATION_DECK+LOCATION_HAND,nil)
		if #g<ct then return end
		Duel.ConfirmCards(tp,g)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local tg=g:Select(tp,ct,ct,nil)
		Duel.SendtoGrave(tg,REASON_EFFECT)
		if tg:IsExists(c33700372.cfilter,1,nil) then
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_FIELD)
			e1:SetCode(EFFECT_SKIP_BP)
			e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
			e1:SetTargetRange(1,1)
			e1:SetLabel(Duel.GetTurnCount())
			e1:SetCondition(function(e3) return Duel.GetTurnCount()==e3:GetLabel() end)
			e1:SetReset(RESET_PHASE+PHASE_END)
			e1:SetReset(RESET_PHASE+PHASE_END)
			Duel.RegisterEffect(e1,tp)
		end
	end
end

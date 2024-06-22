--雪狱之罪证 兽性的吞吐
function c9911386.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,9911386)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetCost(c9911386.cost)
	e1:SetTarget(c9911386.target)
	e1:SetOperation(c9911386.activate)
	c:RegisterEffect(e1)
	--to hand or set
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_LEAVE_GRAVE)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,9911387)
	e2:SetCondition(c9911386.thcon)
	e2:SetCost(c9911386.thcost)
	e2:SetTarget(c9911386.thtg)
	e2:SetOperation(c9911386.thop)
	c:RegisterEffect(e2)
end
function c9911386.cffilter(c)
	return not c:IsPublic()
end
function c9911386.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(c9911386.cffilter,tp,0,LOCATION_HAND,nil)
	if chk==0 then return #g>0 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local tc=g:RandomSelect(tp,1):GetFirst()
	if tc then
		tc:RegisterFlagEffect(9911368,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,66)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_PUBLIC)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
	end
	Duel.AdjustAll()
	Duel.ShuffleHand(1-tp)
end
function c9911386.thfilter(c)
	return c:IsSetCard(0xc956) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c9911386.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9911386.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function c9911386.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c9911386.thfilter),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
	if #g>0 and Duel.SendtoHand(g,nil,REASON_EFFECT)>0 and g:GetFirst():IsLocation(LOCATION_HAND) then
		Duel.ConfirmCards(1-tp,g)
		Duel.ShuffleHand(tp)
		local p=Duel.GetTurnPlayer()
		local g1=Duel.GetMatchingGroup(aux.TRUE,p,LOCATION_HAND+LOCATION_ONFIELD,0,aux.ExceptThisCard(e))
		local g2=Duel.GetMatchingGroup(aux.TRUE,p,0,LOCATION_HAND+LOCATION_ONFIELD,aux.ExceptThisCard(e))
		local tg1=Group.CreateGroup()
		local tg2=Group.CreateGroup()
		if #g1>0 and Duel.SelectYesNo(p,aux.Stringid(9911386,0)) then
			Duel.Hint(HINT_SELECTMSG,p,HINTMSG_DESTROY)
			tg1=g1:Select(p,1,1,nil)
			Duel.HintSelection(tg1)
		end
		if #g2>0 and Duel.SelectYesNo(1-p,aux.Stringid(9911386,0)) then
			Duel.Hint(HINT_SELECTMSG,1-p,HINTMSG_DESTROY)
			tg2=g2:Select(1-p,1,1,nil)
			Duel.HintSelection(tg2)
		end
		tg1:Merge(tg2)
		if #tg1>0 then Duel.Destroy(tg1,REASON_EFFECT) end
		local og=Duel.GetOperatedGroup()
		if not og:IsExists(Card.IsPreviousControler,1,nil,tp) then
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			e1:SetCode(EVENT_CHAIN_SOLVING)
			e1:SetReset(RESET_PHASE+PHASE_END)
			e1:SetCondition(c9911386.discon)
			e1:SetOperation(c9911386.disop)
			e1:SetLabel(tp)
			Duel.RegisterEffect(e1,tp)
			local e2=Effect.CreateEffect(c)
			e2:SetDescription(aux.Stringid(9911386,1))
			e2:SetType(EFFECT_TYPE_FIELD)
			e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CLIENT_HINT)
			e2:SetTargetRange(1,0)
			e2:SetReset(RESET_PHASE+PHASE_END)
			Duel.RegisterEffect(e2,tp)
			e1:SetLabelObject(e2)
		end
		if not og:IsExists(Card.IsPreviousControler,1,nil,1-tp) then
			local e3=Effect.CreateEffect(c)
			e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			e3:SetCode(EVENT_CHAIN_SOLVING)
			e3:SetReset(RESET_PHASE+PHASE_END)
			e3:SetCondition(c9911386.discon)
			e3:SetOperation(c9911386.disop)
			e3:SetLabel(1-tp)
			Duel.RegisterEffect(e3,tp)
			local e4=Effect.CreateEffect(c)
			e4:SetDescription(aux.Stringid(9911386,1))
			e4:SetType(EFFECT_TYPE_FIELD)
			e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CLIENT_HINT)
			e4:SetTargetRange(0,1)
			e4:SetReset(RESET_PHASE+PHASE_END)
			Duel.RegisterEffect(e4,tp)
			e3:SetLabelObject(e4)
		end
	end
	if e:IsHasType(EFFECT_TYPE_ACTIVATE) then
		Duel.RegisterFlagEffect(tp,9911387,RESET_PHASE+PHASE_END,0,1)
	end
end
function c9911386.discon(e,tp,eg,ep,ev,re,r,rp)
	return rp==e:GetLabel() and Duel.GetFlagEffect(e:GetLabel(),9911386)==0
end
function c9911386.disop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,9911386)
	Duel.RegisterFlagEffect(e:GetLabel(),9911386,RESET_PHASE+PHASE_END,0,1)
	Duel.NegateEffect(ev,true)
	e:GetLabelObject():Reset()
	e:Reset()
end
function c9911386.thcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(tp,9911387)==0
end
function c9911386.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsPreviousLocation(LOCATION_HAND+LOCATION_ONFIELD) and c:IsAbleToRemoveAsCost() end
	Duel.Remove(c,POS_FACEUP,REASON_COST)
end
function c9911386.setfilter(c)
	return c:IsType(TYPE_TRAP) and (c:IsAbleToHand() or c:IsSSetable())
end
function c9911386.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9911386.setfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,nil,1,tp,LOCATION_GRAVE)
end
function c9911386.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c9911386.setfilter),tp,LOCATION_GRAVE,0,1,1,nil)
	local tc=g:GetFirst()
	if tc then
		if tc:IsAbleToHand() and (not tc:IsSSetable() or Duel.SelectOption(tp,1190,1153)==0) then
			Duel.SendtoHand(tc,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,tc)
		else
			Duel.SSet(tp,tc)
		end
	end
end

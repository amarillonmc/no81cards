--轨道清理员 寰界星澄号
function c9910667.initial_effect(c)
	c:EnableReviveLimit()
	--xyz summon
	aux.AddXyzProcedureLevelFree(c,c9910667.mfilter,aux.TRUE,2,2)
	--to hand/remove
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(9910667,1))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_REMOVE+CATEGORY_GRAVE_ACTION)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,9910667)
	e1:SetCost(c9910667.thcost)
	e1:SetTarget(c9910667.thtg)
	e1:SetOperation(c9910667.thop)
	c:RegisterEffect(e1)
	if not c9910667.global_check then
		c9910667.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_REMOVE)
		ge1:SetOperation(c9910667.checkop)
		Duel.RegisterEffect(ge1,0)
	end
end
function c9910667.checkop(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	while tc do
		if tc:IsReason(REASON_EFFECT) and re:IsActiveType(TYPE_MONSTER) and re:GetHandler():IsType(TYPE_XYZ)
			and not tc:IsReason(REASON_REDIRECT) then
			tc:RegisterFlagEffect(9910667,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(9910667,3))
		end
		tc=eg:GetNext()
	end
end
function c9910667.mfilter(c,xyzc)
	return c:IsXyzLevel(xyzc,5) or c:IsXyzLevel(xyzc,10)
end
function c9910667.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c9910667.thfilter(c,tp)
	if not c:IsRace(RACE_MACHINE) then return false end
	return c:IsAbleToHand() or c9910667.rmfilter(c,tp)
end
function c9910667.rmfilter(c,tp)
	return c:IsAbleToRemove() and Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD+LOCATION_GRAVE,1,nil)
end
function c9910667.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c9910667.thfilter(chkc,tp) end
	if chk==0 then return Duel.IsExistingTarget(c9910667.thfilter,tp,LOCATION_GRAVE,0,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,c9910667.thfilter,tp,LOCATION_GRAVE,0,1,1,nil,tp)
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,g,1,0,0)
end
function c9910667.disfilter(c)
	return c:IsFaceup() and c:GetFlagEffect(9910667)~=0
end
function c9910667.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and not aux.NecroValleyNegateCheck(tc) and aux.NecroValleyFilter()(tc) then
		if tc:IsAbleToHand() and (not c9910667.rmfilter(tc,tp) or Duel.SelectOption(tp,1190,aux.Stringid(9910667,2))==0) then
			Duel.SendtoHand(tc,nil,REASON_EFFECT)
		elseif c9910667.rmfilter(tc,tp) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
			local g=Duel.SelectMatchingCard(tp,Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD+LOCATION_GRAVE,1,1,nil)
			Duel.HintSelection(g)
			g:AddCard(tc)
			Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
		end
	end
	local sg=Duel.GetMatchingGroup(c9910667.disfilter,tp,LOCATION_REMOVED,LOCATION_REMOVED,nil)
	for sc in aux.Next(sg) do
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetTargetRange(LOCATION_ONFIELD,LOCATION_ONFIELD)
		e1:SetTarget(c9910667.distg)
		e1:SetLabelObject(sc)
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e2:SetCode(EVENT_CHAIN_SOLVING)
		e2:SetCondition(c9910667.discon)
		e2:SetOperation(c9910667.disop)
		e2:SetLabelObject(sc)
		e2:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e2,tp)
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_FIELD)
		e3:SetCode(EFFECT_DISABLE_TRAPMONSTER)
		e3:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
		e3:SetTarget(c9910667.distg)
		e3:SetLabelObject(sc)
		e3:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e3,tp)
	end
end
function c9910667.distg(e,c)
	local tc=e:GetLabelObject()
	return c:IsOriginalCodeRule(tc:GetOriginalCodeRule())
end
function c9910667.discon(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	return re:GetHandler():IsOriginalCodeRule(tc:GetOriginalCodeRule())
end
function c9910667.disop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateEffect(ev)
end

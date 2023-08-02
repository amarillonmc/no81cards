--侵 略  的 终 焉
function c98910021.initial_effect(c)
	--immune
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(98910021,0))
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c98910021.target)
	e1:SetOperation(c98910021.operation)
	c:RegisterEffect(e1)	
   --Activate
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(98910021,1))
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e2:SetTarget(c98910021.target1)
	e2:SetOperation(c98910021.activate1)
	c:RegisterEffect(e2)
end
function c98910021.filter(c)
	return c:IsFaceup() and c:IsSetCard(0xa)
end
function c98910021.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c98910021.filter,tp,LOCATION_MZONE,0,1,nil) end
end
function c98910021.operation(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c98910021.filter,tp,LOCATION_MZONE,0,nil)
	local tc=g:GetFirst()
	while tc do
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e1:SetRange(LOCATION_MZONE)
		e1:SetCode(EFFECT_IMMUNE_EFFECT)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		e1:SetValue(c98910021.efilter)
		tc:RegisterEffect(e1)
		tc=g:GetNext()
	end
end
function c98910021.efilter(e,te)
	return te:GetOwnerPlayer()~=e:GetHandlerPlayer() and te:IsActiveType(TYPE_MONSTER)
end
function c98910021.xyzfilter(c,tp)
	return c:IsFaceup() and c:IsType(TYPE_XYZ) and c:IsSetCard(0xa)
end
function c98910021.matfilter(c)
	return c:IsSummonType(TYPE_SPSUMMON) and c:IsCanOverlay() and c:IsType(TYPE_MONSTER) and c:IsLocation(LOCATION_MZONE)
end
function c98910021.target1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_ONFIELD) and c98910021.xyzfilter(chkc,e,tp) end
	if chk==0 then return Duel.IsExistingTarget(c98910021.xyzfilter,tp,LOCATION_MZONE,0,1,nil,e,tp)
		and Duel.IsExistingTarget(c98910021.matfilter,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g1=Duel.SelectTarget(tp,c98910021.xyzfilter,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(37564025,0))
	local g2=Duel.SelectTarget(tp,c98910021.matfilter,tp,0,LOCATION_MZONE,1,1,nil)
	e:SetLabelObject(g2:GetFirst())
end
function c98910021.activate1(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local tc=g:GetFirst()
	local sc=g:GetNext()
	local ac=e:GetLabelObject()
	if tc==ac then tc=sc end
	if tc:IsFacedown() or not tc:IsRelateToEffect(e)
		or ac:IsImmuneToEffect(e) or not ac:IsRelateToEffect(e) then return end
	if tc:IsType(TYPE_XYZ) then
		local og=ac:GetOverlayGroup()
		if #og>0 then
			Duel.SendtoGrave(og,REASON_RULE)
		end
		Duel.Overlay(tc,Group.FromCards(ac))
	end
end
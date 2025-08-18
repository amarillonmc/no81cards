--98374858
function c98374858.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetHintTiming(0,TIMING_END_PHASE)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_LIMIT_ZONE)
	e1:SetCountLimit(1,98374858)
	e1:SetTarget(c98374858.target)
	e1:SetOperation(c98374858.activate)
	e1:SetValue(c98374858.zones)
	c:RegisterEffect(e1)
	--to deck
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(98374858,1))
	e2:SetCategory(CATEGORY_TODECK)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,98374858+1)
	e2:SetTarget(c98374858.tdtg)
	e2:SetOperation(c98374858.tdop)
	c:RegisterEffect(e2)
end
function c98374858.zones(e,tp,eg,ep,ev,re,r,rp)
	local zone=0xff
	local ft=0
	local p0=Duel.CheckLocation(tp,LOCATION_PZONE,0)
	local p1=Duel.CheckLocation(tp,LOCATION_PZONE,1)
	if p0 then ft=ft+1 end
	if p1 then ft=ft+1 end
	local b=e:IsHasType(EFFECT_TYPE_ACTIVATE) and not e:GetHandler():IsLocation(LOCATION_SZONE)
	local st=Duel.GetLocationCount(tp,LOCATION_SZONE)
	local b1=not b and ft>0
	local b2=b and ft==1 and st-ft>0
	local b3=b and ft==2
	if b1 or b3 then return zone end
	if b2 and p0 then zone=zone-0x1 end
	if b2 and p1 then zone=zone-0x10 end
	return zone
end
function c98374858.pfilter(c)
	return c:IsType(TYPE_PENDULUM) and c:IsFaceup() and not c:IsForbidden()
end
function c98374858.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_PZONE) and chkc:IsControler(tp) and chkc:IsSetCard(0x3af2) end
	if chk==0 then return Duel.IsExistingTarget(Card.IsSetCard,tp,LOCATION_PZONE,0,1,nil,0x3af2) and Duel.IsExistingMatchingCard(c98374858.pfilter,tp,LOCATION_EXTRA,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,Card.IsSetCard,tp,LOCATION_PZONE,0,1,1,nil,0x3af2)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c98374858.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.Destroy(tc,REASON_EFFECT)~=0 and (Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
		local tc=Duel.SelectMatchingCard(tp,c98374858.pfilter,tp,LOCATION_EXTRA,0,1,1,nil):GetFirst()
		if tc then
			Duel.BreakEffect()
			Duel.MoveToField(tc,tp,tp,LOCATION_PZONE,POS_FACEUP,true)
		end
	end
end
function c98374858.tdfilter(c)
	return c:IsSetCard(0x3af2) and c:IsAbleToDeck()
end
function c98374858.tdtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c98374858.tdfilter(chkc)  and chkc~=e:GetHandler() end
	if chk==0 then return Duel.IsExistingTarget(c98374858.tdfilter,tp,LOCATION_GRAVE,0,1,e:GetHandler()) and e:GetHandler():IsAbleToDeck() end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,c98374858.tdfilter,tp,LOCATION_GRAVE,0,1,1,e:GetHandler())
	g:AddCard(e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,g:GetCount(),0,0)
end
function c98374858.tdop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	local c=e:GetHandler()
	if tc:IsRelateToEffect(e) and c:IsRelateToEffect(e) then
		Duel.SendtoDeck(Group.FromCards(tc,c),nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
	end
end

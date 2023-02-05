--火山犰狳蜥
function c98920009.initial_effect(c)
   --to hand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(98920009,0))
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1,98920009)
	e2:SetTarget(c98920009.thtg)
	e2:SetOperation(c98920009.thop)
	c:RegisterEffect(e2)
  --set
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,98930009)	
	e3:SetCondition(c98920009.spcon)
	e3:SetTarget(c98920009.target)
	e3:SetOperation(c98920009.operation)
	c:RegisterEffect(e3)
end
function c98920009.thfilter(c)
	return c:IsAbleToHand() and c:IsSetCard(0x32)
end
function c98920009.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c98920009.thfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c98920009.thfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local sg=Duel.SelectTarget(tp,c98920009.thfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,sg,sg:GetCount(),0,0)
end
function c98920009.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
	end
end
function c98920009.spcon(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	return Duel.GetTurnPlayer()~=tp
		and (ph==PHASE_MAIN1 or (ph>=PHASE_BATTLE_START and ph<=PHASE_BATTLE) or ph==PHASE_MAIN2)
end
function c98920009.pfilter(c,tp)
	return c:IsType(TYPE_CONTINUOUS) and c:IsSetCard(0xb9)
		and not c:IsForbidden() and c:CheckUniqueOnField(tp)
end
function c98920009.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingMatchingCard(c98920009.pfilter,tp,LOCATION_DECK+LOCATION_HAND,0,1,nil,tp) end
end
function c98920009.operation(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local tc=Duel.SelectMatchingCard(tp,c98920009.pfilter,tp,LOCATION_DECK+LOCATION_HAND,0,1,1,nil,tp):GetFirst()
	if tc then Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true) end
end

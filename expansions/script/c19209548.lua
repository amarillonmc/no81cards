--判决：不赦免
function c19209548.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_TODECK)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(2,19209548+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c19209548.target)
	e1:SetOperation(c19209548.activate)
	c:RegisterEffect(e1)
end
function c19209548.cfilter(c)
	return c:IsSetCard(0x3b50) and c:IsType(TYPE_PENDULUM) and c:IsAbleToExtra() and c:IsFaceup()
end
function c19209548.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsControler(tp) and c19209548.cfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c19209548.cfilter,tp,LOCATION_ONFIELD,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,c19209548.cfilter,tp,LOCATION_ONFIELD,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
end
function c19209548.thfilter(c,sc)
	return c:IsSetCard(0xb50) and c:GetCurrentScale()-sc==1 and c:IsAbleToHand()
end
function c19209548.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.SendtoExtraP(tc,nil,REASON_EFFECT)~=0 and tc:IsLocation(LOCATION_EXTRA) and Duel.IsExistingMatchingCard(c19209548.thfilter,tp,LOCATION_DECK,0,1,nil,tc:GetCurrentScale()) and Duel.SelectYesNo(tp,aux.Stringid(19209548,0)) then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local tg=Duel.SelectMatchingCard(tp,c19209548.thfilter,tp,LOCATION_DECK,0,1,1,nil,tc:GetCurrentScale())
		Duel.SendtoHand(tg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tg)
	end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetDescription(1193)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetCountLimit(1)
	e1:SetLabel(Duel.GetTurnCount())
	e1:SetCondition(c19209548.tdcon)
	e1:SetOperation(c19209548.tdop)
	e1:SetReset(RESET_PHASE+PHASE_END,2)
	Duel.RegisterEffect(e1,tp)
	local e0=Effect.CreateEffect(e:GetHandler())
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e0:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e0:SetTargetRange(1,0)
	e0:SetTarget(c19209548.splimit)
	e0:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e0,tp)
end
function c19209548.tdfilter(c)
	return c:IsSetCard(0x3b50) and c:IsFaceup() and c:IsAbleToDeck()
end
function c19209548.tdcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnCount()~=e:GetLabel()
		and Duel.IsExistingMatchingCard(c19209548.tdfilter,tp,LOCATION_EXTRA,0,1,nil)
end
function c19209548.tdop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,c19209548.tdfilter,tp,LOCATION_EXTRA,0,1,1,nil)
	Duel.SendtoDeck(g,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
end
function c19209548.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return not c:IsSetCard(0xb50)
end

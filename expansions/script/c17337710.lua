--合辛的青年使者
function c17337710.initial_effect(c)
	--material redirect-hoshin
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetValue(LOCATION_HAND)
	e0:SetCondition(c17337710.redcon)
	c:RegisterEffect(e0)
	--spsummon-self
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(17337710,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_TO_HAND)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,17337710)
	e1:SetCondition(c17337710.spcon)
	e1:SetTarget(c17337710.sptg)
	e1:SetOperation(c17337710.spop)
	c:RegisterEffect(e1)
	--to hand
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,17337710+1)
	e2:SetCondition(c17337710.icon)
	e2:SetCost(c17337710.thcost)
	--e2:SetTarget(c17337710.thtg)
	e2:SetOperation(c17337710.thop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetHintTiming(TIMING_DAMAGE_STEP,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetCondition(c17337710.qcon)
	c:RegisterEffect(e3)
end
function c17337710.redcon(e)
	local c=e:GetHandler()
	return c:IsOnField() and c:IsReason(REASON_MATERIAL) and c:IsReason(REASON_SYNCHRO)
end
function c17337710.chkfilter(c,tp)
	return c:IsPreviousControler(tp) and c:IsPreviousLocation(LOCATION_ONFIELD) and c:IsPreviousPosition(POS_FACEUP) and c:IsPreviousSetCard(0x3f51)
end
function c17337710.spcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c17337710.chkfilter,1,nil,tp)
end
function c17337710.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetMZoneCount(tp)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c17337710.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToChain() and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0 and Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)>Duel.GetFieldGroupCount(tp,0,LOCATION_HAND) and Duel.IsExistingMatchingCard(Card.IsSetCard,tp,LOCATION_DECK,0,1,nil,0x3f51) and Duel.SelectYesNo(tp,aux.Stringid(17337710,2)) then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(17337710,3))
		local tc=Duel.SelectMatchingCard(tp,Card.IsSetCard,tp,LOCATION_DECK,0,1,1,nil,0x3f51):GetFirst()
		Duel.ShuffleDeck(tp)
		Duel.MoveSequence(tc,SEQ_DECKTOP)
		Duel.ConfirmDecktop(tp,1)
	end
end
function c17337710.icon(e,tp,eg,ep,ev,re,r,rp)
	return not (Duel.IsPlayerAffectedByEffect(tp,17337721)~=nil and e:GetHandler():IsOriginalSetCard(0x3f51))
end
function c17337710.qcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsPlayerAffectedByEffect(tp,17337721)~=nil and e:GetHandler():IsOriginalSetCard(0x3f51)
end
function c17337710.costfilter(c)
	return c:IsSetCard(0x3f51) and c:IsFaceup() and c:IsAbleToHandAsCost()
end
function c17337710.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c17337710.costfilter,tp,LOCATION_ONFIELD,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local tc=Duel.SelectMatchingCard(tp,c17337710.costfilter,tp,LOCATION_ONFIELD,0,1,1,nil):GetFirst()
	Duel.HintSelection(Group.FromCards(tc))
	e:SetLabel(tc:GetCode())
	Duel.SendtoHand(tc,nil,REASON_COST)
end
function c17337710.thop(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e1:SetCountLimit(1)
	e1:SetOperation(c17337710.regop)
	e1:SetLabel(e:GetLabel())
	e1:SetReset(RESET_PHASE+PHASE_STANDBY)
	Duel.RegisterEffect(e1,tp)
end
function c17337710.thfilter(c,code)
	return c:IsSetCard(0x3f51) and not c:IsCode(code) and c:IsAbleToHand()
end
function c17337710.regop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,17337710)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c17337710.thfilter,tp,LOCATION_DECK,0,1,1,nil,e:GetLabel())
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end

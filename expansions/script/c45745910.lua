--极翼灵兽 钢铠鸦
function c45745910.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(45745910,0))
	e1:SetCategory(CATEGORY_DRAW+CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetCountLimit(1,45745910)
	e1:SetTarget(c45745910.target)
	e1:SetOperation(c45745910.operation)
	c:RegisterEffect(e1)

	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(45745910,1))
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_MZONE)
	e3:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
	e3:SetCountLimit(1,45745986)
	e3:SetCondition(c45745910.spcon)
	e3:SetTarget(c45745910.target1)
	e3:SetOperation(c45745910.operation1)
	c:RegisterEffect(e3)

	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND+CATEGORY_HANDES)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCountLimit(1,45745987)
	e3:SetCondition(c45745910.eqcon)
	e3:SetTarget(c45745910.thtg)
	e3:SetOperation(c45745910.thop)
	c:RegisterEffect(e3)
end
--e1
function c45745910.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1)
			and Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,LOCATION_HAND,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_HAND)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c45745910.spfilter(c,e,tp)
	return c:IsSetCard(0x124453450) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_DEFENSE) and not c:IsCode(45745910)
end
function c45745910.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local rc=Duel.SelectMatchingCard(tp,Card.IsAbleToRemove,tp,LOCATION_HAND,0,1,1,nil)
	if #rc>0 and Duel.SendtoGrave(rc,REASON_EFFECT)>0 and Duel.Draw(tp,1,REASON_EFFECT)>0 then
		local g=Duel.GetMatchingGroup(c45745910.spfilter,tp,LOCATION_DECK+LOCATION_HAND,0,nil,e,tp)
		if #g>0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.SelectYesNo(tp,aux.Stringid(45745910,1)) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local sg=g:Select(tp,1,1,nil)
			Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP_DEFENSE)
		end
	end
end
--e2
function c45745910.spcon(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	return ph==PHASE_MAIN1 or ph==PHASE_MAIN2
end
function c45745910.filter4(c)
	return c:IsFaceup() and c:GetLevel()>0 and c:IsSetCard(0x881,0x324) 
end
function c45745910.target1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c45745910.filter4(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c45745910.filter4,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,c45745910.filter4,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	local op=0
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EFFECT)
	if g:GetFirst():IsLevel(1,2) then
		op=Duel.SelectOption(tp,aux.Stringid(45745910,2))
	else
		op=Duel.SelectOption(tp,aux.Stringid(45745910,2),aux.Stringid(45745910,3))
	end
	e:SetLabel(op)
end
function c45745910.operation1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(c)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_LEVEL)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		if e:GetLabel()==0 then
			e1:SetValue(2)
		else
			e1:SetValue(-2)
		end
		tc:RegisterEffect(e1)
	end
	local e2=Effect.CreateEffect(e:GetHandler())
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e2:SetTargetRange(1,0)
	e2:SetTarget(c45745910.splimit)
	e2:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e2,tp)

	local e3=Effect.CreateEffect(e:GetHandler())
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e3:SetTargetRange(1,0)
	e3:SetTarget(c45745910.splimit2)
	e3:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e3,tp)
end
function c45745910.splimit(e,c)
	return c:IsLocation(LOCATION_DECK) and not c:IsSetCard(0x881,0x322)
end
function c45745910.splimit2(e,c)
	return c:IsLocation(LOCATION_EXTRA) and c:IsType(TYPE_LINK) and not c:IsSetCard(0x323) 
end
--e3
function c45745910.eqcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=tp
end
function c45745910.thfilter(c)
	return c:IsSetCard(0x881,0x322) and c:IsAbleToHand()
end
function c45745910.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c45745910.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
	Duel.SetOperationInfo(0,CATEGORY_HANDES,nil,1,tp,1)
end
function c45745910.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c45745910.thfilter),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
	if g:GetCount()>0 and Duel.SendtoHand(g,nil,REASON_EFFECT)~=0 then
		Duel.ConfirmCards(1-tp,g)
		if g:GetFirst():IsLocation(LOCATION_HAND) and Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)>0 then
			Duel.BreakEffect()
			Duel.ShuffleHand(tp)
			Duel.DiscardHand(tp,aux.TRUE,1,1,REASON_EFFECT+REASON_DISCARD,nil)
		end
	end
end
--防火弹丸龙
function c21194010.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetCategory(CATEGORY_SEARCH+CATEGORY_GRAVE_ACTION+CATEGORY_TOHAND)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,21194010)
	e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e1:SetTarget(c21194010.tg)
	e1:SetOperation(c21194010.op)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetOperation(c21194010.op3)
	c:RegisterEffect(e3)
end
function c21194010.q(c)
	return c:IsType(1) and c:IsSetCard(0x102) and c:IsAbleToHand() and not c:IsCode(21194010)
end
function c21194010.w(c,tp)
	return c:IsSetCard(0x10f) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsType(TYPE_CONTINUOUS) and not c:IsForbidden() and c:CheckUniqueOnField(tp) and Duel.GetLocationCount(tp,8)>0
end
function c21194010.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingTarget(Card.IsFaceup,tp,12,12,1,nil) and (Duel.IsExistingMatchingCard(c21194010.q,tp,0x11,0,1,nil) or Duel.IsExistingMatchingCard(c21194010.w,tp,0x11,0,1,nil,tp)) end
	Duel.Hint(3,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,Card.IsFaceup,tp,12,12,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c21194010.op(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	local g1=Duel.GetMatchingGroup(c21194010.q,tp,0x11,0,nil)
	local g2=Duel.GetMatchingGroup(c21194010.w,tp,0x11,0,nil,tp)
	local op=aux.SelectFromOptions(tp,{#g1>0,aux.Stringid(21194010,0),0},{#g2>0,aux.Stringid(21194010,1),1})
	if op==0 then 
		Duel.Hint(3,tp,HINTMSG_ATOHAND)
		local g=g1:Select(tp,1,1,nil)
		if Duel.SendtoHand(g,nil,REASON_EFFECT)>0 and g:GetFirst():IsLocation(2) then
		Duel.ConfirmCards(1-tp,g)
			if tc:IsRelateToEffect(e) then
			Duel.Destroy(tc,REASON_EFFECT)
			end
		end			
	elseif op==1 then
		Duel.Hint(3,tp,HINTMSG_TOFIELD)
		local g=g2:Select(tp,1,1,nil)
		if Duel.MoveToField(g:GetFirst(),tp,tp,8,POS_FACEUP,true) and tc:IsRelateToEffect(e) then
		Duel.Destroy(tc,REASON_EFFECT)
		end
	end	
end
function c21194010.op3(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsReason(REASON_BATTLE+REASON_EFFECT) and c:IsReason(REASON_DESTROY) and c:IsPreviousLocation(LOCATION_ONFIELD) then
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(21194010,3))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetCountLimit(1,21194011)
	e1:SetRange(LOCATION_GRAVE)
	e1:SetTarget(c21194010.tg0)
	e1:SetOperation(c21194010.op0)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
	c:RegisterEffect(e1)
	end
end
function c21194010.e(c,e,tp)
	return c:IsSetCard(0x102) and not c:IsCode(21194010) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c21194010.tg0(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,4)>0 and Duel.IsExistingMatchingCard(c21194010.e,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c21194010.op0(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,4)<=0 then return end
	Duel.Hint(3,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c21194010.e,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	if #g>0 then
	Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
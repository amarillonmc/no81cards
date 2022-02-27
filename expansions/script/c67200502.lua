--海贼的珊海环舰
function c67200502.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,67200502+EFFECT_COUNT_CODE_OATH)
	e1:SetOperation(c67200502.activate)
	c:RegisterEffect(e1)  
	--spsummon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(67200502,1))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e3:SetCode(EVENT_LEAVE_FIELD)
	e3:SetRange(LOCATION_FZONE)
	e3:SetCountLimit(1,67200503)
	e3:SetCondition(c67200502.ctcon)
	e3:SetTarget(c67200502.cttg)
	e3:SetOperation(c67200502.ctop)
	c:RegisterEffect(e3)  
	local e2=e3:Clone()
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCondition(c67200502.ctcon2)
	c:RegisterEffect(e2)
end
function c67200502.thfilter(c)
	return c:IsCode(67200500) and c:IsAbleToHand()
end
function c67200502.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c67200502.thfilter,tp,LOCATION_DECK,0,nil)
	if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(67200502,0)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=g:Select(tp,1,1,nil)
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg)
	end
end
--
function c67200502.cfilter(c,tp,rp)
	return c:IsPreviousPosition(POS_FACEUP) and c:IsPreviousControler(tp) 
		and c:IsPreviousSetCard(0x675) and rp==1-tp and c:IsReason(REASON_EFFECT)
end
function c67200502.ctcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c67200502.cfilter,1,nil,tp,rp) 
end
function c67200502.ctcon2(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c67200502.cfilter,1,nil,tp,rp) and Duel.IsPlayerAffectedByEffect(tp,67200590)
end
function c67200502.ctfilter(c)
	return c:IsFaceup() and c:IsControlerCanBeChanged()
end
function c67200502.cttg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and c67200502.ctfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c67200502.ctfilter,tp,0,LOCATION_MZONE,1,nil) and Duel.GetLocationCount(tp,LOCATION_MZONE)>1
		and Duel.IsPlayerCanSpecialSummonMonster(tp,67200502,0x3675,TYPE_TUNER,0,2400,6,RACE_MACHINE,ATTRIBUTE_WATER) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONTROL)
	local g=Duel.SelectTarget(tp,c67200502.ctfilter,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_CONTROL,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c67200502.ctop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=1 then return end
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.GetControl(tc,tp)~=0 and c:IsRelateToEffect(e) and Duel.IsPlayerCanSpecialSummonMonster(tp,67200502,0x3675,TYPE_TUNER,0,2400,6,RACE_MACHINE,ATTRIBUTE_WATER) then
		c:AddMonsterAttribute(TYPE_NORMAL+TYPE_TUNER)
		Duel.SpecialSummonStep(c,0,tp,tp,true,false,POS_FACEUP)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetRange(LOCATION_MZONE)
		e1:SetAbsoluteRange(tp,1,0)
		e1:SetTarget(c67200502.splimit)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		c:RegisterEffect(e1,true)
		Duel.SpecialSummonComplete()
	end
end
function c67200502.splimit(e,c)
	return not c:IsSetCard(0x675) and c:IsLocation(LOCATION_EXTRA)
end


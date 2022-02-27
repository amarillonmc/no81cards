--阿尔维德的珊海环舰
function c67200522.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,67200522+EFFECT_COUNT_CODE_OATH)
	e1:SetOperation(c67200522.activate)
	c:RegisterEffect(e1)  
	--plunder hand
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(67200522,1))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_LEAVE_FIELD)
	e3:SetRange(LOCATION_FZONE)
	e3:SetCountLimit(1,67200523)
	e3:SetCondition(c67200522.ctcon)
	e3:SetTarget(c67200522.cttg)
	e3:SetOperation(c67200522.ctop)
	c:RegisterEffect(e3)  
	local e2=e3:Clone()
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCondition(c67200522.ctcon2)
	c:RegisterEffect(e2)
end
function c67200522.thfilter(c)
	return c:IsCode(67200520) and c:IsAbleToHand()
end
function c67200522.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c67200522.thfilter,tp,LOCATION_DECK,0,nil)
	if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(67200522,0)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=g:Select(tp,1,1,nil)
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg)
	end
end
--
function c67200522.cfilter(c,tp,rp)
	return c:IsPreviousPosition(POS_FACEUP) and c:IsPreviousControler(tp) 
		and c:IsPreviousSetCard(0x675) and rp==1-tp and c:IsReason(REASON_EFFECT)
end
function c67200522.ctcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c67200522.cfilter,1,nil,tp,rp)
end
function c67200522.ctcon2(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c67200522.cfilter,1,nil,tp,rp) and Duel.IsPlayerAffectedByEffect(tp,67200590)
end
function c67200522.filter(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP,1-tp)
end
function c67200522.cttg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(1-tp) and c67200522.filter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE,tp)>1 and Duel.IsPlayerCanSpecialSummonMonster(tp,67200522,0x3675,TYPE_TUNER,0,2400,6,RACE_MACHINE,ATTRIBUTE_DARK) and Duel.IsExistingTarget(c67200522.filter,tp,0,LOCATION_GRAVE,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c67200522.filter,tp,0,LOCATION_GRAVE,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c67200522.ctop(e,tp,eg,ep,ev,re,r,rp)
	--if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)~=0 and c:IsRelateToEffect(e) and Duel.IsPlayerCanSpecialSummonMonster(tp,67200522,0x3675,TYPE_TUNER,0,2400,6,RACE_MACHINE,ATTRIBUTE_DARK) then
		c:AddMonsterAttribute(TYPE_NORMAL+TYPE_TUNER)
		Duel.SpecialSummonStep(c,0,tp,tp,true,false,POS_FACEUP)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetRange(LOCATION_MZONE)
		e1:SetAbsoluteRange(tp,1,0)
		e1:SetTarget(c67200522.splimit)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		c:RegisterEffect(e1,true)
		Duel.SpecialSummonComplete()
	end
end
function c67200522.splimit(e,c)
	return not c:IsSetCard(0x675) and c:IsLocation(LOCATION_EXTRA)
end




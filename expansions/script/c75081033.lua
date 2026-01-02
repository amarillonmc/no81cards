--黑之牙的『白狼』 罗伊德
function c75081033.initial_effect(c)
	--
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(75081033,0))
	e2:SetCategory(CATEGORY_TOGRAVE+CATEGORY_SPECIAL_SUMMON+CATEGORY_SEARCH+CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_LEAVE_FIELD)
	e2:SetRange(LOCATION_HAND)
	e2:SetCondition(c75081033.thcon)
	e2:SetTarget(c75081033.thtg)
	e2:SetOperation(c75081033.thop)
	--e2:SetLabelObject(e0)
	c:RegisterEffect(e2)
	--
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(75081033,1))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetCountLimit(1,75081033)
	e3:SetTarget(c75081033.tgtg)
	e3:SetOperation(c75081033.tgop)
	c:RegisterEffect(e3)	 
end
function c75081033.thcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c75081033.cfilter1,1,nil,tp) or eg:IsExists(c75081033.cfilter2,1,nil,tp)
end
function c75081033.cfilter1(c,tp)
	return c:IsSetCard(0xa754) and c:IsLocation(LOCATION_HAND+LOCATION_GRAVE) and c:IsPreviousControler(tp) and c:IsPreviousLocation(LOCATION_MZONE)
end
function c75081033.cfilter2(c,tp)
	return c:IsSetCard(0xa754) and c:IsLocation(LOCATION_DECK+LOCATION_REMOVED) and c:IsPreviousControler(tp) and c:IsPreviousLocation(LOCATION_MZONE)
end
function c75081033.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local b1=eg:IsExists(c75081033.cfilter1,1,nil,tp) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
	local b2=eg:IsExists(c75081033.cfilter2,1,nil,tp) and c:IsAbleToGrave() 
	if chk==0 then return b1 or b2 end
	if b1 and b2 and Duel.SelectOption(tp,1152,1191)==0 then
		e:SetLabel(1)
	else
		e:SetLabel(2)
	end
	if b1 then
		e:SetLabel(1)
	end
	if b2 then
		e:SetLabel(2)
	end
end
function c75081033.spfilter(c,e,tp)
	return c:IsSetCard(0xa754) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c75081033.thfilter(c)
	return c:IsSetCard(0xa754) and c:IsAbleToHand() and c:IsType(TYPE_MONSTER) and c:IsFaceupEx()
end
function c75081033.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local label=e:GetLabel()
	if label==1 then
		if Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0 and Duel.IsExistingMatchingCard(c75081033.spfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil,e,tp) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.SelectYesNo(tp,aux.Stringid(75081033,2)) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c75081033.spfilter),tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil,e,tp)
			if g:GetCount()>0 then
				Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
			end
		end
	end
	if label==2 then
		if Duel.SendtoGrave(c,REASON_EFFECT)~=0 and c:IsLocation(LOCATION_GRAVE)  and Duel.IsExistingMatchingCard(c75081033.thfilter,tp,LOCATION_DECK+LOCATION_REMOVED,0,1,nil,e,tp) and Duel.SelectYesNo(tp,aux.Stringid(75081033,3)) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			local tg=Duel.SelectMatchingCard(tp,c75081033.thfilter,tp,LOCATION_DECK+LOCATION_REMOVED,0,1,1,nil)
			if #tg>0 then
				Duel.SendtoHand(tg,nil,REASON_EFFECT)
				Duel.ConfirmCards(1-tp,tg)
			end
		end
	end
end
--
function c75081033.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToHand() end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
end
function c75081033.tgop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SendtoHand(c,nil,REASON_EFFECT)
	end
end
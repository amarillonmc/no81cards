--纳米飞行器 摄界星帆号
function c9910663.initial_effect(c)
	--search
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,9910663)
	e1:SetCost(c9910663.thcost)
	e1:SetTarget(c9910663.thtg)
	e1:SetOperation(c9910663.thop)
	c:RegisterEffect(e1)
	--destroy
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DESTROY+CATEGORY_SPECIAL_SUMMON+CATEGORY_DECKDES)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1,9910664)
	e2:SetTarget(c9910663.destg)
	e2:SetOperation(c9910663.desop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
end
function c9910663.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsDiscardable() end
	Duel.SendtoGrave(c,REASON_COST+REASON_DISCARD)
end
function c9910663.thcfilter(c,tp)
	return c:IsSetCard(0xa952) and Duel.IsExistingMatchingCard(c9910663.thfilter,tp,LOCATION_DECK,0,1,nil,c:GetCode())
end
function c9910663.thfilter(c,code)
	return c:IsSetCard(0xa952) and not c:IsCode(code) and c:IsAbleToHand()
end
function c9910663.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(c9910663.thcfilter,tp,LOCATION_HAND,0,1,nil,tp) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c9910663.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local tc=Duel.SelectMatchingCard(tp,c9910663.thcfilter,tp,LOCATION_HAND,0,1,1,nil,tp):GetFirst()
	if tc then
		Duel.ConfirmCards(1-tp,tc)
		tc:RegisterFlagEffect(0,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,EFFECT_FLAG_CLIENT_HINT,1,0,66)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_PUBLIC)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,c9910663.thfilter,tp,LOCATION_DECK,0,1,1,nil,tc:GetCode())
		if g:GetCount()>0 then
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
		end
	end
end
function c9910663.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsFaceup() and chkc~=c end
	if chk==0 then return Duel.IsExistingTarget(Card.IsFaceup,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,Card.IsFaceup,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c9910663.spfilter(c,e,tp)
	return c:IsFaceupEx() and c:IsRace(RACE_MACHINE) and c:IsAttribute(ATTRIBUTE_LIGHT) and c:IsAttack(0) and c:IsDefense(3000)
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c9910663.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.Destroy(tc,REASON_EFFECT)>0 then
		Duel.AdjustAll()
		local p=tc:GetControler()
		local g=Duel.GetMatchingGroup(c9910663.spfilter,p,LOCATION_DECK+LOCATION_REMOVED,0,nil,e,p)
		if Duel.GetLocationCount(p,LOCATION_MZONE)>0 and #g>0 and Duel.SelectYesNo(p,aux.Stringid(9910663,0)) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,p,HINTMSG_SPSUMMON)
			local sg=g:Select(p,1,1,nil)
			Duel.SpecialSummon(sg,0,p,p,false,false,POS_FACEUP)
		end
	end
end

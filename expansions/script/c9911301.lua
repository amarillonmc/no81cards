--胧之渺翳 武尔坎魔
function c9911301.initial_effect(c)
	local e0=aux.AddThisCardInGraveAlreadyCheck(c)
	--special summon self
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(9911301,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SSET)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,9911301)
	e1:SetCondition(c9911301.spcon)
	e1:SetTarget(c9911301.sptg)
	e1:SetOperation(c9911301.spop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetRange(LOCATION_GRAVE)
	e2:SetLabelObject(e0)
	c:RegisterEffect(e2)
	--search
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(9911301,1))
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_RELEASE+CATEGORY_EQUIP)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EVENT_CHAINING)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCountLimit(1,9911302)
	e3:SetCondition(c9911301.thcon)
	e3:SetTarget(c9911301.thtg)
	e3:SetOperation(c9911301.thop)
	c:RegisterEffect(e3)
end
function c9911301.cfilter(c,se)
	return se==nil or c:GetReasonEffect()~=se
end
function c9911301.spcon(e,tp,eg,ep,ev,re,r,rp)
	local se
	if e:GetLabelObject() then se=e:GetLabelObject():GetLabelObject() end
	return eg:IsExists(c9911301.cfilter,1,nil,se)
end
function c9911301.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c9911301.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)>0 and c:IsSummonLocation(LOCATION_GRAVE) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
		e1:SetValue(LOCATION_REMOVED)
		e1:SetReset(RESET_EVENT+RESETS_REDIRECT)
		c:RegisterEffect(e1,true)
	end
end
function c9911301.thcon(e,tp,eg,ep,ev,re,r,rp)
	return re:IsHasType(EFFECT_TYPE_ACTIVATE) and re:IsActiveType(TYPE_SPELL+TYPE_TRAP)
		and not re:GetHandler():IsStatus(STATUS_ACT_FROM_HAND)
end
function c9911301.thfilter(c)
	return c:IsSetCard(0xa958) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c9911301.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local b1=c:IsReleasableByEffect()
	local b2=Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingMatchingCard(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,1,c)
	if chk==0 then return Duel.IsExistingMatchingCard(c9911301.thfilter,tp,LOCATION_DECK,0,1,nil) and (b1 or b2) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c9911301.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c9911301.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if #g==0 or Duel.SendtoHand(g,nil,REASON_EFFECT)==0 or not g:GetFirst():IsLocation(LOCATION_HAND) then return end
	Duel.ConfirmCards(1-tp,g)
	Duel.ShuffleDeck(tp)
	if not c:IsRelateToEffect(e) then return end
	local b1=c:IsReleasableByEffect()
	local b2=Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and c:IsFaceup()
		and Duel.IsExistingMatchingCard(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,1,c)
	if b1 and (not b2 or Duel.SelectOption(tp,aux.Stringid(9911301,2),aux.Stringid(9911301,3))==0) then
		Duel.BreakEffect()
		Duel.Release(c,REASON_EFFECT)
	elseif b2 then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
		local sg=Duel.SelectMatchingCard(tp,Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,c)
		local tc=sg:GetFirst()
		if tc and Duel.Equip(tp,c,tc) then
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_EQUIP_LIMIT)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			e1:SetValue(c9911301.eqlimit)
			e1:SetLabelObject(tc)
			c:RegisterEffect(e1)
			--atkup
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_EQUIP)
			e2:SetCode(EFFECT_UPDATE_ATTACK)
			e2:SetValue(600)
			e2:SetReset(RESET_EVENT+RESETS_STANDARD)
			c:RegisterEffect(e2)
		end
	end
end
function c9911301.eqlimit(e,c)
	return c==e:GetLabelObject()
end

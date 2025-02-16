--炼金工房流浪术士 安佩尔·沃尔默
function c75011015.initial_effect(c)
	aux.AddCodeList(c,46130346)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,75011015)
	e1:SetCondition(c75011015.spcon)
	e1:SetCost(c75011015.spcost)
	e1:SetTarget(c75011015.sptg)
	e1:SetOperation(c75011015.spop)
	c:RegisterEffect(e1)
	--to hand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(75011015,1))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_DAMAGE)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,75011016)
	e2:SetCondition(c75011015.thcon)
	e2:SetTarget(c75011015.thtg)
	e2:SetOperation(c75011015.thop)
	c:RegisterEffect(e2)
end
function c75011015.chkfilter(c)
	return c:IsSetCard(0x75e) and c:IsFaceup()
end
function c75011015.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c75011015.chkfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c75011015.costfilter(c)
	return c:IsSetCard(0x75e) and c:IsType(TYPE_MONSTER) and c:IsNonAttribute(ATTRIBUTE_WIND) and c:IsAbleToGraveAsCost()
end
function c75011015.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c75011015.costfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c75011015.costfilter,tp,LOCATION_DECK,0,1,1,nil)
	Duel.SendtoGrave(g,REASON_COST)
end
function c75011015.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetMZoneCount(tp)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c75011015.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.GetMZoneCount(tp)>0 then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c75011015.thcon(e,tp,eg,ep,ev,re,r,rp)
	return ep==1-tp and rp==tp
end
function c75011015.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(Card.IsAbleToHand,tp,0,LOCATION_MZONE,nil)
	if chk==0 then return #g>0 end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c75011015.thfilter(c)
	return c:IsCode(46130346) and c:IsAbleToGrave()
end
function c75011015.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=Duel.SelectMatchingCard(tp,Card.IsAbleToHand,tp,0,LOCATION_MZONE,1,1,nil)
	if #g>0 then
		Duel.HintSelection(g)
		if Duel.SendtoHand(g,nil,REASON_EFFECT)==0 or not g:GetFirst():IsLocation(LOCATION_HAND) then return end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local tg=Duel.SelectMatchingCard(tp,c75011015.thfilter,tp,LOCATION_DECK,0,1,1,nil)
		if #tg>0 then
			Duel.BreakEffect()
			Duel.SendtoHand(tg,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,tg)
		end
	end
end

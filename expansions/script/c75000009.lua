--邪龙的救济 贝迩
function c75000009.initial_effect(c)
	aux.AddCodeList(c,75000001)
	--tograve
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_TO_GRAVE)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,75000010)
	e1:SetTarget(c75000009.thtg)
	e1:SetOperation(c75000009.thop)
	c:RegisterEffect(e1)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(75000009,0))
	e2:SetCategory(CATEGORY_TOGRAVE+CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetCountLimit(1,75000009)
	e2:SetTarget(c75000009.tg1)
	e2:SetOperation(c75000009.op1)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
end
-- 1
function c75000009.filter1(c)
	return c:IsSetCard(0x3751) and c:IsType(TYPE_MONSTER) and c:IsAbleToGrave()
end
function c75000009.filter11(c)
	return c:IsFaceup() and (aux.IsCodeListed(c,75000001) or c:IsCode(75000001))
end
function c75000009.filter111(c,e,tp)
	return c:IsSetCard(0x3751) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c75000009.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c75000009.filter1,tp,LOCATION_DECK+LOCATION_EXTRA,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK+LOCATION_EXTRA)
end
function c75000009.op1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c75000009.filter1,tp,LOCATION_DECK+LOCATION_EXTRA,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoGrave(g,REASON_EFFECT)
		if Duel.GetLocationCount(tp,LOCATION_MZONE)>0
			and Duel.IsExistingMatchingCard(c75000009.filter11,tp,LOCATION_MZONE,0,1,nil)
			and Duel.IsExistingMatchingCard(c75000009.filter111,tp,LOCATION_GRAVE,0,1,nil,e,tp)
			and Duel.SelectYesNo(tp,aux.Stringid(75000009,1)) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local sg=Duel.SelectMatchingCard(tp,c75000009.filter111,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
			Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end

function c75000009.thfilter(c)
	return aux.AddCodeList(c,75000001) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToHand()
end
function c75000009.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c75000009.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c75000009.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c75000009.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
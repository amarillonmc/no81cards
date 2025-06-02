--黑之裁判<断罪者>米兰达
function c95101035.initial_effect(c)
	aux.AddCodeList(c,95101001)
	--spsummon-self
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e1:SetCountLimit(1,95101035)
	e1:SetCondition(c95101035.spcon1)
	e1:SetCost(c95101035.spcost)
	e1:SetTarget(c95101035.sptg)
	e1:SetOperation(c95101035.spop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCondition(c95101035.spcon2)
	c:RegisterEffect(e2)
	--spsummon-other
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(95101035,1))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e3:SetCode(EVENT_SUMMON_SUCCESS)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCountLimit(1,95101035+1)
	e3:SetCost(c95101035.spocost)
	e3:SetTarget(c95101035.spotg)
	e3:SetOperation(c95101035.spoop)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e4)
end
function c95101035.spcon1(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsExistingMatchingCard(Card.IsType,tp,0,LOCATION_GRAVE,5,nil,TYPE_MONSTER)
end
function c95101035.spcon2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(Card.IsType,tp,0,LOCATION_GRAVE,5,nil,TYPE_MONSTER)
end
function c95101035.costfilter(c,tp)
	return (aux.IsCodeListed(c,95101001) or c:IsSetCard(0xbbb)) and c:IsFaceup() and Duel.GetMZoneCount(tp,c)>0 and c:IsAbleToHandAsCost()
end
function c95101035.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c95101035.costfilter,tp,LOCATION_ONFIELD,0,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=Duel.SelectMatchingCard(tp,c95101035.costfilter,tp,LOCATION_ONFIELD,0,1,1,nil,tp)
	Duel.SendtoHand(g,nil,REASON_COST)
end
function c95101035.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c95101035.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0 and not c:IsLevel(4) and Duel.SelectYesNo(tp,aux.Stringid(95101035,2)) then
		Duel.BreakEffect()
		local e0=Effect.CreateEffect(c)
		e0:SetType(EFFECT_TYPE_SINGLE)
		e0:SetCode(EFFECT_CHANGE_LEVEL)
		e0:SetValue(4)
		e0:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
		c:RegisterEffect(e0)
	end
end
function c95101035.spocost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDiscardDeckAsCost(1-tp,3) end
	Duel.DiscardDeck(1-tp,3,REASON_COST)
end
function c95101035.spfilter(c,e,tp)
	return (aux.IsCodeListed(c,95101001) or c:IsSetCard(0xbbb)) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c95101035.spotg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetMZoneCount(tp)>0
		and Duel.IsExistingMatchingCard(c95101035.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c95101035.spoop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetMZoneCount(tp)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sc=Duel.SelectMatchingCard(tp,c95101035.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp):GetFirst()
	if sc then
		Duel.SpecialSummon(sc,0,tp,tp,false,false,POS_FACEUP)
	end
end

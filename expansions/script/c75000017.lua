--流风回雪 艾比
function c75000017.initial_effect(c)
	aux.AddCodeList(c,75000001)
	--search
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,75000017)
	e1:SetCost(c75000017.cost)
	e1:SetTarget(c75000017.target)
	e1:SetOperation(c75000017.operation)
	c:RegisterEffect(e1)
-----1
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCategory(CATEGORY_DAMAGE+CATEGORY_SPECIAL_SUMMON+CATEGORY_DECKDES)
	e1:SetCode(EVENT_BE_MATERIAL)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,75000018)
	e1:SetCondition(c75000017.damcon)
	e1:SetTarget(c75000017.damtg)
	e1:SetOperation(c75000017.damop)
	c:RegisterEffect(e1)
-------2
end

function c75000017.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsDiscardable() end
	Duel.SendtoGrave(c,REASON_COST+REASON_DISCARD)
end
function c75000017.filter(c)
	return aux.IsCodeOrListed(c,75000001) and not c:IsCode(75000017) and c:IsAbleToHand()
end
function c75000017.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c75000017.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c75000017.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c75000017.filter,tp,LOCATION_DECK,0,1,1,nil)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end

function c75000017.damcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rc=c:GetReasonCard()
	return c:IsLocation(LOCATION_GRAVE) and  (aux.IsCodeListed(c,75000001) or c:IsCode(75000001)) and r&REASON_FUSION+REASON_LINK~=0
end
function c75000017.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,500)
end
function c75000017.spfilter(c,e,tp)
	return c:IsSetCard(0x120) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_DEFENSE) and not c:IsCode(18236002)
end
function c75000017.damop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c75000017.spfilter,tp,LOCATION_DECK+LOCATION_HAND,0,nil,e,tp)
	if Duel.Damage(1-tp,500,REASON_EFFECT)~=0 and #g>0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.SelectYesNo(tp,aux.Stringid(75000017,0)) then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=g:Select(tp,1,1,nil)
		Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP_DEFENSE)
	end
end
--灰灭都的末裔
function c98920772.initial_effect(c)	
	--search
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(98920772,0))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_HAND)
	e2:SetCountLimit(1,98920772)
	e2:SetCost(c98920772.thcost)
	e2:SetTarget(c98920772.thtg)
	e2:SetOperation(c98920772.thop)
	c:RegisterEffect(e2)
	--spsummon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(98920772,1))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_DESTROYED)
	e3:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCountLimit(1,98930772)
	e3:SetCondition(c98920772.spcon)
	e3:SetTarget(c98920772.sptg)
	e3:SetOperation(c98920772.spop)
	c:RegisterEffect(e3)
end
function c98920772.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsDiscardable() end
	Duel.SendtoGrave(c,REASON_COST+REASON_DISCARD)
end
function c98920772.thfilter(c,check)
	return c:IsAbleToHand()
		and ((check and (c:IsSetCard(0x1ad) and c:IsType(TYPE_MONSTER) or c:IsCode(78783557))) or c:IsCode(3055018))
end
function c98920772.checkfilter(c)
	return c:IsCode(3055018) and c:IsFaceup()
end
function c98920772.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local check=Duel.IsEnvironment(3055018,PLAYER_ALL,LOCATION_FZONE)
		return Duel.IsExistingMatchingCard(c98920772.thfilter,tp,LOCATION_DECK,0,1,nil,check)
	end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c98920772.thop(e,tp,eg,ep,ev,re,r,rp)
	local check=Duel.IsEnvironment(3055018,PLAYER_ALL,LOCATION_FZONE)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c98920772.thfilter,tp,LOCATION_DECK,0,1,1,nil,check)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c98920772.sfilter(c,tp)
	return c:IsPreviousPosition(POS_FACEUP) and c:IsPreviousControler(1-tp)
		and bit.band(c:GetPreviousRaceOnField(),RACE_PYRO)~=0
		and c:IsPreviousLocation(LOCATION_MZONE)
end
function c98920772.spcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c98920772.sfilter,1,nil,tp) and Duel.IsEnvironment(3055018,PLAYER_ALL,LOCATION_FZONE) and not eg:IsContains(e:GetHandler())
end
function c98920772.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c98920772.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
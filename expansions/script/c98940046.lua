--奇迹之暗魔导师
function c98940046.initial_effect(c)
	--change name
	aux.EnableChangeCode(c,46986414,LOCATION_MZONE+LOCATION_GRAVE)
	--search
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_HAND)
	e2:SetCountLimit(1,98940046)
	e2:SetCost(c98940046.thcost)
	e2:SetTarget(c98940046.thtg)
	e2:SetOperation(c98940046.thop)
	c:RegisterEffect(e2)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(98940046,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,98950046)
	e2:SetCondition(c98940046.spcon)
	e2:SetTarget(c98940046.sptg)
	e2:SetOperation(c98940046.spop)
	c:RegisterEffect(e2)
end
function c98940046.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToGraveAsCost() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST)
end
function c98940046.thfilter(c)
	return c:IsLevel(6,7) and c:IsRace(RACE_SPELLCASTER) and c:IsAbleToHand()
end
function c98940046.filter2(c)
	return c:IsFaceup() and not c:IsRace(RACE_SPELLCASTER)
end
function c98940046.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local res=not Duel.IsExistingMatchingCard(c98940046.filter2,tp,LOCATION_MZONE,0,1,nil) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		return Duel.IsExistingMatchingCard(c98940046.thfilter,tp,LOCATION_DECK,0,1,nil,e,tp,res)
	end
end
function c98940046.thop(e,tp,eg,ep,ev,re,r,rp)
	local res=Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and not Duel.IsExistingMatchingCard(c98940046.filter2,tp,LOCATION_MZONE,0,1,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local tc=Duel.SelectMatchingCard(tp,c98940046.thfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp,res):GetFirst()
	if tc then
		if res and tc:IsCanBeSpecialSummoned(e,0,tp,false,false)
			and (not tc:IsAbleToHand() or Duel.SelectOption(tp,1190,1152)==1) then
			Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
		else
			Duel.SendtoHand(tc,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,tc)
		end
	end
end
function c98940046.cfilter(c,tp)
	return c:IsRace(RACE_SPELLCASTER) and (c:IsLevel(6) or c:IsLevel(7)) and c:IsControler(tp)
end
function c98940046.spcon(e,tp,eg,ep,ev,re,r,rp)
	return not eg:IsContains(e:GetHandler()) and eg:IsExists(c98940046.cfilter,1,nil,tp)
end
function c98940046.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c98940046.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
	   Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
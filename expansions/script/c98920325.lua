--空牙团的铁臂 沃德
function c98920325.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,c98920325.mat,1,1)
	c:EnableReviveLimit()
--spsummon
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(98920325,0))
	e5:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCountLimit(1,98920325)
	e5:SetTarget(c98920325.sptg)
	e5:SetOperation(c98920325.spop)
	c:RegisterEffect(e5)
--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(98920325,1))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetHintTiming(0,TIMING_END_PHASE)
	e1:SetCountLimit(1,98920325)
	e1:SetCost(c98920325.cost)
	e1:SetTarget(c98920325.target)
	e1:SetOperation(c98920325.activate)
	c:RegisterEffect(e1)
end
function c98920325.mat(c)
	return c:IsLinkSetCard(0x114) and not c:IsLinkType(TYPE_LINK)
end
function c98920325.spfilter(c,e,tp)
	return not c:IsCode(98920325) and c:IsSetCard(0x114) and c:IsCanBeSpecialSummoned(e,0,tp,true,true)
end
function c98920325.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c98920325.spfilter,tp,0x13,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE)
end
function c98920325.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c98920325.spfilter),tp,0x13,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,true,true,POS_FACEUP)
		g:GetFirst():CompleteProcedure()
	end
	local e2=Effect.CreateEffect(e:GetHandler())
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetTargetRange(1,0)
	e2:SetTarget(c98920325.splimit)
	e2:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e2,tp)
end
function c98920325.splimit(e,c)
	return not c:IsSetCard(0x114) and c:IsLocation(LOCATION_HAND)
end
function c98920325.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsReleasable() end
	Duel.Release(e:GetHandler(),REASON_COST)
end
function c98920325.filter1(c,race)
	return c:IsFaceup() and c:IsRace(race)
end
function c98920325.filter(c)
	return c:IsSetCard(0x114) and c:IsType(TYPE_MONSTER) and not Duel.IsExistingMatchingCard(c98920325.filter1,tp,LOCATION_MZONE,0,1,c,c:GetRace()) and c:IsAbleToHand()
end
function c98920325.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c98920325.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c98920325.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.GetMatchingGroup(c98920325.filter,tp,LOCATION_DECK,0,nil)
	local sg=g:SelectSubGroup(tp,aux.dncheck,false,1,2)
	if sg:GetCount()>0 then
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg)
	end
end
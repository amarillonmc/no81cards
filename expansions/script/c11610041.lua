--光角幻兔 GO！

--光角幻兔卡号
local key=25795273
local s,id,o=GetID()

function s.initial_effect(c)
    aux.AddCodeList(c,25795273)
	--
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DECKDES+CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(s.sptohtg)
	e1:SetOperation(s.sptohop)
	c:RegisterEffect(e1)	
	
end

function s.spfilter(c,e,tp)
    return c:IsCode(25795273) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.tohfilter(c)
    return aux.IsCodeListed(c,25795273) and not c:IsCode(id)
end
function s.sptohtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,1,nil,e,tp) and Duel.IsExistingMatchingCard(s.tohfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE)
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,0,LOCATION_DECK+LOCATION_GRAVE)
end
function s.sptohop(e,tp,eg,ep,ev,re,r,rp)
    local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetTargetRange(1,0)
	e1:SetTarget(s.spelimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local spg=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(s.spfilter),tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,e,tp)
    if not (spg:GetCount()>0 and Duel.SpecialSummon(spg,0,tp,tp,false,false,POS_FACEUP)~=0) then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local tohg=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(s.tohfilter),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
    if not (tohg:GetCount()>0) then return end
    Duel.SendtoHand(tohg,nil,REASON_EFFECT)
    Duel.ConfirmCards(1-tp,tohg)
end
function s.spelimit(e,c)
	return not (c:IsCode(25795273) or aux.IsCodeListed(c,25795273)) and c:IsLocation(LOCATION_GRAVE+LOCATION_DECK)
end

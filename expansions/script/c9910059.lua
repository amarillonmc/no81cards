--月神之都
function c9910059.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--def up
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_UPDATE_DEFENSE)
	e2:SetRange(LOCATION_FZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetTarget(aux.TargetBoolFunction(Card.IsRace,RACE_FAIRY))
	e2:SetValue(1000)
	c:RegisterEffect(e2)
	--spsummon
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_FZONE)
	e3:SetCountLimit(1,9910059)
	e3:SetCost(c9910059.spcost)
	e3:SetTarget(c9910059.sptg)
	e3:SetOperation(c9910059.spop)
	c:RegisterEffect(e3)
end
function c9910059.rfilter(c,e,tp)
	return c:IsRace(RACE_FAIRY) and Duel.IsExistingMatchingCard(c9910059.spfilter,tp,LOCATION_DECK+LOCATION_EXTRA,0,1,nil,e,tp,c)
end
function c9910059.spfilter(c,e,tp,mc)
	return c:IsSetCard(0x9951) and c:IsLevelAbove(4) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_DEFENSE)
		and (c:IsLocation(LOCATION_DECK) and Duel.GetMZoneCount(tp,mc)>0
			or c:IsLocation(LOCATION_EXTRA) and Duel.GetLocationCountFromEx(tp,tp,mc,c)>0)
end
function c9910059.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroupEx(tp,c9910059.rfilter,1,REASON_COST,true,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local g=Duel.SelectReleaseGroupEx(tp,c9910059.rfilter,1,1,REASON_COST,true,nil,e,tp)
	Duel.Release(g,REASON_COST)
end
function c9910059.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK+LOCATION_EXTRA)
end
function c9910059.spop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c9910059.spfilter,tp,LOCATION_DECK+LOCATION_EXTRA,0,1,1,nil,e,tp,nil)
	if #g>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP_DEFENSE)
	end
end

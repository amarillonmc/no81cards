--永恒之心
function c21050000.initial_effect(c)
	c:SetSPSummonOnce(21050000)
   --link summon
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkRace,RACE_MACHINE),2,2)
 --tohand
  --special summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(21050000,2))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,21050000)
	e2:SetTarget(c21050000.sptg1)
	e2:SetOperation(c21050000.spop1)
	c:RegisterEffect(e2)
 --destroy replace
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_DESTROY_REPLACE)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetTarget(c21050000.reptg)
	e2:SetValue(c21050000.repval)
	e2:SetOperation(c21050000.repop)
	c:RegisterEffect(e2)
end

function c21050000.spfilter1(c,e,tp,zone)
	return c:IsType(TYPE_MONSTER) and c:IsRace(RACE_MACHINE) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP,tp,zone)
end
function c21050000.sptg1(e,tp,eg,ep,ev,re,r,rp,chk)
	local zone=e:GetHandler():GetLinkedZone(tp)
	if chk==0 then return Duel.IsExistingMatchingCard(c21050000.spfilter1,tp,LOCATION_HAND,0,1,nil,e,tp,zone) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function c21050000.spop1(e,tp,eg,ep,ev,re,r,rp)
	local zone=e:GetHandler():GetLinkedZone(tp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE,tp,LOCATION_REASON_TOFIELD,zone)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c21050000.spfilter1,tp,LOCATION_HAND,0,1,1,nil,e,tp,zone)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP,zone)
	end
end
function c21050000.filter(c,tp)
	return c:IsControler(tp) and c:IsLocation(LOCATION_MZONE)
		and c:IsReason(REASON_BATTLE) and not c:IsReason(REASON_REPLACE)
end
function c21050000.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return eg:IsExists(c21050000.filter,1,nil,tp) and e:GetHandler():IsAbleToRemove() end
	return Duel.SelectEffectYesNo(tp,e:GetHandler(),96)
end
function c21050000.repval(e,c)
	return c21050000.filter(c,e:GetHandlerPlayer())
end
function c21050000.repop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_EFFECT+REASON_REPLACE)
end

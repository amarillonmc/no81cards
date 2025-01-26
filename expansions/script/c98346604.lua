--林中的女儿
local s,id,o=GetID()
function s.initial_effect(c)
	--self special summon1
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(98346604,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e1:SetCountLimit(1,id)
	e1:SetHintTiming(0,TIMING_END_PHASE)
	e1:SetCost(c98346604.sspcost1)
	e1:SetTarget(c98346604.ssptg)
	e1:SetOperation(c98346604.sspop)
	c:RegisterEffect(e1)
	--self special summon2
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(98346604,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e2:SetCountLimit(1,id)
	e2:SetHintTiming(0,TIMING_END_PHASE)
	e2:SetCost(c98346604.sspcost2)
	e2:SetTarget(c98346604.ssptg)
	e2:SetOperation(c98346604.sspop)
	c:RegisterEffect(e2)
	--special summon from deck
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(98346604,2))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DECKDES)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_BATTLE_DESTROYING)
	e3:SetCountLimit(1,id)
	e3:SetCondition(aux.bdogcon)
	e3:SetTarget(c98346604.spdtg)
	e3:SetOperation(c98346604.spdop)
	c:RegisterEffect(e3)
end
function c98346604.c1filter(c)
	return c:IsSetCard(0xaf7) and c:IsAbleToRemoveAsCost() and not c:IsCode(98346604)
end
function c98346604.sspcost1(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(c98346604.c1filter,tp,LOCATION_DECK+LOCATION_GRAVE,0,nil)
	if chk==0 then return g:GetCount()>1 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local tg=g:Select(tp,2,2,nil)
	Duel.Remove(tg,POS_FACEDOWN,REASON_COST)
end
function c98346604.c2filter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToGraveAsCost()
end
function c98346604.sspcost2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c98346604.c2filter,tp,LOCATION_ONFIELD,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c98346604.c2filter,tp,LOCATION_ONFIELD,0,1,1,nil)
	Duel.SendtoGrave(g,REASON_COST)
end
function c98346604.ssptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c98346604.sspop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c98346604.spdfilter(c,e,tp)
	return c:IsType(TYPE_TUNER) and c:IsSetCard(0xaf7) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c98346604.spdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c98346604.spdfilter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c98346604.spdop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c98346604.spdfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end

--布洛妮娅·异度黑核侵蚀
function c9951198.initial_effect(c)
	 --synchro summon
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(nil),1)
	c:EnableReviveLimit()
  --special summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(9951198,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCost(c9951198.spcost)
	e2:SetTarget(c9951198.sptg)
	e2:SetOperation(c9951198.spop)
	c:RegisterEffect(e2)
 --to grave1
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(9951198,1))
	e2:SetCategory(CATEGORY_TOGRAVE)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,9951198)
	e2:SetCost(c9951198.tgcost1)
	e2:SetTarget(c9951198.tgtg1)
	e2:SetOperation(c9951198.tgop1)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetDescription(aux.Stringid(9951198,2))
	e3:SetCategory(CATEGORY_TOGRAVE)
	e3:SetCost(c9951198.tgcost2)
	e3:SetTarget(c9951198.tgtg2)
	e3:SetOperation(c9951198.tgop2)
	c:RegisterEffect(e3)
	--spsummon bgm
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e8:SetCode(EVENT_SPSUMMON_SUCCESS)
	e8:SetOperation(c9951198.sumsuc)
	c:RegisterEffect(e8)
	local e9=e8:Clone()
	e9:SetCode(EVENT_SUMMON_SUCCESS)
	c:RegisterEffect(e9)
end
function c9951198.sumsuc(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_MUSIC,0,aux.Stringid(9951198,0))
   Duel.Hint(HINT_SOUND,0,aux.Stringid(9951198,3))
end
function c9951198.filter(c,e,tp)
	return c:IsCode(9951194,9951197) and c:IsCanBeSpecialSummoned(e,0,tp,true,false)
end
function c9951198.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost()
		and Duel.CheckReleaseGroup(tp,nil,1,nil) end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
	local g=Duel.SelectReleaseGroup(tp,nil,1,1,nil)
	Duel.Release(g,REASON_COST)
end
function c9951198.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>-1
		and Duel.IsExistingMatchingCard(c9951198.filter,tp,LOCATION_HAND,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function c9951198.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c9951198.filter,tp,LOCATION_HAND,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,true,false,POS_FACEUP)
	end
   Duel.Hint(HINT_SOUND,0,aux.Stringid(9951198,4))
end
function c9951198.tgcost1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil) end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	local g=Duel.SelectMatchingCard(tp,Card.IsDiscardable,tp,LOCATION_HAND,0,1,1,nil)
	Duel.SendtoGrave(g,REASON_COST+REASON_DISCARD)
end
function c9951198.filter1(c)
	return c:IsRace(RACE_FAIRY) and c:IsAbleToGrave()
end
function c9951198.tgtg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9951198.filter1,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function c9951198.tgop1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c9951198.filter1,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoGrave(g,REASON_EFFECT)
	end
   Duel.Hint(HINT_SOUND,0,aux.Stringid(9951198,4))
end
function c9951198.tgcost2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToGraveAsCost() end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	Duel.SendtoGrave(e:GetHandler(),REASON_COST)
end
function c9951198.filter2(c)
	return c:IsRace(RACE_FAIRY) and c:IsType(TYPE_MONSTER) and c:IsAbleToGrave()
end
function c9951198.exfilter(c)
	return c:GetSummonLocation()==LOCATION_EXTRA
end
function c9951198.tgtg2(e,tp,eg,ep,ev,re,r,rp,chk)
	local ct=Duel.GetMatchingGroupCount(c9951198.exfilter,tp,0,LOCATION_MZONE,nil)
	local g=Duel.GetMatchingGroup(c9951198.filter2,tp,LOCATION_HAND+LOCATION_DECK,0,nil)
	if chk==0 then return ct>0 and g:GetCount()>0 end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_HAND+LOCATION_DECK)
end
function c9951198.tgop2(e,tp,eg,ep,ev,re,r,rp)
	local ct=Duel.GetMatchingGroupCount(c9951198.exfilter,tp,0,LOCATION_MZONE,nil)
	if ct<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.GetMatchingGroup(c9951198.filter2,tp,LOCATION_HAND+LOCATION_DECK,0,nil)
	aux.GCheckAdditional=aux.dncheck
	local sg=g:SelectSubGroup(tp,aux.TRUE,false,1,ct)
	aux.GCheckAdditional=nil
	if sg:GetCount()>0 then
		Duel.SendtoGrave(sg,REASON_EFFECT)
	end
   Duel.Hint(HINT_SOUND,0,aux.Stringid(9951198,4))
end

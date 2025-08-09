--进化龙·活堡龙
function c98920369.initial_effect(c)
	 --special summon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TODECK+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,98920369)
	e1:SetCost(c98920369.spcost)
	e1:SetTarget(c98920369.sptg)
	e1:SetOperation(c98920369.spop)
	c:RegisterEffect(e1)
--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(98920369,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(aux.evospcon)
	e1:SetCountLimit(1,98930369)
	e1:SetCost(c98920369.spcost1)
	e1:SetTarget(c98920369.sptg1)
	e1:SetOperation(c98920369.spop1)
	c:RegisterEffect(e1)
end
function c98920369.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not e:GetHandler():IsPublic() end
end
function c98920369.spfilter(c,e,tp)
	return c:IsSetCard(0x304e) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c98920369.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)>0
		and Duel.IsExistingMatchingCard(c98920369.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,e:GetHandler(),1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c98920369.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SendtoDeck(c,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)>0 and c:IsLocation(LOCATION_DECK) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,c98920369.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
		if g:GetCount()>0 then
			Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end
function c98920369.cfilter1(c,tp)
	return c:IsRace(RACE_REPTILE) and Duel.GetMZoneCount(tp,c)>=1
end
function c98920369.spcost1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroupEx(tp,c98920369.cfilter1,1,REASON_COST,true,nil,tp) end
	local g=Duel.SelectReleaseGroupEx(tp,c98920369.cfilter1,1,1,REASON_COST,true,nil,tp)
	Duel.Release(g,REASON_COST)
end
function c98920369.filter(c,e,tp)
	return c:IsSetCard(0x504e) and c:IsType(TYPE_XYZ)
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c98920369.sptg1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c98920369.filter,tp,LOCATION_EXTRA,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c98920369.matfilter(c,e)
	return c:IsAttribute(ATTRIBUTE_FIRE) and c:IsType(TYPE_MONSTER) and c:IsCanOverlay() and (not e or not c:IsImmuneToEffect(e))
end
function c98920369.spop1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c98920369.filter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
		local tc=g:GetFirst()
		if Duel.SelectYesNo(tp,aux.Stringid(98920369,1)) then
		  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
		  local sg=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c98920369.matfilter),tp,LOCATION_HAND+LOCATION_GRAVE+LOCATION_MZONE,0,1,2,tc,e)
		  if sg:GetCount()>0 then
			  Duel.Overlay(tc,sg)
		  end
	   end
	end
end
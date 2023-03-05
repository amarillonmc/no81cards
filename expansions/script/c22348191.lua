--遥 远 之 民 到 达 的 旅 人
local m=22348191
local cm=_G["c"..m]
function cm.initial_effect(c)
	--xyz summon
	c:EnableReviveLimit()
	aux.AddXyzProcedure(c,nil,4,2,nil,nil,99)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetDescription(aux.Stringid(22348191,0))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetCountLimit(1,22348191)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(c22348191.spcon1)
	e1:SetCost(c22348191.spcost)
	e1:SetTarget(c22348191.sptg)
	e1:SetOperation(c22348191.spop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCondition(c22348191.spcon2)
	c:RegisterEffect(e2)
	
end
function c22348191.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c22348191.spcon1(e,tp,eg,ep,ev,re,r,rp)
	return aux.MZoneSequence(e:GetHandler():GetSequence())<4
end
function c22348191.spcon2(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSequence()==4
end
function c22348191.spfilter(c,e,tp)
	return c:IsSetCard(0x706) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c22348191.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c22348191.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c22348191.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c22348191.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	local tc=g:GetFirst()
	if tc and Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)~=0 then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetDescription(aux.Stringid(22348191,1))
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
		e1:SetCode(EFFECT_CANNOT_TRIGGER)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
	end
	Duel.SpecialSummonComplete()
end



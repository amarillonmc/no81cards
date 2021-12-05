--星宫觉醒
function c79520002.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_END_PHASE)
	e1:SetCountLimit(1,79520002)
	e1:SetCost(c79520002.cost)
	e1:SetTarget(c79520002.target)
	e1:SetOperation(c79520002.activate)
	c:RegisterEffect(e1)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(79520002,2))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetCountLimit(1,19520002)
	e2:SetCondition(c79520002.spcon)
	e2:SetTarget(c79520002.sptg)
	e2:SetOperation(c79520002.spop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_TO_HAND)
	c:RegisterEffect(e3)
end
c79520002.named_with_Constellation=true 
function c79520002.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(1)
	return true
end
function c79520002.filter1(c,e,tp)
	return c.named_with_Constellation and Duel.GetMZoneCount(tp,c)>0
		and Duel.IsExistingMatchingCard(c79520002.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,c:GetCode()) and c:IsAbleToGraveAsCost()
end
function c79520002.filter2(c,e,tp,tcode)
	return c.named_with_Constellation and c.assault_name==tcode and c:IsCanBeSpecialSummoned(e,0,tp,true,false)
end
function c79520002.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		if e:GetLabel()~=1 then return false end
		e:SetLabel(0)
		return Duel.IsExistingMatchingCard(c79520002.filter1,tp,LOCATION_MZONE,0,1,nil,e,tp)
	end
	local rg=Duel.SelectMatchingCard(tp,c79520002.filter1,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
	e:SetLabel(rg:GetFirst():GetCode())
	e:SetLabelObject(rg:GetFirst())
	Duel.SendtoGrave(rg,REASON_COST)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c79520002.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tc=Duel.SelectMatchingCard(tp,c79520002.filter2,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,e:GetLabel()):GetFirst()
	if tc and Duel.SpecialSummon(tc,0,tp,tp,true,false,POS_FACEUP_ATTACK)>0 then 
	if tc:IsType(TYPE_XYZ) then 
	Duel.Overlay(tc,e:GetLabelObject())
	end
		tc:CompleteProcedure()
	end
end
function c79520002.spcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousLocation(LOCATION_DECK) and c:IsReason(REASON_REVEAL)
end
function c79520002.filter(c,e,tp)
	return c.named_with_Constellation and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c79520002.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c79520002.filter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c79520002.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c79520002.filter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end







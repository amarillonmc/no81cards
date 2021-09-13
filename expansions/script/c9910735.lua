--远古造物 致命刃齿虎
require("expansions/script/c9910700")
function c9910735.initial_effect(c)
	--special summon
	Ygzw.AddSpProcedure(c,3)
	c:EnableReviveLimit()
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_ATKCHANGE)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,9910735)
	e1:SetCost(c9910735.spcost)
	e1:SetTarget(c9910735.sptg)
	e1:SetOperation(c9910735.spop)
	c:RegisterEffect(e1)
	Duel.AddCustomActivityCounter(9910735,ACTIVITY_SPSUMMON,c9910735.counterfilter)
end
function c9910735.counterfilter(c)
	return c:IsSetCard(0xc950)
end
function c9910735.costfilter(c)
	return c:IsSetCard(0xc950) and c:IsAbleToRemoveAsCost()
end
function c9910735.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetCustomActivityCount(9910735,tp,ACTIVITY_SPSUMMON)==0
		and Duel.IsExistingMatchingCard(c9910735.costfilter,tp,LOCATION_GRAVE,0,2,nil) end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c9910735.splimit)
	Duel.RegisterEffect(e1,tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c9910735.costfilter,tp,LOCATION_GRAVE,0,2,2,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c9910735.splimit(e,c)
	return not c:IsSetCard(0xc950)
end
function c9910735.spfilter(c,e,tp)
	return c:IsSetCard(0xc950) and c:IsLevelBelow(7) and c:IsCanBeSpecialSummoned(e,0,tp,true,false)
end
function c9910735.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not Duel.IsPlayerAffectedByEffect(tp,59822133)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>1
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,true,false)
		and Duel.IsExistingMatchingCard(c9910735.spfilter,tp,LOCATION_HAND,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,2,tp,LOCATION_HAND)
end
function c9910735.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetTargetRange(0,LOCATION_MZONE)
	e1:SetValue(-1000)
	e1:SetReset(RESET_PHASE+PHASE_END,2)
	Duel.RegisterEffect(e1,tp)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_UPDATE_DEFENSE)
	Duel.RegisterEffect(e2,tp)
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then return end
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<2 or not c:IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c9910735.spfilter,tp,LOCATION_HAND,0,1,1,nil,e,tp)
	if g:GetCount()==0 then return end
	g:AddCard(c)
	Duel.SpecialSummon(g,0,tp,tp,true,false,POS_FACEUP)
end

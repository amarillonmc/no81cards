--魔偶甜点·芭菲杯猫咪
function c19198170.initial_effect(c)
--link summon
	aux.AddLinkProcedure(c,c19198170.linkfilter,1,1)
	c:EnableReviveLimit() 
--once
	c:SetSPSummonOnce(19198170) 
--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(19198170,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetCountLimit(1)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTarget(c19198170.sumtg)
	e1:SetOperation(c19198170.sumop)
	c:RegisterEffect(e1)  
end
function c19198170.linkfilter(c)
	return c:IsLevelBelow(4) and c:IsSetCard(0x71)
end
--summon
function c19198170.mfilter(c,e,tp)
	return c:IsSetCard(0x71) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
	   
end
function c19198170.sumtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c19198170.mfilter,tp,LOCATION_HAND,0,1,nil,e,tp) and Duel.GetLocationCount(tp,0x04)>0 end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
function c19198170.sumop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c19198170.mfilter,tp,LOCATION_HAND,0,1,1,nil,e,tp)
	local tc=g:GetFirst()
	if tc then
	   Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
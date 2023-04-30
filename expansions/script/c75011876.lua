--气场破坏者-基格尔德10%
function c75011876.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,nil,1,2,nil,nil,99)
	c:EnableReviveLimit() 
	--spsummon
	local e1=Effect.CreateEffect(c) 
	e1:SetDescription(aux.Stringid(75011876,1))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCost(function(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,2,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,2,2,REASON_COST) end)
	e1:SetTarget(c75011876.sptg)
	e1:SetOperation(c75011876.spop)
	c:RegisterEffect(e1) 
	--spsummon
	local e2=Effect.CreateEffect(c) 
	e2:SetDescription(aux.Stringid(75011876,2))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,75011876)
	e2:SetCost(c75011876.rspcost)
	e2:SetTarget(c75011876.rsptg)
	e2:SetOperation(c75011876.rspop)
	c:RegisterEffect(e2)  
end 
c75011876.SetCard_TT_JGRD=true   
function c75011876.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,75011877,nil,TYPES_TOKEN_MONSTER,0,0,1,RACE_DRAGON,ATTRIBUTE_EARTH) end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0) 
end
function c75011876.spop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,75011877,nil,TYPES_TOKEN_MONSTER,0,0,1,RACE_DRAGON,ATTRIBUTE_EARTH) then
		local token=Duel.CreateToken(tp,75011877)
		Duel.SpecialSummon(token,0,tp,tp,false,false,POS_FACEUP) 
	end
end
function c75011876.rspcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsReleasable() end
	Duel.Release(e:GetHandler(),REASON_COST) 
end
function c75011876.rspfilter(c,e,tp)
	return c:IsRace(RACE_DRAGON) and c:IsAttribute(ATTRIBUTE_EARTH) and not c:IsType(TYPE_XYZ) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c75011876.rsptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetMZoneCount(tp,c)>0 and Duel.IsExistingMatchingCard(c75011876.rspfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end
function c75011876.rspop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler() 
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c75011876.rspfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end






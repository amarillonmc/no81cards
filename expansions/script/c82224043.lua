local m=82224043
local cm=_G["c"..m]
cm.name="凛锋剑豪"
function cm.initial_effect(c)
	--link summon  
	aux.AddLinkProcedure(c,nil,2,2,cm.lcheck)
	c:EnableReviveLimit()  
	--special summon  
	local e1=Effect.CreateEffect(c)  
	e1:SetDescription(aux.Stringid(m,0))  
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)  
	e1:SetType(EFFECT_TYPE_IGNITION)  
	e1:SetRange(LOCATION_MZONE)  
	e1:SetCountLimit(1,m)  
	e1:SetTarget(cm.target)  
	e1:SetOperation(cm.operation)  
	c:RegisterEffect(e1)  
end  
function cm.lcheck(g,lc)  
	return g:GetClassCount(Card.GetLinkCode)==g:GetCount()  
end  
function cm.filter(c,e,tp,zone)  
	return c:IsLevelBelow(4) and (c:IsRace(RACE_WARRIOR) or c:IsAttribute(ATTRIBUTE_WATER)) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP,tp,zone)  
end  
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then  
		local zone=e:GetHandler():GetLinkedZone(tp)  
		return zone~=0 and Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_HAND,0,1,nil,e,tp,zone)  
	end  
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)  
end  
function cm.operation(e,tp,eg,ep,ev,re,r,rp)  
	local zone=e:GetHandler():GetLinkedZone(tp)  
	if zone==0 then return end  
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)  
	local g=Duel.SelectMatchingCard(tp,cm.filter,tp,LOCATION_HAND,0,1,1,nil,e,tp,zone)  
	if g:GetCount()>0 then  
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP,zone)  
	end  
end  
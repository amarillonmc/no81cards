--铃兰之寻芳精
function c98876703.initial_effect(c)
	--SpecialSummon
	local e1=Effect.CreateEffect(c)  
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION) 
	e1:SetRange(LOCATION_HAND) 
	e1:SetCountLimit(1,98876703) 
	e1:SetTarget(c98876703.hsptg) 
	e1:SetOperation(c98876703.hspop) 
	c:RegisterEffect(e1)  
	--spsummon
	local e2=Effect.CreateEffect(c) 
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,18876703) 
	e2:SetCondition(c98876703.spcon)
	e2:SetTarget(c98876703.sptg)
	e2:SetOperation(c98876703.spop)
	c:RegisterEffect(e2)
end 
function c98876703.hspfil(c,e,tp)   
	return c:IsLevel(4) and c:IsSetCard(0x988) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) 
end  
function c98876703.hspgck(g,tp,ec) 
	return g:IsContains(ec) and Duel.GetLocationCount(tp,LOCATION_MZONE)>=g:GetCount()  
end 
function c98876703.hsptg(e,tp,eg,ep,ev,re,r,rp,chk) 
	local c=e:GetHandler() 
	local g=Duel.GetMatchingGroup(c98876703.hspfil,tp,LOCATION_HAND,0,nil,e,tp) 
	if chk==0 then return g:CheckSubGroup(c98876703.hspgck,2,2,tp,c) end 
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,2,tp,LOCATION_HAND) 
end 
function c98876703.hspop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	local g=Duel.GetMatchingGroup(c98876703.hspfil,tp,LOCATION_HAND,0,nil,e,tp) 
	if g:CheckSubGroup(c98876703.hspgck,2,2,tp,c) then 
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON) 
	local sg=g:SelectSubGroup(tp,c98876703.hspgck,false,2,2,tp,c) 
	Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP) 
	end 
end 
function c98876703.spcon(e,tp,eg,ep,ev,re,r,rp) 
	return e:GetHandler():IsSummonLocation(LOCATION_GRAVE)  
end 
function c98876703.filter(c,e,tp)
	return c:IsRace(RACE_PLANT) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP) 
end
function c98876703.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c98876703.filter,tp,LOCATION_HAND,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function c98876703.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c98876703.filter,tp,LOCATION_HAND,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end

















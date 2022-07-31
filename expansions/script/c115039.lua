--方舟骑士-临光
c115039.named_with_Arknight=1
function c115039.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--SpecialSummon
	local e1=Effect.CreateEffect(c) 
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O) 
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)  
	e1:SetProperty(EFFECT_FLAG_DELAY) 
	e1:SetCountLimit(1,115039) 
	e1:SetTarget(c115039.sptg) 
	e1:SetOperation(c115039.spop) 
	c:RegisterEffect(e1)
	--SpecialSummon P 
	local e3=Effect.CreateEffect(c) 
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_IGNITION) 
	e3:SetRange(LOCATION_PZONE)  
	e3:SetCountLimit(1,315039) 
	e3:SetCondition(c115039.pspcon)
	e3:SetTarget(c115039.psptg) 
	e3:SetOperation(c115039.pspop) 
	c:RegisterEffect(e3)
end 
function c115039.spfil(c,e,tp) 
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsType(TYPE_PENDULUM) and (c:IsSetCard(0x87af) or (_G["c"..c:GetCode()] and  _G["c"..c:GetCode()].named_with_Arknight))   
end 
function c115039.sptg(e,tp,eg,ep,ev,re,r,rp,chk) 
	if chk==0 then return e:GetHandler():IsSummonLocation(LOCATION_EXTRA) and Duel.IsExistingMatchingCard(c115039.spfil,tp,LOCATION_DECK,0,1,nil,e,tp) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end 
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK) 
end 
function c115039.spop(e,tp,eg,ep,ev,re,r,rp)  
	local c=e:GetHandler()  
	local g=Duel.GetMatchingGroup(c115039.spfil,tp,LOCATION_DECK,0,nil,e,tp) 
	if g:GetCount()>0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then  
	local sg=g:Select(tp,1,1,nil) 
	Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
	end 
end 
function c115039.pspcon(e,tp,eg,ep,ev,re,r,rp) 
	return Duel.IsExistingMatchingCard(nil,tp,LOCATION_PZONE,0,1,e:GetHandler()) 
end   
function c115039.psptg(e,tp,eg,ep,ev,re,r,rp,chk) 
	local sc=Duel.GetFirstMatchingCard(nil,tp,LOCATION_PZONE,0,e:GetHandler()) 
	if chk==0 then return e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end 
	Duel.SetTargetCard(sc) 
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0) 
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,sc,1,0,0) 
end 
function c115039.pspfil(c,e,tp) 
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and (c:IsSetCard(0x87af) or (_G["c"..c:GetCode()] and  _G["c"..c:GetCode()].named_with_Arknight))  
end 
function c115039.pspop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget() 
	if tc:IsRelateToEffect(e) and Duel.Destroy(tc,REASON_EFFECT)~=0 then 
	if c:IsRelateToEffect(e) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then 
	if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0 then
	if Duel.IsExistingMatchingCard(c115039.pspfil,tp,LOCATION_HAND,0,1,nil,e,tp) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.SelectYesNo(tp,aux.Stringid(115039,0)) then 
	local sg=Duel.SelectMatchingCard(tp,c115039.pspfil,tp,LOCATION_HAND,0,1,1,nil,e,tp) 
	Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
	end
	end 
	end 
	end 
end 


















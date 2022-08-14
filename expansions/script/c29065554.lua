--方舟骑士异格 
c29065554.named_with_Arknight=1
function c29065554.initial_effect(c)
	--SpecialSummon  
	local e1=Effect.CreateEffect(c)  
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_RELEASE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)  
	e1:SetCode(EVENT_FREE_CHAIN)  
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,29065554+EFFECT_COUNT_CODE_OATH) 
	e1:SetTarget(c29065554.actg) 
	e1:SetOperation(c29065554.acop) 
	c:RegisterEffect(e1) 
end 
function c29065554.rlfil(c,e,tp) 
	return c:IsReleasable() and Duel.IsExistingMatchingCard(c29065554.spfil,tp,LOCATION_GRAVE+LOCATION_HAND,0,1,nil,e,tp,c) 
end 
function c29065554.spfil(c,e,tp,mc)  
	local code=mc:GetCode()
	return aux.IsCodeListed(c,code) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,true,false) and Duel.GetMZoneCount(tp,mc)>0   
end 
function c29065554.actg(e,tp,eg,ep,ev,re,r,rp,chk,chkc) 
	if chk==0 then return Duel.IsExistingTarget(c29065554.rlfil,tp,LOCATION_MZONE,0,1,nil,e,tp) end 
	local g=Duel.SelectTarget(tp,c29065554.rlfil,tp,LOCATION_MZONE,0,1,1,nil,e,tp) 
	Duel.SetOperationInfo(0,CATEGORY_RELEASE,g,g:GetCount(),0,0) 
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE+LOCATION_HAND) 
end 
function c29065554.acop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget() 
	local g=Duel.GetMatchingGroup(c29065554.spfil,tp,LOCATION_GRAVE+LOCATION_HAND,0,nil,e,tp,tc)
	if tc:IsRelateToEffect(e) and Duel.Release(tc,REASON_EFFECT+REASON_MATERIAL+REASON_RITUAL)~=0 then 
	if g:GetCount()<=0 or Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end 
	local sc=g:Select(tp,1,1,nil):GetFirst() 
	sc:SetMaterial(Group.FromCards(tc))
	Duel.SpecialSummon(sc,SUMMON_TYPE_RITUAL,tp,tp,true,false,POS_FACEUP) 
	sc:CompleteProcedure()
	end 
end 





 
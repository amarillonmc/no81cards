--真红眼究极龙
function c77004003.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcCodeRep(c,74677422,3,true,true)
	--sp and dam  
	local e1=Effect.CreateEffect(c)  
	e1:SetCategory(CATEGORY_TODECK+CATEGORY_SPECIAL_SUMMON+CATEGORY_DAMAGE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)	  
	e1:SetCode(EVENT_LEAVE_FIELD) 
	e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP) 
	e1:SetCountLimit(3,77004003) 
	e1:SetTarget(c77004003.sdatg) 
	e1:SetOperation(c77004003.sdaop) 
	c:RegisterEffect(e1) 
end 
c77004003.material_setcode=0x3b
function c77004003.tdfil(c) 
	return c:IsCode(74677422) and c:IsAbleToDeck()  
end 
function c77004003.sdatg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():GetReasonPlayer()==1-tp and Duel.IsExistingMatchingCard(c77004003.tdfil,tp,LOCATION_GRAVE,0,1,nil) and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,tp,LOCATION_GRAVE) 
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0) 
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,800) 
end 
function c77004003.sdaop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	local g=Duel.GetMatchingGroup(c77004003.tdfil,tp,LOCATION_GRAVE,0,nil) 
	if g:GetCount()>0 then 
		local sg=g:Select(tp,1,1,nil) 
		if Duel.SendtoDeck(sg,nil,2,REASON_EFFECT)~=0 and c:IsRelateToEffect(e) and c:IsLocation(LOCATION_GRAVE) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0 then 
			Duel.Damage(1-tp,800,REASON_EFFECT) 
		end 
	end 
end 









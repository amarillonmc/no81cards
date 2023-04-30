--逐火十三英桀 格蕾修
function c32131316.initial_effect(c)
	--SpecialSummon 
	local e1=Effect.CreateEffect(c) 
	e1:SetCategory(CATEGORY_TOGRAVE+CATEGORY_SPECIAL_SUMMON)  
	e1:SetType(EFFECT_TYPE_IGNITION) 
	e1:SetRange(LOCATION_HAND) 
	e1:SetCountLimit(1,32131316) 
	e1:SetCost(c32131316.spcost) 
	e1:SetTarget(c32131316.sptg)   
	e1:SetOperation(c32131316.spop) 
	c:RegisterEffect(e1) 
	--copy 
	local e2=Effect.CreateEffect(c) 
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O) 
	e2:SetCode(EVENT_SPSUMMON_SUCCESS) 
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET) 
	e2:SetCountLimit(1,23131316)
	e2:SetTarget(c32131316.cptg) 
	e2:SetOperation(c32131316.cpop) 
	c:RegisterEffect(e2) 
end 
c32131316.SetCard_HR_flame13=true 
function c32131316.spcost(e,tp,eg,ep,ev,re,r,rp,chk) 
	if chk==0 then return not e:GetHandler():IsPublic() end 
	Duel.ConfirmCards(1-tp,e:GetHandler()) 
end 
function c32131316.sctfil(c) 
	return c:IsAbleToGrave() and c:IsType(TYPE_MONSTER) and c.SetCard_HR_flame13  
end 
function c32131316.sptg(e,tp,eg,ep,ev,re,r,rp,chk) 
	if chk==0 then return Duel.IsExistingMatchingCard(c32131316.sctfil,tp,LOCATION_HAND,0,1,e:GetHandler()) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end  
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_HAND)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end 
function c32131316.spop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	local g=Duel.GetMatchingGroup(c32131316.sctfil,tp,LOCATION_HAND,0,e:GetHandler()) 
	if g:GetCount()>0 then 
	   local sg=g:Select(tp,1,1,nil) 
	   if Duel.SendtoGrave(sg,REASON_EFFECT)~=0 and c:IsRelateToEffect(e) then  
	   Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	   end 
	end 
end  
function c32131316.cpfil(c,e,tp,eg,ep,ev,re,r,rp) 
	if not (c:IsType(TYPE_MONSTER) and c.SetCard_HR_flame13) then return false end
	local te=c.sp_effect 
	if not te then return false end
	local tg=te:GetTarget()
	return not tg or (tg and tg(e,tp,eg,ep,ev,re,r,rp,0))  
end 
function c32131316.cptg(e,tp,eg,ep,ev,re,r,rp,chk) 
	if chk==0 then return Duel.IsExistingTarget(c32131316.cpfil,tp,LOCATION_MZONE+LOCATION_GRAVE,0,1,nil,e,tp,eg,ep,ev,re,r,rp) end 
	local tc=Duel.SelectTarget(tp,c32131316.cpfil,tp,LOCATION_MZONE+LOCATION_GRAVE,0,1,1,nil,e,tp,eg,ep,ev,re,r,rp):GetFirst()  
	Duel.ClearTargetCard()
	tc:CreateEffectRelation(e)
	e:SetLabelObject(tc)
	local te=tc.sp_effect 
	local tg=te:GetTarget()
	if tg then tg(e,tp,eg,ep,ev,re,r,rp,1) end
end 
function c32131316.cpop(e,tp,eg,ep,ev,re,r,rp)  
	local c=e:GetHandler() 
	local tc=e:GetLabelObject()
	if tc:IsRelateToEffect(e) then
		local te=tc.sp_effect 
		local op=te:GetOperation()
		if op then op(e,tp,eg,ep,ev,re,r,rp) end 
	end
end




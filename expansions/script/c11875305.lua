--风花纹章士 贝鲁特
function c11875305.initial_effect(c)
	--
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CANNOT_SELECT_BATTLE_TARGET)
	e1:SetValue(function(e,c)
	return not e:GetHandler():GetColumnGroup():IsContains(c) end)
	c:RegisterEffect(e1)  
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SELECT_BATTLE_TARGET) 
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(0,LOCATION_MZONE) 
	e1:SetTarget(function(e,c) 
	return not e:GetHandler():GetColumnGroup():IsContains(c) end)
	e1:SetValue(function(e,c)
	return c==e:GetHandler() end)
	c:RegisterEffect(e1) 
	--SpecialSummon
	local e2=Effect.CreateEffect(c) 
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON) 
	e2:SetType(EFFECT_TYPE_IGNITION) 
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_HAND) 
	e2:SetCountLimit(1,11875305) 
	e2:SetTarget(c11875305.sptg) 
	e2:SetOperation(c11875305.spop) 
	c:RegisterEffect(e2) 
	--move 
	local e3=Effect.CreateEffect(c) 
	e3:SetType(EFFECT_TYPE_QUICK_O) 
	e3:SetCode(EVENT_FREE_CHAIN) 
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET) 
	e3:SetRange(LOCATION_MZONE) 
	e3:SetCountLimit(1)  
	e3:SetTarget(c11875305.mvtg) 
	e3:SetOperation(c11875305.mvop) 
	c:RegisterEffect(e3) 
end
c11875305.SetCard_tt_FireEmblem=true  
function c11875305.thfil(c,e,tp) 
	return c:IsAbleToHand() and c.SetCard_tt_FireEmblem and c:IsType(TYPE_MONSTER) and Duel.GetMZoneCount(tp,c)>0  
end 
function c11875305.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.IsExistingTarget(c11875305.thfil,tp,LOCATION_MZONE+LOCATION_GRAVE,0,1,nil,e,tp) end   
	local g=Duel.SelectTarget(tp,c11875305.thfil,tp,LOCATION_MZONE+LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,tc,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)  
end 
function c11875305.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler() 
	local tc=Duel.GetFirstTarget() 
	if tc:IsRelateToEffect(e) and Duel.SendtoHand(tc,nil,REASON_EFFECT)~=0 and c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0 and tc:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.SelectYesNo(tp,aux.Stringid(11875305,0)) then 
		Duel.BreakEffect() 
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)   
	end 
end 
function c11875305.mvtg(e,tp,eg,ep,ev,re,r,rp,chk) 
	local x=Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)+Duel.GetLocationCount(tp,LOCATION_MZONE)
	if chk==0 then return x>0 and Duel.IsExistingTarget(nil,tp,LOCATION_MZONE,0,1,nil) end 
	Duel.SelectTarget(tp,nil,tp,LOCATION_MZONE,0,1,1,nil)  
end 
function c11875305.sckfil(c,seq) 
	return c:GetSequence()==seq  
end 
function c11875305.mvop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler() 
	local tc=Duel.GetFirstTarget() 
	local x=Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)+Duel.GetLocationCount(tp,LOCATION_MZONE)
	if tc:IsRelateToEffect(e) and x>0 then 
		local filter=0 
		for seq=1,5 do 
			local seq=seq-1 
			if (Duel.GetMatchingGroupCount(c11875305.sckfil,tp,LOCATION_MZONE,0,nil,seq)==0 and not Duel.CheckLocation(tp,LOCATION_MZONE,seq)) or tc:GetSequence()==seq then 
				if seq==0 then filter=bit.bor(filter,1) end 
				if seq==1 then filter=bit.bor(filter,2) end 
				if seq==2 then filter=bit.bor(filter,4) end 
				if seq==3 then filter=bit.bor(filter,8) end 
				if seq==4 then filter=bit.bor(filter,16) end 
			end 
		end 
		filter=bit.bor(filter,4194336)
		filter=bit.bor(filter,2097216)
		local zone=Duel.SelectField(tp,1,LOCATION_MZONE,0,filter) 
		local seq=math.log(zone,2) 
		if Duel.IsExistingMatchingCard(c11875305.sckfil,tp,LOCATION_MZONE,0,1,nil,seq) then  
			local sc=Duel.GetFirstMatchingCard(c11875305.sckfil,tp,LOCATION_MZONE,0,nil,seq)  
			Duel.SwapSequence(tc,sc) 
		else 
			Duel.MoveSequence(tc,seq) 
		end 
	end 
end 







--结合纹章士 琉迩
function c11875299.initial_effect(c)
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
	--search
	local e2=Effect.CreateEffect(c) 
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,11875299)
	e2:SetTarget(c11875299.thtg)
	e2:SetOperation(c11875299.thop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3) 
	--move 
	local e4=Effect.CreateEffect(c) 
	e4:SetType(EFFECT_TYPE_QUICK_O) 
	e4:SetCode(EVENT_FREE_CHAIN) 
	e4:SetRange(LOCATION_MZONE) 
	e4:SetCountLimit(1) 
	e4:SetCondition(function(e) 
	return Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2 end)
	e4:SetTarget(c11875299.mvtg) 
	e4:SetOperation(c11875299.mvop) 
	c:RegisterEffect(e4) 
end
c11875299.SetCard_tt_FireEmblem=true  
function c11875299.thfilter(c)
	return c.SetCard_tt_FireEmblem and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToHand()
end
function c11875299.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c11875299.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c11875299.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler() 
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c11875299.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c11875299.splimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c11875299.splimit(e,c)
	return not c.SetCard_tt_FireEmblem 
end
function c11875299.mvtg(e,tp,eg,ep,ev,re,r,rp,chk) 
	local x=Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)+Duel.GetLocationCount(tp,LOCATION_MZONE)
	if chk==0 then return x>0 end  
end 
function c11875299.sckfil(c,seq) 
	return c:GetSequence()==seq  
end 
function c11875299.mvop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler() 
	local x=Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)+Duel.GetLocationCount(tp,LOCATION_MZONE)
	if c:IsRelateToEffect(e) and x>0 then 
		local filter=0 
		for seq=1,5 do 
			local seq=seq-1 
			if (Duel.GetMatchingGroupCount(c11875299.sckfil,tp,LOCATION_MZONE,0,nil,seq)==0 and not Duel.CheckLocation(tp,LOCATION_MZONE,seq)) or c:GetSequence()==seq then 
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
		if Duel.IsExistingMatchingCard(c11875299.sckfil,tp,LOCATION_MZONE,0,1,nil,seq) then  
			local tc=Duel.GetFirstMatchingCard(c11875299.sckfil,tp,LOCATION_MZONE,0,nil,seq)  
			Duel.SwapSequence(c,tc) 
		else 
			Duel.MoveSequence(c,seq) 
		end 
	end 
end 







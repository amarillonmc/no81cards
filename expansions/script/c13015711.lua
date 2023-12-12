--深海姬·海豚
function c13015711.initial_effect(c)
	--tg dr sr 
	local e1=Effect.CreateEffect(c) 
	e1:SetCategory(CATEGORY_DRAW+CATEGORY_SPECIAL_SUMMON) 
	e1:SetType(EFFECT_TYPE_IGNITION) 
	e1:SetRange(LOCATION_HAND) 
	e1:SetLabel(13015713)
	e1:SetCountLimit(1,13015711)  
	e1:SetCost(c13015711.tdrcost)
	e1:SetTarget(c13015711.tdrtg) 
	e1:SetOperation(c13015711.tdrop) 
	c13015711.tdr_effect=e1   
	c:RegisterEffect(e1) 
	--to grave   
	local e2=Effect.CreateEffect(c) 
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON) 
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O) 
	e2:SetCode(EVENT_LEAVE_FIELD) 
	e2:SetProperty(EFFECT_FLAG_DELAY) 
	e2:SetCountLimit(1,23015711) 
	e2:SetTarget(c13015711.tgtg) 
	e2:SetOperation(c13015711.tgop) 
	c:RegisterEffect(e2) 
	--lv 
	
end
function c13015711.tdrcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not e:GetHandler():IsPublic() end 
	
end  
function c13015711.tdrtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end 
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)  
end 
function c13015711.spfil(c,e,tp) 
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsRace(RACE_AQUA) and c:IsAttribute(ATTRIBUTE_WATER) 
end 
function c13015711.tdrop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler() 
	Duel.SendtoGrave(e:GetHandler(),REASON_EFFECT)
	Duel.Draw(tp,1,REASON_EFFECT)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c13015711.splimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
  
		local g=Duel.GetMatchingGroup(c13015711.spfil,tp,LOCATION_HAND,0,nil,e,tp)   
		if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(13015711,0)) then 
			Duel.BreakEffect() 
			local sg=g:Select(tp,1,1,nil) 
			Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)   
		 
	end   
end   
function c13015711.splimit(e,c)
return not (c:IsRace(RACE_AQUA) and c:IsAttribute(ATTRIBUTE_WATER))
end
function c13015711.sumfilter(c)
	return c:IsSummonable(true,nil)
end
function c13015711.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c13015711.spfil,tp,LOCATION_GRAVE,0,1,e:GetHandler(),e,tp) or Duel.IsExistingMatchingCard(c13015711.sumfilter,tp,LOCATION_SZONE,0,1,nil) end 
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)  
end  
function c13015711.tgop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler() 
	local op=0
		local off=1
		local ops={}
		local opval={}
		local b1=Duel.IsExistingMatchingCard(c13015711.spfil,tp,LOCATION_GRAVE,0,1,e:GetHandler(),e,tp)
		local b2=Duel.IsExistingMatchingCard(c13015711.sumfilter,tp,LOCATION_SZONE,0,1,nil) 
		if b1 then
			ops[off]=aux.Stringid(13015711,3)
			opval[off-1]=1
			off=off+1
		end
		if b2 then
			ops[off]=aux.Stringid(13015711,4)
			opval[off-1]=2
			off=off+1
		end
	local op=Duel.SelectOption(tp,table.unpack(ops))
		if opval[op]==1 then
		local sg=Duel.SelectMatchingCard(tp,c13015711.spfil,tp,LOCATION_GRAVE,0,1,1,e:GetHandler(),e,tp):GetFirst()
		Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)   
		elseif opval[op]==2 then
		local sa=Duel.SelectMatchingCard(tp,c13015711.sumfilter,tp,LOCATION_SZONE,0,1,1,nil):GetFirst()
		 Duel.Summon(tp,sa,true,nil)
	   end  
end

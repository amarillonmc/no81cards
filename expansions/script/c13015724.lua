--深海姬的圣女
function c13015724.initial_effect(c)
	--tg dr sr 
	local e1=Effect.CreateEffect(c)  
	e1:SetType(EFFECT_TYPE_IGNITION) 
	e1:SetRange(LOCATION_HAND) 
	e1:SetLabel(66615713)
	e1:SetCountLimit(1,13015724)  
	e1:SetCost(c13015724.tdrcost)
	e1:SetTarget(c13015724.tdrtg) 
	e1:SetOperation(c13015724.tdrop) 
	c13015724.tdr_effect=e1
	c:RegisterEffect(e1)   
	--special summon
	local e2=Effect.CreateEffect(c) 
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O) 
	e2:SetCode(EVENT_FREE_CHAIN)  
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,23015724)  
	e2:SetCondition(c13015724.spcon)   
	e2:SetCost(c13015724.spcost)
	e2:SetTarget(c13015724.sptg)
	e2:SetOperation(c13015724.spop)
	c:RegisterEffect(e2)
	
end

function c13015724.tdrcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not e:GetHandler():IsPublic() end 
	Duel.ConfirmCards(1-tp,e:GetHandler()) 
	Duel.ShuffleHand(tp) 
	
end 
function c13015724.setfil(c) 
	return c:IsSSetable() and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsSetCard(0xe01) 
end 
function c13015724.tdrtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c13015724.setfil,tp,LOCATION_DECK,0,1,nil) end 
	  
end 
function c13015724.tdrop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler() 
	Duel.SendtoGrave(c,REASON_EFFECT)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c13015724.splimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	
		local g=Duel.GetMatchingGroup(c13015724.setfil,tp,LOCATION_DECK,0,nil)   
		if g:GetCount()>0 then 
			Duel.BreakEffect() 
			local tc=g:Select(tp,1,1,nil):GetFirst() 
			Duel.SSet(tp,tc) 
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_TRAP_ACT_IN_SET_TURN)
			e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e1)
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_QP_ACT_IN_SET_TURN)
			e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e1)
		  
	end   
end   
function c13015724.splimit(e,c)
return not (c:IsRace(RACE_AQUA) and c:IsAttribute(ATTRIBUTE_WATER))
end
function c13015724.spcon(e,tp,eg,ep,ev,re,r,rp)
	return (Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2) 
end 
function c13015724.spcost(e,tp,eg,ep,ev,re,r,rp,chk) 
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsReleasable,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,nil) end 
	local g=Duel.SelectMatchingCard(tp,Card.IsReleasable,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,1,nil)  
	Duel.Release(g,REASON_COST)
end 
function c13015724.cfilter(c)
	return c:IsSetCard(0xe01) and c:IsType(TYPE_LINK) 
end
function c13015724.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local zone=0
	local lg=Duel.GetMatchingGroup(c13015724.cfilter,tp,LOCATION_MZONE,0,nil) 
	for tc in aux.Next(lg) do
		zone=bit.bor(zone,tc:GetLinkedZone())
	end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP,tp,zone) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c13015724.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local zone=0
	local lg=Duel.GetMatchingGroup(c13015724.cfilter,tp,LOCATION_MZONE,0,nil) 
	for tc in aux.Next(lg) do
		zone=bit.bor(zone,tc:GetLinkedZone())
	end
	if c:IsRelateToEffect(e) and zone~=0 and Duel.SpecialSummonStep(c,0,tp,tp,false,false,POS_FACEUP,zone) then 
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
		e1:SetValue(LOCATION_REMOVED)
		e1:SetReset(RESET_EVENT+RESETS_REDIRECT)
		c:RegisterEffect(e1,true)
	end
	Duel.SpecialSummonComplete() 
	if Duel.IsPlayerCanDraw(1-tp,1) and Duel.IsExistingMatchingCard(function(c) return c:IsFaceup() and c:IsCanChangePosition() end,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(13015724,0)) then
		Duel.BreakEffect()  
		Duel.Draw(1-tp,1,REASON_EFFECT) 
		local sc=Duel.SelectMatchingCard(tp,function(c) return c:IsFaceup() and c:IsCanChangePosition() end,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil):GetFirst()  
		Duel.ChangePosition(sc,POS_FACEDOWN_DEFENSE)  
	end   
end

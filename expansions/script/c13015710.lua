--深海姬·沙丁
function c13015710.initial_effect(c)
	--tg dr sr 
	local e1=Effect.CreateEffect(c) 
	e1:SetCategory(CATEGORY_TOGRAVE+CATEGORY_DRAW+CATEGORY_TODECK+CATEGORY_TOHAND+CATEGORY_SEARCH) 
	e1:SetType(EFFECT_TYPE_IGNITION) 
	e1:SetRange(LOCATION_HAND) 
	e1:SetLabel(66615713)
	e1:SetCountLimit(1,13015710)  
	e1:SetCost(c13015710.tdrcost)
	e1:SetTarget(c13015710.tdrtg) 
	e1:SetOperation(c13015710.tdrop) 
	c13015710.tdr_effect=e1
	c:RegisterEffect(e1)  
	--to grave   
	local e2=Effect.CreateEffect(c) 
	e2:SetCategory(CATEGORY_TOGRAVE) 
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O) 
	e2:SetCode(EVENT_LEAVE_FIELD) 
	e2:SetProperty(EFFECT_FLAG_DELAY) 
	e2:SetCountLimit(1,23015710) 
	e2:SetCondition(function(e) 
	return e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD) end) 
	e2:SetTarget(c13015710.tgtg) 
	e2:SetOperation(c13015710.tgop) 
	c:RegisterEffect(e2) 
   
end

function c13015710.tdrcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not e:GetHandler():IsPublic() end 
   
end 
function c13015710.thfil(c) 
	return c:IsAbleToHand() and c:IsType(TYPE_MONSTER) and c:IsSetCard(0xe01) and not c:IsCode(13015710)  
end 
function c13015710.tdrtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c13015710.thfil,tp,LOCATION_DECK,0,1,nil) end 
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,e:GetHandler(),1,0,0)  
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK) 
end 
function c13015710.tdrop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler() 
	Duel.SendtoGrave(e:GetHandler(),REASON_EFFECT)
		local g=Duel.GetMatchingGroup(c13015710.thfil,tp,LOCATION_DECK,0,nil)   
		if g:GetCount()>0 then  
			local sg=g:Select(tp,1,1,nil) 
			Duel.SendtoHand(sg,tp,REASON_EFFECT) 
			Duel.ConfirmCards(1-tp,sg)   
			if Duel.IsExistingMatchingCard(function(c) return c:IsAbleToDeck() and c:IsFaceup() and c:IsType(TYPE_SPELL+TYPE_TRAP) end,tp,LOCATION_REMOVED,LOCATION_REMOVED,1,nil) and Duel.IsPlayerCanDraw(tp,1) and Duel.SelectYesNo(tp,aux.Stringid(13015710,0)) then 
				Duel.BreakEffect() 
				local dg=Duel.SelectMatchingCard(tp,function(c) return c:IsAbleToDeck() and c:IsFaceup() and c:IsType(TYPE_SPELL+TYPE_TRAP) end,tp,LOCATION_REMOVED,LOCATION_REMOVED,1,1,nil)  
				if Duel.SendtoDeck(dg,nil,2,REASON_EFFECT)~=0 then  
					Duel.Draw(tp,1,REASON_EFFECT)	   
				end 
		   local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c13015710.splimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
			
		end  
	end   
end   
function c13015710.splimit(e,c)
return not (c:IsRace(RACE_AQUA) and c:IsAttribute(ATTRIBUTE_WATER))
end
function c13015710.tgfil(c) 
	return c:IsSetCard(0xe01) and c:IsAbleToGrave()   
end 
function c13015710.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c13015710.tgfil,tp,LOCATION_DECK,0,1,nil) end 
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,0,tp,LOCATION_DECK)
end 
function c13015710.tgop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	local g=Duel.GetMatchingGroup(c13015710.tgfil,tp,LOCATION_DECK,0,nil) 
	if g:GetCount()>0 then 
		local sg=g:Select(tp,1,1,nil) 
		if Duel.SendtoGrave(sg,REASON_EFFECT)~=0 and Duel.IsExistingMatchingCard(Card.IsSetCard,tp,LOCATION_GRAVE,0,3,nil,0xe01) and Duel.IsExistingMatchingCard(c13015710.tgfil,tp,LOCATION_DECK,0,1,nil) then 
			Duel.BreakEffect() 
			local sg=Duel.SelectMatchingCard(tp,c13015710.tgfil,tp,LOCATION_DECK,0,1,1,nil) 
			Duel.SendtoGrave(sg,REASON_EFFECT)  
		end 
	end  
end

--岩窟王　基督山
function c71201970.initial_effect(c)
	aux.AddCodeList(c,71201916)
	--xyz summon
	aux.AddXyzProcedure(c,nil,6,2)
	c:EnableReviveLimit()
	--immune
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(function(e) 
	return e:GetHandler():IsSummonType(SUMMON_TYPE_XYZ) end)
	e1:SetValue(function(e,te) 
	return te:IsActiveType(TYPE_MONSTER) and te:GetHandler():IsRace(RACE_AQUA+RACE_THUNDER+RACE_PYRO) end)
	c:RegisterEffect(e1)
	--to ex 
	local e1=Effect.CreateEffect(c) 
	e1:SetDescription(aux.Stringid(71201970,0))
	e1:SetCategory(CATEGORY_TOEXTRA+CATEGORY_SPECIAL_SUMMON) 
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE) 
	e1:SetCountLimit(1,71201970)
	e1:SetCondition(function(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2 end) 
	e1:SetTarget(c71201970.testg)  
	e1:SetOperation(c71201970.tesop) 
	c:RegisterEffect(e1)	 
	--th 
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(71201910,2))
	e2:SetCategory(CATEGORY_RECOVER+CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_IGNITION) 
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCondition(c71201970.thcon)
	e2:SetCost(c71201970.thcost)
	e2:SetTarget(c71201970.thtg)
	e2:SetOperation(c71201970.thop)
	c:RegisterEffect(e2)
end
function c71201970.espfil(c,e,tp) 
	return c:IsCode(71201910) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,false,false) and Duel.GetLocationCountFromEx(tp,tp,e:GetHandler(),c)>0   
end 
function c71201970.ovfil(c)  
	return c:IsCanOverlay() and c:IsCode(71201916)  
end 
function c71201970.testg(e,tp,eg,ep,ev,re,r,rp,chk) 
	if chk==0 then return e:GetHandler():IsAbleToExtra() and Duel.IsExistingMatchingCard(c71201970.espfil,tp,LOCATION_EXTRA,0,1,nil,e,tp) and Duel.IsExistingMatchingCard(c71201970.ovfil,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end 
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c71201970.tesop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SendtoDeck(c,nil,SEQ_DECKTOP,REASON_EFFECT)~=0 then 
		local sc=Duel.SelectMatchingCard(tp,c71201970.espfil,tp,LOCATION_EXTRA,0,1,1,nil,e,tp):GetFirst() 
		if sc then
			Duel.SpecialSummon(sc,SUMMON_TYPE_XYZ,tp,tp,false,false,POS_FACEUP) 
			sc:CompleteProcedure() 
			Duel.BreakEffect()
			local og=Duel.SelectMatchingCard(tp,c71201970.ovfil,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil) 
			if og:GetCount()>0 then 
				Duel.Overlay(sc,og) 
			end 
		end 
	end 
end  
function c71201970.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetOverlayGroup():IsExists(Card.IsType,1,nil,TYPE_SPELL)  
end 
function c71201970.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c71201970.thtg(e,tp,eg,ep,ev,re,r,rp,chk) 
	if chk==0 then return true end  
	Duel.SetTargetPlayer(tp) 
	Duel.SetTargetParam(2500)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,2500)
end
function c71201970.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	if Duel.Recover(p,d,REASON_EFFECT)~=0 then 
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_PHASE+PHASE_END)
		e1:SetCountLimit(1)
		e1:SetOperation(c71201970.sthop)
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,p)
	end 
end
function c71201970.setfil(c)  
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and aux.IsCodeListed(c,71201916) and (c:IsSSetable() or c:IsAbleToHand())
end 
function c71201970.sthop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler() 
	Duel.Hint(HINT_CARD,0,71201970) 
	if Duel.IsExistingMatchingCard(c71201970.setfil,tp,LOCATION_GRAVE,0,1,nil) then 
		local tc=Duel.SelectMatchingCard(tp,c71201970.setfil,tp,LOCATION_GRAVE,0,1,1,nil):GetFirst() 
		if tc:IsAbleToHand() and (not tc:IsSSetable() or Duel.SelectOption(tp,1190,1153)==0) then
			Duel.SendtoHand(tc,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,tc)
		else
			Duel.SSet(tp,tc)
		end   
	end 
end 


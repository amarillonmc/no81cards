--还零龙之影灵衣
function c11533701.initial_effect(c)
	c:EnableReviveLimit()
	--cannot special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(aux.ritlimit)
	c:RegisterEffect(e1) 
	--rl rm td 
	local e1=Effect.CreateEffect(c) 
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_RELEASE+CATEGORY_REMOVE) 
	e1:SetType(EFFECT_TYPE_IGNITION) 
	e1:SetRange(LOCATION_HAND) 
	e1:SetCountLimit(1,11533701) 
	e1:SetCost(c11533701.rrtcost) 
	e1:SetTarget(c11533701.rrttg) 
	e1:SetOperation(c11533701.rrtop) 
	c:RegisterEffect(e1)  
	--remove
	local e2=Effect.CreateEffect(c) 
	e2:SetCategory(CATEGORY_REMOVE) 
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O) 
	e2:SetCode(EVENT_SPSUMMON_SUCCESS) 
	e2:SetProperty(EFFECT_FLAG_DELAY) 
	e2:SetCountLimit(1,21533701)  
	e2:SetCondition(c11533701.rmcon)
	e2:SetTarget(c11533701.rmtg) 
	e2:SetOperation(c11533701.rmop) 
	c:RegisterEffect(e2) 
	--sp 
	local e3=Effect.CreateEffect(c) 
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DISABLE) 
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O) 
	e3:SetCode(EVENT_DESTROYED) 
	e3:SetProperty(EFFECT_FLAG_DELAY) 
	e3:SetCountLimit(1,31533701) 
	e3:SetCondition(function(e,tp,eg,ep,ev,re,r,rp) 
	return c11533701.rmcon(e,tp,eg,ep,ev,re,r,rp) and e:GetHandler():GetReasonPlayer()==1-e:GetHandlerPlayer() end) 
	e3:SetTarget(c11533701.spdtg) 
	e3:SetOperation(c11533701.spdop) 
	c:RegisterEffect(e3) 
end
function c11533701.mat_filter(c)
	return not c:IsLevel(11)
end 
function c11533701.rrtcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsDiscardable() end 
	Duel.SendtoGrave(e:GetHandler(),REASON_COST+REASON_DISCARD)
end 
function c11533701.srfil(c)  
	return c:IsAbleToHand() and c:IsSetCard(0xb4)   
end 
function c11533701.rrfil(c) 
	if not c:IsSetCard(0xb4) then return false end  
	return c:IsAbleToRemove() or c:IsReleasable() or c:IsAbleToGrave() 
end 
function c11533701.rrttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c11533701.srfil,tp,LOCATION_DECK,0,1,nil) end 
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK) 
end 
function c11533701.rrtop(e,tp,eg,ep,ev,re,r,rp)  
	local c=e:GetHandler() 
	local g=Duel.GetMatchingGroup(c11533701.srfil,tp,LOCATION_DECK,0,nil) 
	if g:GetCount()>0 then 
		local sg=g:Select(tp,1,1,nil) 
		Duel.SendtoHand(sg,tp,REASON_EFFECT) 
		Duel.ConfirmCards(1-tp,sg) 
		if Duel.IsExistingMatchingCard(c11533701.rrfil,tp,LOCATION_HAND,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(11533701,4)) then 
		Duel.BreakEffect() 
		local tc=Duel.SelectMatchingCard(tp,c11533701.rrfil,tp,LOCATION_HAND,0,1,1,nil):GetFirst() 
		local b1=tc:IsReleasable()
		local b2=tc:IsAbleToRemove() 
		local b3=tc:IsAbleToGrave()  
		local op=0 
			if b1 and b2 and b3 then 
				op=Duel.SelectOption(tp,aux.Stringid(11533701,1),aux.Stringid(11533701,2),aux.Stringid(11533701,3))
			elseif b1 and b2 then 
				op=Duel.SelectOption(tp,aux.Stringid(11533701,1),aux.Stringid(11533701,2))
			elseif b2 and b3 then 
				op=Duel.SelectOption(tp,aux.Stringid(11533701,2),aux.Stringid(11533701,3))+1 
			elseif b1 and b3 then 
				op=Duel.SelectOption(tp,aux.Stringid(11533701,2),aux.Stringid(11533701,3)) 
				if op==1 then op=op+1 end 
			elseif b1 then 
				op=Duel.SelectOption(tp,aux.Stringid(11533701,1)) 
			elseif b2 then 
				op=Duel.SelectOption(tp,aux.Stringid(11533701,2))+1 
			elseif b3 then 
				op=Duel.SelectOption(tp,aux.Stringid(11533701,3))+2		 
			end 
			if op==0 then 
				Duel.Release(tc,REASON_EFFECT)  
			elseif op==1 then 
				Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)
			elseif op==2 then 
				Duel.SendtoGrave(tc,REASON_EFFECT)
			end 
		end 
	end 
end 
function c11533701.rmcon(e,tp,eg,ep,ev,re,r,rp) 
	local mg=e:GetHandler():GetMaterial()
	return e:GetHandler():IsSummonType(SUMMON_TYPE_RITUAL) and mg and mg:FilterCount(Card.IsSetCard,nil,0xb4)==mg:GetCount()  
end 
function c11533701.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,LOCATION_DECK+LOCATION_GRAVE,LOCATION_DECK+LOCATION_HAND+LOCATION_EXTRA+LOCATION_GRAVE+LOCATION_ONFIELD,1,nil) end 
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_DECK+LOCATION_HAND+LOCATION_EXTRA+LOCATION_GRAVE+LOCATION_ONFIELD)
end 
function c11533701.rmop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	local g1=Duel.GetDecktopGroup(tp,1) 
	if g1:GetCount()>0 then 
		Duel.ConfirmCards(1-tp,g1) 
		if Duel.SelectYesNo(tp,aux.Stringid(11533701,0)) then 
			Duel.Remove(g1,POS_FACEUP,REASON_EFFECT)   
		end
	end 
	local g2=Duel.GetDecktopGroup(1-tp,1) 
	if g2:GetCount()>0 then 
		Duel.ConfirmCards(tp,g2) 
		if Duel.SelectYesNo(tp,aux.Stringid(11533701,0)) then 
			Duel.Remove(g2,POS_FACEUP,REASON_EFFECT)	
		end
	end 
	local g3=Duel.GetFieldGroup(tp,0,LOCATION_EXTRA)
	if g3:GetCount()>0 then 
		Duel.ConfirmCards(tp,g3) 
		if Duel.SelectYesNo(tp,aux.Stringid(11533701,0)) then 
			local rg=g3:Select(tp,1,1,nil)
			Duel.Remove(rg,POS_FACEUP,REASON_EFFECT)	
		end
	end 
	local g4=Duel.GetFieldGroup(tp,0,LOCATION_HAND)
	if g4:GetCount()>0 then 
		Duel.HintSelection(g4) 
		if Duel.SelectYesNo(tp,aux.Stringid(11533701,0)) then 
			local rg=g4:RandomSelect(tp,1)
			Duel.Remove(rg,POS_FACEUP,REASON_EFFECT)	
		end
	end 
	local g5=Duel.GetFieldGroup(tp,LOCATION_GRAVE,0)
	if g5:GetCount()>0 then 
		Duel.ConfirmCards(tp,g5) 
		if Duel.SelectYesNo(tp,aux.Stringid(11533701,0)) then 
			local rg=g5:Select(tp,1,1,nil)
			Duel.Remove(rg,POS_FACEUP,REASON_EFFECT)	
		end
	end 
	local g6=Duel.GetFieldGroup(tp,0,LOCATION_ONFIELD)
	if g6:GetCount()>0 then  
		Duel.HintSelection(g6) 
		if Duel.SelectYesNo(tp,aux.Stringid(11533701,0)) then 
			local rg=g6:Select(tp,1,1,nil)
			Duel.Remove(rg,POS_FACEUP,REASON_EFFECT)	
		end
	end 
	local g7=Duel.GetFieldGroup(tp,0,LOCATION_GRAVE)
	if g7:GetCount()>0 then  
		if Duel.SelectYesNo(tp,aux.Stringid(11533701,0)) then 
			local rg=g7:Select(tp,1,1,nil)
			Duel.Remove(rg,POS_FACEUP,REASON_EFFECT)	
		end
	end 
end 
function c11533701.spfil(c,e,tp) 
	return c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,false,true) and c:IsCode(52068432)  
end 
function c11533701.spdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c11533701.spfil,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil,e,tp) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end 
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end 
function c11533701.spdop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	local g=Duel.GetMatchingGroup(c11533701.spfil,tp,LOCATION_DECK+LOCATION_GRAVE,0,nil,e,tp) 
	if g:GetCount()>0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then 
		local tc=g:Select(tp,1,1,nil):GetFirst()  
		Duel.SpecialSummon(tc,SUMMON_TYPE_RITUAL,tp,tp,false,true,POS_FACEUP) 
		tc:CompleteProcedure() 
		local dg=Duel.GetMatchingGroup(aux.NegateEffectMonsterFilter,tp,0,LOCATION_MZONE,nil) 
		if dg:GetCount()>0 then 
			local tc=dg:GetFirst() 
			while tc do 
			Duel.NegateRelatedChain(tc,RESET_TURN_SET)
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_DISABLE)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e1)
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_DISABLE_EFFECT)
			e2:SetValue(RESET_TURN_SET)
			e2:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e2)
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_SET_ATTACK_FINAL) 
			e2:SetRange(LOCATION_MZONE) 
			e2:SetValue(tc:GetAttack()/2)
			e2:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e2)
			tc=dg:GetNext() 
			end  
		end 
	end  
end 







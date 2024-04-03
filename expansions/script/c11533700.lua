--心意海仙女之影灵衣
function c11533700.initial_effect(c)
	c:EnableReviveLimit()
	--cannot special summon
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	e0:SetValue(aux.ritlimit)
	c:RegisterEffect(e0) 
	--rl rm td 
	local e1=Effect.CreateEffect(c) 
	e1:SetCategory(CATEGORY_RELEASE+CATEGORY_REMOVE+CATEGORY_TODECK+CATEGORY_DRAW) 
	e1:SetType(EFFECT_TYPE_QUICK_O) 
	e1:SetCode(EVENT_FREE_CHAIN) 
	e1:SetRange(LOCATION_HAND) 
	e1:SetCountLimit(1,11533700) 
	e1:SetCost(c11533700.rrtcost) 
	e1:SetTarget(c11533700.rrttg) 
	e1:SetOperation(c11533700.rrtop) 
	c:RegisterEffect(e1)	
	--tohand
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_REMOVE)
	e2:SetCountLimit(1,31533700) 
	e2:SetTarget(c11533700.thtg)
	e2:SetOperation(c11533700.thop)
	c:RegisterEffect(e2)
	--rl and disable
	local e3=Effect.CreateEffect(c) 
	e3:SetCategory(CATEGORY_RELEASE+CATEGORY_REMOVE+CATEGORY_DISABLE)
	e3:SetType(EFFECT_TYPE_QUICK_O) 
	e3:SetCode(EVENT_FREE_CHAIN) 
	e3:SetHintTiming(0,TIMINGS_CHECK_MONSTER)
	e3:SetRange(LOCATION_MZONE) 
	e3:SetCountLimit(1,21533700) 
	e3:SetTarget(c11533700.rdistg)
	e3:SetOperation(c11533700.rdisop)
	c:RegisterEffect(e3)
end
function c11533700.thfilter(c)
	return c:IsSetCard(0xb4) and c:IsAbleToHand()
end
function c11533700.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c11533700.thfilter,tp,LOCATION_REMOVED,0,1,e:GetHandler()) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_REMOVED)
end
function c11533700.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c11533700.thfilter,tp,LOCATION_REMOVED,0,1,1,e:GetHandler())
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c11533700.mat_filter(c)
	return not c:IsCode(11533700)  
end 
function c11533700.rrtcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsDiscardable() end 
	Duel.SendtoGrave(e:GetHandler(),REASON_COST+REASON_DISCARD)
end 
function c11533700.rrfil1(c)
	return c:IsSetCard(0xb4) and c:IsReleasable()
end 
function c11533700.rrfil2(c)
	return c:IsSetCard(0xb4) and c:IsAbleToRemove()
end 
function c11533700.rrttg(e,tp,eg,ep,ev,re,r,rp,chk)
	local b1=Duel.IsExistingMatchingCard(c11533700.rrfil1,tp,LOCATION_HAND,0,1,e:GetHandler()) and Duel.IsExistingMatchingCard(Card.IsAbleToDeck,tp,LOCATION_GRAVE+LOCATION_REMOVED,LOCATION_GRAVE+LOCATION_REMOVED,5,nil) and Duel.IsPlayerCanDraw(tp,2)

	local b2=Duel.IsExistingMatchingCard(c11533700.rrfil2,tp,0,LOCATION_GRAVE,1,e:GetHandler()) and Duel.IsExistingMatchingCard(Card.IsAbleToDeck,tp,LOCATION_GRAVE+LOCATION_REMOVED,LOCATION_GRAVE+LOCATION_REMOVED,3,nil) and Duel.IsPlayerCanDraw(tp,1)
	if chk==0 then return b1 or b2 end 
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,0,tp,LOCATION_GRAVE+LOCATION_REMOVED) 
end 
function c11533700.rrtop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler()
	local b1=Duel.IsExistingMatchingCard(c11533700.rrfil1,tp,LOCATION_HAND,0,1,c) and Duel.IsExistingMatchingCard(Card.IsAbleToDeck,tp,LOCATION_GRAVE+LOCATION_REMOVED,LOCATION_GRAVE+LOCATION_REMOVED,5,nil) and Duel.IsPlayerCanDraw(tp,2)
	local b2=Duel.IsExistingMatchingCard(c11533700.rrfil2,tp,LOCATION_GRAVE,0,1,c) and Duel.IsExistingMatchingCard(Card.IsAbleToDeck,tp,LOCATION_GRAVE+LOCATION_REMOVED,LOCATION_GRAVE+LOCATION_REMOVED,3,nil) and Duel.IsPlayerCanDraw(tp,1)
	local op=0
			if b1 or b2 then  
			op=Duel.SelectOption(tp,aux.Stringid(11533700,2),aux.Stringid(11533700,3))
			elseif b1 then 
			op=Duel.SelectOption(tp,aux.Stringid(11533700,2))
			elseif b2 then 
			op=Duel.SelectOption(tp,aux.Stringid(11533700,3))+1
			end  


			if op==0 then 
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local g1=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c11533700.rrfil1),tp,LOCATION_HAND,0,1,1,c)
	if g1:GetCount()>0 and Duel.Release(g1,REASON_EFFECT)>0 and Duel.IsExistingMatchingCard(aux.NecroValleyFilter(Card.IsAbleToDeck),tp,LOCATION_GRAVE+LOCATION_REMOVED,LOCATION_GRAVE+LOCATION_REMOVED,5,nil) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local rrg=Duel.SelectMatchingCard(tp,Card.IsAbleToDeck,tp,LOCATION_GRAVE+LOCATION_REMOVED,LOCATION_GRAVE+LOCATION_REMOVED,5,5,nil)
	if rrg:GetCount()>0 then
		Duel.SendtoDeck(rrg,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
		Duel.ShuffleDeck(tp)
		local ct=rrg:FilterCount(Card.IsLocation,nil,LOCATION_DECK+LOCATION_EXTRA)
		if ct>0 then Duel.Draw(tp,2,REASON_EFFECT) end 
	end
	end
			elseif op==1 then 
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g3=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c11533700.rrfil2),tp,LOCATION_GRAVE,0,1,1,c)
	if g3:GetCount()>0 and Duel.Remove(g3,POS_FACEUP,REASON_EFFECT)>0 and Duel.IsExistingMatchingCard(aux.NecroValleyFilter(Card.IsAbleToDeck),tp,LOCATION_GRAVE+LOCATION_REMOVED,LOCATION_GRAVE+LOCATION_REMOVED,3,nil) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local rrg=Duel.SelectMatchingCard(tp,Card.IsAbleToDeck,tp,LOCATION_GRAVE+LOCATION_REMOVED,LOCATION_GRAVE+LOCATION_REMOVED,3,3,nil)
	if rrg:GetCount()>0 then
		Duel.SendtoDeck(rrg,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
		Duel.ShuffleDeck(tp)
		local ct=rrg:FilterCount(Card.IsLocation,nil,LOCATION_DECK+LOCATION_EXTRA)
		if ct>0 then Duel.Draw(tp,1,REASON_EFFECT) end 
	end
	end
	end
end  
function c11533700.rlfil(c)  
	return c:IsReleasable() or c:IsAbleToRemove() 
end 
function c11533700.rdistg(e,tp,eg,ep,ev,re,r,rp,chk) 
	if chk==0 then return Duel.IsExistingMatchingCard(c11533700.rlfil,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,nil) end 
	Duel.SetOperationInfo(0,CATEGORY_RELEASE,nil,1,tp,LOCATION_HAND+LOCATION_ONFIELD)  
end
function c11533700.rdisop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler() 
	local g=Duel.GetMatchingGroup(c11533700.rlfil,tp,LOCATION_HAND+LOCATION_ONFIELD,0,nil) 
	if g:GetCount()>0 then 
		local rc=g:Select(tp,1,1,nil):GetFirst()  
		local x=0 
			local b1=rc:IsReleasable() 
			local b2=rc:IsAbleToRemove()
			local op=0  
			if b1 and b2 then  
			op=Duel.SelectOption(tp,aux.Stringid(11533700,2),aux.Stringid(11533700,3))
			elseif b1 then 
			op=Duel.SelectOption(tp,aux.Stringid(11533700,2))
			elseif b2 then 
			op=Duel.SelectOption(tp,aux.Stringid(11533700,3))+1
			end  
			if op==0 then 
			x=Duel.Release(rc,REASON_EFFECT) 
			elseif op==1 then 
			x=Duel.Remove(rc,POS_FACEUP,REASON_EFFECT) 
			end 
		if x>0 and Duel.IsExistingMatchingCard(aux.NegateAnyFilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(11533700,1)) then   
			Duel.BreakEffect()
			local tc=Duel.SelectMatchingCard(tp,aux.NegateAnyFilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil):GetFirst()  
			Duel.NegateRelatedChain(tc,RESET_TURN_SET)
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_DISABLE)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e1)
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_DISABLE_EFFECT)
			e2:SetValue(RESET_TURN_SET)
			e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e2:SetReset(RESET_EVENT+RESETS_STANDARD) 
			tc:RegisterEffect(e2)
		end 
	end 
end







--心意海仙女之影灵衣
function c11533700.initial_effect(c)
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
	e1:SetCategory(CATEGORY_RELEASE+CATEGORY_REMOVE+CATEGORY_TODECK) 
	e1:SetType(EFFECT_TYPE_QUICK_O) 
	e1:SetCode(EVENT_FREE_CHAIN) 
	e1:SetRange(LOCATION_HAND) 
	e1:SetCountLimit(1,11533700) 
	e1:SetCost(c11533700.rrtcost) 
	e1:SetTarget(c11533700.rrttg) 
	e1:SetOperation(c11533700.rrtop) 
	c:RegisterEffect(e1)	 
	--indes
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e2:SetValue(1)
	c:RegisterEffect(e2) 
	--rl and disable
	local e3=Effect.CreateEffect(c) 
	e3:SetCategory(CATEGORY_RELEASE+CATEGORY_DISABLE)
	e3:SetType(EFFECT_TYPE_QUICK_O) 
	e3:SetCode(EVENT_FREE_CHAIN) 
	e3:SetHintTiming(0,TIMINGS_CHECK_MONSTER)
	e3:SetRange(LOCATION_MZONE) 
	e3:SetCountLimit(1,21533700) 
	e3:SetTarget(c11533700.rdistg)
	e3:SetOperation(c11533700.rdisop)
	c:RegisterEffect(e3)
end
function c11533700.mat_filter(c)
	return not c:IsCode(11533700)  
end 
function c11533700.rrtcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsDiscardable() end 
	Duel.SendtoGrave(e:GetHandler(),REASON_COST+REASON_DISCARD)
end 
function c11533700.rrfil(c) 
	if not c:IsSetCard(0xb4) then return false end  
	if c:IsLocation(LOCATION_HAND) then 
	return c:IsReleasable() or c:IsAbleToGrave()  
	elseif c:IsLocation(LOCATION_GRAVE) then 
	return c:IsAbleToRemove() and not c:IsCode(11533700)  
	else return false end 
end 
function c11533700.rrttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c11533700.rrfil,tp,LOCATION_HAND,0,1,e:GetHandler()) end 
	Duel.SetOperationInfo(0,CATEGORY_RELEASE,nil,1,tp,LOCATION_HAND) 
end 
function c11533700.rrtop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	local g=Duel.GetMatchingGroup(c11533700.rrfil,tp,LOCATION_HAND,0,nil) 
	if g:GetCount()>0 then 
		local tc=g:Select(tp,1,1,nil):GetFirst() 
		local x=0
		if tc:IsLocation(LOCATION_HAND) then  
			local b1=tc:IsReleasable() 
			local b2=tc:IsAbleToGrave()
			local op=0  
			if b1 and b2 then  
			op=Duel.SelectOption(tp,aux.Stringid(11533700,2),aux.Stringid(11533700,3))
			elseif b1 then 
			op=Duel.SelectOption(tp,aux.Stringid(11533700,2))
			elseif b2 then 
			op=Duel.SelectOption(tp,aux.Stringid(11533700,3))+1
			end  
			if op==0 then 
			x=Duel.Release(tc,REASON_EFFECT) 
			elseif op==1 then 
			x=Duel.SendtoGrave(tc,REASON_EFFECT) 
			end  
		--elseif tc:IsLocation(LOCATION_GRAVE) then 
			--x=Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)
		end 
		if x>0 and Duel.IsExistingMatchingCard(Card.IsAbleToDeck,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(11533700,0)) then 
			Duel.BreakEffect() 
			local sg=Duel.SelectMatchingCard(tp,Card.IsAbleToDeck,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,3,nil) 
			Duel.SendtoDeck(sg,nil,2,REASON_EFFECT)   
		end 
	end 
end  
function c11533700.rlfil(c)  
	return c:IsSetCard(0xb4) and (c:IsReleasable() or c:IsAbleToGrave()) 
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
			local b2=rc:IsAbleToGrave()
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
			x=Duel.SendtoGrave(rc,REASON_EFFECT) 
			end 
		if x>0 and Duel.IsExistingMatchingCard(aux.NegateAnyFilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(11533700,1)) then   
			Duel.BreakEffect()
			local tc=Duel.SelectMatchingCard(tp,aux.NegateAnyFilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil):GetFirst()  
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
		end 
	end 
end







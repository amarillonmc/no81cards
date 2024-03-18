--仗剑走天涯 跳跳
function c50099152.initial_effect(c)
	--tohand
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND) 
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_REMOVE)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,50099152) 
	e1:SetCondition(c50099152.thcon)
	e1:SetTarget(c50099152.thtg)
	e1:SetOperation(c50099152.thop)
	c:RegisterEffect(e1) 
	--negate
	local e2=Effect.CreateEffect(c) 
	e2:SetCategory(CATEGORY_TODECK)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING) 
	e2:SetRange(LOCATION_HAND)
	e2:SetCountLimit(1,10099152)
	e2:SetCondition(c50099152.discon)
	e2:SetCost(c50099152.discost)
	e2:SetTarget(c50099152.distg)
	e2:SetOperation(c50099152.disop)
	c:RegisterEffect(e2)	
end
function c50099152.thcon(e,tp,eg,ep,ev,re,r,rp)
	if not re then return end
	local c=e:GetHandler()
	local rc=re:GetHandler()
	return ((c:IsReason(REASON_COST) and re:IsActivated()) or c:IsReason(REASON_EFFECT)) and rc:IsSetCard(0x998)  
end 
function c50099152.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToHand() end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
end
function c50099152.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler() 
	if c:IsRelateToEffect(e) then 
		Duel.SendtoHand(c,nil,REASON_EFFECT) 
	end 
end 
function c50099152.discon(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.IsExistingMatchingCard(function(c) return c:IsFaceup() and c:IsSetCard(0x998) and c:IsType(TYPE_SYNCHRO+TYPE_LINK) end,tp,LOCATION_MZONE,0,1,nil) then return false end 
	return rp==1-tp and re:IsActiveType(TYPE_SPELL)  
end
function c50099152.discost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not e:GetHandler():IsPublic() end 
end
function c50099152.setfilter(c)
	return c:IsSetCard(0x998) and c:IsType(TYPE_SPELL) and c:IsSSetable()
end
function c50099152.distg(e,tp,eg,ep,ev,re,r,rp,chk) 
	if chk==0 then return e:GetHandler():IsAbleToDeck() and Duel.IsExistingMatchingCard(c50099152.setfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end 
	Duel.SetOperationInfo(0,CATEGORY_TODECK,e:GetHandler(),1,0,0) 
end
function c50099152.disop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SendtoDeck(c,nil,2,REASON_EFFECT)~=0 and Duel.IsExistingMatchingCard(c50099152.setfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) then 
		local tc=Duel.SelectMatchingCard(tp,c50099152.setfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil):GetFirst()
		if tc and Duel.SSet(tp,tc)~=0 then
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_QP_ACT_IN_SET_TURN)
			e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e1)
		end
	end 
end








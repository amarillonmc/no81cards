--仗剑走天涯 莎莉
function c50099153.initial_effect(c)
	--tohand
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND) 
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_REMOVE)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,50099153) 
	e1:SetCondition(c50099153.thcon)
	e1:SetTarget(c50099153.thtg)
	e1:SetOperation(c50099153.thop)
	c:RegisterEffect(e1)  
	--negate
	local e2=Effect.CreateEffect(c) 
	e2:SetCategory(CATEGORY_TODECK+CATEGORY_NEGATE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e2:SetRange(LOCATION_HAND)
	e2:SetCountLimit(1,10099153)
	e2:SetCondition(c50099153.discon)
	e2:SetCost(c50099153.discost)
	e2:SetTarget(c50099153.distg)
	e2:SetOperation(c50099153.disop)
	c:RegisterEffect(e2)
end
function c50099153.thcon(e,tp,eg,ep,ev,re,r,rp)
	if not re then return end
	local c=e:GetHandler()
	local rc=re:GetHandler()
	return ((c:IsReason(REASON_COST) and re:IsActivated()) or c:IsReason(REASON_EFFECT)) and rc:IsSetCard(0x998)  
end 
function c50099153.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToHand() end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
end
function c50099153.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler() 
	if c:IsRelateToEffect(e) then 
		Duel.SendtoHand(c,nil,REASON_EFFECT) 
	end 
end 
function c50099153.discon(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.IsExistingMatchingCard(function(c) return c:IsFaceup() and c:IsSetCard(0x998) and c:IsType(TYPE_SYNCHRO+TYPE_LINK) end,tp,LOCATION_MZONE,0,1,nil) then return false end 
	return rp==1-tp and re:IsActiveType(TYPE_SPELL) and Duel.IsChainNegatable(ev) 
end
function c50099153.discost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not e:GetHandler():IsPublic() end 
end
function c50099153.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToDeck() end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,e:GetHandler(),1,0,0) 
end
function c50099153.disop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.NegateActivation(ev) and c:IsRelateToEffect(e) then 
		Duel.SendtoDeck(c,nil,2,REASON_EFFECT)
	end 
end


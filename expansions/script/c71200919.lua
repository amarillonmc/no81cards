--绝音魔女·舞泣之红
function c71200919.initial_effect(c)
	--to hand or set
	local e1=Effect.CreateEffect(c) 
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetCountLimit(1,71200919)
	e1:SetTarget(c71200919.thtg)
	e1:SetOperation(c71200919.thop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
	--immune 
	local e2=Effect.CreateEffect(c) 
	e2:SetType(EFFECT_TYPE_QUICK_O)  
	e2:SetCode(EVENT_CHAINING) 
	e2:SetRange(LOCATION_HAND+LOCATION_MZONE) 
	e2:SetCountLimit(1,71200874)
	e2:SetCondition(c71200919.imcon) 
	e2:SetCost(c71200919.imcost) 
	e2:SetTarget(c71200919.imtg) 
	e2:SetOperation(c71200919.imop) 
	c:RegisterEffect(e2) 
end
function c71200919.thfilter(c)
	if not (c:IsSetCard(0x895) and c:IsType(TYPE_SPELL+TYPE_TRAP)) then return false end
	return c:IsAbleToHand() or c:IsSSetable()
end
function c71200919.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c71200919.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end 
end
function c71200919.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
	local g=Duel.SelectMatchingCard(tp,c71200919.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
	local tc=g:GetFirst()
	if tc then
		if tc:IsAbleToHand() and (not tc:IsSSetable() or Duel.SelectOption(tp,1190,1153)==0) then
			Duel.SendtoHand(tc,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,tc)
		else
			Duel.SSet(tp,tc)
		end
	end
end
function c71200919.imcon(e,tp,eg,ep,ev,re,r,rp) 
	local te,p=Duel.GetChainInfo(ev-1,CHAININFO_TRIGGERING_EFFECT,CHAININFO_TRIGGERING_PLAYER)
	return te and te:GetHandler():IsSetCard(0x895) and te:IsActiveType(TYPE_MONSTER) and p==tp and rp==1-tp
end 
function c71200919.imcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,700) end
	Duel.PayLPCost(tp,700) 
end
function c71200919.imtg(e,tp,eg,ep,ev,re,r,rp,chk) 
	local te,p=Duel.GetChainInfo(ev-1,CHAININFO_TRIGGERING_EFFECT,CHAININFO_TRIGGERING_PLAYER) 
	local tc=te:GetHandler()
	if chk==0 then return tc end  
	Duel.SetTargetCard(tc) 
end
function c71200919.imop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler() 
	local te,p=Duel.GetChainInfo(ev-1,CHAININFO_TRIGGERING_EFFECT,CHAININFO_TRIGGERING_PLAYER) 
	local tc=te:GetHandler()
	if p==tp and tc then 
		if tc:IsRelateToEffect(e) then 
			local e1=Effect.CreateEffect(c) 
			e1:SetType(EFFECT_TYPE_SINGLE) 
			e1:SetCode(EFFECT_IMMUNE_EFFECT) 
			e1:SetOwnerPlayer(tp)
			e1:SetValue(function(e,te) 
			return e:GetOwnerPlayer()~=te:GetOwnerPlayer() end) 
			e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_CHAIN) 
			tc:RegisterEffect(e1) 
			if c:IsRelateToEffect(e) then 
				local e1=Effect.CreateEffect(c) 
				e1:SetType(EFFECT_TYPE_SINGLE) 
				e1:SetCode(EFFECT_IMMUNE_EFFECT) 
				e1:SetOwnerPlayer(tp)
				e1:SetValue(function(e,te) 
				return e:GetOwnerPlayer()~=te:GetOwnerPlayer() end) 
				e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_CHAIN) 
				c:RegisterEffect(e1) 
			end 
		end 
	end 
end 



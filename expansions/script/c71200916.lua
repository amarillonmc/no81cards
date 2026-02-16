--绝音魔女·燃尽之火
function c71200916.initial_effect(c)
	--to hand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(71200916,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetCountLimit(1,71200916)
	e1:SetTarget(c71200916.thtg)
	e1:SetOperation(c71200916.thop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2) 
	--immune 
	local e2=Effect.CreateEffect(c) 
	e2:SetType(EFFECT_TYPE_QUICK_O)  
	e2:SetCode(EVENT_CHAINING) 
	e2:SetRange(LOCATION_HAND+LOCATION_MZONE) 
	e2:SetCountLimit(1,71200871)
	e2:SetCondition(c71200916.imcon) 
	e2:SetCost(c71200916.imcost) 
	e2:SetTarget(c71200916.imtg) 
	e2:SetOperation(c71200916.imop) 
	c:RegisterEffect(e2) 
end
function c71200916.thfilter(c)
	return c:IsSetCard(0x895) and c:IsType(TYPE_MONSTER) and not c:IsCode(71200916) and c:IsAbleToHand()
end
function c71200916.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c71200916.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function c71200916.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c71200916.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c71200916.imcon(e,tp,eg,ep,ev,re,r,rp) 
	local te,p=Duel.GetChainInfo(ev-1,CHAININFO_TRIGGERING_EFFECT,CHAININFO_TRIGGERING_PLAYER)
	return te and te:GetHandler():IsSetCard(0x895) and te:IsActiveType(TYPE_SPELL+TYPE_TRAP) and te:IsHasType(EFFECT_TYPE_ACTIVATE) and p==tp and rp==1-tp
end 
function c71200916.imcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,700) end
	Duel.PayLPCost(tp,700) 
end
function c71200916.imtg(e,tp,eg,ep,ev,re,r,rp,chk) 
	local te,p=Duel.GetChainInfo(ev-1,CHAININFO_TRIGGERING_EFFECT,CHAININFO_TRIGGERING_PLAYER) 
	local tc=te:GetHandler()
	if chk==0 then return tc end  
	Duel.SetTargetCard(tc) 
end
function c71200916.imop(e,tp,eg,ep,ev,re,r,rp)
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







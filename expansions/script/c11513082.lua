--征服斗魂 决战之仪
function c11513082.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c) 
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN) 
	e1:SetCountLimit(1,11513082+EFFECT_COUNT_CODE_OATH)
	c:RegisterEffect(e1)
	--atk
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetRange(LOCATION_FZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetTarget(function(e,c) 
	return c:IsSetCard(0x195) end)
	e2:SetValue(function(e) 
	return (Duel.GetFlagEffect(0,11513082)+Duel.GetFlagEffect(1,11513082))*100 end)
	c:RegisterEffect(e2) 
	-- 
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_TODECK)
	e3:SetType(EFFECT_TYPE_IGNITION) 
	e3:SetRange(LOCATION_FZONE)
	e3:SetCountLimit(1,21513082) 
	e3:SetCost(c11513082.thcost)
	e3:SetTarget(c11513082.thtg)
	e3:SetOperation(c11513082.thop)
	c:RegisterEffect(e3)
end
function c11513082.checkop(e,tp,eg,ep,ev,re,r,rp)  
	local tc=eg:GetFirst()
	while tc do 
		if tc:IsType(TYPE_MONSTER) and not tc:IsPreviousLocation(LOCATION_DECK) then 
			Duel.RegisterFlagEffect(tc:GetControler(),11513082,RESET_PHASE+PHASE_END,0,1) 
		end 
		tc=eg:GetNext()
	end
end
function c11513082.pbfil(c)
	return not c:IsPublic() and c:IsAbleToDeck()
end
function c11513082.thfil(c)
	return c:IsSetCard(0x195) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c11513082.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(c11513082.pbfil,tp,LOCATION_HAND,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local g=Duel.SelectMatchingCard(tp,c11513082.pbfil,tp,LOCATION_HAND,0,1,1,nil)
	Duel.ConfirmCards(1-tp,g)
	Duel.RaiseEvent(g,EVENT_CUSTOM+9091064,e,REASON_COST,tp,tp,0)
	Duel.ShuffleHand(tp)
	Duel.SetTargetCard(g)
end
function c11513082.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c11513082.pbfil,tp,LOCATION_HAND,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end  
function c11513082.thop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler()
	local pc=Duel.GetFirstTarget()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local tc=Duel.SelectMatchingCard(tp,c11513082.thfil,tp,LOCATION_DECK,0,1,1,nil):GetFirst()
	if tc then
		if Duel.SendtoHand(tc,tp,REASON_EFFECT)~=0 then
			Duel.ConfirmCards(1-tp,tc)  
			if pc:IsRelateToEffect(e) then
				Duel.SendtoDeck(pc,nil,2,REASON_EFFECT) 
			end
		end
	end
end
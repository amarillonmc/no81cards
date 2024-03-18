--星空闪耀 稷下学院
function c50001002.initial_effect(c)
	c:EnableCounterPermit(0xe991)
	c:SetCounterLimit(0xe991,6)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--search
	local e2=Effect.CreateEffect(c) 
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1,50001002) 
	e2:SetCost(c50001002.thcost)
	e2:SetTarget(c50001002.thtg)
	e2:SetOperation(c50001002.thop)
	c:RegisterEffect(e2) 
	--add counter
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e0:SetCode(EVENT_CHAINING)
	e0:SetRange(LOCATION_SZONE)
	e0:SetOperation(aux.chainreg)
	c:RegisterEffect(e0)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e1:SetCode(EVENT_CHAIN_SOLVED)
	e1:SetRange(LOCATION_SZONE)
	e1:SetOperation(function(e,tp,eg,ep,ev,re,r,rp)
	if re:GetHandler():IsSetCard(0x99a) and rp==tp and e:GetHandler():GetFlagEffect(1)>0 then
		e:GetHandler():AddCounter(0xe991,1)
	end end) 
	c:RegisterEffect(e1)
	--to hand
	local e3=Effect.CreateEffect(c) 
	e3:SetCategory(CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_LEAVE_FIELD)
	e3:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCountLimit(1,10001002)
	e3:SetCondition(c50001002.thcon2)
	e3:SetTarget(c50001002.thtg2)
	e3:SetOperation(c50001002.thop2)
	c:RegisterEffect(e3)
end
c50001002.SetCard_WK_StarS=true 
function c50001002.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,500) end
	Duel.PayLPCost(tp,500)
end
function c50001002.thfilter(c)
	return c:IsSetCard(0x99a) and c:IsAbleToHand() and not c:IsCode(50001002)
end
function c50001002.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c50001002.thfilter,tp,LOCATION_DECK,0,3,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,0,LOCATION_DECK)
end
function c50001002.thop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	local g=Duel.GetMatchingGroup(c50001002.thfilter,tp,LOCATION_DECK,0,nil)
	if #g>=3 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=g:Select(tp,3,3,nil)
		Duel.ConfirmCards(1-tp,sg)
		Duel.ShuffleDeck(tp)
		local tg=sg:RandomSelect(1-tp,1)
		tg:GetFirst():SetStatus(STATUS_TO_HAND_WITHOUT_CONFIRM,true)
		Duel.SendtoHand(tg,nil,REASON_EFFECT)
	end
end
function c50001002.thcfilter(c,tp)
	return c:IsSetCard(0x99a) and c:IsPreviousControler(tp) and c:IsPreviousLocation(LOCATION_MZONE) and c:IsPreviousPosition(POS_FACEUP) and c:GetReasonPlayer()==1-tp and not c:IsReason(REASON_RULE)
end
function c50001002.thcon2(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c50001002.thcfilter,1,nil,tp)
end
function c50001002.thfilter2(c)
	return c:IsSetCard(0x99a) and c:IsType(TYPE_QUICKPLAY) and c:IsAbleToHand()
end
function c50001002.thtg2(e,tp,eg,ep,ev,re,r,rp,chk)
	local x=e:GetHandler():GetCounter(0xe991)   
	if chk==0 then return x>0 and e:GetHandler():IsCanRemoveCounter(tp,0xe991,x,REASON_EFFECT) and Duel.IsExistingMatchingCard(c50001002.thfilter2,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE)
end
function c50001002.thop2(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	local x=c:GetCounter(0xe991)   
	if c:IsRelateToEffect(e) and x>0 and c:IsCanRemoveCounter(tp,0xe991,x,REASON_EFFECT) then  
		c:RemoveCounter(tp,0xe991,x,REASON_EFFECT) 
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.GetMatchingGroup(aux.NecroValleyFilter(c50001002.thfilter2),tp,LOCATION_GRAVE,0,nil)
		local sg=g:SelectSubGroup(tp,aux.dncheck,false,1,x) 
		if sg and Duel.SendtoHand(sg,nil,REASON_EFFECT)>0 then
			Duel.ConfirmCards(1-tp,sg)
		end 
	end 
end






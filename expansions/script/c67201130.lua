--基鲁特利之王 托吉古・基鲁特利
function c67201130.initial_effect(c)
	--search
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(67201130,3))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCost(c67201130.thcost)
	e1:SetTarget(c67201130.thtg)
	e1:SetOperation(c67201130.thop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_DRAW)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	c:RegisterEffect(e2) 
	--search
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(67201130,0))
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_CUSTOM+67201130)
	e3:SetRange(LOCATION_HAND)
	e3:SetCountLimit(1,67201130)
	e3:SetCondition(c67201130.opcon)
	e3:SetCost(c67201130.opcost)
	e3:SetTarget(c67201130.optg)
	e3:SetOperation(c67201130.opop)
	c:RegisterEffect(e3) 
	if not c67201130.global_check then
		c67201130.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_TO_HAND)
		ge1:SetCondition(c67201130.regcon)
		ge1:SetOperation(c67201130.regop)
		Duel.RegisterEffect(ge1,0)
	end 
end
function c67201130.regfilter(c,tp)
	return c:IsControler(tp) and c:IsPreviousLocation(LOCATION_DECK)
end
function c67201130.regcon(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetCurrentPhase()==0 then return false end
	local v=0
	if eg:IsExists(c67201130.regfilter,1,nil,0) then v=v+1 end
	if eg:IsExists(c67201130.regfilter,1,nil,1) then v=v+2 end
	if v==0 then return false end
	e:SetLabel(({0,1,PLAYER_ALL})[v])
	return true
end
function c67201130.regop(e,tp,eg,ep,ev,re,r,rp)
	Duel.RaiseEvent(eg,EVENT_CUSTOM+67201130,re,r,rp,ep,e:GetLabel())
end
--
function c67201130.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsDiscardable() end
	Duel.SendtoGrave(c,REASON_COST+REASON_DISCARD)
end
function c67201130.thfilter(c)
	return c:IsCode(67201128) and c:IsAbleToHand()
end
function c67201130.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(c67201130.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c67201130.thop(e,tp,eg,ep,ev,re,r,rp)
	local tg=Duel.GetFirstMatchingCard(c67201130.thfilter,tp,LOCATION_DECK,0,nil)
	if tg then
		Duel.SendtoHand(tg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tg)
	end
end
--
function c67201130.opcon(e,tp,eg,ep,ev,re,r,rp)
	return ev==tp or ev==1-tp or ev==PLAYER_ALL
end
function c67201130.drfilter(c,tp)
	return c:IsAbleToGraveAsCost() and c:IsSetCard(0x3670)
end
function c67201130.opcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToGraveAsCost() and Duel.IsExistingMatchingCard(c67201130.drfilter,tp,LOCATION_HAND,0,1,c,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c67201130.drfilter,tp,LOCATION_HAND,0,1,1,c,tp)+c
	Duel.SendtoGrave(g,REASON_COST)
end

function c67201130.optg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return true end
end
function c67201130.opop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local b1=true
	local b2=true
	local op=0
	if b1 and b2 then op=Duel.SelectOption(tp,aux.Stringid(67201130,1),aux.Stringid(67201130,2))
	elseif b1 then op=Duel.SelectOption(tp,aux.Stringid(67201130,1))
	elseif b2 then op=Duel.SelectOption(tp,aux.Stringid(67201130,2))+1
	else return end
	if op==0 then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
		--e1:SetProperty(EFFECT_FLAG_DELAY)
		e1:SetCode(EVENT_CHAIN_SOLVING)
		e1:SetCondition(c67201130.thcon2)
		e1:SetOperation(c67201130.thop2)
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
	else
		local e4=Effect.CreateEffect(e:GetHandler())
		e4:SetType(EFFECT_TYPE_FIELD)
		e4:SetCode(EFFECT_CANNOT_TO_HAND)
		e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e4:SetTargetRange(1,1)
		e4:SetTarget(aux.TargetBoolFunction(Card.IsLocation,LOCATION_DECK))
		e4:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e4,tp)
	end
end
--
function c67201130.thfilter1(c)
	return c:IsSetCard(0x3670) and c:IsAbleToHand()
end
function c67201130.thcon2(e,tp,eg,ep,ev,re,r,rp)
	return re:IsHasCategory(CATEGORY_DRAW) and Duel.IsExistingMatchingCard(c67201130.thfilter1,tp,LOCATION_DECK,0,1,nil)
end
function c67201130.thop2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,67201130)
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(67201130,4))
	local g=Duel.SelectMatchingCard(tp,c67201130.thfilter1,tp,LOCATION_DECK,0,1,1,nil)
	local tc=g:GetFirst()
	if tc then
		Duel.ShuffleDeck(tp)
		Duel.MoveSequence(tc,SEQ_DECKTOP)
		Duel.ConfirmDecktop(tp,1)
	end
end

local s, id = GetID()--诛仙剑阵·戮仙
function s.initial_effect(c)
 
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(id,0))
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_TRAP_ACT_IN_SET_TURN)
	e4:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e4:SetCondition(s.actcon)
	c:RegisterEffect(e4)

	local e1=Effect.CreateEffect(c)
	e1:SetHintTiming(TIMINGS_CHECK_MONSTER)
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(s.targett)
	e1:SetOperation(s.activatee)
	c:RegisterEffect(e1)   

	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,0))
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_REMOVE)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1,id)
	e2:SetCondition(s.condtion)   
	e2:SetTarget(s.target)
	e2:SetOperation(s.activate)
	e2:SetCategory(CATEGORY_DISABLE)	 
	c:RegisterEffect(e2)



	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_SEARCH) 
	e3:SetRange(LOCATION_REMOVED)   
	e3:SetTarget(s.thtg)
	e3:SetOperation(s.thop)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetDescription(aux.Stringid(id,1)) 
	e3:SetCountLimit(1,9540031) 
	e3:SetCode(EVENT_FREE_CHAIN)		
	e3:SetCondition(aux.dscon)
	e3:SetCost(s.atkcost) 
	e3:SetCondition(s.actcon) 
	c:RegisterEffect(e3)
end

--4
function s.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x954)
end
function s.actcon(e)
	return Duel.IsExistingMatchingCard(s.cfilter,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil)
end


--1
function s.targett(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemove() end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,e:GetHandler(),1,0,0)
end
function s.activatee(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		c:CancelToGrave()
		Duel.Remove(c,nil,POS_FACEUP,REASON_EFFECT)
	end
end


--3
function s.atkcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToGraveAsCost() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST)
end
function s.thfilter(c)
	return c:IsSetCard(0x954) and c:IsAbleToHand()
end

function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(s.thfilter),tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end

--t
function s.condtion(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_DECK + LOCATION_SZONE)
end

--2

function s.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsFaceup() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,g,1,0,0)
end

function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then
		Duel.NegateRelatedChain(tc,RESET_TURN_SET)   
		local e5=Effect.CreateEffect(c)  
		e5:SetType(EFFECT_TYPE_SINGLE)
		e5:SetCode(EFFECT_DISABLE)
		e5:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e5)
  
		local e6=Effect.CreateEffect(c) 
		e6:SetType(EFFECT_TYPE_SINGLE)  
		e6:SetCode(EFFECT_DISABLE_EFFECT)
		e6:SetValue(RESET_TURN_SET)
		e6:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e6)
	end  
end
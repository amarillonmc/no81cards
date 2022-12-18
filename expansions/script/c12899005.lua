--H.P.T.-001
local m=12899005
local cm=_G["c"..m]
function cm.initial_effect(c)
	c:SetUniqueOnField(1,0,m)
	--act in set turn
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_TRAP_ACT_IN_SET_TURN)
	e0:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e0:SetCondition(cm.actcon)
	c:RegisterEffect(e0)  
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--activate (return)
	local e12=Effect.CreateEffect(c)
	e12:SetDescription(aux.Stringid(m,1))
	e12:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e12:SetType(EFFECT_TYPE_ACTIVATE)
	e12:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e12:SetCode(EVENT_FREE_CHAIN)
	e12:SetCountLimit(1,EFFECT_COUNT_CODE_SINGLE)
	e12:SetHintTiming(0,TIMING_MAIN_END)
	e12:SetCondition(cm.thcon)
	e12:SetTarget(cm.thtg)
	e12:SetOperation(cm.thop)
	c:RegisterEffect(e12)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,1))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCountLimit(1,EFFECT_COUNT_CODE_SINGLE)
	e2:SetHintTiming(0,TIMING_MAIN_END)
	e2:SetCondition(cm.thcon)
	e2:SetTarget(cm.thtg)
	e2:SetOperation(cm.thop)
	c:RegisterEffect(e2)  
	--tograve and immune
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,2))
	e3:SetCategory(CATEGORY_TOGRAVE)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetCountLimit(1)
	--e3:SetCondition(cm.tgcon)
	e3:SetTarget(cm.tgtg)
	e3:SetOperation(cm.tgop)
	c:RegisterEffect(e3)
end
--act in set turn
function cm.cfilter(c)
	return not c:IsSetCard(0x5a71) 
end
function cm.actcon(e)
	return Duel.GetFieldGroupCount(e:GetHandlerPlayer(),LOCATION_MZONE,0)==0 or not Duel.IsExistingMatchingCard(cm.cfilter,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil)
end
--tohand
function cm.thcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp and (Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2)
end
function cm.thfilter(c)
	return c:IsSetCard(0x5a71,0x6a71) and c:IsAbleToHand()
end
function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function cm.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,cm.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
--tograve
function cm.tgcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==1-tp
end
function cm.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToGrave,tp,LOCATION_HAND,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_HAND)
end
function cm.tgop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,Card.IsAbleToGrave,tp,LOCATION_HAND,0,1,1,nil)
	if Duel.SendtoGrave(g,REASON_EFFECT)>0 then
		local c=e:GetHandler()
		--cannot be target
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_FIELD)
		e3:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
		e3:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
		e3:SetTargetRange(LOCATION_ONFIELD,0)
		e3:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x5a71,0x6a71))
		e3:SetValue(aux.tgoval)
		e3:SetReset(RESET_PHASE+PHASE_END)
		c:RegisterEffect(e3,tp)
	end
end














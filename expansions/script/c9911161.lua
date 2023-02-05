--溯雪触情的街道
function c9911161.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,9911161+EFFECT_COUNT_CODE_OATH)
	e1:SetOperation(c9911161.activate)
	c:RegisterEffect(e1)
	--cannot remove
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_REMOVE)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTargetRange(0,1)
	e2:SetCondition(c9911161.limcon)
	e2:SetTarget(c9911161.rmlimit)
	c:RegisterEffect(e2)
	--set
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(9911161,0))
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_SUMMON_SUCCESS)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetRange(LOCATION_GRAVE)
	e4:SetCountLimit(1,9911162)
	e4:SetCondition(aux.exccon)
	e4:SetCost(c9911161.setcost)
	e4:SetTarget(c9911161.settg)
	e4:SetOperation(c9911161.setop)
	c:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e5)
end
function c9911161.thfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x3958) and c:IsAbleToHand()
end
function c9911161.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c9911161.thfilter,tp,LOCATION_DECK,0,nil)
	if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(9911161,1)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=g:Select(tp,1,1,nil)
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg)
	end
end
function c9911161.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x3958) and c:IsType(TYPE_XYZ)
end
function c9911161.limcon(e)
	local tp=e:GetHandlerPlayer()
	return Duel.IsExistingMatchingCard(c9911161.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c9911161.rmlimit(e,c)
	return c:IsLocation(LOCATION_ONFIELD+LOCATION_GRAVE)
end
function c9911161.costfilter(c)
	return c:IsSetCard(0x3958) and c:IsAbleToGraveAsCost()
end
function c9911161.setcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local fe=Duel.IsPlayerAffectedByEffect(tp,9911163)
	local b1=fe and Duel.IsExistingMatchingCard(c9911161.costfilter,tp,LOCATION_DECK,0,1,nil)
	local b2=Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil)
	if chk==0 then return b1 or b2 end
	if b1 and (not b2 or Duel.SelectYesNo(tp,aux.Stringid(9911163,1))) then
		Duel.Hint(HINT_CARD,0,9911163)
		fe:UseCountLimit(tp)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local g=Duel.SelectMatchingCard(tp,c9911161.costfilter,tp,LOCATION_DECK,0,1,1,nil)
		Duel.SendtoGrave(g,REASON_COST)
	else
		Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)
	end
end
function c9911161.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0 end
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,e:GetHandler(),1,0,0)
end
function c9911161.setop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.MoveToField(c,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
	end
end

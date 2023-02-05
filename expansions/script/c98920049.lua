--圣星辉龙-神数星圣
function c98920049.initial_effect(c)
   --xyz summon
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsXyzType,TYPE_PENDULUM),4,3)
	c:EnableReviveLimit()
	aux.EnablePendulumAttribute(c,false)
	--reg
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(98920049,0))
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetCost(c98920049.cost)
	e3:SetOperation(c98920049.operation)
	c:RegisterEffect(e3)
--tohand
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e3:SetRange(LOCATION_PZONE)
	e3:SetCountLimit(1,98920049)
	e3:SetCondition(c98920049.thcon)
	e3:SetTarget(c98920049.thtg)
	e3:SetOperation(c98920049.thop)
	c:RegisterEffect(e3) 
  --tohand
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_TODECK)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_PHASE+PHASE_END)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,98920049)
	e3:SetCondition(c98920049.tdcon)
	e3:SetTarget(c98920049.tdtg)
	e3:SetOperation(c98920049.tdop)
	c:RegisterEffect(e3)
end
c98920049.pendulum_level=7
function c98920049.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c98920049.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetTargetRange(1,1)
	e2:SetTarget(c98920049.splimit)
	e2:SetReset(RESET_PHASE+PHASE_END+RESET_OPPO_TURN)
	Duel.RegisterEffect(e2,tp)

end
function c98920049.splimit(e,c)
	return c:IsLocation(LOCATION_HAND+LOCATION_GRAVE) and c:IsType(TYPE_MONSTER)
end
function c98920049.thcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end
function c98920049.filter(c)
	return c:IsSetCard(0xc4,0x9c,0x53) and c:IsAbleToHand()
end
function c98920049.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c98920049.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c98920049.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c98920049.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c98920049.tdcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=tp
end
function c98920049.tdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local g=Duel.GetMatchingGroup(c98920049.tdfilter,tp,0,LOCATION_MZONE+LOCATION_GRAVE,nil)
	if g:GetCount()>0 then
		Duel.SetOperationInfo(0,CATEGORY_TODECK,g,1,0,0)
	end
end
function c98920049.tdop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,c98920049.tdfilter,tp,0,LOCATION_MZONE+LOCATION_GRAVE,1,1,nil)
	local tc=g:GetFirst()
	local c=e:GetHandler()
	if tc and Duel.SendtoDeck(tc,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)~=0 then
		if (Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1))
			and c:IsRelateToEffect(e) and c:IsFaceup()
			and Duel.SelectEffectYesNo(tp,c,aux.Stringid(67865534,3)) then
			Duel.MoveToField(c,tp,tp,LOCATION_PZONE,POS_FACEUP,true)
		end
	end
end
function c98920049.spfilter(c,e,tp)
	return c:IsType(TYPE_MONSTER) and c:IsAbleToDeck()
end
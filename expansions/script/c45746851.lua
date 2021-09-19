--营地
function c45746851.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,45746851+EFFECT_COUNT_CODE_OATH)
	c:RegisterEffect(e1)

	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(45746851,0))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_FZONE)
	e2:SetCountLimit(1)
	e2:SetCondition(c45746851.spcon1)
	e2:SetTarget(c45746851.thtg)
	e2:SetOperation(c45746851.thop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetHintTiming(0,TIMING_END_PHASE)
	e3:SetCondition(c45746851.spcon2)
	c:RegisterEffect(e3) 

  --  local e4=Effect.CreateEffect(c)
   -- e4:SetDescription(aux.Stringid(45746851,0))
   -- e4:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
   -- e4:SetType(EFFECT_TYPE_IGNITION)
  --  e4:SetRange(LOCATION_FZONE)
  --  e4:SetCost(c45746851.thcost)
   -- e4:SetTarget(c45746851.thtg1)
   -- e4:SetOperation(c45746851.thop1)
   -- c:RegisterEffect(e4)
end
function c45746851.spcon1(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsPlayerAffectedByEffect(tp,45746905)
end
function c45746851.spcon2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsPlayerAffectedByEffect(tp,45746905)
end
--e3
function c45746851.thfilter(c)
	return c:IsSetCard(0x88e) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c45746851.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c45746851.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c45746851.thop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c45746851.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
--e4
--function c45746851.thcost(e,tp,eg,ep,ev,re,r,rp)
 --   local c=e:GetHandler()
  --  return rp==1-tp and c:IsReason(REASON_EFFECT) and c:IsPreviousPosition(POS_FACEUP) and c:IsPreviousControler(tp)
--end
--function c45746851.thfilter(c)
  --  return c:IsCode(45746852) and c:IsAbleToHand()
--end
--function c45746851.thtg1(e,tp,eg,ep,ev,re,r,rp,chk)
 --   if chk==0 then return Duel.IsExistingMatchingCard(c45746851.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
  --  Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
--end
--function c45746851.thop1(e,tp,eg,ep,ev,re,r,rp)
  --  if not e:GetHandler():IsRelateToEffect(e) then return end
  --  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
 --   local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c45746851.thfilter),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
  --  if g:GetCount()>0 then
  --	  Duel.SendtoHand(g,nil,REASON_EFFECT)
  --	  Duel.ConfirmCards(1-tp,g)
  --  end
--end
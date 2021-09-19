--海滩
function c45746852.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,45746852+EFFECT_COUNT_CODE_OATH)
	c:RegisterEffect(e1)



	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_EQUIP)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
	e2:SetRange(LOCATION_FZONE)
	e2:SetCountLimit(1,EFFECT_COUNT_CODE_SINGLE)
	e2:SetCondition(c45746852.lkcon)
	e2:SetTarget(c45746852.target)
	e2:SetOperation(c45746852.activate)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetHintTiming(0,TIMING_END_PHASE)
	e3:SetCondition(c45746852.spcon2)
	c:RegisterEffect(e3) 

--  local e4=Effect.CreateEffect(c)
   -- e4:SetDescription(aux.Stringid(45746852,0))
   -- e4:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
  --  e4:SetType(EFFECT_TYPE_IGNITION)
  --  e4:SetRange(LOCATION_FZONE)
 --   e4:SetCost(c45746852.thcost)
  --  e4:SetTarget(c45746852.thtg)
 --   e4:SetOperation(c45746852.thop)
 --   c:RegisterEffect(e4)
end
--e3
function c45746852.lkcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=tp
		and (Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2)
end
function c45746852.spcon2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsPlayerAffectedByEffect(tp,45746905)
end

function c45746852.filter(c,tp)
	return c:IsFaceup() and Duel.IsExistingMatchingCard(c45746852.eqfilter,tp,LOCATION_DECK,0,1,nil,c,tp)
end
function c45746852.eqfilter(c,tc,tp)
	return c:IsType(TYPE_EQUIP) and c:CheckEquipTarget(tc) and c:IsSetCard(0x88e) and c:CheckUniqueOnField(tp) and not c:IsForbidden()
end
function c45746852.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c45746852.filter(chkc,tp) end
	if chk==0 then return Duel.IsExistingTarget(c45746852.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c45746852.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil,tp)
end
function c45746852.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
		local g=Duel.SelectMatchingCard(tp,c45746852.eqfilter,tp,LOCATION_DECK,0,1,1,nil,tc,tp)
		if g:GetCount()>0 then
			Duel.Equip(tp,g:GetFirst(),tc)
		end
	end
end
--e4
--function c45746852.thcost(e,tp,eg,ep,ev,re,r,rp)
 --   local c=e:GetHandler()
  --  return rp==1-tp and c:IsReason(REASON_EFFECT) and c:IsPreviousPosition(POS_FACEUP) and c:IsPreviousControler(tp)
--end
--function c45746852.thfilter(c)
  --  return c:IsCode(45746851) and c:IsAbleToHand()
--end
--function c45746852.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
 --   if chk==0 then return Duel.IsExistingMatchingCard(c45746852.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
--  Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
--end
--function c45746852.thop(e,tp,eg,ep,ev,re,r,rp)
 --   if not e:GetHandler():IsRelateToEffect(e) then return end
  --  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
  --  local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c45746852.thfilter),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
   -- if g:GetCount()>0 then
   --   Duel.SendtoHand(g,nil,REASON_EFFECT)
  --	  Duel.ConfirmCards(1-tp,g)
 --   end
--end
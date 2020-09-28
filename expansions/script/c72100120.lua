--音响战士 智能机
function c72100120.initial_effect(c)
  local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetTarget(c72100120.seatg)
	e2:SetOperation(c72100120.seaop)
	c:RegisterEffect(e2)
  local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(72100120,1))
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_GRAVE)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetCost(aux.bfgcost)
	e4:SetTarget(c72100120.sptg2)
	e4:SetOperation(c72100120.spop2)
	c:RegisterEffect(e4)
end
function c72100120.spfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x1066)
end
function c72100120.seatg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
  if chkc then return chkc:IsOnField() and chkc:IsControler(tp) end
  if chk==0 then return Duel.IsExistingTarget(c72100120.tg,tp,LOCATION_ONFIELD,0,1,nil) end
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
  local g=Duel.SelectTarget(tp,c72100120.tg,tp,LOCATION_ONFIELD,0,1,1,nil)
  Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c72100120.tg(c)
  return c:IsFaceup() and c:IsSetCard(0x1066) 
end
function c72100120.seaop(e,tp,eg,ep,ev,re,r,rp)
  local tc=Duel.GetFirstTarget()
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
  local g=Duel.SelectMatchingCard(tp,c72100120.filter,tp,LOCATION_DECK,0,0,1,nil)
  if g:GetCount()>0 then
  Duel.SendtoHand(g,nil,REASON_EFFECT)
  Duel.ConfirmCards(1-tp,g)
  end
end
function c72100120.filter(c)
  return c:IsSetCard(0x1066)
end
-----
function c72100120.spfilter1(c,e,tp)
	return c:IsSetCard(0x1066) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c72100120.sptg2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_GRAVE) and c72100120.spfilter1(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c72100120.spfilter1,tp,LOCATION_GRAVE,0,1,e:GetHandler(),e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c72100120.spfilter1,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c72100120.spop2(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
end
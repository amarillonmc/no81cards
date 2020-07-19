--超热血跑者
function c31400002.initial_effect(c)
  local e1=Effect.CreateEffect(c)
  e1:SetType(EFFECT_TYPE_FIELD)
  e1:SetCode(EFFECT_SPSUMMON_PROC)
  e1:SetRange(LOCATION_HAND)
  e1:SetCondition(c31400002.spcon)
  e1:SetValue(1)
  c:RegisterEffect(e1)
  local e2=Effect.CreateEffect(c)
  e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
  e2:SetType(EFFECT_TYPE_IGNITION)
  e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
  e2:SetRange(LOCATION_MZONE)
  e2:SetCountLimit(1,31400002)
  e2:SetTarget(c31400002.seatg)
  e2:SetOperation(c31400002.seaop)
  c:RegisterEffect(e2)
end
function c31400002.spcon(e,c)
  if c==nil then return true end
  return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
	and Duel.IsExistingMatchingCard(c31400002.spfilter,c:GetControler(),LOCATION_MZONE,0,1,nil)
end
function c31400002.spfilter(c)
	return c:IsFaceup() and c:IsRace(RACE_WARRIOR) and c:GetLevel()==3 and c:IsAttribute(ATTRIBUTE_FIRE)
end
function c31400002.seatg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
  if chkc then return chkc:IsOnField() and chkc:IsControler(tp) end
  if chk==0 then return Duel.IsExistingTarget(c31400002.tg,tp,LOCATION_ONFIELD,0,1,nil) end
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
  local g=Duel.SelectTarget(tp,c31400002.tg,tp,LOCATION_ONFIELD,0,1,1,nil)
  Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c31400002.tg(c)
  return c:IsFaceup() and c:IsRace(RACE_WARRIOR) and c:GetLevel()==3 and c:IsAttribute(ATTRIBUTE_FIRE) and c:GetAttack()>=500
end
function c31400002.seaop(e,tp,eg,ep,ev,re,r,rp)
  local tc=Duel.GetFirstTarget()
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
  local g=Duel.SelectMatchingCard(tp,c31400002.filter,tp,LOCATION_DECK,0,0,math.floor(tc:GetAttack()/500),nil)
  if g:GetCount()>0 then
  Duel.SendtoHand(g,nil,REASON_EFFECT)
  Duel.ConfirmCards(1-tp,g)
  end
end
function c31400002.filter(c)
  return c:IsRace(RACE_WARRIOR) and c:GetLevel()==3 and c:IsAttribute(ATTRIBUTE_FIRE)
end
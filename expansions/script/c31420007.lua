local m=31420007
local cm=_G["c"..m]
cm.name="时计塔的公理"
function cm.initial_effect(c)
  local e1=Effect.CreateEffect(c)
  e1:SetType(EFFECT_TYPE_ACTIVATE)
  e1:SetCode(EVENT_FREE_CHAIN)
  e1:SetOperation(cm.activate)
  c:RegisterEffect(e1)
  local e2=Effect.CreateEffect(c)
  e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
  e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
  e2:SetProperty(EFFECT_FLAG_DELAY)
  e2:SetRange(LOCATION_FZONE)
  e2:SetCountLimit(1,31420007)
  e2:SetCode(EVENT_TO_HAND)
  e2:SetCondition(cm.spcon)
  e2:SetCost(cm.spcost)
  e2:SetOperation(cm.spop)
  c:RegisterEffect(e2)
end
function cm.actfilter(c,e,tp)
  return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x5311) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
  if not e:GetHandler():IsRelateToEffect(e) or Duel.GetMZoneCount(tp)<=0 then return end
  local g=Duel.GetMatchingGroup(cm.actfilter,tp,LOCATION_HAND,0,nil,e,tp)
  if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(31420007,0)) then
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sg=g:Select(tp,1,1,nil)
	Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
  end
end
function cm.spfilter1(c)
  return c:IsPreviousLocation(LOCATION_MZONE) and c:IsSetCard(0x5311) and c:IsType(TYPE_MONSTER)
end
function cm.spfilter2(c,e,tp)
  return c:IsSetCard(0x5311) and c:IsType(TYPE_MONSTER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function cm.spcon(e,tp,eg,ep,ev,re,r,rp)
  return eg:IsExists(cm.spfilter1,1,nil) and Duel.IsExistingMatchingCard(cm.spfilter2,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,1,nil,e,tp) and Duel.GetMZoneCount(tp)>0
end
function cm.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return e:GetHandler():IsAbleToHandAsCost() end
  Duel.SendtoHand(e:GetHandler(),tp,REASON_COST)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
  if Duel.GetMZoneCount(tp)<=0 then return end
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
  local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(cm.spfilter2),tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,e,tp)
  if g:GetCount()>0 then
	Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
  end
end
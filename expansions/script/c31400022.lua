local m=31400022
local cm=_G["c"..m]
cm.name="娱乐伙伴 异色眼时空之灵摆魔术师"
function cm.initial_effect(c)
  aux.EnablePendulumAttribute(c)  
  local e2=Effect.CreateEffect(c)
  e2:SetType(EFFECT_TYPE_FIELD)
  e2:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
  e2:SetRange(LOCATION_PZONE)
  e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
  e2:SetTargetRange(LOCATION_MZONE,0)
  e2:SetTarget(aux.TargetBoolFunction(Card.IsRace,RACE_SPELLCASTER))
  e2:SetValue(cm.evalue)
  c:RegisterEffect(e2)
  local e3=Effect.CreateEffect(c)
  e3:SetDescription(aux.Stringid(31400022,0))
  e3:SetCategory(CATEGORY_DESTROY)
  e3:SetType(EFFECT_TYPE_QUICK_O)
  e3:SetCode(EVENT_FREE_CHAIN)
  e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
  e3:SetRange(LOCATION_PZONE)
  e3:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
  e3:SetCountLimit(1,31400022)
  e3:SetCondition(cm.descon)
  e3:SetTarget(cm.destg)
  e3:SetOperation(cm.desop)
  c:RegisterEffect(e3)
end
function cm.evalue(e,re,rp)
  return re:IsActiveType(TYPE_TRAP) and rp==1-e:GetHandlerPlayer()
end
function cm.desfilter(c)
  return c:IsFaceup() and c:IsSetCard(0x98) and c:IsType(TYPE_PENDULUM)
end
function cm.descon(e)
	return Duel.GetTurnCount()~=e:GetHandler():GetTurnID()
end
function cm.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
  if chkc then return false end
  if chk==0 then return Duel.IsExistingTarget(cm.desfilter,tp,LOCATION_MZONE+LOCATION_PZONE,0,1,nil)
	and Duel.IsExistingTarget(nil,tp,0,LOCATION_ONFIELD,1,nil) end
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
  local g1=Duel.SelectTarget(tp,cm.desfilter,tp,LOCATION_MZONE+LOCATION_PZONE,0,1,1,nil)
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
  local g2=Duel.SelectTarget(tp,nil,tp,0,LOCATION_ONFIELD,1,1,nil)
  g1:Merge(g2)
  Duel.SetOperationInfo(0,CATEGORY_DESTROY,g1,2,0,0)
end
function cm.desop(e,tp,eg,ep,ev,re,r,rp)
  if not e:GetHandler():IsRelateToEffect(e) then return end
  local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
  if Duel.Destroy(g,REASON_EFFECT)~=2 then
	local g2=Duel.GetFieldGroup(tp,LOCATION_ONFIELD,LOCATION_ONFIELD)
	if g2:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(31400022,1)) then
	  Duel.BreakEffect()
	  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	  local sg=g2:Select(tp,1,1,nil)
	  Duel.HintSelection(sg)
	  Duel.SendtoGrave(sg,REASON_EFFECT)
	end
  end
end

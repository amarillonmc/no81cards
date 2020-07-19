local m=31400012
local cm=_G["c"..m]
cm.name="永恒的温柔"
function cm.initial_effect(c)   
  local e1=Effect.CreateEffect(c)
  e1:SetCategory(CATEGORY_DESTROY)
  e1:SetType(EFFECT_TYPE_ACTIVATE)
  e1:SetCode(EVENT_FREE_CHAIN)
  e1:SetHintTiming(0,TIMING_END_PHASE+TIMING_EQUIP)
  e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
  e1:SetCost(cm.cost)
  e1:SetTarget(cm.target)
  e1:SetOperation(cm.activate)
  c:RegisterEffect(e1)
  --act in set turn
  local e2=Effect.CreateEffect(c)
  e2:SetType(EFFECT_TYPE_SINGLE)
  e2:SetCode(EFFECT_QP_ACT_IN_SET_TURN)
  e2:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
  c:RegisterEffect(e2)
end
function cm.filter(c)
  return c:IsType(TYPE_MONSTER)
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return Duel.CheckLPCost(tp,1000) end
  Duel.PayLPCost(tp,1000)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
  if chkc then return chkc:IsOnField() and cm.filter(chkc) and chkc~=e:GetHandler() end
  if chk==0 then return Duel.IsExistingTarget(cm.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,e:GetHandler()) end
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
  local g=Duel.SelectTarget(tp,cm.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,e:GetHandler())
  Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
  local tc=Duel.GetFirstTarget()
  if tc:IsRelateToEffect(e) then
	Duel.Destroy(tc,REASON_EFFECT)
  end
  local c=e:GetHandler()
  if c:IsRelateToEffect(e) and c:IsCanTurnSet() then
	Duel.BreakEffect()
	c:CancelToGrave()
	Duel.ChangePosition(c,POS_FACEDOWN)
	Duel.RaiseEvent(c,EVENT_SSET,e,REASON_EFFECT,tp,tp,0)
  end
end
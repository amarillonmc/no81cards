local m=31400010
local cm=_G["c"..m]
cm.name="机界骑士 阿斯特拉姆"
function cm.initial_effect(c)
  c:SetSPSummonOnce(31400010)
  aux.AddLinkProcedure(c,nil,1,1) 
  local e1=Effect.CreateEffect(c)
  e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
  e1:SetType(EFFECT_TYPE_TRIGGER_F+EFFECT_TYPE_SINGLE)
  e1:SetCode(EVENT_SPSUMMON_SUCCESS)
  e1:SetTarget(cm.seatg)
  e1:SetOperation(cm.seaop)
  c:RegisterEffect(e1)  
  local e2=Effect.CreateEffect(c)
  e2:SetType(EFFECT_TYPE_QUICK_O)
  e2:SetCode(EVENT_FREE_CHAIN)
  e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
  e2:SetRange(LOCATION_MZONE)
  e2:SetCountLimit(1)
  e2:SetTarget(cm.seqtg)
  e2:SetOperation(cm.seqop)
  c:RegisterEffect(e2) 
end
function cm.filter(c)
  return c:IsSetCard(0x10c)
end
function cm.splimit(e,c)
  return not c:IsSetCard(0x10c)
end
function cm.seqfilter(c,g)
  return g:IsContains(c) and c:IsType(TYPE_MONSTER)
end
function cm.seatg(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_DECK,0,1,nil) end
  Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function cm.seaop(e,tp,eg,ep,ev,re,r,rp)
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
  local g=Duel.SelectMatchingCard(tp,cm.filter,tp,LOCATION_DECK,0,1,1,nil)
  if g:GetCount()>0 then
	Duel.SendtoHand(g,nil,REASON_EFFECT)
	Duel.ConfirmCards(1-tp,g)
  end
  local e1=Effect.CreateEffect(e:GetHandler())
  e1:SetType(EFFECT_TYPE_FIELD)
  e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
  e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
  e1:SetTargetRange(1,0)
  e1:SetTarget(cm.splimit)
  e1:SetReset(RESET_PHASE+PHASE_END)
  Duel.RegisterEffect(e1,tp)
end
function cm.seqtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
  local cg=e:GetHandler():GetColumnGroup()
  Group.AddCard(cg,e:GetHandler())
  if chkc then return chkc:IsOnField() and cm.seqfilter(chkc,cg) end
  if chk==0 then return Duel.IsExistingTarget(cm.seqfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil,cg) end
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
  local g=Duel.SelectTarget(tp,cm.seqfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil,cg)
end
function cm.seqop(e,tp,eg,ep,ev,re,r,rp)
  local tc=Duel.GetFirstTarget()
  if not tc:IsRelateToEffect(e) or Duel.GetLocationCount(tc:GetControler(),LOCATION_MZONE)<=0 then return end
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOZONE)
  if tc:GetControler()==e:GetHandler():GetControler() then
	local s=Duel.SelectDisableField(tp,1,LOCATION_MZONE,0,0)
	local nseq=math.log(s,2)
	Duel.MoveSequence(tc,nseq)
  else
	local s=Duel.SelectDisableField(tp,1,0,LOCATION_MZONE,0)
	local nseq=math.log(bit.rshift(s,16),2)
	Duel.MoveSequence(tc,nseq)
  end
end
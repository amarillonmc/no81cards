local m=31400024
local cm=_G["c"..m]
cm.name="武神姬-淡岛"
function cm.initial_effect(c)
  c:SetUniqueOnField(1,0,31400024)
  aux.AddLinkProcedure(c,cm.lmfilter1,2,2,cm.lmfilter2)
  c:EnableReviveLimit()
  local e1=Effect.CreateEffect(c)
  e1:SetType(EFFECT_TYPE_SINGLE)
  e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
  e1:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
  e1:SetValue(1)
  c:RegisterEffect(e1)
  local e2=Effect.CreateEffect(c)
  e2:SetType(EFFECT_TYPE_SINGLE)
  e2:SetCode(EFFECT_MATERIAL_CHECK)
  e2:SetValue(cm.matcheck)
  c:RegisterEffect(e2)
  local e3=Effect.CreateEffect(c)
  e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
  e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
  e3:SetCode(EVENT_SPSUMMON_SUCCESS)
  e3:SetCondition(cm.xyzcon)
  e3:SetCost(cm.xyzcost)
  e3:SetOperation(cm.xyzop)
  e3:SetLabelObject(e2)
  c:RegisterEffect(e3)
  e2:SetLabelObject(e3)
  local e4=Effect.CreateEffect(c)
  e4:SetCategory(CATEGORY_DESTROY)
  e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
  e4:SetCode(EVENT_TO_GRAVE)
  e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
  e4:SetCondition(cm.descon)
  e4:SetTarget(cm.destg)
  e4:SetOperation(cm.desop)
  c:RegisterEffect(e4)
end
function cm.lmfilter1(c)
  return c:IsLevelAbove(0) or c:IsRankAbove(0)
end
function cm.lmfilter2(g,lc)
  return g:GetClassCount(cm.getlrfilter,c)==1
end
function cm.getlrfilter(c)
  if c:IsLevelAbove(0) then
	return c:GetLevel()
  end
  if c:IsRankAbove(0) then
	return c:GetRank()
  end
end
function cm.matcheck(e,c)
  local g=c:GetMaterial()
  local lvl=g:GetSum(cm.getlrfilter)
  lvl=lvl/2
  e:GetLabelObject():SetLabel(lvl)
end
function cm.xyzspfilter(c,e,tp,lvl)
  return c:IsLevel(lvl) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function cm.xyzcon(e,tp,eg,ep,ev,re,r,rp)
  local lvl=e:GetLabel()
  return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK) and Duel.IsExistingMatchingCard(cm.xyzspfilter,tp,LOCATION_REMOVED,0,1,nil,e,tp,lvl)
end
function cm.xyzcostfilter(c,lvl)
  return c:IsLevel(lvl) and c:IsAbleToHandAsCost()
end
function cm.xyzcost(e,tp,eg,ep,ev,re,r,rp,chk)
  local lvl=e:GetLabel()
  if chk==0 then return Duel.IsExistingMatchingCard(cm.xyzcostfilter,tp,LOCATION_GRAVE,0,1,nil,lvl) end
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
  local g=Duel.SelectMatchingCard(tp,cm.xyzcostfilter,tp,LOCATION_GRAVE,0,1,1,nil,lvl)
  Duel.SendtoHand(g,nil,REASON_COST)
end
function cm.xyzop(e,tp,eg,ep,ev,re,r,rp)
  local lvl=e:GetLabel()
  if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,cm.xyzspfilter,tp,LOCATION_REMOVED,0,1,1,nil,e,tp,lvl)
	if g:GetCount()>0 then
	  Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
  end
  local c=e:GetHandler()
  local e1=Effect.CreateEffect(c)
  e1:SetType(EFFECT_TYPE_SINGLE)
  e1:SetCode(EFFECT_XYZ_LEVEL)
  e1:SetValue(lvl)
  e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
  c:RegisterEffect(e1)
end
function cm.descon(e,tp,eg,ep,ev,re,r,rp)
  local c=e:GetHandler()
  return c:IsPreviousLocation(LOCATION_OVERLAY)
end
function cm.destg(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return Duel.IsExistingMatchingCard(nil,tp,0,LOCATION_ONFIELD,1,nil) end
  local g=Duel.GetMatchingGroup(nil,tp,0,LOCATION_ONFIELD,nil)
  Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function cm.desop(e,tp,eg,ep,ev,re,r,rp)
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
  local g=Duel.SelectMatchingCard(tp,nil,tp,0,LOCATION_ONFIELD,1,1,nil)
  if #g>0 then
	Duel.HintSelection(g)
	Duel.Destroy(g,REASON_EFFECT)
  end
end
